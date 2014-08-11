Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaHKPlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:41:03 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45763 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbaHKPk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:40:56 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] pinctrl: Add documentation for SPMI PMIC pinctrl driver bindings
Date: Mon, 11 Aug 2014 18:40:31 +0300
Message-Id: <1407771634-14946-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

DeviceTree binding documentation for Qualcomm SPMI PMIC GPIO and
MPP pinctrl drivers.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt |   4 +
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 179 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       |  35 ++++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  70 ++++++++
 4 files changed, 288 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
index 7e57102..c2d01b4 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
@@ -12,6 +12,8 @@ Qualcomm.
 		    "qcom,pm8058-gpio"
 		    "qcom,pm8917-gpio"
 		    "qcom,pm8921-gpio"
+		    "qcom,pm8941-gpio"
+		    "qcom,pma8084-gpio"
 
 - reg:
 	Usage: required
@@ -74,6 +76,8 @@ to specify in a pin configuration subnode:
 		    gpio1-gpio40 for pm8058
 		    gpio1-gpio38 for pm8917
 		    gpio1-gpio44 for pm8921
+		    gpio1-gpio36 for pm8941
+		    gpio1-gpio22 for pma8084
 
 - function:
 	Usage: required
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
new file mode 100644
index 0000000..0a64567
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
@@ -0,0 +1,179 @@
+Qualcomm PMIC Multi-Purpose Pin (MPP) block
+
+This binding describes the MPP block(s) found in the 8xxx series of pmics from
+Qualcomm.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8841-mpp"
+		    "qcom,pm8941-mpp"
+		    "qcom,pma8084-mpp"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: Register base of the gpio block
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Must contain an array of encoded interrupt specifiers for
+		    each available gpio
+
+- gpio-controller:
+	Usage: required
+	Value type: <none>
+	Definition: Mark the device node as a GPIO controller
+
+- #gpio-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Must be 2;
+		    the first cell will be used to define gpio number and the
+		    second denotes the flags for this gpio
+
+Please refer to ../gpio/gpio.txt and ../interrupt-controller/interrupts.txt for
+a general description of GPIO and interrupt bindings.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+The pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin or a list of pins. This configuration can include the
+mux function to select on those pin(s), and various pin configuration
+parameters, as listed below.
+
+
+SUBNODES:
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Each subnode only affects those parameters that are explicitly listed. In
+other words, a subnode that lists a mux function but no pin configuration
+parameters implies no information about any pin configuration parameters.
+Similarly, a pin subnode that describes a pullup parameter implies no
+information about e.g. the mux function.
+
+The following generic properties as defined in pinctrl-bindings.txt are valid
+to specify in a pin configuration subnode:
+
+- pins:
+	Usage: required
+	Value type: <string-array>
+	Definition: List of gpio pins affected by the properties specified in
+		    this subnode.  Valid pins are:
+		    mpp1-mpp4 for pm8841
+		    mpp1-mpp8 for pm8941
+		    mpp1-mpp4 for pma8084
+
+- function:
+	Usage: optional
+	Value type: <string>
+	Definition: Specify the alternative function to be configured for the
+		    specified pins.  Valid values are:
+		    "normal",
+		    "paired",
+		    "dtest1",
+		    "dtest2",
+		    "dtest3",
+		    "dtest4"
+
+- qcom,mode:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects MPP mode of operation: Digital Input, Digital Output,
+		    Digital Input and Digital Output, Bidirectional Logic,
+		    Analog Input, Analog Output, Current Sink Valid values are
+		    defined in <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+		    PMIC_MPP_MODE_DI, PMIC_MPP_MODE_DO, PMIC_MPP_MODE_DIO...
+
+- bias-disable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configued as no pull.
+
+- bias-pull-up:
+	Usage: optional
+	Value type:  <u32>
+	Definition: The specified pins should be configued as pull up.
+		    Valid values are 600, 10000 and 30000.
+
+- bias-high-impedance:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins will put in high-Z mode and disabled.
+
+- input-enable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are put in input mode.
+
+- output-high:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in output mode, driven
+		    high.
+
+- output-low:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in output mode, driven
+		    low.
+
+- power-source:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the power source for the specified pins. Valid only
+		    when pin operate in Digital I/O mode ("gpio"). Valid
+		    power sources are defined in
+		    <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+
+- drive-strength:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the drive strength for the specified pins. Value
+		    drive strengths are: 5-40mA with 5mA step
+
+- qcom,amux-route:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the source for analog input. Valid values are
+		    defined in <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+		    PMIC_MPP_AMUX_ROUTE_CH5, PMIC_MPP_AMUX_ROUTE_CH6...
+
+- qcom,vrefence:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the analog output voltage reference. Valid values
+		    are defined in <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+		    PMIC_MPP_VREFERENCE_1V25, PMIC_MPP_VREFERENCE_0V625...
+
+Example:
+
+	mpps@a000 {
+		compatible = "qcom,pm8841-mpp";
+		reg = <0xa000>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupts = <4 0xa0 0 0>, <4 0xa1 0 0>, <4 0xa2 0 0>, <4 0xa3 0 0>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&pm8841_default>;
+
+		pm8841_default: default {
+			gpio {
+				pins = "mpp1", "mpp2", "mpp3", "mpp4";
+				function = "normal";
+
+				input-enable;
+
+				power-source = <PM8841_MPP_S3>;
+				bias-pull-up = <600>;
+			};
+		};
+	};
diff --git a/include/dt-bindings/pinctrl/qcom,pmic-gpio.h b/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
index 994e748..b208fdd 100644
--- a/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
+++ b/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
@@ -63,6 +63,24 @@
 #define PM8921_GPIO_L3			5
 #define PM8921_GPIO_L17			6
 
