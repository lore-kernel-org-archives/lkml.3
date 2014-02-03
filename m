Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaBCOgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:36:07 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:44555 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbaBCOgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:36:04 -0500
From: <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, Arnd Bergmann <arnd@arndb.de>,
        <stephen.gallimore@st.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH v2 4/6] drivers: reset: stih415: add softreset controller
Date: Mon, 3 Feb 2014 14:28:50 +0000
Message-ID: <1391437730-12102-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
References: <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds softreset controller for STiH415 SOC, soft reset
controller is based on system configuration registers which are mapped
via regmap. This reset controller does not have any feedback or
acknowledgement. With this patch a new device "st,stih415-softreset" is
registered with system configuration registers based reset controller
that controls the softreset state of the hardware such as Ethernet, IRB.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 .../devicetree/bindings/reset/st,sti-softreset.txt |   46 ++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi                     |    5 +++
 drivers/reset/sti/reset-stih415.c                  |   35 +++++++++++++++
 .../dt-bindings/reset-controller/stih415-resets.h  |    7 +++
 4 files changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-softreset.txt

diff --git a/Documentation/devicetree/bindings/reset/st,sti-softreset.txt b/Documentation/devicetree/bindings/reset/st,sti-softreset.txt
new file mode 100644
index 0000000..a8d3d3c
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/st,sti-softreset.txt
@@ -0,0 +1,46 @@
+STMicroelectronics STi family Sysconfig Peripheral SoftReset Controller
+=============================================================================
+
+This binding describes a reset controller device that is used to enable and
+disable on-chip peripheral controllers such as USB and SATA, using
+"softreset" control bits found in the STi family SoC system configuration
+registers.
+
+The actual action taken when softreset is asserted is hardware dependent.
+However, when asserted it may not be possible to access the hardware's
+registers and after an assert/deassert sequence the hardware's previous state
+may no longer be valid.
+
+Please refer to reset.txt in this directory for common reset
+controller binding usage.
+
+Required properties:
+- compatible: Should be "st,<chip>-softreset" example:
+	"st,stih415-softreset" or "st,stih416-softreset";
+- #reset-cells: 1, see below
+
+example:
+
+	softreset: softreset-controller {
+		#reset-cells = <1>;
+		compatible = "st,stih415-softreset";
+	};
+
+
+Specifying softreset control of devices
+=======================================
+
+Device nodes should specify the reset channel required in their "resets"
+property, containing a phandle to the softreset device node and an
+index specifying which channel to use, as described in reset.txt
+
+example:
+
+	ethernet0{
+		resets			= <&softreset STIH415_ETH0_SOFTRESET>;
+	};
+
+Macro definitions for the supported reset channels can be found in:
+
+include/dt-bindings/reset-controller/stih415-resets.h
+include/dt-bindings/reset-controller/stih416-resets.h
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index 19e29f4..d52207c 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -34,6 +34,11 @@
 			compatible = "st,stih415-powerdown";
 		};
 
