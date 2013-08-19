Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3HSVkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:40:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34890 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3HSVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:40:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 2/4] devicetree: serial: Document msm_serial bindings
Date: Mon, 19 Aug 2013 14:39:55 -0700
Message-Id: <1376948397-6882-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
References: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm serial device bindings were added to the DTS files but
never documented. Let's document them now and also fix things up
so that it's clearer what hardware is supported. Instead of using
hsuart (for high speed uart), let's use uartdm because that
matches the actual name of the hardware. Also, let's add the
version information in case we need to differentiate between
different versions of the hardware in the future.

Cc: David Brown <davidb@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/serial/msm_serial.txt      | 82 ++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/msm_serial.txt

diff --git a/Documentation/devicetree/bindings/serial/msm_serial.txt b/Documentation/devicetree/bindings/serial/msm_serial.txt
new file mode 100644
index 0000000..a6efac3
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/msm_serial.txt
@@ -0,0 +1,82 @@
+* MSM Serial UART and UARTDM
+
+There are two MSM serial hardware designs. UARTDM is designed for use with a
+dma engine in high-speed use cases and the non-DM design is for lower speed use
+cases. The two designs are mostly compatible from a software perspective except
+the non-DM design can only read and write one character at a time and so the
+register layout differs slightly.
+
+UART
+----
+Required properties:
+- compatible: Should contain "qcom,msm-uart"
+- reg: Should contain UART register location and length. The first
+       register shall specify the main control registers
+- interrupts: Should contain UART interrupt.
+- clocks: Should contain the core clock.
+- clock-names: Should be "core_clk".
+
+Optional properties:
+- dmas: Should contain dma specifiers for transmit and receive
+- dma-names: Should contain "tx" for transmit and "rx" for receive
+
+Example:
+
+A uart device with dma capabilities.
+
+serial@a9c00000 {
+	compatible = "qcom,msm-uart";
+	reg = <0xa9c00000 0x1000>;
+	interrupts = <11>;
+	clocks = <&uart_cxc>;
+	clock-names = "core_clk";
+	dmas = <&dma0 0>, <&dma0 1>;
+	dma-names = "tx", "rx";
+};
+
+UARTDM
+------
+Required properties:
+- compatible: Should contain at least "qcom,msm-uartdm".
+              A more specific property should be specified as follows depending
+	      on the version:
+		"qcom,msm-uartdm-v1.1"
+		"qcom,msm-uartdm-v1.2"
+		"qcom,msm-uartdm-v1.3"
+		"qcom,msm-uartdm-v1.4"
+- reg: Should contain UART register locations and lengths. The first
+       register shall specify the main control registers. An optional second
+       register location shall specify the GSBI control region.
+- interrupts: Should contain UART interrupt.
+- clocks: Should contain the core clock and the ahb clock.
+- clock-names: Should be "core_clk" for the core clock and "iface_clk" for the
+	       ahb clock.
+
+Optional properties:
+- dmas: Should contain dma specifiers for transmit and receive channels
+- dma-names: Should contain "tx" for transmit and "rx" for receive channels
+
+Examples:
+
+A uartdm v1.4 device with dma capabilities.
+
+serial@f991e000 {
+	compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+	reg = <0xf991e000 0x1000>;
+	interrupts = <0 108 0x0>;
+	clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
+	clock-names = "core_clk", "iface_clk";
+	dmas = <&dma0 0>, <&dma0 1>;
+	dma-names = "tx", "rx";
+};
+
+A uartdm v1.3 device without dma capabilities.
+
+serial@19c40000 {
+	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+	reg = <0x19c40000 0x1000>,
+	      <0x19c00000 0x1000>;
+	interrupts = <0 195 0x0>;
+	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
+	clock-names = "core_clk", "iface_clk";
+};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

