Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbbALNJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:09:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53711 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751054AbbALNJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:09:39 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Paul Bolle <pebolle@tiscali.nl>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 1/5] usb: atmel_usba_udc: Rework at91sam9rl errata handling
Date: Mon, 12 Jan 2015 14:08:43 +0100
Message-Id: <1421068123-29541-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9rl SoC has an erratum forcing us to toggle the BIAS on USB
suspend/resume events.

This specific handling was only activated when CONFIG_ARCH_AT91SAM9RL
was set, but commit bcf8c7e7703b ("ARM: at91: remove at91sam9rl legacy
board support") removed this option.

Rework the toggle_bias implementation to attach it to the "at91sam9rl-udc"
compatible string.

Add new compatible strings to avoid executing at91sam9rl erratum handling
on other SoCs.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---

Changes since v3:
- rework commit message

 .../devicetree/bindings/usb/atmel-usb.txt          |  5 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c            | 78 ++++++++++++----------
 drivers/usb/gadget/udc/atmel_usba_udc.h            |  5 ++
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/atmel-usb.txt b/Documentation/devicetree/bindings/usb/atmel-usb.txt
index bc2222c..38fee0f 100644
--- a/Documentation/devicetree/bindings/usb/atmel-usb.txt
+++ b/Documentation/devicetree/bindings/usb/atmel-usb.txt
@@ -51,7 +51,10 @@ usb1: gadget@fffa4000 {
 Atmel High-Speed USB device controller
 
 Required properties:
- - compatible: Should be "atmel,at91sam9rl-udc"
+ - compatible: Should be one of the following
+	       "at91sam9rl-udc"
+	       "at91sam9g45-udc"
+	       "sama5d3-udc"
  - reg: Address and length of the register set for the device
  - interrupts: Should contain usba interrupt
  - ep childnode: To specify the number of endpoints and their properties.
diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index ce88237..36fd34b 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/clk/at91_pmc.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -324,28 +325,12 @@ static int vbus_is_present(struct usba_udc *udc)
 	return 1;
 }
 
-#if defined(CONFIG_ARCH_AT91SAM9RL)
-
-#include <linux/clk/at91_pmc.h>
-
-static void toggle_bias(int is_on)
-{
-	unsigned int uckr = at91_pmc_read(AT91_CKGR_UCKR);
-
-	if (is_on)
-		at91_pmc_write(AT91_CKGR_UCKR, uckr | AT91_PMC_BIASEN);
-	else
-		at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
-}
-
-#else
-
-static void toggle_bias(int is_on)
+static void toggle_bias(struct usba_udc *udc, int is_on)
 {
+	if (udc->errata && udc->errata->toggle_bias)
+		udc->errata->toggle_bias(udc, is_on);
 }
 
-#endif /* CONFIG_ARCH_AT91SAM9RL */
-
 static void next_fifo_transaction(struct usba_ep *ep, struct usba_request *req)
 {
 	unsigned int transaction_len;
@@ -1620,7 +1605,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	DBG(DBG_INT, "irq, status=%#08x\n", status);
 
 	if (status & USBA_DET_SUSPEND) {
-		toggle_bias(0);
+		toggle_bias(udc, 0);
 		usba_writel(udc, INT_CLR, USBA_DET_SUSPEND);
 		DBG(DBG_BUS, "Suspend detected\n");
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
@@ -1632,7 +1617,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	}
 
 	if (status & USBA_WAKE_UP) {
-		toggle_bias(1);
+		toggle_bias(udc, 1);
 		usba_writel(udc, INT_CLR, USBA_WAKE_UP);
 		DBG(DBG_BUS, "Wake Up CPU detected\n");
 	}
@@ -1736,13 +1721,13 @@ static irqreturn_t usba_vbus_irq(int irq, void *devid)
 	vbus = vbus_is_present(udc);
 	if (vbus != udc->vbus_prev) {
 		if (vbus) {
-			toggle_bias(1);
+			toggle_bias(udc, 1);
 			usba_writel(udc, CTRL, USBA_ENABLE_MASK);
 			usba_writel(udc, INT_ENB, USBA_END_OF_RESET);
 		} else {
 			udc->gadget.speed = USB_SPEED_UNKNOWN;
 			reset_all_endpoints(udc);
-			toggle_bias(0);
+			toggle_bias(udc, 0);
 			usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 			if (udc->driver->disconnect) {
 				spin_unlock(&udc->lock);
@@ -1788,7 +1773,7 @@ static int atmel_usba_start(struct usb_gadget *gadget,
 	/* If Vbus is present, enable the controller and wait for reset */
 	spin_lock_irqsave(&udc->lock, flags);
 	if (vbus_is_present(udc) && udc->vbus_prev == 0) {
-		toggle_bias(1);
+		toggle_bias(udc, 1);
 		usba_writel(udc, CTRL, USBA_ENABLE_MASK);
 		usba_writel(udc, INT_ENB, USBA_END_OF_RESET);
 	}
@@ -1811,7 +1796,7 @@ static int atmel_usba_stop(struct usb_gadget *gadget)
 	spin_unlock_irqrestore(&udc->lock, flags);
 
 	/* This will also disable the DP pullup */
-	toggle_bias(0);
+	toggle_bias(udc, 0);
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 
 	clk_disable_unprepare(udc->hclk);
@@ -1823,6 +1808,29 @@ static int atmel_usba_stop(struct usb_gadget *gadget)
 }
 
 #ifdef CONFIG_OF
+static void at91sam9rl_toggle_bias(struct usba_udc *udc, int is_on)
+{
+	unsigned int uckr = at91_pmc_read(AT91_CKGR_UCKR);
+
+	if (is_on)
+		at91_pmc_write(AT91_CKGR_UCKR, uckr | AT91_PMC_BIASEN);
+	else
+		at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
+}
+
+static const struct usba_udc_errata at91sam9rl_errata = {
+	.toggle_bias = at91sam9rl_toggle_bias,
+};
+
+static const struct of_device_id atmel_udc_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9rl-udc", .data = &at91sam9rl_errata },
+	{ .compatible = "atmel,at91sam9g45-udc" },
+	{ .compatible = "atmel,sama5d3-udc" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, atmel_udc_dt_ids);
+
 static struct usba_ep * atmel_udc_of_init(struct platform_device *pdev,
 						    struct usba_udc *udc)
 {
@@ -1830,10 +1838,17 @@ static struct usba_ep * atmel_udc_of_init(struct platform_device *pdev,
 	const char *name;
 	enum of_gpio_flags flags;
 	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
 	struct device_node *pp;
 	int i, ret;
 	struct usba_ep *eps, *ep;
 
+	match = of_match_node(atmel_udc_dt_ids, np);
+	if (!match)
+		return ERR_PTR(-EINVAL);
+
+	udc->errata = match->data;
+
 	udc->num_ep = 0;
 
 	udc->vbus_pin = of_get_named_gpio_flags(np, "atmel,vbus-gpio", 0,
@@ -2024,7 +2039,7 @@ static int usba_udc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Unable to enable pclk, aborting.\n");
 		return ret;
 	}
-	toggle_bias(0);
+
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 	clk_disable_unprepare(pclk);
 
@@ -2033,6 +2048,8 @@ static int usba_udc_probe(struct platform_device *pdev)
 	else
 		udc->usba_ep = usba_udc_pdata(pdev, udc);
 
+	toggle_bias(udc, 0);
+
 	if (IS_ERR(udc->usba_ep))
 		return PTR_ERR(udc->usba_ep);
 
@@ -2092,15 +2109,6 @@ static int __exit usba_udc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#if defined(CONFIG_OF)
-static const struct of_device_id atmel_udc_dt_ids[] = {
-	{ .compatible = "atmel,at91sam9rl-udc" },
-	{ /* sentinel */ }
-};
-
-MODULE_DEVICE_TABLE(of, atmel_udc_dt_ids);
-#endif
-
 static struct platform_driver udc_driver = {
 	.remove		= __exit_p(usba_udc_remove),
 	.driver		= {
diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.h b/drivers/usb/gadget/udc/atmel_usba_udc.h
index a70706e..456899e 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.h
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.h
@@ -304,6 +304,10 @@ struct usba_request {
 	unsigned int				mapped:1;
 };
 
+struct usba_udc_errata {
+	void (*toggle_bias)(struct usba_udc *udc, int is_on);
+};
+
 struct usba_udc {
 	/* Protect hw registers from concurrent modifications */
 	spinlock_t lock;
@@ -314,6 +318,7 @@ struct usba_udc {
 	struct usb_gadget gadget;
 	struct usb_gadget_driver *driver;
 	struct platform_device *pdev;
+	const struct usba_udc_errata *errata;
 	int irq;
 	int vbus_pin;
 	int vbus_pin_inverted;
-- 
1.9.1

