Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3KLRqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:46:15 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:41709
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab3KLRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:46:11 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VZ3-07-EB3-02
X-M-MSG: 
Subject: [PATCH 01/10] crypto: authenc - Find proper IV address in ablkcipher
 callback
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:46:04 -0600
Message-ID: <20131112174604.19746.83804.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When performing an asynchronous ablkcipher operation the authenc
completion callback routine is invoked, but it does not locate and use
the proper IV.

The callback routine, crypto_authenc_encrypt_done, is updated to use
the same method of calculating the address of the IV as is done in
crypto_authenc_encrypt function which sets up the callback.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 crypto/authenc.c |    7 ++++---
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


