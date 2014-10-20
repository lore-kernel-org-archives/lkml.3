Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJTDrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:47:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54504 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaJTDrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:47:04 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 1/3] i2c/at91: add support for runtime PM
Date: Mon, 20 Oct 2014 11:42:12 +0800
Message-ID: <1413776535-10123-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
References: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should put the device into low power states proactively whenever the
device is not in use. Thus implement support for runtime PM and use the
autosuspend feature to make sure that we can still perform well in case we see
lots of i2c traffic within short period of time.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/i2c/busses/i2c-at91.c |   48 ++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 917d545..03b9f48 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -31,10 +31,12 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/platform_data/dma-atmel.h>
+#include <linux/pm_runtime.h>
 
 #define DEFAULT_TWI_CLK_HZ		100000		/* max 400 Kbits/s */
 #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
 #define AT91_I2C_DMA_THRESHOLD	8			/* enable DMA if transfer size is bigger than this threshold */
+#define AUTOSUSPEND_TIMEOUT		2000
 
 /* AT91 TWI register definitions */
 #define	AT91_TWI_CR		0x0000	/* Control Register */
@@ -475,12 +477,16 @@ error:
 static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 {
 	struct at91_twi_dev *dev = i2c_get_adapdata(adap);
-	int ret;
+	int ret = 0;
 	unsigned int_addr_flag = 0;
 	struct i2c_msg *m_start = msg;
 
 	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
 
+	ret = pm_runtime_get_sync(dev->dev);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * The hardware can handle at most two messages concatenated by a
 	 * repeated start via it's internal address feature.
@@ -488,18 +494,21 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	if (num > 2) {
 		dev_err(dev->dev,
 			"cannot handle more than two concatenated messages.\n");
-		return 0;
+		ret = 0;
+		goto out;
 	} else if (num == 2) {
 		int internal_address = 0;
 		int i;
 
 		if (msg->flags & I2C_M_RD) {
 			dev_err(dev->dev, "first transfer must be write.\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		if (msg->len > 3) {
 			dev_err(dev->dev, "first message size must be <= 3.\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 		/* 1st msg is put into the internal address, start with 2nd */
@@ -523,7 +532,13 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 
 	ret = at91_do_twi_transfer(dev);
 
-	return (ret < 0) ? ret : num;
+	if (ret == 0)
+		ret = num;
+out:
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
+
+	return ret;
 }
 
 static u32 at91_twi_func(struct i2c_adapter *adapter)
@@ -795,11 +810,20 @@ static int at91_twi_probe(struct platform_device *pdev)
 	dev->adapter.timeout = AT91_I2C_TIMEOUT;
 	dev->adapter.dev.of_node = pdev->dev.of_node;
 
+	pm_runtime_set_autosuspend_delay(dev->dev, AUTOSUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(dev->dev);
+	pm_runtime_set_active(dev->dev);
+	pm_runtime_enable(dev->dev);
+
 	rc = i2c_add_numbered_adapter(&dev->adapter);
 	if (rc) {
 		dev_err(dev->dev, "Adapter %s registration failed\n",
 			dev->adapter.name);
 		clk_disable_unprepare(dev->clk);
+
+		pm_runtime_disable(dev->dev);
+		pm_runtime_set_suspended(dev->dev);
+
 		return rc;
 	}
 
@@ -814,16 +838,19 @@ static int at91_twi_remove(struct platform_device *pdev)
 	i2c_del_adapter(&dev->adapter);
 	clk_disable_unprepare(dev->clk);
 
+	pm_runtime_disable(dev->dev);
+	pm_runtime_set_suspended(dev->dev);
+
 	return 0;
 }
 
 #ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_RUNTIME
 static int at91_twi_runtime_suspend(struct device *dev)
 {
 	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
 
-	clk_disable(twi_dev->clk);
+	clk_disable_unprepare(twi_dev->clk);
 
 	return 0;
 }
@@ -832,12 +859,13 @@ static int at91_twi_runtime_resume(struct device *dev)
 {
 	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
 
-	return clk_enable(twi_dev->clk);
+	return clk_prepare_enable(twi_dev->clk);
 }
+#endif
 
 static const struct dev_pm_ops at91_twi_pm = {
-	.runtime_suspend	= at91_twi_runtime_suspend,
-	.runtime_resume		= at91_twi_runtime_resume,
+	SET_RUNTIME_PM_OPS(at91_twi_runtime_suspend,
+				at91_twi_runtime_resume, NULL)
 };
 
 #define at91_twi_pm_ops (&at91_twi_pm)
-- 
1.7.9.5

