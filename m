Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbaKTQyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbaKTQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:54:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/5] X.509: Extract both parts of the AuthorityKeyIdentifier
From: David Howells <dhowells@redhat.com>
To: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2014 16:54:03 +0000
Message-ID: <20141120165403.5264.18275.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract both parts of the AuthorityKeyIdentifier, not just the keyIdentifier,
as the second part can be used to match X.509 certificates by issuer and
serialNumber.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/Makefile           |    8 +-
 crypto/asymmetric_keys/pkcs7_trust.c      |    4 -
 crypto/asymmetric_keys/pkcs7_verify.c     |   12 +-
 crypto/asymmetric_keys/x509_akid.asn1     |   35 +++++++
 crypto/asymmetric_keys/x509_cert_parser.c |  142 ++++++++++++++++++-----------
 crypto/asymmetric_keys/x509_parser.h      |    3 -
 crypto/asymmetric_keys/x509_public_key.c  |    8 +-
 7 files changed, 144 insertions(+), 68 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_akid.asn1

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index e47fcd9ac5e8..cd1406f9b14a 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -15,15 +15,21 @@ obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
 obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
 x509_key_parser-y := \
 	x509-asn1.o \
+	x509_akid-asn1.o \
 	x509_rsakey-asn1.o \
 	x509_cert_parser.o \
 	x509_public_key.o
 
