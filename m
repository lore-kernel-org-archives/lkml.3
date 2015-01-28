Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbbA2DFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:05:21 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38781 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbbA2DFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:05:14 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v3 08/10] ARM: tegra: Use pwrseq-simple for the wifi in Nyan
Date: Wed, 28 Jan 2015 11:51:06 +0100
Message-Id: <1422442278-10405-9-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Nyan boards have a Marvell 88w8897 wifi card connected through SDIO
that needs the reset line to be asserted before mmc power up and deasserted
afterwards.

This patch also adds references to the power supplies of the card so that
the regulators are enabled when it's probed.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 arch/arm/boot/dts/tegra124-nyan.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-nyan.dtsi b/arch/arm/boot/dts/tegra124-nyan.dtsi
index 26e7402..632d181 100644
--- a/arch/arm/boot/dts/tegra124-nyan.dtsi
+++ b/arch/arm/boot/dts/tegra124-nyan.dtsi
@@ -207,7 +207,6 @@
 					regulator-name = "+1.8V_VDDIO";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-boot-on;
 					regulator-always-on;
 				};
 
@@ -364,12 +363,20 @@
 		status = "okay";
 	};
 
+	sdhci0_pwrseq: sdhci0_pwrseq {
+		compatible = "mmc-pwrseq-simple";
+
+		reset-gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
+	};
+
 	sdhci@0,700b0000 { /* WiFi/BT on this bus */
 		status = "okay";
-		power-gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 		no-1-8-v;
 		non-removable;
+		mmc-pwrseq = <&sdhci0_pwrseq>;
+		vmmc-supply = <&vdd_3v3_lp0>;
+		vqmmc-supply = <&vddio_1v8>;
 	};
 
 	sdhci@0,700b0400 { /* SD Card on this bus */
-- 
1.9.3

