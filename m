Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3AKQDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:03:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38255 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3AKQDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:03:38 -0500
Message-ID: <50F037C9.40306@ti.com>
Date: Fri, 11 Jan 2013 18:03:21 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
References: <Pine.LNX.4.44L0.1301111019340.1730-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301111019340.1730-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
	boundary="------------050509080402050001080907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050509080402050001080907
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 01/11/2013 05:28 PM, Alan Stern wrote:
> On Fri, 11 Jan 2013, Roger Quadros wrote:
> 
>> Alan,
>>
>> Thanks for the patch. I've pasted the version that builds and works and
>> put you as the Author of the patch, hope it is fine.
> 
> As far as I can see, yours is the same as what I posted except that:
> 
> 	You altered the changes to ehci-hcd.c and Makefile to remove 
> 	the dependency on the ehci-mxc patch;
> 
> 	You made an unimportant whitespace change in ehci-omap.c
> 	(moved a blank line before ehci_write()).
> 
> Right?  It's hard to compare the patches directly because the one you 
> posted was whitespace-damaged.

My bad pasting it. Patch is attached now.

Apart from what you mentioned I did some more trivial changes. e.g.

+       !IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
instead of
+	!defined(CONFIG_USB_EHCI_HCD_OMAP) && \

use ehci_hcd_omap_driver instead of ehci_omap_driver


> 
> Anyway, if this is okay and there's nothing wrong with the ehci-mxc 
> change (other than the comment for ehci->priv), I'll submit both of 
> them to Greg soon.
> 

OK, thanks.

I tried using ehci->priv in ehci-omap driver but noticed that the
private data gets corrupted after the EHCI controller is running and has
enumerated a few devices.

If I disable USB_DEBUG then things are fine. Could it be possible
that someone is overflowing data when USB_DEBUG is enabled?

My implementation is pasted below. (May contain whitespace errors due to
MS exchange). Patch 2 attached in case.

What was happening there is that omap_priv->phy was not the same during
remove() as it was set to during probe().

Would be nice if you could check if the same happens with ehci-mxc.

cheers,
-roger

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 6388aa6..23c9b9c 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -70,6 +70,11 @@ static const char hcd_name[] = "ehci-omap";

 /*-------------------------------------------------------------------------*/

+struct omap_ehci_hcd {
+	struct usb_hcd *hcd;
+	struct usb_phy **phy;	/* one PHY for each port */
+	int nports;
+};

 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -194,6 +199,8 @@ static int ehci_hcd_omap_probe(struct
platform_device *pdev)
 	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
+	struct omap_ehci_hcd			*omap_hcd;
+	struct usb_phy				*phy;
 	void __iomem				*regs;
 	int					ret = -ENODEV;
 	int					irq;
@@ -208,6 +215,25 @@ static int ehci_hcd_omap_probe(struct
platform_device *pdev)
 		return -ENODEV;
 	}

+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		return -ENODEV;
+	}
+
+	omap_hcd = devm_kzalloc(&pdev->dev, sizeof(*omap_hcd), GFP_KERNEL);
+	if (!omap_hcd) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	omap_hcd->nports = pdata->nports;
+	i = sizeof(struct usb_phy *) * omap_hcd->nports;
+	omap_hcd->phy = devm_kzalloc(&pdev->dev, i, GFP_KERNEL);
+	if (!omap_hcd->phy) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq_byname(pdev, "ehci-irq");
 	if (irq < 0) {
 		dev_err(dev, "EHCI irq failed\n");
@@ -238,9 +264,15 @@ static int ehci_hcd_omap_probe(struct
platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	omap_hcd->hcd = hcd;
+
+	platform_set_drvdata(pdev, omap_hcd);

 	/* get ehci regulator and enable */
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		struct platform_device *phy_pdev;
+		struct usbhs_phy_config *phy_config;
+
 		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
 			pdata->regulator[i] = NULL;
 			continue;
@@ -254,6 +286,33 @@ static int ehci_hcd_omap_probe(struct
platform_device *pdev)
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
@@ -284,6 +343,12 @@ err_pm_runtime:
 	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		phy = omap_hcd->phy[i];
+		if (!phy)
+			continue;
+		platform_device_unregister(to_platform_device(phy->dev));
+	}

 err_io:
 	iounmap(regs);
@@ -301,14 +366,26 @@ err_io:
  */
 static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
-	struct device *dev				= &pdev->dev;
-	struct usb_hcd *hcd				= dev_get_drvdata(dev);
+	struct device *dev		= &pdev->dev;
+	struct omap_ehci_hcd *omap_hcd	= dev_get_drvdata(dev);
+	struct usb_hcd *hcd		= omap_hcd->hcd;
+	int i;

 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
 	usb_put_hcd(hcd);

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
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);

