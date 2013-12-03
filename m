Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3LCDo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:44:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56534 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab3LCDoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 05/15] mfd: menelaus: Use for_each_set_bit()
Date: Mon, 2 Dec 2013 21:42:58 -0600
Message-ID: <1386042188-12246-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that macro just helps removing some extra
line of code and hides ffs() calls.

while at that, also fix a variable shadowing
bug where 'int irq' was being redeclared inside
inner loop while it was also argument to interrupt
handler.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 11dc4d3..9ccbb79 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -795,24 +795,22 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
 	struct menelaus_chip *menelaus = _menelaus;
 	void (*handler)(struct menelaus_chip *menelaus);
-	unsigned isr;
+	unsigned long isr;
+	unsigned long i;
 
 	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
 			& ~menelaus->mask2) << 8;
 	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
 		& ~menelaus->mask1;
 
-	while (isr) {
-		int irq = fls(isr) - 1;
-		isr &= ~(1 << irq);
-
+	for_each_set_bit(i, &isr, 16) {
 		mutex_lock(&menelaus->lock);
-		menelaus_disable_irq(irq);
-		menelaus_ack_irq(irq);
-		handler = menelaus->handlers[irq];
+		menelaus_disable_irq(i);
+		menelaus_ack_irq(i);
+		handler = menelaus->handlers[i];
 		if (handler)
 			handler(menelaus);
-		menelaus_enable_irq(irq);
+		menelaus_enable_irq(i);
 		mutex_unlock(&menelaus->lock);
 	}
 
-- 
1.8.4.GIT

