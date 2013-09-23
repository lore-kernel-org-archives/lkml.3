Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3IWJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:19:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:36394
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373Ab3IWJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:19:22 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h1de097h8275bhz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, <dan.carpenter@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinctrl-adi2: Remove nested lock+irqsave that resue flags.
Date: Mon, 23 Sep 2013 17:29:48 +0800
Message-ID: <1379928588-12627-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Also avoid use NULL pointer in error message.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/pinctrl-adi2.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 7a24e59..6940612 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -247,7 +247,7 @@ static void adi_gpio_ack_irq(struct irq_data *d)
 	unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		if (readl(&regs->invert_set) & pintbit)
@@ -258,7 +258,7 @@ static void adi_gpio_ack_irq(struct irq_data *d)
 
 	writel(pintbit, &regs->request);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -270,7 +270,7 @@ static void adi_gpio_mask_ack_irq(struct irq_data *d)
 	unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		if (readl(&regs->invert_set) & pintbit)
@@ -282,7 +282,7 @@ static void adi_gpio_mask_ack_irq(struct irq_data *d)
 	writel(pintbit, &regs->request);
 	writel(pintbit, &regs->mask_clear);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -293,11 +293,11 @@ static void adi_gpio_mask_irq(struct irq_data *d)
 	struct gpio_pint_regs *regs = port->pint->regs;
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -308,11 +308,11 @@ static void adi_gpio_unmask_irq(struct irq_data *d)
 	struct gpio_pint_regs *regs = port->pint->regs;
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -323,12 +323,12 @@ static unsigned int adi_gpio_irq_startup(struct irq_data *d)
 	struct gpio_pint_regs *regs = port->pint->regs;
 
 	if (!port) {
-		dev_err(port->dev, "GPIO IRQ %d :Not exist\n", d->irq);
+		pr_err("GPIO IRQ %d :Not exist\n", d->irq);
 		return -ENODEV;
 	}
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	port_setup(port, d->hwirq, true);
 	writew(BIT(d->hwirq), &port->regs->dir_clear);
@@ -336,7 +336,7 @@ static unsigned int adi_gpio_irq_startup(struct irq_data *d)
 
 	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	return 0;
@@ -349,11 +349,11 @@ static void adi_gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_pint_regs *regs = port->pint->regs;
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
 
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -368,14 +368,14 @@ static int adi_gpio_irq_type(struct irq_data *d, unsigned int type)
 	char buf[16];
 
 	if (!port) {
-		dev_err(port->dev, "GPIO IRQ %d :Not exist\n", irq);
+		pr_err("GPIO IRQ %d :Not exist\n", d->irq);
 		return -ENODEV;
 	}
 
 	pintmask = hwirq_to_pintbit(port, d->hwirq);
 
 	spin_lock_irqsave(&port->lock, flags);
-	spin_lock_irqsave(&port->pint->lock, flags);
+	spin_lock(&port->pint->lock);
 
 	/* In case of interrupt autodetect, set irq type to edge sensitive. */
 	if (type == IRQ_TYPE_PROBE)
@@ -416,7 +416,7 @@ static int adi_gpio_irq_type(struct irq_data *d, unsigned int type)
 	}
 
 out:
-	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	return ret;
-- 
1.8.2.3