+		softreset: softreset-controller {
+			#reset-cells = <1>;
+			compatible = "st,stih415-softreset";
+		};
+
 		syscfg_sbc: sbc-syscfg@fe600000{
 			compatible      = "st,stih415-sbc-syscfg", "syscon";
 			reg		= <0xfe600000 0xb4>;
diff --git a/drivers/reset/sti/reset-stih415.c b/drivers/reset/sti/reset-stih415.c
index 56c2146..e6f6c41 100644
--- a/drivers/reset/sti/reset-stih415.c
+++ b/drivers/reset/sti/reset-stih415.c
@@ -31,12 +31,29 @@ static const char stih415_lpm[] = "st,stih415-lpm-syscfg";
 #define STIH415_PDN_REAR(_cntl, _stat) \
 	_SYSCFG_RST_CH(stih415_rear, SYSCFG_336, _cntl, SYSSTAT_384, _stat)
 
+#define STIH415_SRST_REAR(_reg, _bit) \
+	_SYSCFG_RST_CH_NO_ACK(stih415_rear, _reg, _bit)
+
+#define STIH415_SRST_SBC(_reg, _bit) \
+	_SYSCFG_RST_CH_NO_ACK(stih415_sbc, _reg, _bit)
+
+#define STIH415_SRST_FRONT(_reg, _bit) \
+	_SYSCFG_RST_CH_NO_ACK(stih415_front, _reg, _bit)
+
+#define STIH415_SRST_LPM(_reg, _bit) \
+	_SYSCFG_RST_CH_NO_ACK(stih415_lpm, _reg, _bit)
+
 #define SYSCFG_114	0x38 /* Powerdown request EMI/NAND/Keyscan */
 #define SYSSTAT_187	0x15c /* Powerdown status EMI/NAND/Keyscan */
 
 #define SYSCFG_336	0x90 /* Powerdown request USB/SATA/PCIe */
 #define SYSSTAT_384	0x150 /* Powerdown status USB/SATA/PCIe */
 
+#define SYSCFG_376	0x130 /* Reset generator 0 control 0 */
+#define SYSCFG_166	0x108 /* Softreset Ethernet 0 */
+#define SYSCFG_31	0x7c /* Softreset Ethernet 1 */
+#define LPM_SYSCFG_1	0x4 /* Softreset IRB */
+
 static const struct syscfg_reset_channel_data stih415_powerdowns[] = {
 	[STIH415_EMISS_POWERDOWN]	= STIH415_PDN_FRONT(0),
 	[STIH415_NAND_POWERDOWN]	= STIH415_PDN_FRONT(1),
@@ -49,15 +66,33 @@ static const struct syscfg_reset_channel_data stih415_powerdowns[] = {
 	[STIH415_PCIE_POWERDOWN]	= STIH415_PDN_REAR(5, 8),
 };
 
+static const struct syscfg_reset_channel_data stih415_softresets[] = {
+	[STIH415_ETH0_SOFTRESET] = STIH415_SRST_FRONT(SYSCFG_166, 0),
+	[STIH415_ETH1_SOFTRESET] = STIH415_SRST_SBC(SYSCFG_31, 0),
+	[STIH415_IRB_SOFTRESET]	 = STIH415_SRST_LPM(LPM_SYSCFG_1, 6),
+	[STIH415_USB0_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 9),
+	[STIH415_USB1_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 10),
+	[STIH415_USB2_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 11),
+};
+
 static struct syscfg_reset_controller_data stih415_powerdown_controller = {
 	.wait_for_ack = true,
 	.nr_channels = ARRAY_SIZE(stih415_powerdowns),
 	.channels = stih415_powerdowns,
 };
 
+static struct syscfg_reset_controller_data stih415_softreset_controller = {
+	.wait_for_ack = false,
+	.active_low = true,
+	.nr_channels = ARRAY_SIZE(stih415_softresets),
+	.channels = stih415_softresets,
+};
+
 static struct of_device_id stih415_reset_match[] = {
 	{ .compatible = "st,stih415-powerdown",
 	  .data = &stih415_powerdown_controller, },
+	{ .compatible = "st,stih415-softreset",
+	  .data = &stih415_softreset_controller, },
 	{},
 };
 
diff --git a/include/dt-bindings/reset-controller/stih415-resets.h b/include/dt-bindings/reset-controller/stih415-resets.h
index 2d54e68..c2f8a66 100644
--- a/include/dt-bindings/reset-controller/stih415-resets.h
+++ b/include/dt-bindings/reset-controller/stih415-resets.h
@@ -16,4 +16,11 @@
 #define STIH415_SATA1_POWERDOWN		7
 #define STIH415_PCIE_POWERDOWN		8
 
+#define STIH415_ETH0_SOFTRESET		0
+#define STIH415_ETH1_SOFTRESET		1
+#define STIH415_IRB_SOFTRESET		2
+#define STIH415_USB0_SOFTRESET		3
+#define STIH415_USB1_SOFTRESET		4
+#define STIH415_USB2_SOFTRESET		5
+
 #endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH415 */
-- 
1.7.9.5

