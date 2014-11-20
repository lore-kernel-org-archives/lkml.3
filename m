Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbaKTQyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbaKTQya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:54:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/5] X.509: Support X.509 lookup by Issuer+Serial form
 AuthorityKeyIdentifier
From: David Howells <dhowells@redhat.com>
To: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2014 16:54:14 +0000
Message-ID: <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an X.509 certificate has an AuthorityKeyIdentifier extension that provides
an issuer and serialNumber, then make it so that these are used in preference
to the keyIdentifier field also held therein for searching for the signing
certificate.

If both the issuer+serialNumber and the keyIdentifier are supplied, then the
certificate is looked up by the former but the latter is checked as well.  If
the latter doesn't match the subjectKeyIdentifier of the parent certificate,
EKEYREJECTED is returned.

This makes it possible to chain X.509 certificates based on the issuer and
serialNumber fields rather than on subjectKeyIdentifier.  This is necessary as
we are having to deal with keys that are represented by X.509 certificates
that lack a subjectKeyIdentifier.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_trust.c     |   10 +++-
 crypto/asymmetric_keys/pkcs7_verify.c    |   47 +++++++++++++----
 crypto/asymmetric_keys/x509_public_key.c |   83 +++++++++++++++++++++---------
 include/crypto/public_key.h              |    3 +
 4 files changed, 102 insertions(+), 41 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index f802cf118053..11f8ca752e2a 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -54,7 +54,8 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		/* Look to see if this certificate is present in the trusted
 		 * keys.
 		 */