+/*
+ * Note: PM8941 gpios from 15 to 18 are supporting
+ * only S3 and L6 options (1.8V)
+ */
+#define PM8941_GPIO_VPH			0
+#define PM8941_GPIO_L1			1
+#define PM8941_GPIO_S3			2
+#define PM8941_GPIO_L6			3
+
+/*
+ * Note: PMA8084 gpios from 15 to 18 are supporting
+ * only S4 and L6 options (1.8V)
+ */
+#define PMA8084_GPIO_VPH		0
+#define PMA8084_GPIO_L1			1
+#define PMA8084_GPIO_S4			2
+#define PMA8084_GPIO_L6			3
+
 /* To be used with "function = " */
 #define PMIC_GPIO_FUNC_NORMAL		"normal"
 #define PMIC_GPIO_FUNC_PAIRED		"paired"
@@ -104,4 +122,21 @@
 #define PM8917_GPIO37_38_XO_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC1
 #define PM8917_GPIO37_38_MP3_CLK	PMIC_GPIO_FUNC_FUNC2
 
+#define PM8941_GPIO9_14_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO15_18_DIV_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO15_18_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC2
+#define PM8941_GPIO23_26_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO23_26_LPG_DRV_HI	PMIC_GPIO_FUNC_FUNC2
+#define PM8941_GPIO31_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO33_36_LPG_DRV_3D	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO33_36_LPG_DRV_HI	PMIC_GPIO_FUNC_FUNC2
+
+#define PMA8084_GPIO4_5_LPG_DRV		PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO7_10_LPG_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO5_14_KEYP_DRV	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO19_21_KEYP_DRV	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO15_18_DIV_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO15_18_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO22_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+
 #endif
diff --git a/include/dt-bindings/pinctrl/qcom,pmic-mpp.h b/include/dt-bindings/pinctrl/qcom,pmic-mpp.h
new file mode 100644
index 0000000..1bda99d
--- /dev/null
+++ b/include/dt-bindings/pinctrl/qcom,pmic-mpp.h
@@ -0,0 +1,70 @@
+/*
+ * This header provides constants for the Qualcomm PMIC's
+ * Multi-Purpose Pin binding.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_QCOM_PMIC_MPP_H
+#define _DT_BINDINGS_PINCTRL_QCOM_PMIC_MPP_H
+
+/* power-source */
+#define PM8841_MPP_VPH			0
+#define PM8841_MPP_S3			2
+
+#define PM8941_MPP_VPH			0
+#define PM8941_MPP_L1			1
+#define PM8941_MPP_S3			2
+#define PM8941_MPP_L6			3
+
+#define PMA8084_MPP_VPH			0
+#define PMA8084_MPP_L1			1
+#define PMA8084_MPP_S4			2
+#define PMA8084_MPP_L6			3
+
+/*
+ * Analog Output - Set the analog output voltage reference.
+ * To be used with "qcom,vrefence = <>"
+ */
+#define PMIC_MPP_VREFERENCE_1V25	0
+#define PMIC_MPP_VREFERENCE_0V625	1
+#define PMIC_MPP_VREFERENCE_0V3125	2
+#define PMIC_MPP_VREFERENCE_PAIRED_MPP	3
+#define PMIC_MPP_VREFERENCE_ABUS1	4
+#define PMIC_MPP_VREFERENCE_ABUS2	5
+#define PMIC_MPP_VREFERENCE_ABUS3	6
+#define PMIC_MPP_VREFERENCE_ABUS4	7
+
+/*
+ * Analog Input - Set the source for analog input.
+ * To be used with "qcom,amux-route = <>"
+ */
+#define PMIC_MPP_AMUX_ROUTE_CH5		0
+#define PMIC_MPP_AMUX_ROUTE_CH6		1
+#define PMIC_MPP_AMUX_ROUTE_CH7		2
+#define PMIC_MPP_AMUX_ROUTE_CH8		3
+#define PMIC_MPP_AMUX_ROUTE_ABUS1	4
+#define PMIC_MPP_AMUX_ROUTE_ABUS2	5
+#define PMIC_MPP_AMUX_ROUTE_ABUS3	6
+#define PMIC_MPP_AMUX_ROUTE_ABUS4	7
+
+/*
+ * Mode select - indicates whether the pin should be digital input, output, both
+ * or analog input, output or current sink. To be used with "qcom,mode = <>"
+ */
+#define PMIC_MPP_MODE_DI		0
+#define PMIC_MPP_MODE_DO		1
+#define PMIC_MPP_MODE_DIO		2
+#define PMIC_MPP_MODE_AIO		3
+#define PMIC_MPP_MODE_AI		4
+#define PMIC_MPP_MODE_AO		5
+#define PMIC_MPP_MODE_CS		6
+
+/* To be used with "function = " */
+#define PMIC_MPP_FUNC_NORMAL		"normal"
+#define PMIC_MPP_FUNC_PAIRED		"paired"
+#define PMIC_MPP_FUNC_DTEST1		"dtest1"
+#define PMIC_MPP_FUNC_DTEST2		"dtest2"
+#define PMIC_MPP_FUNC_DTEST3		"dtest3"
+#define PMIC_MPP_FUNC_DTEST4		"dtest4"
+
+#endif
+
-- 
1.8.3.2

