Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3HBW1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:27:12 -0400
Received: from threespeedlogic.com ([75.98.167.93]:55214 "EHLO
	threespeedlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3HBW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:27:08 -0400
X-Greylist: delayed 3697 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 18:27:08 EDT
From: Graeme Smecher <gsmecher@threespeedlogic.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH] gpio: pca953x: Don't flip bits on PCA957x GPIO expanders when probing them.
Date: Fri,  2 Aug 2013 14:24:16 -0700
Message-Id: <1375478656-3577-1-git-send-email-gsmecher@threespeedlogic.com>
X-Mailer: git-send-email 1.7.10.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s63.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - threespeedlogic.com
X-Get-Message-Sender-Via: a2s63.a2hosting.com: authenticated_id: gsmecher+threespeedlogic.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pca957x driver supports a handful of I2C GPIO expanders from NXP, Maxim,
and TI. For the PCA9574 and PCA9575 devices only, the driver resets the GPIO
level and direction in the pca957x_probe function. This seems like the wrong
thing to do, since it can cause hardware bit twiddles during warm reboots when
the chip state and reset values don't match.

This kind of initialization is best left upstream (in a bootloader) or
downstream (in userspace). It's also an inconsistency across devices supported
by this driver.

Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/gpio/gpio-pca953x.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 426c51d..47c08d8 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -683,17 +683,6 @@ static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
 	int ret;
 	u8 val[MAX_BANK];
 
-	/* Let every port in proper state, that could save power */
-	memset(val, 0, NBANK(chip));
-	pca953x_write_regs(chip, PCA957X_PUPD, val);
-	memset(val, 0xFF, NBANK(chip));
-	pca953x_write_regs(chip, PCA957X_CFG, val);
-	memset(val, 0, NBANK(chip));
-	pca953x_write_regs(chip, PCA957X_OUT, val);
-
-	ret = pca953x_read_regs(chip, PCA957X_IN, val);
-	if (ret)
-		goto out;
 	ret = pca953x_read_regs(chip, PCA957X_OUT, chip->reg_output);
 	if (ret)
 		goto out;
-- 
1.7.10.4

