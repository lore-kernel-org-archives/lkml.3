Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3L2CKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55356 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635Ab3L2CKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:33 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.805201857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 104/185] crypto: authenc - Find proper IV address in
 ablkcipher callback
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/authenc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -368,9 +368,10 @@ static void crypto_authenc_encrypt_done(
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

