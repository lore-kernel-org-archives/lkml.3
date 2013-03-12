Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3CLLZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:25:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38836 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab3CLLZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:50 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 4/8] usb: phy: nop: Handle power supply regulator for the PHY
Date: Tue, 12 Mar 2013 13:24:22 +0200
Message-ID: <1363087466-32444-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363087466-32444-1-git-send-email-rogerq@ti.com>
References: <1363087466-32444-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use "vcc" as the supply name for the PHY's power supply.
The power supply will be enabled during .init() and disabled
during .shutdown()

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 17c174f..fbdcfef 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -33,11 +33,13 @@
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
+#include <linux/regulator/consumer.h>
 
 struct nop_usb_xceiv {
 	struct usb_phy		phy;
 	struct device		*dev;
 	struct clk		*clk;
+	struct regulator	*vcc;
 };
 
 static struct platform_device *pd;
@@ -70,6 +72,11 @@ static int nop_init(struct usb_phy *phy)
 {
 	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
 
+	if (!IS_ERR(nop->vcc)) {
+		if (regulator_enable(nop->vcc))
+			dev_err(phy->dev, "Failed to enable power\n");
+	}
+
 	if (!IS_ERR(nop->clk))
 		clk_enable(nop->clk);
 
@@ -82,6 +89,11 @@ static void nop_shutdown(struct usb_phy *phy)
 
 	if (!IS_ERR(nop->clk))
 		clk_disable(nop->clk);
+
+	if (!IS_ERR(nop->vcc)) {
+		if (regulator_disable(nop->vcc))
+			dev_err(phy->dev, "Failed to disable power\n");
+	}
 }
 
 static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
@@ -154,6 +166,12 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 		}
 	}
 
+	nop->vcc = devm_regulator_get(&pdev->dev, "vcc");
+	if (IS_ERR(nop->vcc)) {
+		dev_dbg(&pdev->dev, "Error getting vcc regulator: %ld\n",
+					PTR_ERR(nop->vcc));
+	}
+
 	nop->dev		= &pdev->dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
-- 
1.7.4.1

