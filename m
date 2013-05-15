Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3EOJwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:52:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54487 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3EOJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/39] usb: musb: ux500: take the dma_mask from coherent_dma_mask
Date: Wed, 15 May 2013 10:51:45 +0100
Message-Id: <1368611522-9984-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_mask will always be the same as the coherent_dma_mask, so let's
cut down on the platform_data burden and set it as such in the driver.
This also saves us from supporting it separately when we come to enable
this driver for Device Tree.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/usb.c |    3 ---
 drivers/usb/musb/ux500.c  |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index 49d6e57..2f9abe9 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -74,8 +74,6 @@ static struct ux500_musb_board_data musb_board_data = {
 	.dma_filter = stedma40_filter,
 };
 
-static u64 ux500_musb_dmamask = DMA_BIT_MASK(32);
-
 static struct musb_hdrc_platform_data musb_platform_data = {
 	.mode = MUSB_OTG,
 	.board_data = &musb_board_data,
@@ -98,7 +96,6 @@ struct platform_device ux500_musb_device = {
 	.id = 0,
 	.dev = {
 		.platform_data = &musb_platform_data,
-		.dma_mask = &ux500_musb_dmamask,
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.num_resources = ARRAY_SIZE(usb_resources),
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 371776f..3cf10bc 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -228,7 +228,7 @@ static int ux500_probe(struct platform_device *pdev)
 	}
 
 	musb->dev.parent		= &pdev->dev;
-	musb->dev.dma_mask		= pdev->dev.dma_mask;
+	musb->dev.dma_mask		= &pdev->dev.coherent_dma_mask;
 	musb->dev.coherent_dma_mask	= pdev->dev.coherent_dma_mask;
 
 	glue->dev			= &pdev->dev;
-- 
1.7.10.4

