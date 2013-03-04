Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3CDQpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:45:32 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43741 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3CDQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:45:29 -0500
MIME-Version: 1.0
From: Kent Yoder <shpedoikal@gmail.com>
Date: Mon, 4 Mar 2013 10:44:57 -0600
Message-ID: <CAM0nabG9SeyX7t77CABiDAzECrWa9g2bRmBTjfeoWFjFE8gPiA@mail.gmail.com>
Subject: [PATCH] drivers/crypto/nx: fix init race, alignmasks and GCM bug
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Fixes a race on driver init with registering algorithms where the
driver status flag wasn't being set before self testing started.

  Added the cra_alignmask field for CBC and ECB modes.

  Fixed a bug in GCM where AES block size was being used instead of
authsize.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c | 1 +
 drivers/crypto/nx/nx-aes-ecb.c | 1 +
 drivers/crypto/nx/nx-aes-gcm.c | 2 +-
 drivers/crypto/nx/nx.c         | 4 ++--
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index a76d4c4..35d483f 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -126,6 +126,7 @@ struct crypto_alg nx_cbc_aes_alg = {
 	.cra_blocksize   = AES_BLOCK_SIZE,
 	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
 	.cra_type        = &crypto_blkcipher_type,
+	.cra_alignmask   = 0xf,
 	.cra_module      = THIS_MODULE,
 	.cra_init        = nx_crypto_ctx_aes_cbc_init,
 	.cra_exit        = nx_crypto_ctx_exit,
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index ba5f161..7bbc9a8 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -123,6 +123,7 @@ struct crypto_alg nx_ecb_aes_alg = {
 	.cra_priority    = 300,
 	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize   = AES_BLOCK_SIZE,
+	.cra_alignmask   = 0xf,
 	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
 	.cra_type        = &crypto_blkcipher_type,
 	.cra_module      = THIS_MODULE,
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index c8109ed..6cca6c3 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -219,7 +219,7 @@ static int gcm_aes_nx_crypt(struct aead_request
*req, int enc)
 	if (enc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
-		nbytes -= AES_BLOCK_SIZE;
+		nbytes -= crypto_aead_authsize(crypto_aead_reqtfm(req));

 	csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index c767f23..7621d05 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -454,6 +454,8 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out;

+	nx_driver.of.status = NX_OKAY;
+
 	rc = crypto_register_alg(&nx_ecb_aes_alg);
 	if (rc)
 		goto out;
@@ -498,8 +500,6 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_s512;

-	nx_driver.of.status = NX_OKAY;
-
 	goto out;

 out_unreg_s512:
-- 
1.7.11.7