-$(obj)/x509_cert_parser.o: $(obj)/x509-asn1.h $(obj)/x509_rsakey-asn1.h
+$(obj)/x509_cert_parser.o: \
+	$(obj)/x509-asn1.h \
+	$(obj)/x509_akid-asn1.h \
+	$(obj)/x509_rsakey-asn1.h
 $(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
+$(obj)/x509_akid-asn1.o: $(obj)/x509_akid-asn1.c $(obj)/x509_akid-asn1.h
 $(obj)/x509_rsakey-asn1.o: $(obj)/x509_rsakey-asn1.c $(obj)/x509_rsakey-asn1.h
 
 clean-files	+= x509-asn1.c x509-asn1.h
+clean-files	+= x509_akid-asn1.c x509_akid-asn1.h
 clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
 
 #
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 1d29376072da..f802cf118053 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -85,8 +85,8 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	/* No match - see if the root certificate has a signer amongst the
 	 * trusted keys.
 	 */
-	if (last && last->authority) {
-		key = x509_request_asymmetric_key(trust_keyring, last->authority,
+	if (last && last->auth_skid) {
+		key = x509_request_asymmetric_key(trust_keyring, last->auth_skid,
 						  false);
 		if (!IS_ERR(key)) {
 			x509 = last;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index cd455450b069..5e956c5b9071 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -187,11 +187,11 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			goto maybe_missing_crypto_in_x509;
 
 		pr_debug("- issuer %s\n", x509->issuer);
-		if (x509->authority)
+		if (x509->auth_skid)
 			pr_debug("- authkeyid %*phN\n",
-				 x509->authority->len, x509->authority->data);
+				 x509->auth_skid->len, x509->auth_skid->data);
 
-		if (!x509->authority ||
+		if (!x509->auth_skid ||
 		    strcmp(x509->subject, x509->issuer) == 0) {
 			/* If there's no authority certificate specified, then
 			 * the certificate must be self-signed and is the root
@@ -216,13 +216,13 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		 * list to see if the next one is there.
 		 */
 		pr_debug("- want %*phN\n",
-			 x509->authority->len, x509->authority->data);
+			 x509->auth_skid->len, x509->auth_skid->data);
 		for (p = pkcs7->certs; p; p = p->next) {
 			if (!p->skid)
 				continue;
 			pr_debug("- cmp [%u] %*phN\n",
 				 p->index, p->skid->len, p->skid->data);
-			if (asymmetric_key_id_same(p->skid, x509->authority))
+			if (asymmetric_key_id_same(p->skid, x509->auth_skid))
 				goto found_issuer;
 		}
 
@@ -338,8 +338,6 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 		ret = x509_get_sig_params(x509);
 		if (ret < 0)
 			return ret;
-		pr_debug("X.509[%u] %*phN\n",
-			 n, x509->authority->len, x509->authority->data);
 	}
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
diff --git a/crypto/asymmetric_keys/x509_akid.asn1 b/crypto/asymmetric_keys/x509_akid.asn1
new file mode 100644
index 000000000000..1a33231a75a8
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_akid.asn1
@@ -0,0 +1,35 @@
+-- X.509 AuthorityKeyIdentifier
+-- rfc5280 section 4.2.1.1
+
+AuthorityKeyIdentifier ::= SEQUENCE {
+	keyIdentifier			[0] IMPLICIT KeyIdentifier		OPTIONAL,
+	authorityCertIssuer		[1] IMPLICIT GeneralNames		OPTIONAL,
+	authorityCertSerialNumber	[2] IMPLICIT CertificateSerialNumber	OPTIONAL
+	}
+
+KeyIdentifier ::= OCTET STRING ({ x509_akid_note_kid })
+
+CertificateSerialNumber ::= INTEGER ({ x509_akid_note_serial })
+
+GeneralNames ::= SEQUENCE OF GeneralName
+
+GeneralName ::= CHOICE {
+	otherName			[0] ANY,
+	rfc822Name			[1] IA5String,
+	dNSName				[2] IA5String,
+	x400Address			[3] ANY,
+	directoryName			[4] Name ({ x509_akid_note_name }),
+	ediPartyName			[5] ANY,
+	uniformResourceIdentifier	[6] IA5String,
+	iPAddress			[7] OCTET STRING,
+	registeredID			[8] OBJECT IDENTIFIER
+	}
+
+Name ::= SEQUENCE OF RelativeDistinguishedName
+
+RelativeDistinguishedName ::= SET OF AttributeValueAssertion
+
+AttributeValueAssertion ::= SEQUENCE {
+	attributeType		OBJECT IDENTIFIER ({ x509_note_OID }),
+	attributeValue		ANY ({ x509_extract_name_segment })
+	}
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index a668d90302d3..e9d6586fdf89 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -18,6 +18,7 @@
 #include "public_key.h"
 #include "x509_parser.h"
 #include "x509-asn1.h"
+#include "x509_akid-asn1.h"
 #include "x509_rsakey-asn1.h"
 
 struct x509_parse_context {
@@ -35,6 +36,10 @@ struct x509_parse_context {
 	u16		o_offset;		/* Offset of organizationName (O) */
 	u16		cn_offset;		/* Offset of commonName (CN) */
 	u16		email_offset;		/* Offset of emailAddress */
+	unsigned	raw_akid_size;
+	const void	*raw_akid;		/* Raw authorityKeyId in ASN.1 */
+	const void	*akid_raw_issuer;	/* Raw directoryName in authorityKeyId */
+	unsigned	akid_raw_issuer_size;
 };
 
 /*
@@ -48,7 +53,8 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert->subject);
 		kfree(cert->id);
 		kfree(cert->skid);
-		kfree(cert->authority);
+		kfree(cert->auth_id);
+		kfree(cert->auth_skid);
 		kfree(cert->sig.digest);
 		mpi_free(cert->sig.rsa.s);
 		kfree(cert);
@@ -85,6 +91,18 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	if (ret < 0)
 		goto error_decode;
 
+	/* Decode the AuthorityKeyIdentifier */
+	if (ctx->raw_akid) {
+		pr_devel("AKID: %u %*phN\n",
+			 ctx->raw_akid_size, ctx->raw_akid_size, ctx->raw_akid);
+		ret = asn1_ber_decoder(&x509_akid_decoder, ctx,
+				       ctx->raw_akid, ctx->raw_akid_size);
+		if (ret < 0) {
+			pr_warn("Couldn't decode AuthKeyIdentifier\n");
+			goto error_decode;
+		}
+	}
+
 	/* Decode the public key */
 	ret = asn1_ber_decoder(&x509_rsakey_decoder, ctx,
 			       ctx->key, ctx->key_size);
@@ -422,7 +440,6 @@ int x509_process_extension(void *context, size_t hdrlen,
 	struct x509_parse_context *ctx = context;
 	struct asymmetric_key_id *kid;
 	const unsigned char *v = value;
-	int i;
 
 	pr_debug("Extension: %u\n", ctx->last_oid);
 
@@ -449,57 +466,8 @@ int x509_process_extension(void *context, size_t hdrlen,
 
 	if (ctx->last_oid == OID_authorityKeyIdentifier) {
 		/* Get hold of the CA key fingerprint */
-		if (ctx->cert->authority || vlen < 5)
-			return -EBADMSG;
-
-		/* Authority Key Identifier must be a Constructed SEQUENCE */
-		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)))
-			return -EBADMSG;
-
-		/* Authority Key Identifier is not indefinite length */
-		if (unlikely(vlen == ASN1_INDEFINITE_LENGTH))
-			return -EBADMSG;
-
-		if (vlen < ASN1_INDEFINITE_LENGTH) {
-			/* Short Form length */
-			if (v[1] != vlen - 2 ||
-			    v[2] != SEQ_TAG_KEYID ||
-			    v[3] > vlen - 4)
-				return -EBADMSG;
-
-			vlen = v[3];
-			v += 4;
-		} else {
-			/* Long Form length */
-			size_t seq_len = 0;
-			size_t sub = v[1] - ASN1_INDEFINITE_LENGTH;
-
-			if (sub > 2)
-				return -EBADMSG;
-
-			/* calculate the length from subsequent octets */
-			v += 2;
-			for (i = 0; i < sub; i++) {
-				seq_len <<= 8;
-				seq_len |= v[i];
-			}
-
-			if (seq_len != vlen - 2 - sub ||
-			    v[sub] != SEQ_TAG_KEYID ||
-			    v[sub + 1] > vlen - 4 - sub)
-				return -EBADMSG;
-
-			vlen = v[sub + 1];
-			v += (sub + 2);
-		}
-
-		kid = asymmetric_key_generate_id(ctx->cert->raw_issuer,
-						 ctx->cert->raw_issuer_size,
-						 v, vlen);
-		if (IS_ERR(kid))
-			return PTR_ERR(kid);
-		pr_debug("authkeyid %*phN\n", kid->len, kid->data);
-		ctx->cert->authority = kid;
+		ctx->raw_akid = v;
+		ctx->raw_akid_size = vlen;
 		return 0;
 	}
 
@@ -569,3 +537,71 @@ int x509_note_not_after(void *context, size_t hdrlen,
 	struct x509_parse_context *ctx = context;
 	return x509_note_time(&ctx->cert->valid_to, hdrlen, tag, value, vlen);
 }
+
+/*
+ * Note a key identifier-based AuthorityKeyIdentifier
+ */
+int x509_akid_note_kid(void *context, size_t hdrlen,
+		       unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	struct asymmetric_key_id *kid;
+
+	pr_debug("AKID: keyid: %*phN\n", (int)vlen, value);
+
+	if (ctx->cert->auth_skid)
+		return 0;
+
+	kid = asymmetric_key_generate_id(ctx->cert->raw_issuer,
+					 ctx->cert->raw_issuer_size,
+					 value, vlen);
+	if (IS_ERR(kid))
+		return PTR_ERR(kid);
+	pr_debug("authkeyid %*phN\n", kid->len, kid->data);
+	ctx->cert->auth_skid = kid;
+	return 0;
+}
+
+/*
+ * Note a directoryName in an AuthorityKeyIdentifier
+ */
+int x509_akid_note_name(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	pr_debug("AKID: name: %*phN\n", (int)vlen, value);
+
+	ctx->akid_raw_issuer = value;
+	ctx->akid_raw_issuer_size = vlen;
+	return 0;
+}
+
+/*
+ * Note a serial number in an AuthorityKeyIdentifier
+ */
+int x509_akid_note_serial(void *context, size_t hdrlen,
+			  unsigned char tag,
+			  const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	struct asymmetric_key_id *kid;
+
+	pr_debug("AKID: serial: %*phN\n", (int)vlen, value);
+
+	if (!ctx->akid_raw_issuer || ctx->cert->auth_id)
+		return 0;
+
+	kid = asymmetric_key_generate_id(value,
+					 vlen,
+					 ctx->akid_raw_issuer,
+					 ctx->akid_raw_issuer_size);
+	if (IS_ERR(kid))
+		return PTR_ERR(kid);
+
+	pr_debug("authkeyid %*phN\n", kid->len, kid->data);
+	ctx->cert->auth_id = kid;
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 3dfe6b5d6f0b..223b72344060 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -21,7 +21,8 @@ struct x509_certificate {
 	char		*subject;		/* Name of certificate subject */
 	struct asymmetric_key_id *id;		/* Serial number + issuer */
 	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
-	struct asymmetric_key_id *authority;	/* Authority key identifier (optional) */
+	struct asymmetric_key_id *auth_id;	/* CA AuthKeyId matching ->id (optional) */
+	struct asymmetric_key_id *auth_skid;	/* CA AuthKeyId matching ->skid (optional) */
 	struct tm	valid_from;
 	struct tm	valid_to;
 	const void	*tbs;			/* Signed data */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a6c42031628e..a3d9ba999da5 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -214,10 +214,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
-	if (ca_keyid && !asymmetric_key_id_partial(cert->authority, ca_keyid))
+	if (ca_keyid && !asymmetric_key_id_partial(cert->auth_skid, ca_keyid))
 		return -EPERM;
 
-	key = x509_request_asymmetric_key(trust_keyring, cert->authority,
+	key = x509_request_asymmetric_key(trust_keyring, cert->auth_skid,
 					  false);
 	if (!IS_ERR(key))  {
 		if (!use_builtin_keys
@@ -274,8 +274,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
-	if (!cert->authority ||
-	    asymmetric_key_id_same(cert->skid, cert->authority)) {
+	if (!cert->auth_skid ||
+	    asymmetric_key_id_same(cert->skid, cert->auth_skid)) {
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;

