Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaBRXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:03:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaBRWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 29/32] pinctrl: at91: use locked variant of irq_set_handler
Date: Tue, 18 Feb 2014 14:47:29 -0800
Message-Id: <20140218224500.933250866@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit b0dcfd87323ea86501e93d0fa2a98d2fd3579bcf upstream.

When setting the gpio irq type, use the __irq_set_handler_locked()
variant instead of the irq_set_handler() to prevent false
spinlock recursion warning.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-at91.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1251,22 +1251,22 @@ static int alt_gpio_irq_type(struct irq_
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		irq_set_handler(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		irq_set_handler(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
@@ -1275,7 +1275,7 @@ static int alt_gpio_irq_type(struct irq_
 		 * disable additional interrupt modes:
 		 * fall back to default behavior
 		 */
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_AIMDR);
 		return 0;
 	case IRQ_TYPE_NONE:


