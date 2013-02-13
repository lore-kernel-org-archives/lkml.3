Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab3BMSIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:08:06 -0500
Received: from mail-qe0-f73.google.com ([209.85.128.73]:61932 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824Ab3BMSID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:08:03 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <w.sang@pengutronix.de>
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
        Kukjin Kim <kgene.kim@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/4] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
Date: Wed, 13 Feb 2013 10:02:10 -0800
Message-Id: <1360778532-7480-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360778532-7480-1-git-send-email-dianders@chromium.org>
References: <1360778532-7480-1-git-send-email-dianders@chromium.org>
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
Changes in v1: None

 arch/arm/boot/dts/cros5250-common.dtsi |  5 ++++-
 arch/arm/boot/dts/exynos5250-snow.dts  | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index 46c0980..f451375 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -58,7 +58,10 @@
 	};
 
 	i2c@12CA0000 {
-		status = "disabled";
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <66000>;
+		gpios = <&gpa2 0 3 3 0>,
+			<&gpa2 1 3 3 0>;
 	};
 
 	i2c@12CB0000 {
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 17dd951..69a87a0 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -16,6 +16,10 @@
 	model = "Google Snow";
 	compatible = "google,snow", "samsung,exynos5250";
 
+	aliases {
+		i2c104 = &i2c_104;
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -29,6 +33,26 @@
 		};
 	};
 
+	i2c-arbitrator {
+		compatible = "i2c-arbitrator";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		bus-arbitration-gpios = <&gpf0 3 1 0 0>, <&gpe0 4 0 3 0>;
+		bus-arbitration-slew-delay-us = <10>;
+		bus-arbitration-wait-retry-us = <3000>;
+		bus-arbitration-wait-free-us = <50000>;
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
1.8.1

