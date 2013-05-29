Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876Ab3E2Ln5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:43:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43337 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965838Ab3E2Lnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:43:45 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <kishon@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/5] USB: PHY: Make PHY driver selection possible by controller drivers
Date: Wed, 29 May 2013 14:43:27 +0300
Message-ID: <1369827811-534-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369827811-534-1-git-send-email-rogerq@ti.com>
References: <1369827811-534-1-git-send-email-rogerq@ti.com>
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
has a negative effect that makes it invisible to the user till
USB_PHY is selected. Most end users will not familiar with this.

With this patch, the end user just needs to select the controller driver
needed for his/her platform without worrying about which PHY driver to
select.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/Makefile    |    3 +--
 drivers/usb/phy/Kconfig |   31 +++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

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

