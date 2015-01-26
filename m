Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbbAZMRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:17:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbbAZMPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:15:55 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 3/7] ARM: dts: dra7-evm: Add extcon nodes for USB
Date: Mon, 26 Jan 2015 14:15:28 +0200
Message-ID: <1422274532-9488-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422274532-9488-1-git-send-email-rogerq@ti.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this EVM, the USB cable state has to be determined via the
ID pin tied to a GPIO line. We use the gpio-usb-extcon driver
to read the ID pin and the extcon framework to forward
the USB cable state information to the USB driver so the
controller can be configured in the right mode (host/peripheral).

Gets USB peripheral mode to work on this EVM.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index ad4118f..746cddb 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -26,6 +26,16 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
+	extcon_usb1: extcon_usb1 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&pcf_gpio_21 1 GPIO_ACTIVE_HIGH>;
+	};
+
+	extcon_usb2: extcon_usb2 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&pcf_gpio_21 2 GPIO_ACTIVE_HIGH>;
+	};
+
 	vtt_fixed: fixedregulator-vtt {
 		compatible = "regulator-fixed";
 		regulator-name = "vtt_fixed";
@@ -391,6 +401,19 @@
 			};
 		};
 	};
+
+	pcf_gpio_21: gpio@21 {
+		compatible = "ti,pcf8575";
+		reg = <0x21>;
+		lines-initial-states = <0x1408>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11 IRQ_TYPE_EDGE_FALLING>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
 };
 
 &i2c2 {
@@ -520,6 +543,14 @@
 	};
 };
 
+&omap_dwc3_1 {
+	extcon = <&extcon_usb1>;
+};
+
+&omap_dwc3_2 {
+	extcon = <&extcon_usb2>;
+};
+
 &usb1 {
 	dr_mode = "peripheral";
 	pinctrl-names = "default";
-- 
2.1.0

