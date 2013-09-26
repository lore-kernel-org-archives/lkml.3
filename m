Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3IZRVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:21:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3IZRVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:21:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 5/5] ARM: shmobile: lager: (DEVEL) add CPUFreq support
Date: Thu, 26 Sep 2013 19:21:00 +0200
Message-Id: <1380216060-14506-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:fbxavfwXhzCZMwXaYCA+JqsisBRfWV/JVb2/NSee/cw
 Ux+Vszjrgq9wTHMcgv7JKObiQD9qsfKpEEA8j2BjvzEnATf03o
 es93YxZbTyU0iZlIJE3/Y02eQ141ZxXs3jMxlep+7vINDMdq8a
 eRMIvk6vjCJrLBrDFpEvy1d/vGY1W+j5vUB5p23C9JskqtSBbG
 PsXxlAuCvuyS5dlZ6EEkqnZ8bObXSLD0LUNan6ZYtWUxH3G2s9
 znO7qZZ3ArVde60Pm4JL6bdqn+ynB+g7azUbtaEo+d/8sjLLVz
 GpG2rExq13ZjPPpWP2DzP7Ljo5UhZrrZlgSnXyAHvloaQlMx3+
 8Eov7YXhr5OG76wgf61T0wGIwUjJ+vJAIp14UIiU0HHEgNnJw+
 oAQixelWlQAUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lager board uses a DA9210 voltage regulator to supply DVFS power to the
CA15 cores on the r8a7790 SoC. This patch adds CPUFreq support for that
board using the cpufreq-cpu0 driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v2: added 'status = "okay";' to the i2c bus

 arch/arm/boot/dts/r8a7790-lager-reference.dts  |   33 ++++++++++++++++++++++++
 arch/arm/mach-shmobile/board-lager-reference.c |    4 ++-
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager-reference.dts b/arch/arm/boot/dts/r8a7790-lager-reference.dts
index c462ef1..1ce0a97 100644
--- a/arch/arm/boot/dts/r8a7790-lager-reference.dts
+++ b/arch/arm/boot/dts/r8a7790-lager-reference.dts
@@ -43,3 +43,36 @@
 		};
 	};
 };
+
+&i2c3 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c3_pins>;
+
+	vdd_dvfs: da9210@68 {
+		compatible = "diasemi,da9210";
+		reg = <0x68>;
+
+		regulator-min-microvolt = <900000>;
+		regulator-max-microvolt = <1000000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+};
+
+&cpu0 {
+	cpu0-supply = <&vdd_dvfs>;
+	operating-points = <
+		/* kHz  uV - OPs unknown yet */
+		1300000 1000000
+		1000000  900000
+	>;
+	voltage-tolerance = <1>; /* 1% */
+};
+
+&pfc {
+	i2c3_pins: i2c3 {
+		renesas,groups = "i2c3";
+		renesas,function = "i2c3";
+	};
+};
diff --git a/arch/arm/mach-shmobile/board-lager-reference.c b/arch/arm/mach-shmobile/board-lager-reference.c
index 1a1a4a8..2bc8bae 100644
--- a/arch/arm/mach-shmobile/board-lager-reference.c
+++ b/arch/arm/mach-shmobile/board-lager-reference.c
@@ -20,6 +20,7 @@
 
 #include <linux/init.h>
 #include <linux/of_platform.h>
+#include <linux/platform_device.h>
 #include <mach/r8a7790.h>
 #include <asm/mach/arch.h>
 
@@ -29,7 +30,8 @@ static void __init lager_add_standard_devices(void)
 	r8a7790_clock_init();
 
 	r8a7790_add_dt_devices();
-        of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
 }
 
 static const char *lager_boards_compat_dt[] __initdata = {
-- 
1.7.2.5

