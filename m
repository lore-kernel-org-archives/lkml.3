Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3K0TI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:08:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58432 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab3K0TIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 04/13] mfd: menelaus: remove unnecessary loop
Date: Wed, 27 Nov 2013 13:06:48 -0600
Message-ID: <1385579217-20127-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can let irqs refire and give the scheduler
a chance to choose when we should be scheduled.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 11d7d81..11dc4d3 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -795,30 +795,25 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
 	struct menelaus_chip *menelaus = _menelaus;
 	void (*handler)(struct menelaus_chip *menelaus);
-
-	while (1) {
-		unsigned isr;
-
-		isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
-				& ~menelaus->mask2) << 8;
-		isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
-				& ~menelaus->mask1;
-		if (!isr)
-			break;
-
-		while (isr) {
-			int irq = fls(isr) - 1;
-			isr &= ~(1 << irq);
-
-			mutex_lock(&menelaus->lock);
-			menelaus_disable_irq(irq);
-			menelaus_ack_irq(irq);
-			handler = menelaus->handlers[irq];
-			if (handler)
-				handler(menelaus);
-			menelaus_enable_irq(irq);
-			mutex_unlock(&menelaus->lock);
-		}
+	unsigned isr;
+
+	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
+			& ~menelaus->mask2) << 8;
+	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
+		& ~menelaus->mask1;
+
+	while (isr) {
+		int irq = fls(isr) - 1;
+		isr &= ~(1 << irq);
+
+		mutex_lock(&menelaus->lock);
+		menelaus_disable_irq(irq);
+		menelaus_ack_irq(irq);
+		handler = menelaus->handlers[irq];
+		if (handler)
+			handler(menelaus);
+		menelaus_enable_irq(irq);
+		mutex_unlock(&menelaus->lock);
 	}
 
 	return IRQ_HANDLED;
-- 
1.8.4.GIT

