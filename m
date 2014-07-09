Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbaGIPRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbaGIPRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:16 -0400
Subject: [PATCH13/17] pefile: Parse the presumed PKCS#7 content of the
 certificate blob
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:16:49 +0100
Message-ID: <20140709151649.23074.1148.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the content of the certificate blob, presuming it to be PKCS#7 format.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---

 crypto/asymmetric_keys/verify_pefile.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 2f5268c..13f3b44 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -216,7 +216,10 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 int verify_pefile_signature(const void *pebuf, unsigned pelen,
 			    struct key *trusted_keyring, bool *_trusted)
 {
+	struct pkcs7_message *pkcs7;
 	struct pefile_context ctx;
+	const void *data;
+	size_t datalen;
 	int ret;
 
 	kenter("");
@@ -230,5 +233,21 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	if (ret < 0)
 		return ret;
 
-	return -ENOANO; // Not yet complete
+	pkcs7 = pkcs7_parse_message(pebuf + ctx.sig_offset, ctx.sig_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+	ctx.pkcs7 = pkcs7;
+
+	ret = pkcs7_get_content_data(ctx.pkcs7, &data, &datalen, false);
+	if (ret < 0 || datalen == 0) {
+		pr_devel("PKCS#7 message does not contain data\n");
+		ret = -EBADMSG;
+		goto error;
+	}
+
+	ret = -ENOANO; // Not yet complete
+
+error:
+	pkcs7_free_message(ctx.pkcs7);
+	return ret;
 }

