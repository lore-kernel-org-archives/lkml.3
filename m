Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748Ab3GRWV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:21:56 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47953 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GRWVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:54 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 13/15] iio: ti_am335x_adc: Fix capture operation during resume
Date: Thu, 18 Jul 2013 23:21:24 +0100
Message-Id: <1374186086-5015-14-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

The ADC needs to go through a proper initialization sequence after
resuming from suspend.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 44b7181..265ed27 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -552,11 +552,14 @@ static int tiadc_resume(struct device *dev)
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	unsigned int restore;
 
+	restore = tiadc_readl(adc_dev, REG_CTRL);
+	restore &= ~(CNTRLREG_TSCSSENB);
+	tiadc_writel(adc_dev, REG_CTRL, restore);
 	tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
 	tiadc_step_config(adc_dev, adc_dev->is_continuous_mode);
 	/* Make sure ADC is powered up */
-	restore = tiadc_readl(adc_dev, REG_CTRL);
 	restore &= ~(CNTRLREG_POWERDOWN);
+	restore |= CNTRLREG_TSCSSENB;
 	tiadc_writel(adc_dev, REG_CTRL, restore);
 
 	return 0;
-- 
1.7.9.5

