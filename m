Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3LQAMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:12:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40990 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3LQAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:09:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 04/10] mfd: menelaus: Remove unnecessary loop
Date: Mon, 16 Dec 2013 18:08:18 -0600
Message-ID: <1387238904-7843-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1387238904-7843-1-git-send-email-balbi@ti.com>
References: <20131216153936.GQ18769@lee--X1>
 <1387238904-7843-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can let irqs refire and give the scheduler a chance to choose when we
should be scheduled.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 268e39c..87d80a8 100644
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

