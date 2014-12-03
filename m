Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaLCLdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:33:43 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753098AbaLCLcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:32:21 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 07/11] usb: gadget: at91_udc: Rework for multi-platform kernel support
Date: Wed,  3 Dec 2014 12:32:06 +0100
Message-Id: <1417606330-17753-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_is_at91xxx are a set of macros defined in mach/cpu.h and are here used
to detect the SoC we are booting on.
Use compatible string + a caps structure to replace those cpu_is_xxx tests.

Remove all mach and asm headers (which are now unused).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 288 ++++++++++++++++++++++++++++----------
 drivers/usb/gadget/udc/at91_udc.h |   7 +
 2 files changed, 218 insertions(+), 77 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index ef1ee07..f870c03 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -31,16 +31,9 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/atmel.h>
-
-#include <asm/byteorder.h>
-#include <mach/hardware.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/gpio.h>
-
-#include <mach/cpu.h>
-#include <mach/at91sam9261_matrix.h>
-#include <mach/at91_matrix.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/atmel-matrix.h>
 
 #include "at91_udc.h"
 
@@ -890,8 +883,6 @@ static void clk_off(struct at91_udc *udc)
  */
 static void pullup(struct at91_udc *udc, int is_on)
 {
-	int	active = !udc->board.pullup_active_low;
-
 	if (!udc->enabled || !udc->vbus)
 		is_on = 0;
 	DBG("%sactive\n", is_on ? "" : "in");
@@ -900,40 +891,15 @@ static void pullup(struct at91_udc *udc, int is_on)
 		clk_on(udc);
 		at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, 0);
-		if (cpu_is_at91rm9200())
-			gpio_set_value(udc->board.pullup_pin, active);
-		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
-			u32	txvc = at91_udp_read(udc, AT91_UDP_TXVC);
-
-			txvc |= AT91_UDP_TXVC_PUON;
-			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
-		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
-			u32	usbpucr;
-
-			usbpucr = at91_matrix_read(AT91_MATRIX_USBPUCR);
-			usbpucr |= AT91_MATRIX_USBPUCR_PUON;
-			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
-		}
 	} else {
 		stop_activity(udc);
 		at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
-		if (cpu_is_at91rm9200())
-			gpio_set_value(udc->board.pullup_pin, !active);
-		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
-			u32	txvc = at91_udp_read(udc, AT91_UDP_TXVC);
-
-			txvc &= ~AT91_UDP_TXVC_PUON;
-			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
-		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
-			u32	usbpucr;
-
-			usbpucr = at91_matrix_read(AT91_MATRIX_USBPUCR);
-			usbpucr &= ~AT91_MATRIX_USBPUCR_PUON;
-			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
-		}
 		clk_off(udc);
 	}
+
+	if (udc->caps && udc->caps->pullup)
+		udc->caps->pullup(udc, is_on);
 }
 
 /* vbus is here!  turn everything on that's ready */
@@ -1670,12 +1636,202 @@ static void at91udc_shutdown(struct platform_device *dev)
 	spin_unlock_irqrestore(&udc->lock, flags);
 }
 
