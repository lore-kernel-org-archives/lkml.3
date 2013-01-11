Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3AKK7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:59:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53691 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab3AKK7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:59:13 -0500
Message-ID: <50EFF075.5090203@ti.com>
Date: Fri, 11 Jan 2013 12:59:01 +0200
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
References: <Pine.LNX.4.44L0.1301101544140.1178-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301101544140.1178-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 10:48 PM, Alan Stern wrote:
> On Thu, 10 Jan 2013, Roger Quadros wrote:
> 
>> If the OMAP's Host controller is in PHY mode then we instantiate
>> a platform device for the PHY (one for each port in PHY mode) and
>> hold a reference to it so that we can use the usb_phy API, e.g.
>> while suspend/resume.
>>
>> The platform data for the PHY must be supplied in the newly added
>> .phy_config parameter in struct usbhs_omap_platform_data.
>>
>> The end goal is to move the PHY's reset and power handling code
>> out of the ehci-omap driver and into the phy driver.
> 
> As mentioned in another thread, I would prefer to have these changes to 
> ehci-omap.c made after the driver is converted to the new "ehci-hcd is 
> a library" scheme.  The patch below does the conversion; it is meant to 
> apply on top of the similar patch for ehci-mxc posted recently on the 
> linux-usb mailing list.
> 
> After this conversion, the omap_ehci_hcd private data structure doesn't 
> have to be allocated specifically.  It can be handled in the same way 
> as the private data structure in the ehci-mxc patch.
> 
> I haven't even tried to compile this.  Please let me know how it works.
> 

Alan,

Thanks for the patch. I've pasted the version that builds and works and
put you as the Author of the patch, hope it is fine.

I could not find the equivalent ehci-mxc implementation though. Any
pointers to that? Thanks.

cheers,
-roger

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
 drivers/usb/host/ehci-omap.c |   76
+++++++++++++++++++-----------------------
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
+static const struct ehci_driver_overrides ehci_omap_overrides
__initdata = {
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


