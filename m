Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaDUFcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:32:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44432 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaDUFbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:33 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 3/4] soc: qcom: Add device tree binding for GSBI
Date: Mon, 21 Apr 2014 00:30:43 -0500
Message-Id: <1398058244-14099-4-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding support for the QCOM GSBI driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/soc/qcom/qcom,gsbi.txt     |   78 ++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
new file mode 100644
index 0000000..6462e61
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
@@ -0,0 +1,78 @@
+QCOM GSBI (General Serial Bus Interface) Driver
+
+The GSBI controller is modeled as a node with zero or more child nodes, each
+representing a serial sub-node device that is mux'd as part of the GSBI
+configuration settings.  The mode setting will govern the input/output mode of
+the 4 GSBI IOs.
+
+Required properties:
+- compatible: must contain "qcom,gsbi-v1.0.0" for APQ8064/IPQ8064
+- reg: Address range for GSBI registers
+- clocks: required clock
+- clock-names: must contain "iface" entry
+- qcom,mode : indicates MUX value for configuration of the serial interface.
+	mode 0: idle, null values applied to all four GSBI IOs
+	mode 1: I2C on 2 ports, SIM/R-UIM on other 2.
+	mode 2: I2C
+	mode 3: SPI
+	mode 4: UART w/ flow control
+	mode 5: SIM/R-UIM
+	mode 6: I2C on 2 ports, UART (without flow control) on other 2
+	mode 7: undefined
+
+Required properties if child node exists:
+- #address-cells: Must be 1
+- #size-cells: Must be 1
+- ranges: Must be present
+
+Properties for children:
+
+A GSBI controller node can contain 0 or more child nodes representing serial
+devices.  These serial devices can be a QCOM UART, I2C controller, spi
+controller, or some combination of aforementioned devices.
+
+See the following for child node definitions:
+Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
+Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
+Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
+
+Example for APQ8064:
+
+	gsbi4@16300000 {
+		compatible = "qcom,gsbi-v1.0.0";
+		reg = <0x16300000 0x100>;
+		clocks = <&gcc GSBI4_H_CLK>;
+		clock-names = "iface";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		qcom,mode = <6>;
+
+		/* child nodes go under here */
+
+		i2c_qup4: i2c@16380000 {
+		        compatible = "qcom,i2c-qup-v1.1.1";
+		        reg = <0x16380000 0x1000>;
+		        interrupts = <0 153 0>;
+
+		        clocks = <&gcc GSBI4_QUP_CLK>, <&gcc GSBI4_H_CLK>;
+		        clock-names = "core", "iface";
+
+		        clock-frequency = <200000>;
+
+		        #address-cells = <1>;
+		        #size-cells = <0>;
+
+		 };
+
+		uart4:	serial@16340000 {
+			compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+			reg = <0x16340000 0x1000>,
+				<0x16300000 0x1000>;
+			interrupts = <0 152 0x0>;
+			clocks = <&gcc GSBI4_UART_CLK>, <&gcc GSBI4_H_CLK>;
+			clock-names = "core", "iface";
+			status = "ok";
+		};
+	};
+
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

