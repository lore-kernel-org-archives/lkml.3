Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaLCLdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:33:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39315 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752616AbaLCLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:32:24 -0500
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
Subject: [PATCH 09/11] usb: gadget: at91_udc: Allocate udc instance
Date: Wed,  3 Dec 2014 12:32:08 +0100
Message-Id: <1417606330-17753-10-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate udc structure instead of relying on the statically declared
object.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 101 ++++++++++----------------------------
 1 file changed, 27 insertions(+), 74 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index f870c03..2b20dd7 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -59,7 +59,15 @@
 #define	DRIVER_VERSION	"3 May 2006"
 
 static const char driver_name [] = "at91_udc";
-static const char ep0name[] = "ep0";
+static const char * const ep_names[] = {
+	"ep0",
+	"ep1",
+	"ep2",
+	"ep3-int",
+	"ep4",
+	"ep5",
+};
+#define ep0name		ep_names[0]
 
 #define VBUS_POLL_TIMEOUT	msecs_to_jiffies(1000)
 
@@ -1477,78 +1485,6 @@ static void nop_release(struct device *dev)
 	/* nothing to free */
 }
 
-static struct at91_udc controller = {
-	.gadget = {
-		.ops	= &at91_udc_ops,
-		.ep0	= &controller.ep[0].ep,
-		.name	= driver_name,
-		.dev	= {
-			.init_name = "gadget",
-			.release = nop_release,
-		}
-	},
-	.ep[0] = {
-		.ep = {
-			.name	= ep0name,
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.maxpacket	= 8,
-		.int_mask	= 1 << 0,
-	},
-	.ep[1] = {
-		.ep = {
-			.name	= "ep1",
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.is_pingpong	= 1,
-		.maxpacket	= 64,
-		.int_mask	= 1 << 1,
-	},
-	.ep[2] = {
-		.ep = {
-			.name	= "ep2",
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.is_pingpong	= 1,
-		.maxpacket	= 64,
-		.int_mask	= 1 << 2,
-	},
-	.ep[3] = {
-		.ep = {
-			/* could actually do bulk too */
-			.name	= "ep3-int",
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.maxpacket	= 8,
-		.int_mask	= 1 << 3,
-	},
-	.ep[4] = {
-		.ep = {
-			.name	= "ep4",
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.is_pingpong	= 1,
-		.maxpacket	= 256,
-		.int_mask	= 1 << 4,
-	},
-	.ep[5] = {
-		.ep = {
-			.name	= "ep5",
-			.ops	= &at91_ep_ops,
-		},
-		.udc		= &controller,
-		.is_pingpong	= 1,
-		.maxpacket	= 256,
-		.int_mask	= 1 << 5,
-	},
-	/* ep6 and ep7 are also reserved (custom silicon might use them) */
-};
-
 static void at91_vbus_update(struct at91_udc *udc, unsigned value)
 {
 	value ^= udc->board.vbus_active_low;
@@ -1859,15 +1795,32 @@ static int at91udc_probe(struct platform_device *pdev)
 	struct at91_ep	*ep;
 	int		i;
 
+	udc = devm_kzalloc(dev, sizeof(*udc), GFP_KERNEL);
+	if (!udc)
+		return -ENOMEM;
+
 	/* init software state */
-	udc = &controller;
 	udc->gadget.dev.parent = dev;
 	at91udc_of_init(udc, pdev->dev.of_node);
 	udc->pdev = pdev;
 	udc->enabled = 0;
 	spin_lock_init(&udc->lock);
 
+	udc->gadget.ops = &at91_udc_ops;
+	udc->gadget.ep0 = &udc->ep[0].ep;
+	udc->gadget.name = driver_name;
+	udc->gadget.dev.init_name = "gadget";
+	udc->gadget.dev.release = nop_release;
 
+	for (i = 0; i < NUM_ENDPOINTS; i++) {
+		ep = &udc->ep[i];
+		ep->ep.name = ep_names[i];
+		ep->ep.ops = &at91_ep_ops;
+		ep->udc = udc;
+		ep->int_mask = BIT(i);
+		if (i != 0 && i != 3)
+			ep->is_pingpong = 1;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	udc->udp_baseaddr = devm_ioremap_resource(dev, res);
-- 
1.9.1

