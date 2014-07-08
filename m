Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaGHNQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbaGHNQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:16:07 -0400
Subject: [PATCH5/7] PKCS#7: Verify internal certificate chain
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        Kees Cook <keescook@chromium.org>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 14:15:38 +0100
Message-ID: <20140708131538.28621.56211.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140708131504.28621.61165.stgit@warthog.procyon.org.uk>
References: <20140708131504.28621.61165.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify certificate chain in the X.509 certificates contained within the PKCS#7
message as far as possible.  If any signature that we should be able to verify
fails, we reject the whole lot.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   88 +++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 745e5c8..51ff36f 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -170,6 +170,91 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 }
 
 /*
+ * Verify the internal certificate chain as best we can.
+ */
+static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
+				  struct pkcs7_signed_info *sinfo)
+{
+	struct x509_certificate *x509 = sinfo->signer, *p;
+	int ret;
+
+	kenter("");
+
+	for (p = pkcs7->certs; p; p = p->next)
+		p->seen = false;
+
+	for (;;) {
+		pr_debug("verify %s: %s\n", x509->subject, x509->fingerprint);
+		x509->seen = true;
+		ret = x509_get_sig_params(x509);
+		if (ret < 0)
+			return ret;
+
+		if (x509->issuer)
+			pr_debug("- issuer %s\n", x509->issuer);
+		if (x509->authority)
+			pr_debug("- authkeyid %s\n", x509->authority);
+
+		if (!x509->authority ||
+		    (x509->subject &&
+		     strcmp(x509->subject, x509->issuer) == 0)) {
+			/* If there's no authority certificate specified, then
+			 * the certificate must be self-signed and is the root
+			 * of the chain.  Likewise if the cert is its own
+			 * authority.
+			 */
+			pr_debug("- no auth?\n");
+			if (x509->raw_subject_size != x509->raw_issuer_size ||
+			    memcmp(x509->raw_subject, x509->raw_issuer,
+				   x509->raw_issuer_size) != 0)
+				return 0;
+
+			ret = x509_check_signature(x509->pub, x509);
+			if (ret < 0)
+				return ret;
+			x509->signer = x509;
+			pr_debug("- self-signed\n");
+			return 0;
+		}
+
+		/* Look through the X.509 certificates in the PKCS#7 message's
+		 * list to see if the next one is there.
+		 */
+		pr_debug("- want %s\n", x509->authority);
+		for (p = pkcs7->certs; p; p = p->next) {
+			pr_debug("- cmp [%u] %s\n", p->index, p->fingerprint);
+			if (p->raw_subject_size == x509->raw_issuer_size &&
+			    strcmp(p->fingerprint, x509->authority) == 0 &&
+			    memcmp(p->raw_subject, x509->raw_issuer,
+				   x509->raw_issuer_size) == 0)
+				goto found_issuer;
+		}
+
+		/* We didn't find the root of this chain */
+		pr_debug("- top\n");
+		return 0;
+
+	found_issuer:
+		pr_debug("- issuer %s\n", p->subject);
+		if (p->seen) {
+			pr_warn("Sig %u: X.509 chain contains loop\n",
+				sinfo->index);
+			return 0;
+		}
+		ret = x509_check_signature(p->pub, x509);
+		if (ret < 0)
+			return ret;
+		x509->signer = p;
+		if (x509 == p) {
+			pr_debug("- self-signed\n");
+			return 0;
+		}
+		x509 = p;
+		might_sleep();
+	}
+}
+
+/*
  * Verify one signed information block from a PKCS#7 message.
  */
 static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
@@ -201,7 +286,8 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 
 	pr_devel("Verified signature %u\n", sinfo->index);
 
-	return 0;
+	/* Verify the internal certificate chain */
+	return pkcs7_verify_sig_chain(pkcs7, sinfo);
 }
 
 /**

