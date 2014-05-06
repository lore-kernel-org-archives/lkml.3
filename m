Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbaEFAUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:20:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41431 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757110AbaEFAO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:28 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        <stable@vger.kernel.org>
Subject: [PATCH v3 01/20] usb: ehci-orion: Fix clock reference leaking
Date: Tue,  6 May 2014 02:13:56 +0200
Message-Id: <1399335255-589-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to disable the clock while the module was removing, a call to
devm_clk_get() was made. This was wrong and lead to a leak module
ref-counts.

In order to have a reference of the clock get, a private structure was
added using the override mechanism provided by the ehci framework.

The bug was introduced in v3.6, however the ehci framework allowing to
use the override mechanism have only been introduced in v3.8, so this
patch won't apply before it.

Fixes: 8c869edaee07c623066266827371235fb9c12e01 ('ARM: Orion: EHCI: Add support for enabling clocks')
Cc: <stable@vger.kernel.org> # v3.8+
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/ehci-orion.c | 49 +++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 30d35e5e503a..d6c19c37c76b 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -42,6 +42,12 @@
 
 #define DRIVER_DESC "EHCI orion driver"
 
+#define hcd_to_orion_priv(h) ((struct orion_ehci_hcd *)hcd_to_ehci(h)->priv)
+
+struct orion_ehci_hcd {
+	struct clk *clk;
+};
+
 static const char hcd_name[] = "ehci-orion";
 
 static struct hc_driver __read_mostly ehci_orion_hc_driver;
@@ -137,6 +143,10 @@ ehci_orion_conf_mbus_windows(struct usb_hcd *hcd,
 	}
 }
 
+static const struct ehci_driver_overrides orion_overrides __initdata = {
+	.extra_priv_size =	sizeof(struct orion_ehci_hcd),
+};
+
 static int ehci_orion_drv_probe(struct platform_device *pdev)
 {
 	struct orion_ehci_data *pd = dev_get_platdata(&pdev->dev);
@@ -144,10 +154,10 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
-	struct clk *clk;
 	void __iomem *regs;
 	int irq, err;
 	enum orion_ehci_phy_ver phy_version;
+	struct orion_ehci_hcd *priv;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -190,17 +200,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	/* Not all platforms can gate the clock, so it is not
-	   an error if the clock does not exists. */
-	clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(clk))
-		clk_prepare_enable(clk);
-
 	hcd = usb_create_hcd(&ehci_orion_hc_driver,
 			&pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		err = -ENOMEM;
-		goto err2;
+		goto err1;
 	}
 
 	hcd->rsrc_start = res->start;
@@ -211,6 +215,15 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	ehci->caps = hcd->regs + 0x100;
 	hcd->has_tt = 1;
 
+	priv = hcd_to_orion_priv(hcd);
+	/*
+	 * Not all platforms can gate the clock, so it is not an error if
+	 * the clock does not exists.
+	 */
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(priv->clk))
+		clk_prepare_enable(priv->clk);
+
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
 	 */
@@ -240,16 +253,16 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
-		goto err3;
+		goto err2;
 
 	device_wakeup_enable(hcd->self.controller);
 	return 0;
 
-err3:
-	usb_put_hcd(hcd);
 err2:
-	if (!IS_ERR(clk))
-		clk_disable_unprepare(clk);
+	usb_put_hcd(hcd);
+
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
 err1:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
 		dev_name(&pdev->dev), err);
@@ -260,14 +273,14 @@ err1:
 static int ehci_orion_drv_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-	struct clk *clk;
+	struct orion_ehci_hcd *priv = hcd_to_orion_priv(hcd);
 
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
-	clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(clk))
-		clk_disable_unprepare(clk);
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -295,7 +308,7 @@ static int __init ehci_orion_init(void)
 
 	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
 
-	ehci_init_driver(&ehci_orion_hc_driver, NULL);
+	ehci_init_driver(&ehci_orion_hc_driver, &orion_overrides);
 	return platform_driver_register(&ehci_orion_driver);
 }
 module_init(ehci_orion_init);
-- 
1.8.1.2

