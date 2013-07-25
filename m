Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3GYNTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:19:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48392 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3GYNRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:17:41 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 2/5] mfd: twl6030-irq: add error check when IRQs are masked initially
Date: Thu, 25 Jul 2013 16:15:48 +0300
Message-ID: <1374758151-12097-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
References: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missed check for errors when TWL IRQs are masked
initially on probe and report an error in case of failure.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Hi Graeme,

I've tried to use only one write to STS_A register to clear IRQ status bits, but,
unfortunatelly, It is *not* working. Seems, all STS registers need to be cleaned
at least once to make everything working.

BR
-grygorii

 drivers/mfd/twl6030-irq.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 1606ced..f7da261 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -313,7 +313,7 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	struct			device_node *node = dev->of_node;
 	int			nr_irqs, irq_base, irq_end;
 	static struct irq_chip  twl6030_irq_chip;
-	int			status = 0;
+	int			status;
 	int			i;
 	u8			mask[3];
 
@@ -335,11 +335,16 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	mask[2] = 0xFF;
 
 	/* mask all int lines */
-	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
+	status = twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
 	/* mask all int sts */
-	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_STS_A, 3);
+	status |= twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_STS_A, 3);
 	/* clear INT_STS_A,B,C */
-	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_STS_A, 3);
+	status |= twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_STS_A, 3);
+
+	if (status < 0) {
+		dev_err(dev, "I2C err writing TWL_MODULE_PIH: %d\n", status);
+		return status;
+	}
 
 	twl6030_irq_base = irq_base;
 
-- 
1.7.9.5

