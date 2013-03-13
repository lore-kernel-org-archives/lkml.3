Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3CMQhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:37:12 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35309 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3CMQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:37:08 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
Date: Wed, 13 Mar 2013 09:36:22 -0700
Message-Id: <1363192583-26363-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363192583-26363-1-git-send-email-dianders@chromium.org>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1363192583-26363-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use the i2c-arbitrator to talk to any of the devices on i2c
bus 4 on exynos5250-snow so that we don't confuse the embedded
controller (EC).  Add the i2c-arbitrator to the device tree.  As we
add future devices (keyboard, sbs, tps65090) we'll add them on top of
this.

The arbitrated bus is numbered 104 simply as a convenience to make it
easier for people poking around to guess that it might have something
to do with the physical bus 4.

The addition is split between the cros5250-common and the snow device
tree file since not all cros5250-class devices use arbitration.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes in v4:
- Changed mux gpio syntax to work atop Thomas's "ARM: dts: add pin
  state information in client nodes for Exynos5 platforms"; avoid
  adding gpios property to i2c@12CA0000 for the same reason.

Changes in v3: None
Changes in v2:
- Use new device tree property names / compatible string.
- Include that the GPIOs for arbitration are active low.

 arch/arm/boot/dts/cros5250-common.dtsi |  3 ++-
 arch/arm/boot/dts/exynos5250-snow.dts  | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index 8a5b3a6..0a61bbb 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -193,7 +193,8 @@
 	};
 
 	i2c@12CA0000 {
-		status = "disabled";
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <66000>;
 	};
 
 	i2c@12CB0000 {
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 581ffae..bf16353 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -16,6 +16,10 @@
 	model = "Google Snow";
 	compatible = "google,snow", "samsung,exynos5250";
 
+	aliases {
+		i2c104 = &i2c_104;
+	};
+
 	pinctrl@11400000 {
 		sd3_clk: sd3-clk {
 			samsung,pin-drv = <0>;
@@ -44,6 +48,27 @@
 		};
 	};
 
+	i2c-arbitrator {
+		compatible = "i2c-arbitrator-cros-ec";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		ap-claim-gpio = <&gpf0 3 1>;
+		ec-claim-gpio = <&gpe0 4 1>;
+		slew-delay-us = <10>;
+		wait-retry-us = <3000>;
+		wait-free-us = <50000>;
+
+		/* Use ID 104 as a hint that we're on physical bus 4 */
+		i2c_104: i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+	};
+
 	/*
 	 * On Snow we've got SIP WiFi and so can keep drive strengths low to
 	 * reduce EMI.
-- 
1.8.1.3

