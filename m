Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3HUGsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:48:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41276 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3HUGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:48:12 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 2/5] devicetree: serial: Document msm_serial bindings
Date: Tue, 20 Aug 2013 23:48:03 -0700
Message-Id: <1377067686-31957-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
References: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
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
 .../devicetree/bindings/serial/qcom,msm-uart.txt   | 25 +++++++++++
 .../devicetree/bindings/serial/qcom,msm-uartdm.txt | 52 ++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt

diff --git a/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt b/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
new file mode 100644
index 0000000..ce8c901
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
@@ -0,0 +1,25 @@
+* MSM Serial UART
+
+The MSM serial UART hardware is designed for low-speed use cases where a
+dma-engine isn't needed. From a software perspective it's mostly compatible
+with the MSM serial UARTDM except that it only supports reading and writing one
+character at a time.
+
+Required properties:
+- compatible: Should contain "qcom,msm-uart"
+- reg: Should contain UART register location and length.
+- interrupts: Should contain UART interrupt.
+- clocks: Should contain the core clock.
+- clock-names: Should be "core".
+
+Example:
+
+A uart device at 0xa9c00000 with interrupt 11.
+
+serial@a9c00000 {
+	compatible = "qcom,msm-uart";
+	reg = <0xa9c00000 0x1000>;
+	interrupts = <11>;
+	clocks = <&uart_cxc>;
+	clock-names = "core";
+};
diff --git a/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
new file mode 100644
index 0000000..1a4d681
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
@@ -0,0 +1,52 @@
+* MSM Serial UARTDM
+
+The MSM serial UARTDM hardware is designed for high-speed use cases where the
+transmit and/or receive channels can be offloaded to a dma-engine. From a
+software perspective it's mostly compatible with the MSM serial UART except
+that it supports reading and writing multiple characters at a time.
+
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
+- clocks: Should contain the core clock and the AHB clock.
+- clock-names: Should be "core" for the core clock and "iface" for the
+	       AHB clock.
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
+	clock-names = "core", "iface";
+	dmas = <&dma0 0>, <&dma0 1>;
+	dma-names = "tx", "rx";
+};
+
+A uartdm v1.3 device without dma capabilities and part of a GSBI complex. Note
+that not all v1.3 hardware is part of a GSBI.
+
+serial@19c40000 {
+	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+	reg = <0x19c40000 0x1000>,
+	      <0x19c00000 0x1000>;
+	interrupts = <0 195 0x0>;
+	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
+	clock-names = "core", "iface";
+};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

