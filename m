Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaKJB7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:59:51 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:35089 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712AbaKJB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:59:49 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <khilman@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenyou.yang@atmel.com>
Subject: [PATCH v4] i2c/at91: adopt pinctrl support
Date: Mon, 10 Nov 2014 09:55:52 +0800
Message-ID: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the at91 i2c pin controller to optionally take a pin control
handle and set the state of the pins to:
- "default" on boot and resume.
- "sleep" on suspend().

This should make it possible to optimize energy usage for the pins
both for the suspend/resume cycle

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
Hi Wolfram,

Thanks a lot.

The change of this version is to remove
	pinctrl_pm_select_default_state(&pdev->dev) from the _probe function.

Best Regards,
Wenyou Yang

 drivers/i2c/busses/i2c-at91.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 7c335f4..77fb647 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/platform_data/dma-atmel.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #define DEFAULT_TWI_CLK_HZ		100000		/* max 400 Kbits/s */
 #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
@@ -851,6 +852,8 @@ static int at91_twi_runtime_suspend(struct device *dev)
 
 	clk_disable_unprepare(twi_dev->clk);
 
+	pinctrl_pm_select_sleep_state(dev);
+
 	return 0;
 }
 
@@ -858,6 +861,8 @@ static int at91_twi_runtime_resume(struct device *dev)
 {
 	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
 
+	pinctrl_pm_select_default_state(dev);
+
 	return clk_prepare_enable(twi_dev->clk);
 }
 
-- 
1.7.9.5

