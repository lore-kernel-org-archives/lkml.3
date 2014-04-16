Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422645AbaDPPRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:17:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34536 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161613AbaDPPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:17:46 -0400
From: Felipe Balbi <balbi@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] power: twl4030_charger: clear IRQs after handling them
Date: Wed, 16 Apr 2014 10:14:59 -0500
Message-ID: <1397661299-31342-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRM says we *must* write 1 to each bit we're handling
in order to clear the IRQ status and bring IRQ line
low. This patch implements that.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Russell, I don't have HW to test, but this should
solve the problem you saw when not using battery
with Zoom board. Let me know if it doesn't.

cheers

 drivers/power/twl4030_charger.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index f141088..b090842 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -301,12 +301,24 @@ static irqreturn_t twl4030_bci_interrupt(int irq, void *arg)
 	ret = twl_i2c_read_u8(TWL4030_MODULE_INTERRUPTS, &irqs1,
 			      TWL4030_INTERRUPTS_BCIISR1A);
 	if (ret < 0)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
+
+	/* clear IRQs early */
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, irqs1,
+			TWL4030_INTERRUPTS_BCIISR1A);
+	if (ret < 0)
+		return IRQ_NONE;
 
 	ret = twl_i2c_read_u8(TWL4030_MODULE_INTERRUPTS, &irqs2,
 			      TWL4030_INTERRUPTS_BCIISR2A);
 	if (ret < 0)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
+
+	/* clear IRQs early */
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, irqs2,
+			      TWL4030_INTERRUPTS_BCIISR2A);
+	if (ret < 0)
+		return IRQ_NONE;
 
 	dev_dbg(bci->dev, "BCI irq %02x %02x\n", irqs2, irqs1);
 
-- 
1.9.1.286.g5172cb3

