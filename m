Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaGVK54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34893 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbaGVK5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/28] phy: miphy365x: Add Device Tree bindings for the MiPHY365x
Date: Tue, 22 Jul 2014 16:26:49 +0530
Message-ID: <1406026611-30493-27-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/phy-miphy365x.txt      |   76 ++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
new file mode 100644
index 0000000..42c8808
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
@@ -0,0 +1,76 @@
+STMicroelectronics STi MIPHY365x PHY binding
+============================================
+
+This binding describes a miphy device that is used to control PHY hardware
+for SATA and PCIe.
+
+Required properties (controller (parent) node):
+- compatible    : Should be "st,miphy365x-phy"
+- st,syscfg     : Should be a phandle of the system configuration register group
+		  which contain the SATA, PCIe mode setting bits
+
+Required nodes	:  A sub-node is required for each channel the controller
+		   provides. Address range information including the usual
+		   'reg' and 'reg-names' properties are used inside these
+		   nodes to describe the controller's topology. These nodes
+		   are translated by the driver's .xlate() function.
+
+Required properties (port (child) node):
+- #phy-cells 	: Should be 1 (See second example)
+		  Cell after port phandle is device type from:
+			- MIPHY_TYPE_SATA
+			- MIPHY_TYPE_PCI
+- reg        	: Address and length of register sets for each device in
+		  "reg-names"
+- reg-names     : The names of the register addresses corresponding to the
+		  registers filled in "reg":
+			- sata:   For SATA devices
+			- pcie:   For PCIe devices
+			- syscfg: To specify the syscfg based config register
+
+Optional properties (port (child) node):
+- st,sata-gen	     :	Generation of locally attached SATA IP. Expected values
+			are {1,2,3). If not supplied generation 1 hardware will
+			be expected
+- st,pcie-tx-pol-inv :	Bool property to invert the polarity PCIe Tx (Txn/Txp)
+- st,sata-tx-pol-inv :	Bool property to invert the polarity SATA Tx (Txn/Txp)
+
+Example:
+
+	miphy365x_phy: miphy365x@fe382000 {
+		compatible      = "st,miphy365x-phy";
+		st,syscfg  	= <&syscfg_rear>;
+		#address-cells	= <1>;
+		#size-cells	= <1>;
+		ranges;
+
+		phy_port0: port@fe382000 {
+			reg = <0xfe382000 0x100>, <0xfe394000 0x100>, <0x824 0x4>;
+			reg-names = "sata", "pcie", "syscfg";
+			#phy-cells = <1>;
+			st,sata-gen = <3>;
+		};
+
+		phy_port1: port@fe38a000 {
+			reg = <0xfe38a000 0x100>, <0xfe804000 0x100>, <0x828 0x4>;;
+			reg-names = "sata", "pcie", "syscfg";
+			#phy-cells = <1>;
+			st,pcie-tx-pol-inv;
+		};
+	};
+
+Specifying phy control of devices
+=================================
+
+Device nodes should specify the configuration required in their "phys"
+property, containing a phandle to the phy port node and a device type.
+
+Example:
+
+#include <dt-bindings/phy/phy-miphy365x.h>
+
+	sata0: sata@fe380000 {
+		...
+		phys	  = <&phy_port0 MIPHY_TYPE_SATA>;
+		...
+	};
-- 
1.7.9.5

