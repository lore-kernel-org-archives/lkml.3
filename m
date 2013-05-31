Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3EaLaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:30:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab3EaL3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:29:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <arnd@arndb.de>,
        <adrienverge@gmail.com>, <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 1/2] USB: PHY: Make PHY driver selection possible by controller drivers
Date: Fri, 31 May 2013 14:29:02 +0300
Message-ID: <1369999743-11758-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369999743-11758-1-git-send-email-rogerq@ti.com>
References: <1369999743-11758-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert PHY Drivers from menuconfig to menu so that the PHY drivers
can be explicitely selected by the controller drivers.

USB_PHY is no longer a user visible option. It is upto to the PHY
drivers to select it if needed. This patch does so for the existing
PHY drivers that use the USB_PHY library.

Doing so moves the USB_PHY and PHY driver selection problem from the
end user to the PHY and controller driver developer.

e.g.

Earlier, a controller driver (e.g. EHCI_OMAP) that needs to select
a PHY driver (e.g. NOP_PHY) couldn't do so because the PHY driver
depended on USB_PHY. Making the controller driver depend on USB_PHY
has a negative effect i.e. it becomes invisible to the user till
USB_PHY is enabled. Most end users will not familiar with this.

With this patch, the end user just needs to select the controller driver
needed for his/her platform without worrying about which PHY driver to
select.

Also update USB_EHCI_MSM, USB_LPC32XX and USB_OMAP to not depend
on USB_PHY any more. They can safely select the necessary PHY drivers.

CC: Pavankumar Kondeti <pkondeti@codeaurora.org>
CC: Roland Stigge <stigge@antcom.de>
Signed-off-by: Roger Quadros <rogerq@ti.com>
[USB_LPC32XX part] Acked-by: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/Makefile       |    3 +--
 drivers/usb/gadget/Kconfig |    2 --
 drivers/usb/host/Kconfig   |    1 -
 drivers/usb/phy/Kconfig    |   31 +++++++++++++++++++++----------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index c41feba..411c34c 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -43,8 +43,7 @@ obj-$(CONFIG_USB_MICROTEK)	+= image/
 
 obj-$(CONFIG_USB_SERIAL)	+= serial/
 
-obj-$(CONFIG_USB)		+= misc/
-obj-$(CONFIG_USB_PHY)		+= phy/
+obj-$(CONFIG_USB)		+= misc/ phy/
 obj-$(CONFIG_EARLY_PRINTK_DBGP)	+= early/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index f41aa0d..86d5d80 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -144,7 +144,6 @@ config USB_AT91
 config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
 	depends on ARCH_LPC32XX
-	depends on USB_PHY
 	select USB_ISP1301
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
@@ -195,7 +194,6 @@ config USB_FUSB300
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
-	depends on USB_PHY
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
 	help
 	   Many Texas Instruments OMAP processors have flexible full
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 344d5e2..7ded784 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -188,7 +188,6 @@ config USB_EHCI_HCD_AT91
 config USB_EHCI_MSM
 	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
 	depends on ARCH_MSM
-	depends on USB_PHY
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
 	---help---
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 7ef3eb8..b57f7f0 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -1,16 +1,11 @@
 #
 # Physical Layer USB driver configuration
 #
-menuconfig USB_PHY
-	bool "USB Physical Layer drivers"
-	help
-	  USB controllers (those which are host, device or DRD) need a
-	  device to handle the physical layer signalling, commonly called
-	  a PHY.
-
-	  The following drivers add support for such PHY devices.
+menu "USB Physical Layer drivers"
 
-if USB_PHY
+config	USB_PHY
+	bool
+	default n
 
 #
 # USB Transceiver Drivers
@@ -18,6 +13,7 @@ if USB_PHY
 config AB8500_USB
 	tristate "AB8500 USB Transceiver Driver"
 	depends on AB8500_CORE
+	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver in AB8500 chip.
 	  This transceiver supports high and full speed devices plus,
@@ -27,12 +23,14 @@ config FSL_USB2_OTG
 	bool "Freescale USB OTG Transceiver Driver"
 	depends on USB_EHCI_FSL && USB_FSL_USB2 && PM_RUNTIME
 	select USB_OTG
+	select USB_PHY
 	help
 	  Enable this to support Freescale USB OTG transceiver.
 
 config ISP1301_OMAP
 	tristate "Philips ISP1301 with OMAP OTG"
 	depends on I2C && ARCH_OMAP_OTG
