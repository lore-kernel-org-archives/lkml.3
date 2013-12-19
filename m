Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3LSMx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:53:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LSL4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/208] crypto: authenc - Find proper IV address in ablkcipher callback
Date: Thu, 19 Dec 2013 11:52:42 +0000
Message-Id: <1387454106-19326-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit fc019c7122dfcd69c50142b57a735539aec5da95 upstream.

When performing an asynchronous ablkcipher operation the authenc
completion callback routine is invoked, but it does not locate and use
the proper IV.

The callback routine, crypto_authenc_encrypt_done, is updated to use
the same method of calculating the address of the IV as is done in
crypto_authenc_encrypt function which sets up the callback.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/authenc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index ffce19d..528b00b 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -368,9 +368,10 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 	if (!err) {
 		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-		struct ablkcipher_request *abreq = aead_request_ctx(areq);
-		u8 *iv = (u8 *)(abreq + 1) +
-			 crypto_ablkcipher_reqsize(ctx->enc);
+		struct authenc_request_ctx *areq_ctx = aead_request_ctx(areq);
+		struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+							    + ctx->reqoff);
+		u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(ctx->enc);
 
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
-- 
1.8.3.2

