Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbbA2PAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:00:38 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47396 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbbA2PAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:00:35 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 5/6] ARM: dts: exynos5250-snow: Enable wifi power-on
Date: Thu, 29 Jan 2015 16:00:07 +0100
Message-Id: <1422543608-24704-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422543608-24704-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422543608-24704-1-git-send-email-javier.martinez@collabora.co.uk>
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

Changes since v2: None.

Changes since v1:
 - Remove cap-sdio-irq from mmc3 dev node since is a separate change.
   Suggested by Arend van Spriel.
---
 arch/arm/boot/dts/exynos5250-snow.dts | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index b9aeec430527..b78712058903 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -229,6 +229,14 @@
 		power-supply = <&fet6>;
 		backlight = <&backlight>;
 	};
+
+	mmc3_pwrseq: mmc3_pwrseq {
+		compatible = "mmc-pwrseq-simple";
+		reset-gpios = <&gpx0 2 GPIO_ACTIVE_LOW>, /* WIFI_RSTn */
+			      <&gpx0 1 GPIO_ACTIVE_LOW>; /* WIFI_EN */
+		clocks = <&max77686 MAX77686_CLK_PMIC>;
+		clock-names = "ext_clock";
+	};
 };
 
 &dp {
@@ -536,12 +544,27 @@
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

