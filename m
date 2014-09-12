Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaILTGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaILTGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:06:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 9/9] PKCS#7: Handle PKCS#7 messages that contain no X.509
 certs
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 20:05:57 +0100
Message-ID: <20140912190557.13239.40936.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
References: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The X.509 certificate list in a PKCS#7 message is optional.  To save space, we
can omit the inclusion of any X.509 certificates if we are sure that we can
look the relevant public key up by the serial number and issuer given in a
signed info block.

This also supports use of a signed info block for which we don't have a
matching X.509 cert giving in a populated certificate list.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_trust.c  |   48 +++++++++++++++++++++++++--------
 crypto/asymmetric_keys/pkcs7_verify.c |   16 ++++++++---
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 8b634ae746e6..926df53ebb7c 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -55,13 +55,16 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		 * keys.
 		 */
 		key = x509_request_asymmetric_key(trust_keyring, x509->id);
-		if (!IS_ERR(key))
+		if (!IS_ERR(key)) {
 			/* One of the X.509 certificates in the PKCS#7 message
 			 * is apparently the same as one we already trust.
 			 * Verify that the trusted variant can also validate
 			 * the signature on the descendant.
 			 */
+			pr_devel("sinfo %u: Cert %u as key %x\n",
+				 sinfo->index, x509->index, key_serial(key));
 			goto matched;
+		}
 		if (key == ERR_PTR(-ENOMEM))
 			return -ENOMEM;
 
@@ -81,15 +84,34 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	/* No match - see if the root certificate has a signer amongst the
 	 * trusted keys.
 	 */
-	if (!last || !last->issuer || !last->authority) {
-		kleave(" = -ENOKEY [no backref]");
-		return -ENOKEY;
+	if (last && last->authority) {
+		key = x509_request_asymmetric_key(trust_keyring, last->authority);
+		if (!IS_ERR(key)) {
+			x509 = last;
+			pr_devel("sinfo %u: Root cert %u signer is key %x\n",
+				 sinfo->index, x509->index, key_serial(key));
+			goto matched;
+		}
+		if (PTR_ERR(key) != -ENOKEY)
+			return PTR_ERR(key);
 	}
 
-	key = x509_request_asymmetric_key(trust_keyring, last->authority);
-	if (IS_ERR(key))
-		return PTR_ERR(key) == -ENOMEM ? -ENOMEM : -ENOKEY;
-	x509 = last;
+	/* As a last resort, see if we have a trusted public key that matches
+	 * the signed info directly.
+	 */
+	key = x509_request_asymmetric_key(trust_keyring,
+					  sinfo->signing_cert_id);
+	if (!IS_ERR(key)) {
+		pr_devel("sinfo %u: Direct signer is key %x\n",
+			 sinfo->index, key_serial(key));
+		x509 = NULL;
+		goto matched;
+	}
+	if (PTR_ERR(key) != -ENOKEY)
+		return PTR_ERR(key);
+
+	kleave(" = -ENOKEY [no backref]");
+	return -ENOKEY;
 
 matched:
 	ret = verify_signature(key, sig);
@@ -103,10 +125,12 @@ matched:
 	}
 
 verified:
-	x509->verified = true;
-	for (p = sinfo->signer; p != x509; p = p->signer) {
-		p->verified = true;
-		p->trusted = trusted;
+	if (x509) {
+		x509->verified = true;
+		for (p = sinfo->signer; p != x509; p = p->signer) {
+			p->verified = true;
+			p->trusted = trusted;
+		}
 	}
 	sinfo->trusted = trusted;
 	kleave(" = 0");
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 73a75a5a0b98..b3059f2ad0f7 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -154,10 +154,13 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		return 0;
 	}
 
-	pr_warn("Sig %u: Issuing X.509 cert not found (#%*ph)\n",
-		sinfo->index,
-		sinfo->signing_cert_id->len, sinfo->signing_cert_id->data);
-	return -ENOKEY;
+	/* The relevant X.509 cert isn't found here, but it might be found in
+	 * the trust keyring.
+	 */
+	pr_debug("Sig %u: Issuing X.509 cert not found (#%*phN)\n",
+		 sinfo->index,
+		 sinfo->signing_cert_id->len, sinfo->signing_cert_id->data);
+	return 0;
 }
 
 /*
@@ -277,11 +280,14 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 	if (ret < 0)
 		return ret;
 
-	/* Find the key for the signature */
+	/* Find the key for the signature if there is one */
 	ret = pkcs7_find_key(pkcs7, sinfo);
 	if (ret < 0)
 		return ret;
 
+	if (!sinfo->signer)
+		return 0;
+
 	pr_devel("Using X.509[%u] for sig %u\n",
 		 sinfo->signer->index, sinfo->index);
 

