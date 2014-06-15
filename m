Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaFOUi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:26 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:37033 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752202AbaFOUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:4605:5007:6119:6261:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sound47_65f607b8d323c
X-Filterd-Recvd-Size: 2571
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH -next 05/26] crypto: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:34 -0700
Message-Id: <7fe501fdc5705074b8d881a31a099f9f9275cc04.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 8 +++-----
 drivers/crypto/ixp4xx_crypto.c       | 8 ++++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 37f9cc9..d3da537 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -304,14 +304,12 @@ static struct ce_pd *crypto4xx_get_pdp(struct crypto4xx_device *dev,
  */
 static u32 crypto4xx_build_gdr(struct crypto4xx_device *dev)
 {
-	dev->gdr = dma_alloc_coherent(dev->core_dev->device,
-				      sizeof(struct ce_gd) * PPC4XX_NUM_GD,
-				      &dev->gdr_pa, GFP_ATOMIC);
+	dev->gdr = dma_zalloc_coherent(dev->core_dev->device,
+				       sizeof(struct ce_gd) * PPC4XX_NUM_GD,
+				       &dev->gdr_pa, GFP_ATOMIC);
 	if (!dev->gdr)
 		return -ENOMEM;
 
-	memset(dev->gdr, 0, sizeof(struct ce_gd) * PPC4XX_NUM_GD);
-
 	return 0;
 }
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index f757a0f..0a32d7c 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -251,12 +251,12 @@ static int setup_crypt_desc(void)
 {
 	struct device *dev = &pdev->dev;
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
-	crypt_virt = dma_alloc_coherent(dev,
-			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_ATOMIC);
+	crypt_virt = dma_zalloc_coherent(dev,
+					 NPE_QLEN * sizeof(struct crypt_ctl),
+					 &crypt_phys, GFP_ATOMIC);
 	if (!crypt_virt)
 		return -ENOMEM;
-	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));
+
 	return 0;
 }
 
-- 
1.8.1.2.459.gbcd45b4.dirty

