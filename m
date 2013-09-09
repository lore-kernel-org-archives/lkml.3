Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3IIQFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:05:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3IIQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:04:00 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 4/4] ARM: shmobile: lager: add CPUFreq support
Date: Mon,  9 Sep 2013 18:03:56 +0200
Message-Id: <1378742636-11215-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:cmfGUwTpAvR6x3LgZiAk6urQRpbGv3ihbAkbkOEKTj8
 Xuscer9qNXky8RtP1Hew49cXYNtbUdL4Mj6iXZicXfAKPkNpdl
 spVbnFhBlZyBFqJcieJ/erTIhn2X5jGeuyER2RtbB9djwkhtif
 cbuioLM3IKjx2eVqgYfY4AwoyAvy6ZlSsXOqGJ0HoIolh9qBJQ
 nejr9EFYOsW8aht0QnRALEjOngZz7pXBdTqpZY16cJJNBTw/aB
 JBEaZcUnnPWOSRrHDrNkDRcoyZpxlaEi9X7Bi8wIPGDqqzXrWm
 ibfm5jf1QujizzAw4qwNOFWlyzW7BwDUfRXnbsGBDKzcICsiSw
 HJQnWNl2MCyEzX1bgpaYYOIdLZJlyqKGQOe+x/y5fXD1Y1znSY
 ZIbirTwFIAV8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lager board uses a DA9210 voltage regulator to supply DVFS power to the
CA15 cores on the r8a7790 SoC. This patch adds CPUFreq support for that
board using the cpufreq-cpu0 driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

This patch is marked as RFC, because so far I don't have data about r8a7790
valid OPPs. The Lager system boots with 1.3GHz, supplying 1.0V to SoC's
DVFS. Apart from that I don't have information what voltage is required for
other clock frequencies. Here I'm using a "safe guess" of 0.95V for 700MHz,
but we might either wait with this patch until exact data is available, or
actually commit these values - this can be decided.

 arch/arm/boot/dts/r8a7790-lager-reference.dts  |   32 ++++++++++++++++++++++++
 arch/arm/mach-shmobile/board-lager-reference.c |    4 ++-
 2 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager-reference.dts b/arch/arm/boot/dts/r8a7790-lager-reference.dts
index c462ef1..7a41419 100644
--- a/arch/arm/boot/dts/r8a7790-lager-reference.dts
+++ b/arch/arm/boot/dts/r8a7790-lager-reference.dts
@@ -43,3 +43,35 @@
 		};
 	};
 };
+
+&i2c3 {
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
+		 700000  950000
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
index 9c316a1..442d854 100644
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