+	select USB_PHY
 	help
 	  If you say yes here you get support for the Philips ISP1301
 	  USB-On-The-Go transceiver working with the OMAP OTG controller.
@@ -46,12 +44,14 @@ config ISP1301_OMAP
 config MV_U3D_PHY
 	bool "Marvell USB 3.0 PHY controller Driver"
 	depends on CPU_MMP3
+	select USB_PHY
 	help
 	  Enable this to support Marvell USB 3.0 phy controller for Marvell
 	  SoC.
 
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
+	select USB_PHY
 	help
 	  This driver is to be used by all the usb transceiver which are either
 	  built-in with usb ip or which are autonomous and doesn't require any
@@ -70,6 +70,7 @@ config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
 	select OMAP_CONTROL_USB
+	select USB_PHY
 	help
 	  Enable this to support the transceiver that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
@@ -79,6 +80,7 @@ config OMAP_USB2
 config OMAP_USB3
 	tristate "OMAP USB3 PHY Driver"
 	select OMAP_CONTROL_USB
+	select USB_PHY
 	help
 	  Enable this to support the USB3 PHY that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
@@ -95,6 +97,7 @@ config SAMSUNG_USBPHY
 config SAMSUNG_USB2PHY
 	tristate "Samsung USB 2.0 PHY controller Driver"
 	select SAMSUNG_USBPHY
+	select USB_PHY
 	help
 	  Enable this to support Samsung USB 2.0 (High Speed) PHY controller
 	  driver for Samsung SoCs.
@@ -102,6 +105,7 @@ config SAMSUNG_USB2PHY
 config SAMSUNG_USB3PHY
 	tristate "Samsung USB 3.0 PHY controller Driver"
 	select SAMSUNG_USBPHY
+	select USB_PHY
 	help
 	  Enable this to support Samsung USB 3.0 (Super Speed) phy controller
 	  for samsung SoCs.
@@ -109,6 +113,7 @@ config SAMSUNG_USB3PHY
 config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
+	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
 	  family chips (including the TWL5030 and TPS659x0 devices).
@@ -129,6 +134,7 @@ config TWL6030_USB
 config USB_GPIO_VBUS
 	tristate "GPIO based peripheral-only VBUS sensing 'transceiver'"
 	depends on GPIOLIB
+	select USB_PHY
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
 	  internal transceiver via the usb_phy interface, and
@@ -139,6 +145,7 @@ config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
 	depends on USB || USB_GADGET
 	depends on I2C
+	select USB_PHY
 	help
 	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.
 	  This chip is typically used as USB transceiver for USB host, gadget
@@ -150,6 +157,7 @@ config USB_ISP1301
 config USB_MSM_OTG
 	tristate "OTG support for Qualcomm on-chip USB controller"
 	depends on (USB || USB_GADGET) && ARCH_MSM
+	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver on MSM chips. It
 	  handles PHY initialization, clock management, and workarounds
@@ -163,6 +171,7 @@ config USB_MV_OTG
 	tristate "Marvell USB OTG support"
 	depends on USB_EHCI_MV && USB_MV_UDC && PM_RUNTIME
 	select USB_OTG
+	select USB_PHY
 	help
 	  Say Y here if you want to build Marvell USB OTG transciever
 	  driver in kernel (including PXA and MMP series). This driver
@@ -174,6 +183,7 @@ config USB_MXS_PHY
 	tristate "Freescale MXS USB PHY support"
 	depends on ARCH_MXC || ARCH_MXS
 	select STMP_DEVICE
+	select USB_PHY
 	help
 	  Enable this to support the Freescale MXS USB PHY.
 
@@ -182,6 +192,7 @@ config USB_MXS_PHY
 config USB_RCAR_PHY
 	tristate "Renesas R-Car USB phy support"
 	depends on USB || USB_GADGET
+	select USB_PHY
 	help
 	  Say Y here to add support for the Renesas R-Car USB phy driver.
 	  This chip is typically used as USB phy for USB host, gadget.
@@ -204,4 +215,4 @@ config USB_ULPI_VIEWPORT
 	  Provides read/write operations to the ULPI phy register set for
 	  controllers with a viewport register (e.g. Chipidea/ARC controllers).
 
-endif # USB_PHY
+endmenu
-- 
1.7.4.1

