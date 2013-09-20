Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3ITN0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:26:20 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35254 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3ITN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:26:14 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 3/3] RX-51: Add support for OMAP3 ROM Random Number Generator
Date: Fri, 20 Sep 2013 15:25:07 +0200
Message-Id: <1379683507-30793-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding this driver as platform device and only for RX-51 until somebody test if
it working also on other OMAP3 HS devices and until there will be generic ARM
way to deal with SMC calls.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   19 +++++++++++++++++++
 arch/arm/mach-omap2/omap-secure.c            |   11 +++++++++++
 arch/arm/mach-omap2/omap-secure.h            |    1 +
 3 files changed, 31 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index c3270c0..497d260 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -57,6 +57,8 @@
 #include "common-board-devices.h"
 #include "gpmc.h"
 #include "gpmc-onenand.h"
+#include "soc.h"
+#include "omap-secure.h"
 
 #define SYSTEM_REV_B_USES_VAUX3	0x1699
 #define SYSTEM_REV_S_USES_VAUX3 0x8
@@ -1289,6 +1291,22 @@ static void __init rx51_init_twl4030_hwmon(void)
 	platform_device_register(&madc_hwmon);
 }
 
+static struct platform_device omap3_rom_rng_device = {
+	.name		= "omap3-rom-rng",
+	.id		= -1,
+	.dev	= {
+		.platform_data	= rx51_secure_rng_call,
+	},
+};
+
+static void __init rx51_init_omap3_rom_rng(void)
+{
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+		pr_info("RX-51: Registring OMAP3 HWRNG device\n");
+		platform_device_register(&omap3_rom_rng_device);
+	}
+}
+
 void __init rx51_peripherals_init(void)
 {
 	rx51_i2c_init();
@@ -1309,5 +1327,6 @@ void __init rx51_peripherals_init(void)
 
 	rx51_charger_init();
 	rx51_init_twl4030_hwmon();
+	rx51_init_omap3_rom_rng();
 }
 
diff --git a/arch/arm/mach-omap2/omap-secure.c b/arch/arm/mach-omap2/omap-secure.c
index 146a7c4..5ac122e 100644
--- a/arch/arm/mach-omap2/omap-secure.c
+++ b/arch/arm/mach-omap2/omap-secure.c
@@ -135,3 +135,14 @@ u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
 				      FLAG_START_CRITICAL,
 				      1, acr, 0, 0, 0);
 }
+
+/**
+ * rx51_secure_rng_call: Routine for HW random generator
+ */
+u32 rx51_secure_rng_call(u32 ptr, u32 count, u32 flag)
+{
+	return rx51_secure_dispatcher(RX51_PPA_HWRNG,
+				      0,
+				      NO_FLAG,
+				      3, ptr, count, flag, 0);
+}
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
index 51b59c6..f6cabb0 100644
--- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -65,6 +65,7 @@ extern int omap_secure_ram_reserve_memblock(void);
 extern u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
 				  u32 arg1, u32 arg2, u32 arg3, u32 arg4);
 extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
+extern u32 rx51_secure_rng_call(u32 ptr, u32 count, u32 flag);
 
 #ifdef CONFIG_OMAP4_ERRATA_I688
 extern int omap_barrier_reserve_memblock(void);
-- 
1.7.10.4

