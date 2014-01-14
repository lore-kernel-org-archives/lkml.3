Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaANK6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:58:01 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43393 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbaANK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:57:57 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stephen.gallimore@st.com>, <kernel@stlinux.com>,
        <lee.jones@linaro.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 5/6] drivers: reset: stih416: add softreset controller
Date: Tue, 14 Jan 2014 10:51:44 +0000
Message-ID: <1389696704-19902-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds softreset controller for STiH416 SOC, soft reset
controller is based on system configuration registers which are mapped
via regmap. This reset controller does not have any feedback or
acknowledgement. With this patch a new device "st,stih416-softreset" is
registered with system configuration registers based reset controller
that controls the softreset state of the hardware such as Ethernet, IRB.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih416.dtsi                     |    5 ++++
 drivers/reset/sti/reset-stih416.c                  |   22 ++++++++++++++++++++
 .../dt-bindings/reset-controller/stih416-resets.h  |    4 +++
 3 files changed, 31 insertions(+), 0 deletions(-)

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
index 0becfc5..685fd3b 100644
--- a/drivers/reset/sti/reset-stih416.c
+++ b/drivers/reset/sti/reset-stih416.c
@@ -37,6 +37,10 @@ static const char stih416_lpm[] = "st,stih416-lpm-syscfg";
 #define SYSCFG_2525	0x834 /* Powerdown request USB/SATA/PCIe */
 #define SYSSTAT_2583	0x91c /* Powerdown status USB/SATA/PCIe */
 
+#define SYSCFG_1539	0x86c /* Softreset Ethernet 0 */
+#define SYSCFG_510	0x7f8 /* Softreset Ethernet 1 */
+#define LPM_SYSCFG_1	0x4 /* Softreset IRB */
+
 static const struct syscfg_reset_channel_data stih416_powerdowns[] = {
 	[STIH416_EMISS_POWERDOWN]	= STIH416_PDN_FRONT(0),
 	[STIH416_NAND_POWERDOWN]	= STIH416_PDN_FRONT(1),
@@ -51,15 +55,33 @@ static const struct syscfg_reset_channel_data stih416_powerdowns[] = {
 	[STIH416_PCIE1_POWERDOWN]	= STIH416_PDN_REAR(5, 8),
 };
 
+static const struct syscfg_reset_channel_data stih416_softresets[] = {
+	[STIH416_ETH0_SOFTRESET] = _SYSCFG_RST_CH_NO_ACK(stih416_front,
+							SYSCFG_1539, 0),
+	[STIH416_ETH1_SOFTRESET] = _SYSCFG_RST_CH_NO_ACK(stih416_sbc,
+							SYSCFG_510, 0),
+	[STIH416_IRB_SOFTRESET]	 = _SYSCFG_RST_CH_NO_ACK(stih416_lpm,
+							LPM_SYSCFG_1, 6),
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
index d7da55f..ee8ccd0 100644
--- a/include/dt-bindings/reset-controller/stih416-resets.h
+++ b/include/dt-bindings/reset-controller/stih416-resets.h
@@ -18,4 +18,8 @@
 #define STIH416_PCIE0_POWERDOWN		9
 #define STIH416_PCIE1_POWERDOWN		10
 
+#define STIH416_ETH0_SOFTRESET		0
+#define STIH416_ETH1_SOFTRESET		1
+#define STIH416_IRB_SOFTRESET		2
+
 #endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH416 */
-- 
1.7.6.5