diff --git a/include/linux/platform_data/usb-omap.h
b/include/linux/platform_data/usb-omap.h
index d63eb7d..927b8a1 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -38,6 +38,12 @@ enum usbhs_omap_port_mode {
 	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
 };

+struct usbhs_phy_config {
+	char *name;		/* binds to device driver */
+	void *pdata;		/* platform data for the phy */
+	size_t pdata_size;
+};
+
 struct usbhs_omap_platform_data {
 	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
@@ -49,6 +55,8 @@ struct usbhs_omap_platform_data {
 	unsigned			single_ulpi_bypass:1;
 	unsigned			es2_compatibility:1;
 	unsigned			phy_reset:1;
+
+	struct usbhs_phy_config		*phy_config[OMAP3_HS_USB_PORTS];
 };

 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1



--------------050509080402050001080907
Content-Type: text/x-patch;
	name="0001-USB-ehci-omap-Convert-to-platform-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-USB-ehci-omap-Convert-to-platform-driver.patch"

>From fafa9c787bcf2ff3f46c07c045997614d7a8a417 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 11 Jan 2013 12:37:01 +0200
Subject: [PATCH] USB: ehci-omap: Convert to platform driver

Convert ehci-omap into a platform driver and use ehci-hcd
as a library.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/Kconfig     |    2 +-
 drivers/usb/host/Makefile    |    1 +
 drivers/usb/host/ehci-hcd.c  |    6 +---
 drivers/usb/host/ehci-omap.c |   76 +++++++++++++++++++-----------------------
 4 files changed, 37 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index d6bb128..432a463 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -155,7 +155,7 @@ config USB_EHCI_MXC
 	  Variation of ARC USB block used in some Freescale chips.
 
 config USB_EHCI_HCD_OMAP
-	bool "EHCI support for OMAP3 and later chips"
+	tristate "EHCI support for OMAP3 and later chips"
 	depends on USB_EHCI_HCD && ARCH_OMAP
 	default y
 	---help---
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 1eb4c30..8a8d079 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_PCI)		+= pci-quirks.o
 obj-$(CONFIG_USB_EHCI_HCD)	+= ehci-hcd.o
 obj-$(CONFIG_USB_EHCI_PCI)	+= ehci-pci.o
 obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
+obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c97503b..c44ef1d 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1260,11 +1260,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_hcd_sh_driver
 #endif
 
-#ifdef CONFIG_USB_EHCI_HCD_OMAP
-#include "ehci-omap.c"
-#define        PLATFORM_DRIVER         ehci_hcd_omap_driver
-#endif
-
 #ifdef CONFIG_PPC_PS3
 #include "ehci-ps3.c"
 #define	PS3_SYSTEM_BUS_DRIVER	ps3_ehci_driver
@@ -1352,6 +1347,7 @@ MODULE_LICENSE ("GPL");
 
 #if !IS_ENABLED(CONFIG_USB_EHCI_PCI) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_PLATFORM) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
 	!defined(CONFIG_USB_CHIPIDEA_HOST) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index b96a4bf..6388aa6 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -36,6 +36,9 @@
  *	- convert to use hwmod and runtime PM
  */
 
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/usb/ulpi.h>
@@ -43,6 +46,10 @@
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include "ehci.h"
 
 #include <linux/platform_data/usb-omap.h>
 
@@ -57,9 +64,11 @@
 #define	EHCI_INSNREG05_ULPI_EXTREGADD_SHIFT		8
 #define	EHCI_INSNREG05_ULPI_WRDATA_SHIFT		0
 
-/*-------------------------------------------------------------------------*/
+#define DRIVER_DESC "OMAP-EHCI Host Controller driver"
 
-static const struct hc_driver ehci_omap_hc_driver;
+static const char hcd_name[] = "ehci-omap";
+
+/*-------------------------------------------------------------------------*/
 
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
@@ -166,6 +175,12 @@ static void disable_put_regulator(
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
+static struct hc_driver __read_mostly ehci_omap_hc_driver;
+
+static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
+	.reset =	omap_ehci_init,
+};
+
 /**
  * ehci_hcd_omap_probe - initialize TI-based HCDs
  *
@@ -315,56 +330,33 @@ static struct platform_driver ehci_hcd_omap_driver = {
 	/*.suspend		= ehci_hcd_omap_suspend, */
 	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
-		.name		= "ehci-omap",
+		.name		= hcd_name,
 	}
 };
 
 /*-------------------------------------------------------------------------*/
 
-static const struct hc_driver ehci_omap_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "OMAP-EHCI Host Controller",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset			= omap_ehci_init,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
+static int __init ehci_omap_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
 
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number	= ehci_get_frame,
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
 
