Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3LCDod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:44:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56327 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3LCDoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 06/15] mfd: menelaus: Pass menelaus pointer as argument to enable/disable irq
Date: Mon, 2 Dec 2013 21:42:59 -0600
Message-ID: <1386042188-12246-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we want to, eventually, get rid of the global
the_menelaus pointer, so let's start passing
menelaus as argument to some function calls
and slowly phase out the_menelaus global pointer.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 9ccbb79..4c51e4b 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -199,35 +199,35 @@ static int menelaus_read_reg(int reg)
 	return val;
 }
 
-static int menelaus_enable_irq(int irq)
+static int menelaus_enable_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7) {
 		irq -= 8;
-		the_menelaus->mask2 &= ~(1 << irq);
+		m->mask2 &= ~(1 << irq);
 		return menelaus_write_reg(MENELAUS_INT_MASK2,
-				the_menelaus->mask2);
+				m->mask2);
 	} else {
-		the_menelaus->mask1 &= ~(1 << irq);
+		m->mask1 &= ~(1 << irq);
 		return menelaus_write_reg(MENELAUS_INT_MASK1,
-				the_menelaus->mask1);
+				m->mask1);
 	}
 }
 
-static int menelaus_disable_irq(int irq)
+static int menelaus_disable_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7) {
 		irq -= 8;
-		the_menelaus->mask2 |= (1 << irq);
+		m->mask2 |= (1 << irq);
 		return menelaus_write_reg(MENELAUS_INT_MASK2,
-				the_menelaus->mask2);
+				m->mask2);
 	} else {
-		the_menelaus->mask1 |= (1 << irq);
+		m->mask1 |= (1 << irq);
 		return menelaus_write_reg(MENELAUS_INT_MASK1,
-				the_menelaus->mask1);
+				m->mask1);
 	}
 }
 
-static int menelaus_ack_irq(int irq)
+static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7)
 		return menelaus_write_reg(MENELAUS_INT_ACK2, 1 << (irq - 8));
@@ -243,7 +243,7 @@ static int menelaus_add_irq_work(int irq,
 
 	mutex_lock(&the_menelaus->lock);
 	the_menelaus->handlers[irq] = handler;
-	ret = menelaus_enable_irq(irq);
+	ret = menelaus_enable_irq(the_menelaus, irq);
 	mutex_unlock(&the_menelaus->lock);
 
 	return ret;
@@ -255,7 +255,7 @@ static int menelaus_remove_irq_work(int irq)
 	int ret = 0;
 
 	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_disable_irq(irq);
+	ret = menelaus_disable_irq(the_menelaus, irq);
 	the_menelaus->handlers[irq] = NULL;
 	mutex_unlock(&the_menelaus->lock);
 
@@ -793,25 +793,25 @@ out:
 
 static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
-	struct menelaus_chip *menelaus = _menelaus;
-	void (*handler)(struct menelaus_chip *menelaus);
+	struct menelaus_chip *m = _menelaus;
+	void (*handler)(struct menelaus_chip *m);
 	unsigned long isr;
 	unsigned long i;
 
 	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
-			& ~menelaus->mask2) << 8;
+			& ~m->mask2) << 8;
 	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
-		& ~menelaus->mask1;
+		& ~m->mask1;
 
 	for_each_set_bit(i, &isr, 16) {
-		mutex_lock(&menelaus->lock);
-		menelaus_disable_irq(i);
-		menelaus_ack_irq(i);
-		handler = menelaus->handlers[i];
+		mutex_lock(&m->lock);
+		menelaus_disable_irq(m, i);
+		menelaus_ack_irq(m, i);
+		handler = m->handlers[i];
 		if (handler)
-			handler(menelaus);
-		menelaus_enable_irq(i);
-		mutex_unlock(&menelaus->lock);
+			handler(m);
+		menelaus_enable_irq(m, i);
+		mutex_unlock(&m->lock);
 	}
 
 	return IRQ_HANDLED;
-- 
1.8.4.GIT

