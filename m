Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbbAFNrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:47:12 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43723 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbbAFNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:47:07 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 2/5] usb: atmel_usba_udc: Add at91sam9g45 and at91sam9x5 errata handling
Date: Tue,  6 Jan 2015 14:46:59 +0100
Message-Id: <1420552022-8422-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9g45 and at91sam9x5 SoCs have an hardware bug forcing us to
generate a pulse on the BIAS signal on "USB end of reset” and
“USB end of resume" events.

Reported-by: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/atmel_usba_udc.c | 28 +++++++++++++++++++++++++++-
 drivers/usb/gadget/udc/atmel_usba_udc.h |  2 ++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index 36fd34b..55c8dde 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -331,6 +331,17 @@ static void toggle_bias(struct usba_udc *udc, int is_on)
 		udc->errata->toggle_bias(udc, is_on);
 }
 
+static void generate_bias_pulse(struct usba_udc *udc)
+{
+	if (!udc->bias_pulse_needed)
+		return;
+
+	if (udc->errata && udc->errata->pulse_bias)
+		udc->errata->pulse_bias(udc);
+
+	udc->bias_pulse_needed = false;
+}
+
 static void next_fifo_transaction(struct usba_ep *ep, struct usba_request *req)
 {
 	unsigned int transaction_len;
@@ -1607,6 +1618,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	if (status & USBA_DET_SUSPEND) {
 		toggle_bias(udc, 0);
 		usba_writel(udc, INT_CLR, USBA_DET_SUSPEND);
+		udc->bias_pulse_needed = true;
 		DBG(DBG_BUS, "Suspend detected\n");
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
 				&& udc->driver && udc->driver->suspend) {
@@ -1624,6 +1636,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 
 	if (status & USBA_END_OF_RESUME) {
 		usba_writel(udc, INT_CLR, USBA_END_OF_RESUME);
+		generate_bias_pulse(udc);
 		DBG(DBG_BUS, "Resume detected\n");
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
 				&& udc->driver && udc->driver->resume) {
@@ -1659,6 +1672,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 		struct usba_ep *ep0;
 
 		usba_writel(udc, INT_CLR, USBA_END_OF_RESET);
+		generate_bias_pulse(udc);
 		reset_all_endpoints(udc);
 
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN && udc->driver) {
@@ -1818,13 +1832,25 @@ static void at91sam9rl_toggle_bias(struct usba_udc *udc, int is_on)
 		at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
 }
 
+static void at91sam9g45_pulse_bias(struct usba_udc *udc)
+{
+	unsigned int uckr = at91_pmc_read(AT91_CKGR_UCKR);
+
+	at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
+	at91_pmc_write(AT91_CKGR_UCKR, uckr | AT91_PMC_BIASEN);
+}
+
 static const struct usba_udc_errata at91sam9rl_errata = {
 	.toggle_bias = at91sam9rl_toggle_bias,
 };
 
+static const struct usba_udc_errata at91sam9g45_errata = {
+	.pulse_bias = at91sam9g45_pulse_bias,
+};
+
 static const struct of_device_id atmel_udc_dt_ids[] = {
 	{ .compatible = "atmel,at91sam9rl-udc", .data = &at91sam9rl_errata },
-	{ .compatible = "atmel,at91sam9g45-udc" },
+	{ .compatible = "atmel,at91sam9g45-udc", .data = &at91sam9g45_errata },
 	{ .compatible = "atmel,sama5d3-udc" },
 	{ /* sentinel */ }
 };
diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.h b/drivers/usb/gadget/udc/atmel_usba_udc.h
index 456899e..72b3537 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.h
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.h
@@ -306,6 +306,7 @@ struct usba_request {
 
 struct usba_udc_errata {
 	void (*toggle_bias)(struct usba_udc *udc, int is_on);
+	void (*pulse_bias)(struct usba_udc *udc);
 };
 
 struct usba_udc {
@@ -326,6 +327,7 @@ struct usba_udc {
 	struct clk *pclk;
 	struct clk *hclk;
 	struct usba_ep *usba_ep;
+	bool bias_pulse_needed;
 
 	u16 devstatus;
 
-- 
1.9.1