-	/*
-	 * root hub support
-	 */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
+	ehci_init_driver(&ehci_omap_hc_driver, &ehci_omap_overrides);
+	return platform_driver_register(&ehci_hcd_omap_driver);
+}
+module_init(ehci_omap_init);
 
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-};
+static void __exit ehci_omap_cleanup(void)
+{
+	platform_driver_unregister(&ehci_hcd_omap_driver);
+}
+module_exit(ehci_omap_cleanup);
 
 MODULE_ALIAS("platform:omap-ehci");
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
 
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
-- 
1.7.4.1


--------------050509080402050001080907
Content-Type: text/x-patch;
	name="0002-usb-ehci-omap-Instantiate-PHY-devices-if-required.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0002-usb-ehci-omap-Instantiate-PHY-devices-if-required.patch"

>From 1f0e3fdaeda35c96edfdc551434cc841f3b65363 Mon Sep 17 00:00:00 2001
From: Roger Quadros <rogerq@ti.com>
Date: Tue, 8 Jan 2013 16:05:16 +0200
Subject: [PATCH] usb: ehci-omap: Instantiate PHY devices if required

If the OMAP's Host controller is in PHY mode then we instantiate
a platform device for the PHY (one for each port in PHY mode) and
hold a reference to it so that we can use the usb_phy API, e.g.
while suspend/resume.

The platform data for the PHY must be supplied in the newly added
.phy_config parameter in struct usbhs_omap_platform_data.

The end goal is to move the PHY's reset and power handling code
out of the ehci-omap driver and into the phy driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c           |   83 ++++++++++++++++++++++++++++++-
 include/linux/platform_data/usb-omap.h |    8 +++
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 6388aa6..23c9b9c 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -70,6 +70,11 @@ static const char hcd_name[] = "ehci-omap";
 
 /*-------------------------------------------------------------------------*/
 
+struct omap_ehci_hcd {
+	struct usb_hcd *hcd;
+	struct usb_phy **phy;	/* one PHY for each port */
+	int nports;
+};
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -194,6 +199,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
+	struct omap_ehci_hcd			*omap_hcd;
+	struct usb_phy				*phy;
 	void __iomem				*regs;
 	int					ret = -ENODEV;
 	int					irq;
@@ -208,6 +215,25 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		return -ENODEV;
+	}
+
+	omap_hcd = devm_kzalloc(&pdev->dev, sizeof(*omap_hcd), GFP_KERNEL);
+	if (!omap_hcd) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	omap_hcd->nports = pdata->nports;
+	i = sizeof(struct usb_phy *) * omap_hcd->nports;
+	omap_hcd->phy = devm_kzalloc(&pdev->dev, i, GFP_KERNEL);
+	if (!omap_hcd->phy) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq_byname(pdev, "ehci-irq");
 	if (irq < 0) {
 		dev_err(dev, "EHCI irq failed\n");
@@ -238,9 +264,15 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	omap_hcd->hcd = hcd;
+
+	platform_set_drvdata(pdev, omap_hcd);
 
 	/* get ehci regulator and enable */
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		struct platform_device *phy_pdev;
+		struct usbhs_phy_config *phy_config;
+
 		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
 			pdata->regulator[i] = NULL;
 			continue;
@@ -254,6 +286,33 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
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
@@ -284,6 +343,12 @@ err_pm_runtime:
 	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		phy = omap_hcd->phy[i];
+		if (!phy)
+			continue;
+		platform_device_unregister(to_platform_device(phy->dev));
+	}
 
 err_io:
 	iounmap(regs);
@@ -301,14 +366,26 @@ err_io:
  */
 static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
-	struct device *dev				= &pdev->dev;
-	struct usb_hcd *hcd				= dev_get_drvdata(dev);
+	struct device *dev		= &pdev->dev;
+	struct omap_ehci_hcd *omap_hcd	= dev_get_drvdata(dev);
+	struct usb_hcd *hcd		= omap_hcd->hcd;
+	int i;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
 
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
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
index d63eb7d..927b8a1 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -38,6 +38,12 @@ enum usbhs_omap_port_mode {
 	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
 };
 
+struct usbhs_phy_config {
+	char *name;		/* binds to device driver */
+	void *pdata;		/* platform data for the phy */
+	size_t pdata_size;
+};
+
 struct usbhs_omap_platform_data {
 	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
@@ -49,6 +55,8 @@ struct usbhs_omap_platform_data {
 	unsigned			single_ulpi_bypass:1;
 	unsigned			es2_compatibility:1;
 	unsigned			phy_reset:1;
+
+	struct usbhs_phy_config		*phy_config[OMAP3_HS_USB_PORTS];
 };
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1


--------------050509080402050001080907--
