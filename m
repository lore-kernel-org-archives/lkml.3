Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006Ab3DIVfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:35:01 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:54090 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab3DIVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:34:53 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, linux@roeck-us.net,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
Date: Tue,  9 Apr 2013 14:34:29 -0700
Message-Id: <1365543270-10736-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1365543270-10736-1-git-send-email-dianders@chromium.org>
References: <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-1-git-send-email-dianders@chromium.org>
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
---
Changes in v5:
- Adjust bindings as per Wolfram Sang.

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
index 581ffae..fa85f58 100644
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
+		compatible = "i2c-arb-gpio-challenge";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		our-claim-gpio = <&gpf0 3 1>;
+		their-claim-gpios = <&gpe0 4 1>;
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

