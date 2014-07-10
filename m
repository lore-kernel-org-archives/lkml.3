Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaGJJJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:09:39 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:58626 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaGJJJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:09:36 -0400
Date: Thu, 10 Jul 2014 10:09:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: kernel@stlinux.com
Subject: [PATCH v3+1 1/5] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140710090931.GA11948@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <1404906074-31992-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404906074-31992-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
new file mode 100644
index 0000000..42c88088
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
