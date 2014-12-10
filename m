Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbaLJUzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:55:47 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51884 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaLJUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:55:44 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Bump SD card pin drive strength up on rk3288-evb
Date: Wed, 10 Dec 2014 12:55:29 -0800
Message-Id: <1418244929-8254-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that ever since (536f6b9 mmc: dw_mmc: Reset DMA before
enabling IDMAC) landed upstream that SD cards have been very unhappy
on rk3288-evb.  They were a little unhappy before that change, but
after that change they're REALLY unhappy.

It turns out that the above fix happens to fix a corruption when
reading card information during probe time.  Without the fix we didn't
detect that high speed SD cards could actually support high speed.
With the fix we suddenly detect that they're high speed and we try to
use them at 50MHz.  That doesn't work so well on EVB with the default
drive strength (maybe because there are two physical SD card slots
hooked up to the same pin?).

Fix the problem by bumping up the drive strength of the sdmmc lines.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Fixes: 536f6b91d21b ("mmc: dw_mmc: Reset DMA before enabling IDMAC")
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 3e067dd..6194d67 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -155,6 +155,15 @@
 };
 
 &pinctrl {
+	pcfg_pull_none_drv_8ma: pcfg-pull-none-drv-8ma {
+		drive-strength = <8>;
+	};
+
+	pcfg_pull_up_drv_8ma: pcfg-pull-up-drv-8ma {
+		bias-pull-up;
+		drive-strength = <8>;
+	};
+
 	backlight {
 		bl_en: bl-en {
 			rockchip,pins = <7 2 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -173,6 +182,27 @@
 		};
 	};
 
+	sdmmc {
+		/*
+		 * Default drive strength isn't enough to achieve even
+		 * high-speed mode on EVB board so bump up to 8ma.
+		 */
+		sdmmc_bus4: sdmmc-bus4 {
+			rockchip,pins = <6 16 RK_FUNC_1 &pcfg_pull_up_drv_8ma>,
+					<6 17 RK_FUNC_1 &pcfg_pull_up_drv_8ma>,
+					<6 18 RK_FUNC_1 &pcfg_pull_up_drv_8ma>,
+					<6 19 RK_FUNC_1 &pcfg_pull_up_drv_8ma>;
+		};
+
+		sdmmc_clk: sdmmc-clk {
+			rockchip,pins = <6 20 RK_FUNC_1 &pcfg_pull_none_drv_8ma>;
+		};
+
+		sdmmc_cmd: sdmmc-cmd {
+			rockchip,pins = <6 21 RK_FUNC_1 &pcfg_pull_up_drv_8ma>;
+		};
+	};
+
 	usb {
 		host_vbus_drv: host-vbus-drv {
 			rockchip,pins = <0 14 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.2.0.rc0.207.ga3a616c

