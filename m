Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab3GQR2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:28:25 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49927 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab3GQR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:27 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 18/21] IIO: ti_adc: Fix capture operation during resume
Date: Wed, 17 Jul 2013 18:26:47 +0100
Message-Id: <1374082010-28095-19-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC needs to go through a proper initialization sequence after
resuming from suspend.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 1f42e0a..40eec84 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -588,12 +588,16 @@ static int tiadc_resume(struct device *dev)
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	unsigned int restore;
 
+        restore = tiadc_readl(adc_dev, REG_CTRL);
+        restore &= ~(CNTRLREG_TSCSSENB);
+        tiadc_writel(adc_dev, REG_CTRL, restore);
+
     tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
     tiadc_step_config(adc_dev, adc_dev->is_continuous_mode);
 
 	/* Make sure ADC is powered up */
-	restore = tiadc_readl(adc_dev, REG_CTRL);
 	restore &= ~(CNTRLREG_POWERDOWN);
+        restore |= CNTRLREG_TSCSSENB;
 	tiadc_writel(adc_dev, REG_CTRL, restore);
 
 	return 0;
-- 
1.7.9.5

