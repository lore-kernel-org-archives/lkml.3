Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBCOgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:36:03 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:39320 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbaBCOf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:35:58 -0500
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
Subject: [PATCH v2 5/6] drivers: reset: stih416: add softreset controller
Date: Mon, 3 Feb 2014 14:28:57 +0000
Message-ID: <1391437737-12143-1-git-send-email-srinivas.kandagatla@st.com>
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

This patch adds softreset controller for STiH416 SOC, soft reset
controller is based on system configuration registers which are mapped
via regmap. This reset controller does not have any feedback or
acknowledgement. With this patch a new device "st,stih416-softreset" is
registered with system configuration registers based reset controller
that controls the softreset state of the hardware such as Ethernet, IRB.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih416.dtsi                     |    5 ++
 drivers/reset/sti/reset-stih416.c                  |   64 ++++++++++++++++++++
 .../dt-bindings/reset-controller/stih416-resets.h  |   29 +++++++++
 3 files changed, 98 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index e5bec66..788ba5b 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -33,6 +33,11 @@
 			compatible = "st,stih416-powerdown";
 		};
 
+		softreset: softreset-controller {
+			#reset-cells = <1>;
+			compatible = "st,stih416-softreset";
+		};
+
 		syscfg_sbc:sbc-syscfg@fe600000{
 			compatible	= "st,stih416-sbc-syscfg", "syscon";
 			reg		= <0xfe600000 0x1000>;
diff --git a/drivers/reset/sti/reset-stih416.c b/drivers/reset/sti/reset-stih416.c
index 0becfc5..fe3bf02 100644
--- a/drivers/reset/sti/reset-stih416.c
+++ b/drivers/reset/sti/reset-stih416.c
@@ -24,6 +24,7 @@ static const char stih416_front[] = "st,stih416-front-syscfg";
 static const char stih416_rear[] = "st,stih416-rear-syscfg";
 static const char stih416_sbc[] = "st,stih416-sbc-syscfg";
 static const char stih416_lpm[] = "st,stih416-lpm-syscfg";
+static const char stih416_cpu[] = "st,stih416-cpu-syscfg";
 
 #define STIH416_PDN_FRONT(_bit) \
 	_SYSCFG_RST_CH(stih416_front, SYSCFG_1500, _bit, SYSSTAT_1578, _bit)
@@ -37,6 +38,29 @@ static const char stih416_lpm[] = "st,stih416-lpm-syscfg";
 #define SYSCFG_2525	0x834 /* Powerdown request USB/SATA/PCIe */
 #define SYSSTAT_2583	0x91c /* Powerdown status USB/SATA/PCIe */
 
+#define SYSCFG_2552	0x8A0 /* Reset Generator control 0 */
+#define SYSCFG_1539	0x86c /* Softreset Ethernet 0 */
+#define SYSCFG_510	0x7f8 /* Softreset Ethernet 1 */
+#define LPM_SYSCFG_1	0x4 /* Softreset IRB */
+#define SYSCFG_2553	0x8a4 /* Softreset SATA0/1, PCIE0/1 */
+#define SYSCFG_7563	0x8cc /* MPE softresets 0 */
+#define SYSCFG_7564	0x8d0 /* MPE softresets 1 */
+
+#define STIH416_SRST_CPU(_reg, _bit) \
+	 _SYSCFG_RST_CH_NO_ACK(stih416_cpu, _reg, _bit)
+
+#define STIH416_SRST_FRONT(_reg, _bit) \
+	 _SYSCFG_RST_CH_NO_ACK(stih416_front, _reg, _bit)
+
+#define STIH416_SRST_REAR(_reg, _bit) \
+	 _SYSCFG_RST_CH_NO_ACK(stih416_rear, _reg, _bit)
+
+#define STIH416_SRST_LPM(_reg, _bit) \
+	 _SYSCFG_RST_CH_NO_ACK(stih416_lpm, _reg, _bit)
+
+#define STIH416_SRST_SBC(_reg, _bit) \
+	 _SYSCFG_RST_CH_NO_ACK(stih416_sbc, _reg, _bit)
+
 static const struct syscfg_reset_channel_data stih416_powerdowns[] = {
 	[STIH416_EMISS_POWERDOWN]	= STIH416_PDN_FRONT(0),
 	[STIH416_NAND_POWERDOWN]	= STIH416_PDN_FRONT(1),
@@ -51,15 +75,55 @@ static const struct syscfg_reset_channel_data stih416_powerdowns[] = {
 	[STIH416_PCIE1_POWERDOWN]	= STIH416_PDN_REAR(5, 8),
 };
 
+static const struct syscfg_reset_channel_data stih416_softresets[] = {
+	[STIH416_ETH0_SOFTRESET] = STIH416_SRST_FRONT(SYSCFG_1539, 0),
+	[STIH416_ETH1_SOFTRESET] = STIH416_SRST_SBC(SYSCFG_510, 0),
+	[STIH416_IRB_SOFTRESET]	 = STIH416_SRST_LPM(LPM_SYSCFG_1, 6),
+	[STIH416_USB0_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 9),
+	[STIH416_USB1_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 10),
+	[STIH416_USB2_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 11),
+	[STIH416_USB3_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 28),
+	[STIH416_SATA0_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 7),
+	[STIH416_SATA1_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 3),
+	[STIH416_PCIE0_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 15),
+	[STIH416_PCIE1_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 2),
+	[STIH416_AUD_DAC_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 14),
+	[STIH416_HDTVOUT_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 5),
+	[STIH416_VTAC_M_RX_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 25),
+	[STIH416_VTAC_A_RX_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2552, 26),
+	[STIH416_SYNC_HD_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 5),
+	[STIH416_SYNC_SD_SOFTRESET] = STIH416_SRST_REAR(SYSCFG_2553, 6),
+	[STIH416_BLITTER_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 10),
+	[STIH416_GPU_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 11),
+	[STIH416_VTAC_M_TX_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 18),
+	[STIH416_VTAC_A_TX_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 19),
+	[STIH416_VTG_AUX_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 21),
+	[STIH416_JPEG_DEC_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7563, 23),
+	[STIH416_HVA_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7564, 2),
+	[STIH416_COMPO_M_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7564, 3),
+	[STIH416_COMPO_A_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7564, 4),
+	[STIH416_VP8_DEC_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7564, 10),
+	[STIH416_VTG_MAIN_SOFTRESET] = STIH416_SRST_CPU(SYSCFG_7564, 16),
+};
+
 static struct syscfg_reset_controller_data stih416_powerdown_controller = {
 	.wait_for_ack	= true,
 	.nr_channels	= ARRAY_SIZE(stih416_powerdowns),
 	.channels	= stih416_powerdowns,
 };
 
+static struct syscfg_reset_controller_data stih416_softreset_controller = {
+	.wait_for_ack = false,
+	.active_low = true,
+	.nr_channels = ARRAY_SIZE(stih416_softresets),
+	.channels = stih416_softresets,
+};
+
 static struct of_device_id stih416_reset_match[] = {
 	{ .compatible = "st,stih416-powerdown",
 	  .data = &stih416_powerdown_controller, },
+	{ .compatible = "st,stih416-softreset",
+	  .data = &stih416_softreset_controller, },
 	{},
 };
 
diff --git a/include/dt-bindings/reset-controller/stih416-resets.h b/include/dt-bindings/reset-controller/stih416-resets.h
index d7da55f..2127743 100644
--- a/include/dt-bindings/reset-controller/stih416-resets.h
+++ b/include/dt-bindings/reset-controller/stih416-resets.h
@@ -18,4 +18,33 @@
 #define STIH416_PCIE0_POWERDOWN		9
 #define STIH416_PCIE1_POWERDOWN		10
 
+#define STIH416_ETH0_SOFTRESET		0
+#define STIH416_ETH1_SOFTRESET		1
+#define STIH416_IRB_SOFTRESET		2
+#define STIH416_USB0_SOFTRESET		3
+#define STIH416_USB1_SOFTRESET		4
+#define STIH416_USB2_SOFTRESET		5
+#define STIH416_USB3_SOFTRESET		6
+#define STIH416_SATA0_SOFTRESET		7
+#define STIH416_SATA1_SOFTRESET		8
+#define STIH416_PCIE0_SOFTRESET		9
+#define STIH416_PCIE1_SOFTRESET		10
+#define STIH416_AUD_DAC_SOFTRESET	11
+#define STIH416_HDTVOUT_SOFTRESET	12
+#define STIH416_VTAC_M_RX_SOFTRESET	13
+#define STIH416_VTAC_A_RX_SOFTRESET	14
+#define STIH416_SYNC_HD_SOFTRESET	15
+#define STIH416_SYNC_SD_SOFTRESET	16
+#define STIH416_BLITTER_SOFTRESET	17
+#define STIH416_GPU_SOFTRESET		18
+#define STIH416_VTAC_M_TX_SOFTRESET	19
+#define STIH416_VTAC_A_TX_SOFTRESET	20
+#define STIH416_VTG_AUX_SOFTRESET	21
+#define STIH416_JPEG_DEC_SOFTRESET	22
+#define STIH416_HVA_SOFTRESET		23
+#define STIH416_COMPO_M_SOFTRESET	24
+#define STIH416_COMPO_A_SOFTRESET	25
+#define STIH416_VP8_DEC_SOFTRESET	26
+#define STIH416_VTG_MAIN_SOFTRESET	27
+
 #endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH416 */
-- 
1.7.9.5

