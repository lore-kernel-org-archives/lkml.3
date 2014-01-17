Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaAQGsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:48:04 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33749 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAQGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:48 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC 6/6] ARM: sun7i: cubietruck: enable bluetooth module
Date: Fri, 17 Jan 2014 14:47:31 +0800
Message-Id: <1389941251-32692-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389941251-32692-1-git-send-email-wens@csie.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CubieTruck has an AMPAK AP6210 WiFi+Bluetooth module. The
Bluetooth part is a BCM20710 device connected to UART2 in the
A20 SoC.

The IC also requires a 32.768 KHz low power clock input for
proper auto-detection of the main clock, and power enable and
wake signals via GPIO.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 37 ++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index c8b3ea9..f172a8f 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -78,6 +78,20 @@
 					allwinner,drive = <0>;
 					allwinner,pull = <2>;
 			};
+
+			bt_pwr_pin: bt_pwr_pin@0 {
+				allwinner,pins = "PH18";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			bt_wake_pin: bt_wake_pin@0 {
+				allwinner,pins = "PH24";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		uart0: serial@01c28000 {
@@ -86,6 +100,12 @@
 			status = "okay";
 		};
 
+		uart2: serial@01c28800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart2_pins_a>;
+			status = "okay";
+		};
+
 		gmac: ethernet@01c50000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&gmac_pins_rgmii>;
@@ -157,4 +177,21 @@
 			gpio = <&pio 7 3 0>;
 		};
 	};
+
+	rfkill-switches {
+		compatible = "simple-bus";
+		pinctrl-names = "default";
+
+		rfkill_bt {
+			compatible = "rfkill-gpio";
+			pinctrl-names = "default";
+			pinctrl-0 = <&bt_pwr_pin>, <&clk_out_a_pins>;
+			rfkill-name = "bt";
+			rfkill-type = <2>;
+			bt_shutdown-gpios = <0>, <&pio 7 18 0>; /* PH18 */
+			bt_reset-gpios = <&pio 7 24 0>; /* PH24 */
+			clocks = <&clk_out_a>;
+			clock-frequency = <32768>;
+		};
+	};
 };
-- 
1.8.5.2

