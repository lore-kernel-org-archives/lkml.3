Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbbA0Kwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:52:43 -0500
Received: from mail-am1on0135.outbound.protection.outlook.com ([157.56.112.135]:50613
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754729AbbA0Kwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:52:39 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 2/7] ARM: vf-colibri: add SPI support and enable MCP2515 CAN
Date: Tue, 27 Jan 2015 16:27:19 +0530
Message-ID: <1422356244-15629-3-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA001.apcprd03.prod.outlook.com (10.242.96.21) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB262;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(92566002)(229853001)(48376002)(19580395003)(122386002)(40100003)(19580405001)(50986999)(50466002)(87976001)(50226001)(53416004)(86362001)(47776003)(42186005)(36756003)(33646002)(77156002)(76176999)(62966003)(2950100001)(110136001)(46102003)(77096005)(2351001)(66066001)(7059030)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:dvb.toradex.int;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:52:30.2441 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCP2515 CAN controller is available on Colibri Evaluation board.
Hence enable MCP2515 CAN.

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/vf-colibri.dtsi         | 15 +++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
index 36cafbf..69364b0 100644
--- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -12,6 +12,12 @@
 		bootargs = "console=ttyLP0,115200";
 	};
 
+	clk16m: clk16m {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <16000000>;
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -47,6 +53,21 @@
 	status  = "okay";
 };
 
+&dspi1 {
+	status = "okay";
+
+	can2: mcp2515@0 {
+		compatible = "microchip,mcp2515";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_can_int>;
+		reg = <0>;
+		clocks = <&clk16m>;
+		spi-max-frequency = <10000000>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <11 GPIO_ACTIVE_LOW>;
+	};
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
@@ -94,3 +115,13 @@
 &usbh1 {
 	vbus-supply = <&usbh_vbus_reg>;
 };
+
+&iomuxc {
+	vf610-colibri {
+		pinctrl_can_int: can_int {
+			fsl,pins = <
+				VF610_PAD_PTB21__GPIO_43	0x22ed
+			>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
index 5c2b732..fbef082 100644
--- a/arch/arm/boot/dts/vf-colibri.dtsi
+++ b/arch/arm/boot/dts/vf-colibri.dtsi
@@ -23,6 +23,12 @@
 	status = "okay";
 };
 
+&dspi1 {
+	bus-num = <1>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_dspi1>;
+};
+
 &edma0 {
 	status = "okay";
 };
@@ -107,6 +113,15 @@
 			>;
 		};
 
+		pinctrl_dspi1: dspi1grp {
+			fsl,pins = <
+				VF610_PAD_PTD5__DSPI1_CS0		0x33e2
+				VF610_PAD_PTD6__DSPI1_SIN		0x33e1
+				VF610_PAD_PTD7__DSPI1_SOUT		0x33e2
+				VF610_PAD_PTD8__DSPI1_SCK		0x33e2
+			>;
+		};
+
 		pinctrl_esdhc1: esdhc1grp {
 			fsl,pins = <
 				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
-- 
2.2.2

