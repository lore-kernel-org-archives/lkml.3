Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3A1LbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab3A1La5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:30:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 05/30] usb: phy: nop: Handle RESET for the PHY
Date: Mon, 28 Jan 2013 13:30:06 +0200
Message-ID: <1359372631-8180-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We expect the RESET line to be modeled as a regulator with supply
name "reset". The regulator should be modeled such that enabling
the regulator brings the PHY device out of RESET and disabling the
regulator holds the device in RESET.

They PHY will be held in RESET in .shutdown() and brought out of
RESET in .init().

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 0a9628c..3060ed0 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -40,6 +40,7 @@ struct nop_usb_xceiv {
 	struct device		*dev;
 	struct clk		*clk;
 	struct regulator	*vcc;
+	struct regulator	*reset;
 };
 
 static struct platform_device *pd;
@@ -80,6 +81,12 @@ static int nop_init(struct usb_phy *phy)
 	if (!IS_ERR(nop->clk))
 		clk_enable(nop->clk);
 
+	if (!IS_ERR(nop->reset)) {
+		/* De-assert RESET */
+		if (regulator_enable(nop->reset))
+			dev_err(phy->dev, "Failed to de-assert reset\n");
+	}
+
 	return 0;
 }
 
@@ -87,6 +94,12 @@ static void nop_shutdown(struct usb_phy *phy)
 {
 	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
 
+	if (!IS_ERR(nop->reset)) {
+		/* Assert RESET */
+		if (regulator_disable(nop->reset))
+			dev_err(phy->dev, "Failed to assert reset\n");
+	}
+
 	if (!IS_ERR(nop->clk))
 		clk_disable(nop->clk);
 
@@ -171,6 +184,12 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 					PTR_ERR(nop->vcc));
 	}
 
+	nop->reset = devm_regulator_get(&pdev->dev, "reset");
+	if (IS_ERR(nop->reset)) {
+		dev_dbg(&pdev->dev, "Error getting reset regulator: %ld\n",
+					PTR_ERR(nop->reset));
+	}
+
 	nop->dev		= &pdev->dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
-- 
1.7.4.1

