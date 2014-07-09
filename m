Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaGIPQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:16:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbaGIPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:16:00 -0400
Subject: [PATCH01/17] X.509: Add bits needed for PKCS#7
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:15:32 +0100
Message-ID: <20140709151532.23074.60142.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PKCS#7 validation requires access to the serial number and the raw names in an
X.509 certificate.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Boyer <jwboyer@redhat.com>
---

 crypto/asymmetric_keys/x509.asn1          |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   17 +++++++++++++++++
 crypto/asymmetric_keys/x509_parser.h      |   13 ++++++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index bf32b3d..aae0cde 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -6,7 +6,7 @@ Certificate ::= SEQUENCE {
 
 TBSCertificate ::= SEQUENCE {
 	version           [ 0 ]	Version DEFAULT,
-	serialNumber		CertificateSerialNumber,
+	serialNumber		CertificateSerialNumber ({ x509_note_serial }),
 	signature		AlgorithmIdentifier ({ x509_note_pkey_algo }),
 	issuer			Name ({ x509_note_issuer }),
 	validity		Validity,
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 2989316..4a8df29 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -211,6 +211,19 @@ int x509_note_signature(void *context, size_t hdrlen,
 }
 
 /*
+ * Note the certificate serial number
+ */
+int x509_note_serial(void *context, size_t hdrlen,
+		     unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_serial = value;
+	ctx->cert->raw_serial_size = vlen;
+	return 0;
+}
+
+/*
  * Note some of the name segments from which we'll fabricate a name.
  */
 int x509_extract_name_segment(void *context, size_t hdrlen,
@@ -322,6 +335,8 @@ int x509_note_issuer(void *context, size_t hdrlen,
 		     const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_issuer = value;
+	ctx->cert->raw_issuer_size = vlen;
 	return x509_fabricate_name(ctx, hdrlen, tag, &ctx->cert->issuer, vlen);
 }
 
@@ -330,6 +345,8 @@ int x509_note_subject(void *context, size_t hdrlen,
 		      const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
+	ctx->cert->raw_subject = value;
+	ctx->cert->raw_subject_size = vlen;
 	return x509_fabricate_name(ctx, hdrlen, tag, &ctx->cert->subject, vlen);
 }
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 87d9cc2..1b76f20 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -14,7 +14,9 @@
 
 struct x509_certificate {
 	struct x509_certificate *next;
+	struct x509_certificate *signer;	/* Certificate that signed this one */
 	struct public_key *pub;			/* Public key details */
+	struct public_key_signature sig;	/* Signature parameters */
 	char		*issuer;		/* Name of certificate issuer */
 	char		*subject;		/* Name of certificate subject */
 	char		*fingerprint;		/* Key fingerprint as hex */
@@ -25,7 +27,16 @@ struct x509_certificate {
 	unsigned	tbs_size;		/* Size of signed data */
 	unsigned	raw_sig_size;		/* Size of sigature */
 	const void	*raw_sig;		/* Signature data */
-	struct public_key_signature sig;	/* Signature parameters */
+	const void	*raw_serial;		/* Raw serial number in ASN.1 */
+	unsigned	raw_serial_size;
+	unsigned	raw_issuer_size;
+	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
+	const void	*raw_subject;		/* Raw subject name in ASN.1 */
+	unsigned	raw_subject_size;
+	unsigned	index;
+	bool		seen;			/* Infinite recursion prevention */
+	bool		verified;
+	bool		trusted;
 };
 
 /*

