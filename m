Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbaIOUpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352AbaIOUpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/10] PKCS#7: Better handling of unsupported crypto [ver #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:45:45 +0100
Message-ID: <20140915204544.27499.65577.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide better handling of unsupported crypto when verifying a PKCS#7 message.
If we can't bridge the gap between a pair of X.509 certs or between a signed
info block and an X.509 cert because it involves some crypto we don't support,
that's not necessarily the end of the world as there may be other ways points
at which we can intersect with a ring of trusted keys.

Instead, only produce ENOPKG immediately if all the signed info blocks in a
PKCS#7 message require unsupported crypto to bridge to the first X.509 cert.
Otherwise, we defer the generation of ENOPKG until we get ENOKEY during trust
validation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.h    |    1 +
 crypto/asymmetric_keys/pkcs7_trust.c     |   30 ++++++++++++--------
 crypto/asymmetric_keys/pkcs7_verify.c    |   46 +++++++++++++++++++++++++++---
 crypto/asymmetric_keys/x509_parser.h     |    1 +
 crypto/asymmetric_keys/x509_public_key.c |   13 +++++++-
 5 files changed, 74 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index 91949f92bc72..efc7dc9b8f9c 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -23,6 +23,7 @@ struct pkcs7_signed_info {
 	struct x509_certificate *signer; /* Signing certificate (in msg->certs) */
 	unsigned index;
 	bool trusted;
+	bool unsupported_crypto;	/* T if not usable due to missing crypto */
 
 	/* Message digest - the digest of the Content Data (or NULL) */
 	const void	*msgdigest;
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 09197e50fa82..2f953158a1a4 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -35,6 +35,11 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 
 	kenter(",%u,", sinfo->index);
 
+	if (sinfo->unsupported_crypto) {
+		kleave(" = -ENOPKG [cached]");
+		return -ENOPKG;
+	}
+
 	for (x509 = sinfo->signer; x509; x509 = x509->signer) {
 		if (x509->seen) {
 			if (x509->verified) {
@@ -139,24 +144,27 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 {
 	struct pkcs7_signed_info *sinfo;
 	struct x509_certificate *p;
-	int cached_ret = 0, ret;
+	int cached_ret = -ENOKEY;
+	int ret;
 
 	for (p = pkcs7->certs; p; p = p->next)
 		p->seen = false;
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
-		ret = pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring);
-		if (ret < 0) {
-			if (ret == -ENOPKG) {
+		switch (pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring)) {
+		case -ENOKEY:
+			continue;
+		case -ENOPKG:
+			if (cached_ret == -ENOKEY)
 				cached_ret = -ENOPKG;
-			} else if (ret == -ENOKEY) {
-				if (cached_ret == 0)
-					cached_ret = -ENOKEY;
-			} else {
-				return ret;
-			}
+			continue;
+		case 0:
+			*_trusted |= sinfo->trusted;
+			cached_ret = 0;
+			continue;
+		default:
+			return ret;
 		}
-		*_trusted |= sinfo->trusted;
 	}
 
 	return cached_ret;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 57e90fa17f2b..bd264052f751 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -181,7 +181,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		x509->seen = true;
 		ret = x509_get_sig_params(x509);
 		if (ret < 0)
-			return ret;
+			goto maybe_missing_crypto_in_x509;
 
 		pr_debug("- issuer %s\n", x509->issuer);
 		if (x509->authority)
@@ -203,7 +203,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 
 			ret = x509_check_signature(x509->pub, x509);
 			if (ret < 0)
-				return ret;
+				goto maybe_missing_crypto_in_x509;
 			x509->signer = x509;
 			pr_debug("- self-signed\n");
 			return 0;
@@ -245,6 +245,17 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		x509 = p;
 		might_sleep();
 	}
+
+maybe_missing_crypto_in_x509:
+	/* Just prune the certificate chain at this point if we lack some
+	 * crypto module to go further.  Note, however, we don't want to set
+	 * sinfo->missing_crypto as the signed info block may still be
+	 * validatable against an X.509 cert lower in the chain that we have a
+	 * trusted copy of.
+	 */
+	if (ret == -ENOPKG)
+		return 0;
+	return ret;
 }
 
 /*
@@ -286,11 +297,33 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 /**
  * pkcs7_verify - Verify a PKCS#7 message
  * @pkcs7: The PKCS#7 message to be verified
+ *
+ * Verify a PKCS#7 message is internally consistent - that is, the data digest
+ * matches the digest in the AuthAttrs and any signature in the message or one
+ * of the X.509 certificates it carries that matches another X.509 cert in the
+ * message can be verified.
+ *
+ * This does not look to match the contents of the PKCS#7 message against any
+ * external public keys.
+ *
+ * Returns, in order of descending priority:
+ *
+ *  (*) -EKEYREJECTED if a signature failed to match for which we found an
+ *	appropriate X.509 certificate, or:
+ *
+ *  (*) -EBADMSG if some part of the message was invalid, or:
+ *
+ *  (*) -ENOPKG if none of the signature chains are verifiable because suitable
+ *	crypto modules couldn't be found, or:
+ *
+ *  (*) 0 if all the signature chains that don't incur -ENOPKG can be verified
+ *	(note that a signature chain may be of zero length), or:
  */
 int pkcs7_verify(struct pkcs7_message *pkcs7)
 {
 	struct pkcs7_signed_info *sinfo;
 	struct x509_certificate *x509;
+	int enopkg = -ENOPKG;
 	int ret, n;
 
 	kenter("");
@@ -306,12 +339,17 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
 		ret = pkcs7_verify_one(pkcs7, sinfo);
 		if (ret < 0) {
+			if (ret == -ENOPKG) {
+				sinfo->unsupported_crypto = true;
+				continue;
+			}
 			kleave(" = %d", ret);
 			return ret;
 		}
+		enopkg = 0;
 	}
 
-	kleave(" = 0");
-	return 0;
+	kleave(" = %d", enopkg);
+	return enopkg;
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 0e8d59b010fb..4e1a384901ed 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -38,6 +38,7 @@ struct x509_certificate {
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
 	bool		trusted;
+	bool		unsupported_crypto;	/* T if can't be verified due to missing crypto */
 };
 
 /*
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index c60905c3f4d2..1d9a4c555376 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -115,6 +115,8 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	pr_devel("==>%s()\n", __func__);
 
+	if (cert->unsupported_crypto)
+		return -ENOPKG;
 	if (cert->sig.rsa.s)
 		return 0;
 
@@ -127,8 +129,13 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	 * big the hash operational data will be.
 	 */
 	tfm = crypto_alloc_shash(hash_algo_name[cert->sig.pkey_hash_algo], 0, 0);
-	if (IS_ERR(tfm))
-		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT) {
+			cert->unsupported_crypto = true;
+			return -ENOPKG;
+		}
+		return PTR_ERR(tfm);
+	}
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
 	digest_size = crypto_shash_digestsize(tfm);
@@ -175,6 +182,8 @@ int x509_check_signature(const struct public_key *pub,
 		return ret;
 
 	ret = public_key_verify_signature(pub, &cert->sig);
+	if (ret == -ENOPKG)
+		cert->unsupported_crypto = true;
 	pr_debug("Cert Verification: %d\n", ret);
 	return ret;
 }