-static void at91udc_of_init(struct at91_udc *udc,
-				     struct device_node *np)
+static int at91rm9200_udc_init(struct at91_udc *udc)
+{
+	struct at91_ep *ep;
+	int ret;
+	int i;
+
+	for (i = 0; i < NUM_ENDPOINTS; i++) {
+		ep = &udc->ep[i];
+
+		switch (i) {
+		case 0:
+		case 3:
+			ep->maxpacket = 8;
+			break;
+		case 1 ... 2:
+			ep->maxpacket = 64;
+			break;
+		case 4 ... 5:
+			ep->maxpacket = 256;
+			break;
+		}
+	}
+
+	if (!gpio_is_valid(udc->board.pullup_pin)) {
+		DBG("no D+ pullup?\n");
+		return -ENODEV;
+	}
+
+	ret = devm_gpio_request(&udc->pdev->dev, udc->board.pullup_pin,
+				"udc_pullup");
+	if (ret) {
+		DBG("D+ pullup is busy\n");
+		return ret;
+	}
+
+	gpio_direction_output(udc->board.pullup_pin,
+			      udc->board.pullup_active_low);
+
+	return 0;
+}
+
+static void at91rm9200_udc_pullup(struct at91_udc *udc, int is_on)
+{
+	int active = !udc->board.pullup_active_low;
+
+	if (is_on)
+		gpio_set_value(udc->board.pullup_pin, active);
+	else
+		gpio_set_value(udc->board.pullup_pin, !active);
+}
+
+static const struct at91_udc_caps at91rm9200_udc_caps = {
+	.init = at91rm9200_udc_init,
+	.pullup = at91rm9200_udc_pullup,
+};
+
+static int at91sam9260_udc_init(struct at91_udc *udc)
+{
+	struct at91_ep *ep;
+	int i;
+
+	for (i = 0; i < NUM_ENDPOINTS; i++) {
+		ep = &udc->ep[i];
+
+		switch (i) {
+		case 0 ... 3:
+			ep->maxpacket = 64;
+			break;
+		case 4 ... 5:
+			ep->maxpacket = 512;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void at91sam9260_udc_pullup(struct at91_udc *udc, int is_on)
+{
+	u32 txvc = at91_udp_read(udc, AT91_UDP_TXVC);
+
+	if (is_on)
+		txvc |= AT91_UDP_TXVC_PUON;
+	else
+		txvc &= ~AT91_UDP_TXVC_PUON;
+
+	at91_udp_write(udc, AT91_UDP_TXVC, txvc);
+}
+
+static const struct at91_udc_caps at91sam9260_udc_caps = {
+	.init = at91sam9260_udc_init,
+	.pullup = at91sam9260_udc_pullup,
+};
+
+static int at91sam9261_udc_init(struct at91_udc *udc)
+{
+	struct at91_ep *ep;
+	int i;
+
+	for (i = 0; i < NUM_ENDPOINTS; i++) {
+		ep = &udc->ep[i];
+
+		switch (i) {
+		case 0:
+			ep->maxpacket = 8;
+			break;
+		case 1 ... 3:
+			ep->maxpacket = 64;
+			break;
+		case 4 ... 5:
+			ep->maxpacket = 256;
+			break;
+		}
+	}
+
+	udc->matrix = syscon_regmap_lookup_by_phandle(udc->pdev->dev.of_node,
+						      "atmel,matrix");
+	if (IS_ERR(udc->matrix))
+		return PTR_ERR(udc->matrix);
+
+	return 0;
+}
+
+static void at91sam9261_udc_pullup(struct at91_udc *udc, int is_on)
+{
+	u32 usbpucr = 0;
+
+	if (is_on)
+		usbpucr = AT91_MATRIX_USBPUCR_PUON;
+
+	regmap_update_bits(udc->matrix, AT91SAM9261_MATRIX_USBPUCR_OFF,
+			   AT91_MATRIX_USBPUCR_PUON, usbpucr);
+}
+
+static const struct at91_udc_caps at91sam9261_udc_caps = {
+	.init = at91sam9261_udc_init,
+	.pullup = at91sam9261_udc_pullup,
+};
+
+static int at91sam9263_udc_init(struct at91_udc *udc)
+{
+	struct at91_ep *ep;
+	int i;
+
+	for (i = 0; i < NUM_ENDPOINTS; i++) {
+		ep = &udc->ep[i];
+
+		switch (i) {
+		case 0:
+		case 1:
+		case 2:
+		case 3:
+			ep->maxpacket = 64;
+			break;
+		case 4:
+		case 5:
+			ep->maxpacket = 256;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static const struct at91_udc_caps at91sam9263_udc_caps = {
+	.init = at91sam9263_udc_init,
+	.pullup = at91sam9260_udc_pullup,
+};
+
+static const struct of_device_id at91_udc_dt_ids[] = {
+	{
+		.compatible = "atmel,at91rm9200-udc",
+		.data = &at91rm9200_udc_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9260-udc",
+		.data = &at91sam9260_udc_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9261-udc",
+		.data = &at91sam9261_udc_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9263-udc",
+		.data = &at91sam9263_udc_caps,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, at91_udc_dt_ids);
+
+static void at91udc_of_init(struct at91_udc *udc, struct device_node *np)
 {
 	struct at91_udc_data *board = &udc->board;
-	u32 val;
+	const struct of_device_id *match;
 	enum of_gpio_flags flags;
+	u32 val;
 
 	if (of_property_read_u32(np, "atmel,vbus-polled", &val) == 0)
 		board->vbus_polled = 1;
@@ -1688,6 +1844,10 @@ static void at91udc_of_init(struct at91_udc *udc,
 						  &flags);
 
 	board->pullup_active_low = (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
+
+	match = of_match_node(at91_udc_dt_ids, np);
+	if (match)
+		udc->caps = match->data;
 }
 
 static int at91udc_probe(struct platform_device *pdev)
@@ -1696,6 +1856,8 @@ static int at91udc_probe(struct platform_device *pdev)
 	struct at91_udc	*udc;
 	int		retval;
 	struct resource	*res;
+	struct at91_ep	*ep;
+	int		i;
 
 	/* init software state */
 	udc = &controller;
@@ -1705,40 +1867,19 @@ static int at91udc_probe(struct platform_device *pdev)
 	udc->enabled = 0;
 	spin_lock_init(&udc->lock);
 
-	/* rm9200 needs manual D+ pullup; off by default */
-	if (cpu_is_at91rm9200()) {
-		if (!gpio_is_valid(udc->board.pullup_pin)) {
-			DBG("no D+ pullup?\n");
-			return -ENODEV;
-		}
-		retval = devm_gpio_request(dev, udc->board.pullup_pin,
-					   "udc_pullup");
-		if (retval) {
-			DBG("D+ pullup is busy\n");
-			return retval;
-		}
-		gpio_direction_output(udc->board.pullup_pin,
-				udc->board.pullup_active_low);
-	}
 
-	/* newer chips have more FIFO memory than rm9200 */
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
-		udc->ep[0].maxpacket = 64;
-		udc->ep[3].maxpacket = 64;
-		udc->ep[4].maxpacket = 512;
-		udc->ep[5].maxpacket = 512;
-	} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
-		udc->ep[3].maxpacket = 64;
-	} else if (cpu_is_at91sam9263()) {
-		udc->ep[0].maxpacket = 64;
-		udc->ep[3].maxpacket = 64;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	udc->udp_baseaddr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(udc->udp_baseaddr))
 		return PTR_ERR(udc->udp_baseaddr);
 
+	if (udc->caps && udc->caps->init) {
+		retval = udc->caps->init(udc);
+		if (retval)
+			return retval;
+	}
+
 	udc_reinit(udc);
 
 	/* get interface and function clocks */
@@ -1907,13 +2048,6 @@ static int at91udc_resume(struct platform_device *pdev)
 #define	at91udc_resume	NULL
 #endif
 
-static const struct of_device_id at91_udc_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-udc" },
-	{ /* sentinel */ }
-};
-
-MODULE_DEVICE_TABLE(of, at91_udc_dt_ids);
-
 static struct platform_driver at91_udc_driver = {
 	.remove		= __exit_p(at91udc_remove),
 	.shutdown	= at91udc_shutdown,
diff --git a/drivers/usb/gadget/udc/at91_udc.h b/drivers/usb/gadget/udc/at91_udc.h
index e647d1c..4fc0daa 100644
--- a/drivers/usb/gadget/udc/at91_udc.h
+++ b/drivers/usb/gadget/udc/at91_udc.h
@@ -107,6 +107,11 @@ struct at91_ep {
 	unsigned			fifo_bank:1;
 };
 
+struct at91_udc_caps {
+	int (*init)(struct at91_udc *udc);
+	void (*pullup)(struct at91_udc *udc, int is_on);
+};
+
 /*
  * driver is non-SMP, and just blocks IRQs whenever it needs
  * access protection for chip registers or driver state
@@ -115,6 +120,7 @@ struct at91_udc {
 	struct usb_gadget		gadget;
 	struct at91_ep			ep[NUM_ENDPOINTS];
 	struct usb_gadget_driver	*driver;
+	const struct at91_udc_caps	*caps;
 	unsigned			vbus:1;
 	unsigned			enabled:1;
 	unsigned			clocked:1;
@@ -134,6 +140,7 @@ struct at91_udc {
 	spinlock_t			lock;
 	struct timer_list		vbus_timer;
 	struct work_struct		vbus_timer_work;
+	struct regmap			*matrix;
 };
 
 static inline struct at91_udc *to_udc(struct usb_gadget *g)
-- 
1.9.1

