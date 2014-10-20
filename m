Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaJTS5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:57:22 -0400
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:48370
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752716AbaJTS5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:57:18 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Date: Mon, 20 Oct 2014 13:52:06 -0500
Message-ID: <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Update DWC2 kconfig and makefile to support dual-role mode. The platform
file will always get compiled for the case where the controller is directly
connected to the CPU. So for loadable modules, dwc2.ko is built for host,
peripheral, and dual-role mode. The PCI bus interface will be called
dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
v5: dwc2.ko for all modes along with dwc2_platform.ko and dwc2_pci.ko will
    get built for kernel modules.
v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
    config options.
v2: Remove reference to dwc2_gadget
---
 drivers/usb/dwc2/Kconfig  | 61 ++++++++++++++++++++++++++++-------------------
 drivers/usb/dwc2/Makefile | 32 ++++++++++++-------------
 2 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
index f93807b..1ea702e 100644
--- a/drivers/usb/dwc2/Kconfig
+++ b/drivers/usb/dwc2/Kconfig
@@ -1,5 +1,5 @@
 config USB_DWC2
-	bool "DesignWare USB2 DRD Core Support"
+	tristate "DesignWare USB2 DRD Core Support"
 	depends on USB
 	help
 	  Say Y here if your system has a Dual Role Hi-Speed USB
@@ -10,31 +10,53 @@ config USB_DWC2
 	  bus interface module (if you have a PCI bus system) will be
 	  called dwc2_pci.ko, and the platform interface module (for
 	  controllers directly connected to the CPU) will be called
-	  dwc2_platform.ko. For gadget mode, there will be a single
-	  module called dwc2_gadget.ko.
-
-	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
-	  host and gadget drivers are still currently separate drivers.
-	  There are plans to merge the dwc2_gadget driver with the dwc2
-	  host driver in the near future to create a dual-role driver.
+	  dwc2_platform.ko. For all modes(host, gadget and dual-role), there
+	  will be a single module called dwc2.ko.
 
 if USB_DWC2
 
+choice
+	bool "DWC2 Mode Selection"
+	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
+	default USB_DWC2_HOST if (USB && !USB_GADGET)
+	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
+
 config USB_DWC2_HOST
-	tristate "Host only mode"
+	bool "Host only mode"
 	depends on USB
 	help
 	  The Designware USB2.0 high-speed host controller
-	  integrated into many SoCs.
+	  integrated into many SoCs. Select this option if you want the
+	  driver to operate in Host-only mode.
+
+comment "Gadget/Dual-role mode requires USB Gadget support to be enabled"
+
+config USB_DWC2_PERIPHERAL
+	bool "Gadget only mode"
+	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
+	help
+	  The Designware USB2.0 high-speed gadget controller
+	  integrated into many SoCs. Select this option if you want the
+	  driver to operate in Peripheral-only mode. This option requires
+	  USB_GADGET=y.
+
+config USB_DWC2_DUAL_ROLE
+	bool "Dual Role mode"
+	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
+	help
+	  Select this option if you want the driver to work in a dual-role
+	  mode. In this mode both host and gadget features are enabled, and
+	  the role will be determined by the cable that gets plugged-in. This
+	  option requires USB_GADGET=y.
+endchoice
 
 config USB_DWC2_PLATFORM
 	bool "DWC2 Platform"
-	depends on USB_DWC2_HOST
 	default USB_DWC2_HOST
-	help
-	  The Designware USB2.0 platform interface module for
-	  controllers directly connected to the CPU. This is only
-	  used for host mode.
+        default y
+        help
+          The Designware USB2.0 platform interface module for
+          controllers directly connected to the CPU.
 
 config USB_DWC2_PCI
 	bool "DWC2 PCI"
@@ -44,15 +66,6 @@ config USB_DWC2_PCI
 	  The Designware USB2.0 PCI interface module for controllers
 	  connected to a PCI bus. This is only used for host mode.
 
-comment "Gadget mode requires USB Gadget support to be enabled"
-
-config USB_DWC2_PERIPHERAL
-	tristate "Gadget only mode"
-	depends on USB_GADGET
-	help
-	  The Designware USB2.0 high-speed gadget controller
-	  integrated into many SoCs.
-
 config USB_DWC2_DEBUG
 	bool "Enable Debugging Messages"
 	help
diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
index b73d2a5..2175d93 100644
--- a/drivers/usb/dwc2/Makefile
+++ b/drivers/usb/dwc2/Makefile
@@ -1,28 +1,28 @@
 ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
 ccflags-$(CONFIG_USB_DWC2_VERBOSE)	+= -DVERBOSE_DEBUG
 
-obj-$(CONFIG_USB_DWC2_HOST)		+= dwc2.o
+obj-$(CONFIG_USB_DWC2)			+= dwc2.o
 dwc2-y					:= core.o core_intr.o
-dwc2-y					+= hcd.o hcd_intr.o
-dwc2-y					+= hcd_queue.o hcd_ddma.o
+
+ifneq ($(filter y,$(CONFIG_USB_DWC2_HOST) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
+	dwc2-y				+= hcd.o hcd_intr.o
+	dwc2-y				+= hcd_queue.o hcd_ddma.o
+endif
+
+ifneq ($(filter y,$(CONFIG_USB_DWC2_PERIPHERAL) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
+	dwc2-y       			+= gadget.o
+endif
 
 # NOTE: The previous s3c-hsotg peripheral mode only driver has been moved to
 # this location and renamed gadget.c. When building for dynamically linked
-# modules, dwc2_gadget.ko will get built for peripheral mode. For host mode,
-# the core module will be dwc2.ko, the PCI bus interface module will called
-# dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.
-# At present the host and gadget driver will be separate drivers, but there
-# are plans in the near future to create a dual-role driver.
+# modules, dwc2.ko will get built for host mode, peripheral mode, and dual-role
+# mode. The PCI bus interface module will called dwc2_pci.ko and the platform
+# interface module will be called dwc2_platform.ko.
 
 ifneq ($(CONFIG_USB_DWC2_PCI),)
-	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_pci.o
+	obj-$(CONFIG_USB_DWC2)		+= dwc2_pci.o
 	dwc2_pci-y			:= pci.o
 endif
 
-ifneq ($(CONFIG_USB_DWC2_PLATFORM),)
-	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_platform.o
-	dwc2_platform-y			:= platform.o
-endif
-
-obj-$(CONFIG_USB_DWC2_PERIPHERAL)	+= dwc2_gadget.o
-dwc2_gadget-y				:= gadget.o
+obj-$(CONFIG_USB_DWC2)			+= dwc2_platform.o
+dwc2_platform-y				:= platform.o
-- 
2.0.3

