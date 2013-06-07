Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3FGSwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:52:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209Ab3FGSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:50:00 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 2/5] i2c: omap: add runtime check in isr to be sure that i2c is enabled
Date: Fri, 7 Jun 2013 21:46:05 +0300
Message-ID: <1370630768-4077-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime check at the beginning of omap_i2c_isr/omap_i2c_isr_thread
to be sure that i2c is enabled, before performing IRQ handling and accessing
I2C IP registers:
	if (pm_runtime_suspended(dev->dev)) {
		WARN_ONCE(true, "We should never be here!\n");
		return IRQ_NONE;
	}

Produce warning in case if ISR called when i2c is disabled

CC: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 97844ff..2dac598 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -885,6 +885,11 @@ omap_i2c_isr(int irq, void *dev_id)
 	u16 stat;
 
 	spin_lock(&dev->lock);
+	if (pm_runtime_suspended(dev->dev)) {
+		WARN_ONCE(true, "We should never be here!\n");
+		return IRQ_NONE;
+	}
+
 	mask = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
 	stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 
@@ -905,6 +910,11 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 	u16 stat;
 	int err = 0, count = 0;
 
+	if (pm_runtime_suspended(dev->dev)) {
+		WARN_ONCE(true, "We should never be here!\n");
+		return IRQ_NONE;
+	}
+
 	spin_lock_irqsave(&dev->lock, flags);
 	do {
 		bits = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
-- 
1.7.9.5

