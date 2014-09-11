Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaIKM4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:56:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57407 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbaIKMxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:53:52 -0400
X-AuditID: cbfee61a-f79e46d00000134f-aa-54119b5e9417
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, dinguyen@opensource.altera.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/2] Revert "usb: dwc2: Update Kconfig to support dual-role"
Date: Thu, 11 Sep 2014 14:53:30 +0200
Message-id: <1410440011-9106-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
References: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd242YIhBj96FSw2zljParHq0xpm
	i+bF69ksLu+aw2axaFkrs8XaI3fZLbZPmc5k8eDwTnYHDo/9c9ewe/Rfm8Tu0bdlFaPHlv2f
	GT0+b5ILYI3isklJzcksSy3St0vgypjWd5ytYK96xblFL9kaGM/JdzFyckgImEisW7GGCcIW
	k7hwbz1bFyMXh5DAIkaJnz8aoJx2Jok/3zayglSxCehIbPk+gbGLkYNDBKjj+wdOkBpmgZuM
	EvOXT2IHiQsL+EgcfcEFUs4ioCpx7PNVNhCbV8BFouPeDahlchInj00GG8kp4CqxvncPO4gt
	BFTzcc95tgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIfXM6kdjCsbLA4xCnAw
	KvHwVrAIhgixJpYVV+YeYpTgYFYS4b0xHSjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQ
	QHpiSWp2ampBahFMlomDU6qBsV74Upn0ncz7AQ85m5V1nMUmhO+dtPrcR0v/0x8c8kSlRbzm
	CTB2v49eeluBa/EijQ+1d75XnTdpOjgv7BavMCtnw65LxVknmW7WCyul1Ghp/xG7qlO0cGes
	Z/o5582Ks/tllPinej03X3rEoeKEuA3jajahX/uzmie3H+AJkJvgLL04Z7q9EktxRqKhFnNR
	cSIAL1uS9SsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e006fee6ecfed5b957bdd41c236aad751ab29042.

This patch causes build break. Modifications in Makefile and Kconfig have
no connection with driver code.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/Kconfig  | 63 ++++++++++++++++++++---------------------------
 drivers/usb/dwc2/Makefile | 21 ++++++++--------
 2 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
index 4396a1f..f93807b 100644
--- a/drivers/usb/dwc2/Kconfig
+++ b/drivers/usb/dwc2/Kconfig
@@ -1,29 +1,40 @@
 config USB_DWC2
-	tristate "DesignWare USB2 DRD Core Support"
+	bool "DesignWare USB2 DRD Core Support"
 	depends on USB
 	help
 	  Say Y here if your system has a Dual Role Hi-Speed USB
 	  controller based on the DesignWare HSOTG IP Core.
 
-	  If you choose to build the driver as dynamically
-	  linked modules, a single dwc2.ko(regardless of mode of operation)
-	  will get built for both platform IPs and PCI.
+	  For host mode, if you choose to build the driver as dynamically
+	  linked modules, the core module will be called dwc2.ko, the PCI
+	  bus interface module (if you have a PCI bus system) will be
+	  called dwc2_pci.ko, and the platform interface module (for
+	  controllers directly connected to the CPU) will be called
+	  dwc2_platform.ko. For gadget mode, there will be a single
+	  module called dwc2_gadget.ko.
 
-if USB_DWC2
+	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
+	  host and gadget drivers are still currently separate drivers.
+	  There are plans to merge the dwc2_gadget driver with the dwc2
+	  host driver in the near future to create a dual-role driver.
 
-choice
-	bool "DWC2 Mode Selection"
-	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
-	default USB_DWC2_HOST if (USB && !USB_GADGET)
-	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
+if USB_DWC2
 
 config USB_DWC2_HOST
-	bool "Host only mode"
+	tristate "Host only mode"
 	depends on USB
 	help
 	  The Designware USB2.0 high-speed host controller
-	  integrated into many SoCs. Select this option if you want the
-	  driver to operate in Host-only mode.
+	  integrated into many SoCs.
+
+config USB_DWC2_PLATFORM
+	bool "DWC2 Platform"
+	depends on USB_DWC2_HOST
+	default USB_DWC2_HOST
+	help
+	  The Designware USB2.0 platform interface module for
+	  controllers directly connected to the CPU. This is only
+	  used for host mode.
 
 config USB_DWC2_PCI
 	bool "DWC2 PCI"
@@ -36,31 +47,11 @@ config USB_DWC2_PCI
 comment "Gadget mode requires USB Gadget support to be enabled"
 
 config USB_DWC2_PERIPHERAL
-	bool "Gadget only mode"
-	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
+	tristate "Gadget only mode"
+	depends on USB_GADGET
 	help
 	  The Designware USB2.0 high-speed gadget controller
-	  integrated into many SoCs. Select this option if you want the
-	  driver to operate in Peripheral-only mode. This option requires
-	  USB_GADGET=y.
-
-config USB_DWC2_DUAL_ROLE
-	bool "Dual Role mode"
-	depends on ((USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2))
-	help
-	  Select this option if you want the driver to work in a dual-role
-	  mode. In this mode both host and gadget features are enabled, and
-	  the role will be determined by the cable that gets plugged-in. This
-	  option requires USB_GADGET=y.
-endchoice
-
-config USB_DWC2_PLATFORM
-	bool
-        depends on !PCI
-        default y
-        help
-          The Designware USB2.0 platform interface module for
-          controllers directly connected to the CPU.
+	  integrated into many SoCs.
 
 config USB_DWC2_DEBUG
 	bool "Enable Debugging Messages"
diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
index 3026135..b73d2a5 100644
--- a/drivers/usb/dwc2/Makefile
+++ b/drivers/usb/dwc2/Makefile
@@ -1,17 +1,10 @@
 ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
 ccflags-$(CONFIG_USB_DWC2_VERBOSE)	+= -DVERBOSE_DEBUG
 
-obj-$(CONFIG_USB_DWC2)			+= dwc2.o
+obj-$(CONFIG_USB_DWC2_HOST)		+= dwc2.o
 dwc2-y					:= core.o core_intr.o
-
-ifneq ($(filter y,$(CONFIG_USB_DWC2_HOST) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
-	dwc2-y				+= hcd.o hcd_intr.o
-	dwc2-y				+= hcd_queue.o hcd_ddma.o
-endif
-
-ifneq ($(filter y,$(CONFIG_USB_DWC2_PERIPHERAL) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
-	dwc2-y       			+= gadget.o
-endif
+dwc2-y					+= hcd.o hcd_intr.o
+dwc2-y					+= hcd_queue.o hcd_ddma.o
 
 # NOTE: The previous s3c-hsotg peripheral mode only driver has been moved to
 # this location and renamed gadget.c. When building for dynamically linked
@@ -26,4 +19,10 @@ ifneq ($(CONFIG_USB_DWC2_PCI),)
 	dwc2_pci-y			:= pci.o
 endif
 
-dwc2-$(CONFIG_USB_DWC2_PLATFORM) += platform.o
+ifneq ($(CONFIG_USB_DWC2_PLATFORM),)
+	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_platform.o
+	dwc2_platform-y			:= platform.o
+endif
+
+obj-$(CONFIG_USB_DWC2_PERIPHERAL)	+= dwc2_gadget.o
+dwc2_gadget-y				:= gadget.o
-- 
1.9.1

