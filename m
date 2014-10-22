Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaJVHQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:16:12 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34035 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932254AbaJVHQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:16:09 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH v4 1/8] phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
Date: Wed, 22 Oct 2014 09:14:20 +0200
Message-Id: <1413962067-25557-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_03:2014-10-21,2014-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
or USB3 devices.

Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 .../devicetree/bindings/phy/phy-miphy28lp.txt      | 126 +++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
new file mode 100644
index 0000000..f7cfc5f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
@@ -0,0 +1,126 @@
+STMicroelectronics STi MIPHY28LP PHY binding
+============================================
+
+This binding describes a miphy device that is used to control PHY hardware
+for SATA, PCIe or USB3.
+
+Required properties (controller (parent) node):
+- compatible	: Should be "st,miphy28lp-phy".
+- st,syscfg	: Should be a phandle of the system configuration register group
+		  which contain the SATA, PCIe or USB3 mode setting bits.
+
+Required nodes	:  A sub-node is required for each channel the controller
+		   provides. Address range information including the usual
+		   'reg' and 'reg-names' properties are used inside these
+		   nodes to describe the controller's topology. These nodes
+		   are translated by the driver's .xlate() function.
+
+Required properties (port (child) node):
+- #phy-cells	: Should be 1 (See second example)
+		  Cell after port phandle is device type from:
+			- MIPHY_TYPE_SATA
+			- MIPHY_TYPE_PCI
+			- MIPHY_TYPE_USB3
+- reg		: Address and length of the register set for the device.
+- reg-names	: The names of the register addresses corresponding to the registers
+		  filled in "reg". Is can also contain the offset of the system configuration
+		  registers used as glue-logic to setup the device for SATA/PCIe or USB3
+		  devices.
+- resets	: phandle to the parent reset controller.
+- reset-names	: Associated name must be "miphy-sw-rst".
+
+Optional properties (port (child) node):
+- st,osc-rdy		: to check the MIPHY0_OSC_RDY status in the glue-logic. This
+			  is not available in all the MiPHY. For example, for STiH407, only the
+			  MiPHY0 has this bit.
+- st,osc-force-ext	: to select the external oscillator. This can change from
+			  different MiPHY inside the same SoC.
+- st,sata_gen		: to select which SATA_SPDMODE has to be set in the SATA system config
+			  register.
+- st,px_rx_pol_inv	: to invert polarity of RXn/RXp (respectively negative line and positive
+			  line).
+
+example:
+
+		miphy28lp_phy: miphy28lp@9b22000 {
+			compatible = "st,miphy28lp-phy";
+			st,syscfg = <&syscfg_core>;
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			ranges;
+
+			phy_port0: port@9b22000 {
+				reg = <0x9b22000 0xff>,
+				      <0x9b09000 0xff>,
+				      <0x9b04000 0xff>,
+				      <0x114 0x4>, /* sysctrl MiPHY cntrl */
+				      <0x818 0x4>, /* sysctrl MiPHY status*/
+				      <0xe0  0x4>, /* sysctrl PCIe */
+				      <0xec  0x4>; /* sysctrl SATA */
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew",
+					    "miphy-ctrl-glue",
+					    "miphy-status-glue",
+					    "pcie-glue",
+					    "sata-glue";
+				#phy-cells = <1>;
+				st,osc-rdy;
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY0_SOFTRESET>;
+			};
+
+			phy_port1: port@9b2a000 {
+				reg = <0x9b2a000 0xff>,
+				      <0x9b19000 0xff>,
+				      <0x9b14000 0xff>,
+				      <0x118 0x4>,
+				      <0x81c 0x4>,
+				      <0xe4  0x4>,
+				      <0xf0  0x4>;
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew",
+					    "miphy-ctrl-glue",
+					    "miphy-status-glue",
+					    "pcie-glue",
+					    "sata-glue";
+				#phy-cells = <1>;
+				st,osc-force-ext;
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY1_SOFTRESET>;
+			};
+
+			phy_port2: port@8f95000 {
+				reg = <0x8f95000 0xff>,
+				      <0x8f90000 0xff>,
+				      <0x11c 0x4>,
+				      <0x820 0x4>;
+				reg-names = "pipew",
+				    "usb3-up",
+				    "miphy-ctrl-glue",
+				    "miphy-status-glue";
+				#phy-cells = <1>;
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY2_SOFTRESET>;
+			};
+		};
+
+
+Specifying phy control of devices
+=================================
+
+Device nodes should specify the configuration required in their "phys"
+property, containing a phandle to the miphy device node and an index
+specifying which configuration to use, as described in phy-bindings.txt.
+
+example:
+		sata0: sata@9b20000  {
+			...
+			phys		= <&phy_port0 MIPHY_TYPE_SATA>;
+			...
+		};
+
+Macro definitions for the supported miphy configuration can be found in:
+
+include/dt-bindings/phy/phy-miphy28lp.h
-- 
1.9.1

