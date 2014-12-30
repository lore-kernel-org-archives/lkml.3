Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaL3VQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:16:10 -0500
Received: from mail.eperm.de ([89.247.134.16]:51097 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaL3VQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:16:09 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Tue, 30 Dec 2014 22:16:03 +0100
Message-ID: <15957213.Wu7Np8vQse@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AEAD decryption operation requires the authentication tag to be
present as part of the cipher text buffer. The added check verifies that
the caller provides a cipher text buffer with at least the
authentication tag.

As the cipher text is provided as a scatterlist, loop through the
scatterlist until we know we have sufficient cipher text bytes to invoke
the AEAD decryption operation.

As the authentication tag is typically smaller or equal to one block of
the cipher (except for authenc operations), it is expected that the
while loop iterating through the scatterlist is traversed not more than
once. Thus, the speed penalty should be marginal.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9c8776d..badc53b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/scatterlist.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -1412,7 +1413,18 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
  */
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
-	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
+	struct scatterlist *sg = req->src;
+	unsigned int size = 0;
+
+	/* ensure that the ciphertext at least contains the auth tag */
+	while (sg) {
+		size += sg->length;
+		if (crypto_aead_authsize(crypto_aead_reqtfm(req)) <= size)
+			return crypto_aead_crt(
+				crypto_aead_reqtfm(req))->decrypt(req);
+		sg = sg_next(sg);
+	}
+	return -EINVAL;
 }
 
 /**
-- 
2.1.0


