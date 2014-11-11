Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKKRSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:18:16 -0500
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:65408
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbaKKRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:13 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 8/8] usb: dwc2: Update Kconfig to support dual-role
Date: Tue, 11 Nov 2014 11:13:40 -0600
Message-ID: <1415726020-19238-9-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR07CA079.namprd07.prod.outlook.com (25.160.24.34) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(20776003)(47776003)(66066001)(53416004)(33646002)(40100003)(101416001)(50466002)(48376002)(122386002)(97736003)(42186005)(102836001)(50226001)(4396001)(105586002)(107046002)(19580395003)(19580405001)(95666004)(21056001)(229853001)(106356001)(86152002)(88136002)(92726001)(104166001)(31966008)(62966003)(87976001)(92566001)(77096003)(87286001)(77156002)(99396003)(89996001)(46102003)(69596002)(120916001)(81156004)(93916002)(86362001)(50986999)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
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
v7: None
v6: Correct notes for USB_DWC2_DUAL_ROLE and USB_DWC2_PERIPHERAL
    Remove extra default for USB_DWC2_PLATFORM and make it a condition for
    building dwc2_platform.ko. In addition USB_DWC2_PLATFORM and USB_DWC2_PCI
    are now tristate.
v5: dwc2.ko for all modes along with dwc2_platform.ko and dwc2_pci.ko will
    get built for kernel modules.
v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
    config options.
v2: Remove reference to dwc2_gadget
---
 drivers/usb/dwc2/Kconfig  | 66 ++++++++++++++++++++++++++++-------------------
 drivers/usb/dwc2/Makefile | 32 +++++++++++------------
 2 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
index 4d02718..b323c4c 100644
--- a/drivers/usb/dwc2/Kconfig
+++ b/drivers/usb/dwc2/Kconfig
@@ -1,5 +1,5 @@
 config USB_DWC2
-	bool "DesignWare USB2 DRD Core Support"
+	tristate "DesignWare USB2 DRD Core Support"
 	depends on USB || USB_GADGET
 	help
 	  Say Y here if your system has a Dual Role Hi-Speed USB
@@ -10,49 +10,61 @@ config USB_DWC2
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
+	  will be an additional module named dwc2.ko.
 
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
 
-config USB_DWC2_PLATFORM
-	bool "DWC2 Platform"
-	depends on USB_DWC2_HOST
-	default USB_DWC2_HOST
+comment "Gadget/Dual-role mode requires USB Gadget support to be enabled"
+
+config USB_DWC2_PERIPHERAL
+	bool "Gadget only mode"
+	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
+	help
+	  The Designware USB2.0 high-speed gadget controller
+	  integrated into many SoCs. Select this option if you want the
+	  driver to operate in Peripheral-only mode. This option requires
+	  USB_GADGET to be enabled.
+
+config USB_DWC2_DUAL_ROLE
+	bool "Dual Role mode"
+	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
 	help
-	  The Designware USB2.0 platform interface module for
-	  controllers directly connected to the CPU. This is only
-	  used for host mode.
+	  Select this option if you want the driver to work in a dual-role
+	  mode. In this mode both host and gadget features are enabled, and
+	  the role will be determined by the cable that gets plugged-in. This
+	  option requires USB_GADGET to be enabled.
+endchoice
+
+config USB_DWC2_PLATFORM
+	tristate "DWC2 Platform"
+	default USB_DWC2_HOST || USB_DWC2_PERIPHERAL
+        help
+          The Designware USB2.0 platform interface module for
+          controllers directly connected to the CPU.
 
 config USB_DWC2_PCI
-	bool "DWC2 PCI"
+	tristate "DWC2 PCI"
 	depends on USB_DWC2_HOST && PCI
 	default USB_DWC2_HOST
 	help
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
index b73d2a5..8f75267 100644
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
+obj-$(CONFIG_USB_DWC2_PLATFORM)		+= dwc2_platform.o
+dwc2_platform-y				:= platform.o
-- 
2.0.3

