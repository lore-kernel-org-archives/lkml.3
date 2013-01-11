Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3AKS1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:27:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35723 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753704Ab3AKS1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:27:48 -0500
Date: Fri, 11 Jan 2013 13:27:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
In-Reply-To: <50F037C9.40306@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301111302380.1730-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Roger Quadros wrote:

> Apart from what you mentioned I did some more trivial changes. e.g.
> 
> +       !IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
> instead of
> +	!defined(CONFIG_USB_EHCI_HCD_OMAP) && \

Ah, that's a very good catch.  There's another entry needing the same
thing.  I'll put that in a separate preliminary patch, and also put
the ehci->priv addition in there instead of including it with the
ehci-mxc update.

> use ehci_hcd_omap_driver instead of ehci_omap_driver

Now fixed.

> I tried using ehci->priv in ehci-omap driver but noticed that the
> private data gets corrupted after the EHCI controller is running and has
> enumerated a few devices.
> 
> If I disable USB_DEBUG then things are fine. Could it be possible
> that someone is overflowing data when USB_DEBUG is enabled?
> 
> My implementation is pasted below. (May contain whitespace errors due to
> MS exchange). Patch 2 attached in case.
> 
> What was happening there is that omap_priv->phy was not the same during
> remove() as it was set to during probe().

I don't understand -- your second patch doesn't use ehci->priv at all.  
How can the private data be getting corrupted?

Below is an updated version of your second patch.  You'll need to
resolve one or two merge errors because it's not based on the same
starting point as yours.  (And it totally omits the part affecting
usb-omap.h.) But it will show you what needs to be done in order to use
ehci->priv.

> Would be nice if you could check if the same happens with ehci-mxc.

I can't -- I don't have an ARM-based system.  But if you still see 
problems, I can test with ehci-pci.

Alan Stern



Index: usb-3.7/drivers/usb/host/ehci-omap.c
===================================================================
--- usb-3.7.orig/drivers/usb/host/ehci-omap.c
+++ usb-3.7/drivers/usb/host/ehci-omap.c
@@ -69,6 +69,10 @@ static const char hcd_name[] = "ehci-oma
 
 /*-------------------------------------------------------------------------*/
 
+struct omap_ehci_hcd {
+	struct usb_phy **phy;	/* one PHY for each port */
+	int nports;
+};
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -177,7 +181,8 @@ static void disable_put_regulator(
 static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
 static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
-	.reset =	omap_ehci_init,
+	.reset =		omap_ehci_init,
+	.extra_priv_size =	sizeof(struct omap_ehci_hcd),
 };
 
 /**
@@ -193,6 +198,8 @@ static int ehci_hcd_omap_probe(struct pl
 	struct ehci_hcd_omap_platform_data	*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
+	struct omap_ehci_hcd			*omap_hcd;
+	struct usb_phy				*phy;
 	void __iomem				*regs;
 	int					ret = -ENODEV;
 	int					irq;
@@ -207,6 +214,11 @@ static int ehci_hcd_omap_probe(struct pl
 		return -ENODEV;
 	}
 
+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		return -ENODEV;
+	}
+
 	irq = platform_get_irq_byname(pdev, "ehci-irq");
 	if (irq < 0) {
 		dev_err(dev, "EHCI irq failed\n");
@@ -238,8 +250,24 @@ static int ehci_hcd_omap_probe(struct pl
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
 
+	omap_hcd = (struct omap_ehci_hcd *) (hcd_to_ehci(hcd))->priv;
+
+	omap_hcd->nports = pdata->nports;
+	i = sizeof(struct usb_phy *) * omap_hcd->nports;
+	omap_hcd->phy = devm_kzalloc(&pdev->dev, i, GFP_KERNEL);
+	if (!omap_hcd->phy) {
+		dev_err(dev, "Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto err_alloc_phy;
+	}
+
+	platform_set_drvdata(pdev, hcd);
+
 	/* get ehci regulator and enable */
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		struct platform_device *phy_pdev;
+		struct usbhs_phy_config *phy_config;
+
 		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
 			pdata->regulator[i] = NULL;
 			continue;
@@ -253,6 +281,33 @@ static int ehci_hcd_omap_probe(struct pl
 		} else {
 			regulator_enable(pdata->regulator[i]);
 		}
+
+		/* instantiate PHY */
+		if (!pdata->phy_config[i]) {
+			dev_dbg(dev, "missing phy_config for port %d\n", i);
+			continue;
+		}
+
+		phy_config = pdata->phy_config[i];
+		phy_pdev = platform_device_register_data(&pdev->dev,
+				phy_config->name, i, phy_config->pdata,
+				phy_config->pdata_size);
+		if (IS_ERR(phy_pdev)) {
+			dev_dbg(dev, "error creating PHY device for port %d\n",
+					i);
+		}
+
+		phy = usb_get_phy_from_dev(&phy_pdev->dev);
+		if (IS_ERR(phy)) {
+			dev_dbg(dev, "could not get USB PHY for port %d\n", i);
+			platform_device_unregister(phy_pdev);
+			continue;
+		}
+
+		usb_phy_init(phy);
+		omap_hcd->phy[i] = phy;
+		/* bring PHY out of suspend */
+		usb_phy_set_suspend(omap_hcd->phy[i], 0);
 	}
 
 	pm_runtime_enable(dev);
@@ -282,6 +336,14 @@ static int ehci_hcd_omap_probe(struct pl
 err_pm_runtime:
 	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		phy = omap_hcd->phy[i];
+		if (!phy)
+			continue;
+		platform_device_unregister(to_platform_device(phy->dev));
+	}
+
+err_alloc_phy:
 	usb_put_hcd(hcd);
 
 err_io:
@@ -300,13 +362,26 @@ err_io:
  */
 static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
-	struct device *dev				= &pdev->dev;
-	struct usb_hcd *hcd				= dev_get_drvdata(dev);
-	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
+	struct device *dev		= &pdev->dev;
+	struct usb_hcd *hcd		= dev_get_drvdata(dev);
+	struct omap_ehci_hcd *omap_hcd;
+	int i;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
+
+	omap_hcd = (struct omap_ehci_hcd *) (hcd_to_ehci(hcd))->priv;
+	for (i = 0; i < omap_hcd->nports; i++) {
+		struct usb_phy *phy = omap_hcd->phy[i];
+
+		if (!phy)
+			continue;
+
+		usb_phy_shutdown(phy);
+		platform_device_unregister(to_platform_device(phy->dev));
+	}
+
 	usb_put_hcd(hcd);
 
 	pm_runtime_put_sync(dev);

