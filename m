Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab3EBPUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:20:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759940Ab3EBPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 17/22] USB: OHCI: clarify Kconfig dependencies
Date: Thu,  2 May 2013 17:16:21 +0200
Message-Id: <1367507786-505303-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dqLTAwSrWf8OA8BI8cmnLI7jz+JC9z1Lr345KKg3LE2
 YeZlRMhTbCWIvrZDm8ZS6WQpf9GGU2iId3JM1oBjIQlGDnA/7H
 tSm1Px8lFBAbxWmbPDjMI7N7OFh44icfVXkk7pCxsRfbyKSdAr
 iLHg4sRrOozLGklguGHA/PhMHyKkWjwLXLzh4ptnKv3fDiDwra
 2jYfEs0gKf8l7SbEbMMNKA+JK5R+YZB6+Yz51kR8s4Bk88GeK+
 40+2cbXR5hPulZdB8fo3oTccbEADMk39VwjcfMrsBecIWM3O0X
 ZnH2uYxdgTjJp5NP6N8aImZZFGutXfZzdzBGqdDr38RtFIVzbW
 swqZ1tIVrPCqIfNItyb1ZwpMt303b4wt2OFzGffWe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OHCI driver currently gives a build error if the base driver is
enabled but none of its bus glues are turned on:

drivers/usb/host/ohci-hcd.c:1209:2: error:
 #error "missing bus glue for ohci-hcd"  #error "missing bus glue for ohci-hcd"

A better solution for this is to change the Kconfig statements to
prevent getting into this situation. This adds a new USB_UHCI_CORE
symbol in Kconfig, which is selected by each of the bus glues.
This way, the driver never gets built if all of them are disabled.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/Kconfig    | 29 +++++++++++++++++++++++++++++
 drivers/usb/host/Makefile   |  2 +-
 drivers/usb/host/ohci-hcd.c | 19 -------------------
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 656af4d..46d1b9e 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -368,9 +368,30 @@ config USB_OHCI_HCD
 
 if USB_OHCI_HCD
 
+config USB_OHCI_CORE
+	tristate
+	depends on USB_OHCI_HCD
+	default y if PCI
+	default y if ARCH_SA1100 && SA1111
+	default y if ARCH_S3C24XX
+	default y if ARCH_S3C64XX
+	default y if PXA27x
+	default y if PXA3xx
+	default y if ARCH_EP93XX
+	default y if ARCH_AT91
+	default y if ARCH_LPC32XX
+	default y if ARCH_DAVINCI_DA8XX
+	default y if PLAT_SPEAR
+	default y if PPC_PS3
+	default y if MFD_SM501
+	default y if MFD_TC6393XB
+	default y if MACH_JZ4740
+	default y if TILE_USB
+
 config USB_OHCI_HCD_OMAP1
 	bool "OHCI support for OMAP1/2 chips"
 	depends on ARCH_OMAP1
+	select USB_OHCI_CORE
 	default y
 	---help---
 	  Enables support for the OHCI controller on OMAP1/2 chips.
@@ -378,6 +399,7 @@ config USB_OHCI_HCD_OMAP1
 config USB_OHCI_HCD_OMAP3
 	bool "OHCI support for OMAP3 and later chips"
 	depends on (ARCH_OMAP3 || ARCH_OMAP4)
+	select USB_OHCI_CORE
 	default y
 	---help---
 	  Enables support for the on-chip OHCI controller on
@@ -398,6 +420,7 @@ config USB_OHCI_ATH79
 config USB_OHCI_HCD_PPC_OF_BE
 	bool "OHCI support for OF platform bus (big endian)"
 	depends on PPC_OF
+	select USB_OHCI_CORE
 	select USB_OHCI_BIG_ENDIAN_DESC
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	---help---
@@ -407,6 +430,7 @@ config USB_OHCI_HCD_PPC_OF_BE
 config USB_OHCI_HCD_PPC_OF_LE
 	bool "OHCI support for OF platform bus (little endian)"
 	depends on PPC_OF
+	select USB_OHCI_CORE
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
 	  Enables support for little-endian USB controllers present on the
@@ -421,6 +445,7 @@ config USB_OHCI_HCD_PCI
 	bool "OHCI support for PCI-bus USB controllers"
 	depends on PCI && (STB03xxx || PPC_MPC52xx || USB_OHCI_HCD_PPC_OF)
 	default y
+	select USB_OHCI_CORE
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
 	  Enables support for PCI-bus plug-in USB controller cards.
@@ -458,6 +483,7 @@ config USB_OHCI_SH
 config USB_OHCI_EXYNOS
 	boolean "OHCI support for Samsung EXYNOS SoC Series"
 	depends on ARCH_EXYNOS
+	select USB_OHCI_CORE
 	help
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 
@@ -465,6 +491,7 @@ config USB_CNS3XXX_OHCI
 	bool "Cavium CNS3XXX OHCI Module (DEPRECATED)"
 	depends on ARCH_CNS3XXX
 	select USB_OHCI_HCD_PLATFORM
+	select USB_OHCI_CORE
 	---help---
 	  This option is deprecated now and the driver was removed, use
 	  USB_OHCI_HCD_PLATFORM instead.
@@ -475,6 +502,7 @@ config USB_CNS3XXX_OHCI
 config USB_OHCI_HCD_PLATFORM
 	bool "Generic OHCI driver for a platform device"
 	default n
+	select USB_OHCI_CORE
 	---help---
 	  Adds an OHCI host driver for a generic platform device, which
 	  provides a memory space and an irq.
@@ -487,6 +515,7 @@ config USB_OCTEON_OHCI
 	default USB_OCTEON_EHCI
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	select USB_OHCI_LITTLE_ENDIAN
+	select USB_OHCI_CORE
 	help
 	  Enable support for the Octeon II SOC's on-chip OHCI
 	  controller.  It is needed for low-speed USB 1.0 device
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 1441d42..2697bd9 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
-obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
+obj-$(CONFIG_USB_OHCI_CORE)	+= ohci-hcd.o
 obj-$(CONFIG_USB_UHCI_CORE)	+= uhci-hcd.o
 obj-$(CONFIG_USB_FHCI_HCD)	+= fhci.o
 obj-$(CONFIG_USB_XHCI_HCD)	+= xhci-hcd.o
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 9e6de95..2bb1b06 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1190,25 +1190,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_platform_driver
 #endif
 
-#if	!defined(PCI_DRIVER) &&		\
-	!defined(PLATFORM_DRIVER) &&	\
-	!defined(OMAP1_PLATFORM_DRIVER) &&	\
-	!defined(OMAP3_PLATFORM_DRIVER) &&	\
-	!defined(OF_PLATFORM_DRIVER) &&	\
-	!defined(SA1111_DRIVER) &&	\
-	!defined(PS3_SYSTEM_BUS_DRIVER) && \
-	!defined(SM501_OHCI_DRIVER) && \
-	!defined(TMIO_OHCI_DRIVER) && \
-	!defined(S3C2410_PLATFORM_DRIVER) && \
-	!defined(EXYNOS_PLATFORM_DRIVER) && \
-	!defined(EP93XX_PLATFORM_DRIVER) && \
-	!defined(AT91_PLATFORM_DRIVER) && \
-	!defined(NXP_PLATFORM_DRIVER) && \
-	!defined(DAVINCI_PLATFORM_DRIVER) && \
-	!defined(SPEAR_PLATFORM_DRIVER)
-#error "missing bus glue for ohci-hcd"
-#endif
-
 static int __init ohci_hcd_mod_init(void)
 {
 	int retval = 0;
-- 
1.8.1.2

