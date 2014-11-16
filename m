Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaKPUQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:16:49 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65252 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaKPUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:16:46 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 1/3] pinctrl: meson: add device tree bindings documentation
Date: Sun, 16 Nov 2014 21:14:14 +0100
Message-Id: <1416168856-12747-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation for Amlogic Meson pin and GPIO
controller.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 .../devicetree/bindings/pinctrl/meson,pinctrl.txt  | 97 ++++++++++++++++++++++
 1 file changed, 97 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
new file mode 100644
index 0000000..9edd1ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
@@ -0,0 +1,97 @@
+== Amlogic Meson pinmux controller ==
+
+Required properties for the root node:
+ - compatible: "amlogic,meson8-pinctrl"
+ - reg: address and size of registers controlling irq functionality
+
+=== GPIO sub-nodes ===
+
+The 2 power domains of the controller (regular and always-on) are
+represented as sub-nodes and each of them acts as a GPIO controller.
+
+Required properties for sub-nodes are:
+ - reg: should contain address and size for mux, pull-enable, pull and
+   gpio register sets
+ - reg-names: an array of strings describing the "reg" entries. Must
+   contain "mux", "pull" and "gpio". "pull-enable" is optional and
+   when it is missing the "pull" registers are used instead
+ - gpio-controller: identifies the node as a gpio controller
+ - #gpio-cells: must be 2
+
+Valid sub-node names are:
+ - "banks" for the regular domain
+ - "ao-bank" for the always-on domain
+
+=== Other sub-nodes ===
+
+Child nodes without the "gpio-controller" represent some desired
+configuration for a pin or a group. Those nodes can be pinmux nodes or
+configuration nodes.
+
+Required properties for pinmux nodes are:
+ - groups: a list of pinmux groups. The list of all available groups
+   depends on the SoC and can be found in driver sources.
+ - function: the name of a function to activate for the specified set
+   of groups. The list of all available functions depends on the SoC
+   and can be found in driver sources.
+
+Required properties for configuration nodes:
+ - pins: a list of pin names
+
+Configuration nodes support the generic properties "bias-disable",
+"bias-pull-up" and "bias-pull-down", described in file
+pinctrl-bindings.txt
+
+=== Example ===
+
+	pinctrl: pinctrl@c1109880 {
+		compatible = "amlogic,meson8-pinctrl";
+		reg = <0xc1109880 0x10>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		gpio: banks@c11080b0 {
+			reg = <0xc11080b0 0x28>,
+			      <0xc11080e8 0x18>,
+			      <0xc1108120 0x18>,
+			      <0xc1108030 0x30>;
+			reg-names = "mux", "pull", "pull-enable", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+               };
+
+		gpio_ao: ao-bank@c1108030 {
+			reg = <0xc8100014 0x4>,
+			      <0xc810002c 0x4>,
+			      <0xc8100024 0x8>;
+			reg-names = "mux", "pull", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		nand {
+			mux {
+				groups = "nand_io", "nand_io_ce0", "nand_io_ce1",
+					 "nand_io_rb0", "nand_ale", "nand_cle",
+					 "nand_wen_clk", "nand_ren_clk", "nand_dqs",
+					 "nand_ce2", "nand_ce3";
+				function = "nand";
+			};
+		};
+
+		uart_ao_a {
+			mux {
+				groups = "uart_tx_ao_a", "uart_rx_ao_a",
+					 "uart_cts_ao_a", "uart_rts_ao_a";
+				function = "uart_ao";
+			};
+
+			conf {
+				pins = "GPIOAO_0", "GPIOAO_1",
+				       "GPIOAO_2", "GPIOAO_3";
+				bias-disable;
+			};
+		};
+	};
+
-- 
1.9.1

