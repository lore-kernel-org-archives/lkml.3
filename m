Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaK3Jzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:55:31 -0500
Received: from mail.eperm.de ([89.247.134.16]:54840 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaK3Jza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:55:30 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: algif_skcipher - initialize upon init request
Date: Sun, 30 Nov 2014 10:55:26 +0100
Message-ID: <2770903.h32OWUVXRy@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the algif_skcipher, the following call sequence causess a
re-initialization:

1. sendmsg with ALG_SET_OP and iov == NULL, iovlen == 0 (i.e
initializing the cipher, but not sending data)

2. sendmsg with msg->msg-controllen == 0 and iov != NULL (using the initalized
cipher handle by sending data)

In step 2, the cipher operation type (encryption or decryption) is reset
to always decryption, because the local variable of enc is put into
ctx->enc as ctx->user is still zero.

The same applies when all send data is processed and ctx->used falls to
zero followed by user space to send new data.

This patch changes the behavior to only reset the cipher operation type
(and the IV) if such configuration request is received.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f80e652..1f157c7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -251,6 +251,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
+	bool init = 0;
 	int err;
 	int i;
 
@@ -259,6 +260,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 		if (err)
 			return err;
 
+		init = 1;
 		switch (con.op) {
 		case ALG_OP_ENCRYPT:
 			enc = 1;
@@ -280,7 +282,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	if (!ctx->more && ctx->used)
 		goto unlock;
 
-	if (!ctx->used) {
+	if (init) {
 		ctx->enc = enc;
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
-- 
2.1.0


