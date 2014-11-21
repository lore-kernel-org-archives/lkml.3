Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaKUKsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:48:22 -0500
Received: from mout.perfora.net ([74.208.4.196]:52494 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaKUKsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:48:20 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 05:48:19 EST
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch,
        Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH] ARM: tegra: colibri t30: fix on-module ethernet
Date: Fri, 21 Nov 2014 11:41:41 +0100
Message-Id: <b1cdc96ce8bb15059d7eea282f6586a826bee124.1416566157.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:x06M1XxNwJ9pDQvX7Ej3AWug9iFoV03dTcTZ8VXs+CU
 Uqi8gRnDbFubxK5yAnhmd72v/2/Ci81nR75zm6tOiYC2vBE1dk
 4+dvX2ilZIn+qGN439NXpFTw1uP187HKhyYO8oHvrGaqVZUX73
 Oq8tk/aUd7sAj3qxHXtSSP4HNTYHBuGmG50TxrczdB/XWXYug5
 QzbjcRtVENnj3LKJ8VTjpEMuQQEIGorz7O+qnZLndRXWQr9naS
 FEE1fV7DnMD4UdlM6oFgS4wHlTQSS4GmkqqJBTPyDZLsJHOROz
 63tXWJFtZXMl0Cpr28Bkmjmr93CFouU8MgEkuurV/o4NYYlHdX
 o0STLgGMag5exfm0PiuK9N7eOsjPDeqoOSrqw+yS7Ns+vThRXW
 FcimfD414Vn/TFVqzaav1/29HgRIs+5G/MKqGtE/P4Nx+WUqng
 0e0MvGSjsDuGFx8fOIHckGMlzag==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like Ethernet only ever worked if U-Boot properly brought it up
as both the reset as well as the VBUS lines were not actively handled
in-kernel.
This patch fixes this by just pulling up the reset GPIO and properly
enabling VBUS via a GPIO enabled fixed regulator VBUS supply.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
Don't know whether this one could still make it into the current RC
cycle as it is clearly a bug fix.

 arch/arm/boot/dts/tegra30-colibri.dtsi | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
index c4ed1be..ddbdb77 100644
--- a/arch/arm/boot/dts/tegra30-colibri.dtsi
+++ b/arch/arm/boot/dts/tegra30-colibri.dtsi
@@ -167,6 +167,22 @@
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
+
+			/* LAN_RESET# */
+			pex_l0_prsnt_n_pdd0 {
+				nvidia,pins = "pex_l0_prsnt_n_pdd0";
+				nvidia,function = "rsvd3";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
+
+			/* LAN_V_BUS */
+			pex_l0_clkreq_n_pdd2 {
+				nvidia,pins = "pex_l0_clkreq_n_pdd2";
+				nvidia,function = "rsvd3";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
 		};
 	};
 
@@ -345,6 +361,7 @@
 	usb-phy@7d004000 {
 		status = "okay";
 		nvidia,is-wired = <1>;
+		vbus-supply = <&lan_vbus_reg>;
 	};
 
 	clocks {
@@ -382,5 +399,17 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		/* LAN_V_BUS */
+		lan_vbus_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "lan_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio TEGRA_GPIO(DD, 2) GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			vin-supply = <&charge_pump_5v0_reg>;
+		};
 	};
 };
-- 
1.9.3

