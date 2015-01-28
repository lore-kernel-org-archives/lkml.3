Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbbA1Ury (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46227 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276AbbA1Url (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 5/5] ARM: dts: exynos5250-snow: Enable wifi power-on
Date: Wed, 28 Jan 2015 11:10:19 +0100
Message-Id: <1422439819-29854-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Snow board has a MMC/SDIO wifi chip that is always powered but it
needs a power sequence involving a reset (active low) and an enable
(active high) pins. Both pins are marked as active low since the MMC
simple power sequence driver asserts the pins prior to the card power
up procedure and de-asserts the pins after the card has been powered.

So the reset line will be left de-asserted and the enable pin will be
left asserted.

The chip also needs an external 32kHz reference clock to be operational
that is by the MAX77686 PMIC clock.

Add a simple MMC power sequence provider for the wifi MMC/SDIO slot.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index b9aeec430527..0f7971ba8238 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -229,6 +229,13 @@
 		power-supply = <&fet6>;
 		backlight = <&backlight>;
 	};
+
+	mmc3_pwrseq: mmc3_pwrseq {
+		reset-gpios = <&gpx0 2 GPIO_ACTIVE_LOW>, /* WIFI_RSTn */
+			      <&gpx0 1 GPIO_ACTIVE_LOW>; /* WIFI_EN */
+		clocks = <&max77686 MAX77686_CLK_PMIC>;
+		clock-names = "ext_clock";
+	};
 };
 
 &dp {
@@ -531,17 +538,33 @@
 	status = "okay";
 	num-slots = <1>;
 	broken-cd;
+	cap-sdio-irq;
 	card-detect-delay = <200>;
 	samsung,dw-mshc-ciu-div = <3>;
 	samsung,dw-mshc-sdr-timing = <2 3>;
 	samsung,dw-mshc-ddr-timing = <1 2>;
 	pinctrl-names = "default";
-	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4 &wifi_en &wifi_rst>;
 	bus-width = <4>;
 	cap-sd-highspeed;
+	mmc-pwrseq = <&mmc3_pwrseq>;
 };
 
 &pinctrl_0 {
+	wifi_en: wifi-en {
+		samsung,pins = "gpx0-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	wifi_rst: wifi-rst {
+		samsung,pins = "gpx0-2";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	power_key_irq: power-key-irq {
 		samsung,pins = "gpx1-3";
 		samsung,pin-function = <0xf>;
-- 
2.1.3