-		key = x509_request_asymmetric_key(trust_keyring, x509->id,
+		key = x509_request_asymmetric_key(trust_keyring,
+						  x509->id, x509->skid,
 						  false);
 		if (!IS_ERR(key)) {
 			/* One of the X.509 certificates in the PKCS#7 message
@@ -85,8 +86,10 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	/* No match - see if the root certificate has a signer amongst the
 	 * trusted keys.
 	 */
-	if (last && last->auth_skid) {
-		key = x509_request_asymmetric_key(trust_keyring, last->auth_skid,
+	if (last && (last->auth_id || last->auth_skid)) {
+		key = x509_request_asymmetric_key(trust_keyring,
+						  last->auth_id,
+						  last->auth_skid,
 						  false);
 		if (!IS_ERR(key)) {
 			x509 = last;
@@ -103,6 +106,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	 */
 	key = x509_request_asymmetric_key(trust_keyring,
 					  sinfo->signing_cert_id,
+					  NULL,
 					  false);
 	if (!IS_ERR(key)) {
 		pr_devel("sinfo %u: Direct signer is key %x\n",
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 5e956c5b9071..667064daf66b 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -170,6 +170,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				  struct pkcs7_signed_info *sinfo)
 {
 	struct x509_certificate *x509 = sinfo->signer, *p;
+	struct asymmetric_key_id *auth;
 	int ret;
 
 	kenter("");
@@ -187,11 +188,14 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			goto maybe_missing_crypto_in_x509;
 
 		pr_debug("- issuer %s\n", x509->issuer);
+		if (x509->auth_id)
+			pr_debug("- authkeyid.id %*phN\n",
+				 x509->auth_id->len, x509->auth_id->data);
 		if (x509->auth_skid)
-			pr_debug("- authkeyid %*phN\n",
+			pr_debug("- authkeyid.skid %*phN\n",
 				 x509->auth_skid->len, x509->auth_skid->data);
 
-		if (!x509->auth_skid ||
+		if ((!x509->auth_id && !x509->auth_skid) ||
 		    strcmp(x509->subject, x509->issuer) == 0) {
 			/* If there's no authority certificate specified, then
 			 * the certificate must be self-signed and is the root
@@ -215,21 +219,42 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		/* Look through the X.509 certificates in the PKCS#7 message's
 		 * list to see if the next one is there.
 		 */
-		pr_debug("- want %*phN\n",
-			 x509->auth_skid->len, x509->auth_skid->data);
-		for (p = pkcs7->certs; p; p = p->next) {
-			if (!p->skid)
-				continue;
-			pr_debug("- cmp [%u] %*phN\n",
-				 p->index, p->skid->len, p->skid->data);
-			if (asymmetric_key_id_same(p->skid, x509->auth_skid))
-				goto found_issuer;
+		auth = x509->auth_id;
+		if (auth) {
+			pr_debug("- want %*phN\n", auth->len, auth->data);
+			for (p = pkcs7->certs; p; p = p->next) {
+				pr_debug("- cmp [%u] %*phN\n",
+					 p->index, p->id->len, p->id->data);
+				if (asymmetric_key_id_same(p->id, auth))
+					goto found_issuer_check_skid;
+			}
+		} else {
+			auth = x509->auth_skid;
+			pr_debug("- want %*phN\n", auth->len, auth->data);
+			for (p = pkcs7->certs; p; p = p->next) {
+				if (!p->skid)
+					continue;
+				pr_debug("- cmp [%u] %*phN\n",
+					 p->index, p->skid->len, p->skid->data);
+				if (asymmetric_key_id_same(p->skid, auth))
+					goto found_issuer;
+			}
 		}
 
 		/* We didn't find the root of this chain */
 		pr_debug("- top\n");
 		return 0;
 
+	found_issuer_check_skid:
+		/* We matched issuer + serialNumber, but if there's an
+		 * authKeyId.keyId, that must match the CA subjKeyId also.
+		 */
+		if (x509->auth_skid &&
+		    !asymmetric_key_id_same(p->skid, x509->auth_skid)) {
+			pr_warn("Sig %u: X.509 chain contains auth-skid nonmatch (%u->%u)\n",
+				sinfo->index, x509->index, p->index);
+			return -EKEYREJECTED;
+		}
 	found_issuer:
 		pr_debug("- subject %s\n", p->subject);
 		if (p->seen) {
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a3d9ba999da5..9c1a3d60a42d 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -52,23 +52,36 @@ __setup("ca_keys=", ca_keys_setup);
 /**
  * x509_request_asymmetric_key - Request a key by X.509 certificate params.
  * @keyring: The keys to search.
- * @kid: The key ID.
+ * @id: The issuer & serialNumber to look for or NULL.
+ * @skid: The subjectKeyIdentifier to look for or NULL.
  * @partial: Use partial match if true, exact if false.
  *
- * Find a key in the given keyring by subject name and key ID.  These might,
- * for instance, be the issuer name and the authority key ID of an X.509
- * certificate that needs to be verified.
+ * Find a key in the given keyring by identifier.  The preferred identifier is
+ * the issuer + serialNumber and the fallback identifier is the
+ * subjectKeyIdentifier.  If both are given, the lookup is by the former, but
+ * the latter must also match.
  */
 struct key *x509_request_asymmetric_key(struct key *keyring,
-					const struct asymmetric_key_id *kid,
+					const struct asymmetric_key_id *id,
+					const struct asymmetric_key_id *skid,
 					bool partial)
 {
-	key_ref_t key;
-	char *id, *p;
-
+	struct key *key;
+	key_ref_t ref;
+	const char *lookup;
+	char *req, *p;
+	int len;
+
+	lookup = id->data;
+	len = id->len;
+	if (!lookup) {
+		lookup = skid->data;
+		len = skid->len;
+	}
+	
 	/* Construct an identifier "id:<keyid>". */
-	p = id = kmalloc(2 + 1 + kid->len * 2 + 1, GFP_KERNEL);
-	if (!id)
+	p = req = kmalloc(2 + 1 + len * 2 + 1, GFP_KERNEL);
+	if (!req)
 		return ERR_PTR(-ENOMEM);
 
 	if (partial) {
@@ -79,32 +92,48 @@ struct key *x509_request_asymmetric_key(struct key *keyring,
 		*p++ = 'x';
 	}
 	*p++ = ':';
-	p = bin2hex(p, kid->data, kid->len);
+	p = bin2hex(p, lookup, len);
 	*p = 0;
 
-	pr_debug("Look up: \"%s\"\n", id);
+	pr_debug("Look up: \"%s\"\n", req);
 
-	key = keyring_search(make_key_ref(keyring, 1),
-			     &key_type_asymmetric, id);
-	if (IS_ERR(key))
-		pr_debug("Request for key '%s' err %ld\n", id, PTR_ERR(key));
-	kfree(id);
+	ref = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_asymmetric, req);
+	if (IS_ERR(ref))
+		pr_debug("Request for key '%s' err %ld\n", req, PTR_ERR(ref));
+	kfree(req);
 
-	if (IS_ERR(key)) {
-		switch (PTR_ERR(key)) {
+	if (IS_ERR(ref)) {
+		switch (PTR_ERR(ref)) {
 			/* Hide some search errors */
 		case -EACCES:
 		case -ENOTDIR:
 		case -EAGAIN:
 			return ERR_PTR(-ENOKEY);
 		default:
-			return ERR_CAST(key);
+			return ERR_CAST(ref);
+		}
+	}
+
+	key = key_ref_to_ptr(ref);
+	if (id && skid) {
+		const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
+		if (!kids->id[1]) {
+			pr_debug("issuer+serial match, but expected SKID missing\n");
+			goto reject;
+		}
+		if (!asymmetric_key_id_same(skid, kids->id[1])) {
+			pr_debug("issuer+serial match, but SKID does not\n");
+			goto reject;
 		}
 	}
+	
+	pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key));
+	return key;
 
-	pr_devel("<==%s() = 0 [%x]\n", __func__,
-		 key_serial(key_ref_to_ptr(key)));
-	return key_ref_to_ptr(key);
+reject:
+	key_put(key);
+	return ERR_PTR(-EKEYREJECTED);
 }
 EXPORT_SYMBOL_GPL(x509_request_asymmetric_key);
 
@@ -217,7 +246,8 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (ca_keyid && !asymmetric_key_id_partial(cert->auth_skid, ca_keyid))
 		return -EPERM;
 
-	key = x509_request_asymmetric_key(trust_keyring, cert->auth_skid,
+	key = x509_request_asymmetric_key(trust_keyring,
+					  cert->auth_id, cert->auth_skid,
 					  false);
 	if (!IS_ERR(key))  {
 		if (!use_builtin_keys
@@ -274,8 +304,9 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
-	if (!cert->auth_skid ||
-	    asymmetric_key_id_same(cert->skid, cert->auth_skid)) {
+	if ((!cert->auth_skid && !cert->auth_id) ||
+	    asymmetric_key_id_same(cert->skid, cert->auth_skid) ||
+	    asymmetric_key_id_same(cert->id, cert->auth_id)) {
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 54add2069901..b6f27a240856 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -101,7 +101,8 @@ extern int verify_signature(const struct key *key,
 
 struct asymmetric_key_id;
 extern struct key *x509_request_asymmetric_key(struct key *keyring,
-					       const struct asymmetric_key_id *kid,
+					       const struct asymmetric_key_id *id,
+					       const struct asymmetric_key_id *skid,
 					       bool partial);
 
 #endif /* _LINUX_PUBLIC_KEY_H */

