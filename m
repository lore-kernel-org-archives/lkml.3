Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab3ECOeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:34:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64290 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab3ECOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/63] dmaengine: ste_dma40: Move rev error-check up to revision acquisition
Date: Fri,  3 May 2013 15:32:08 +0100
Message-Id: <1367591569-32197-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment we fetch the hardware revision, then do some stuff, then
check whether the revision is correct and return in error if it's not.
Well we may as well check it as soon as we know what it is, so let's
move the check right up underneath where we acquire the version.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 34e0fb0..e5f0e3c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3198,6 +3198,10 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	 * DB8540v1 has revision 4
 	 */
 	rev = AMBA_REV_BITS(pid);
+	if (rev < 2) {
+		d40_err(&pdev->dev, "hardware revision: %d is not supported", rev);
+		goto failure;
+	}
 
 	plat_data = pdev->dev.platform_data;
 
@@ -3212,12 +3216,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
 		 rev, res->start, num_phy_chans);
 
-	if (rev < 2) {
-		d40_err(&pdev->dev, "hardware revision: %d is not supported",
-			rev);
-		goto failure;
-	}
-
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
 		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
 		       sizeof(struct d40_chan), GFP_KERNEL);
-- 
1.7.10.4

