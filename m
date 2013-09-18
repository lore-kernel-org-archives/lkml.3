Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3IRR6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:58:12 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48030 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3IRRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:14 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/26] clk: sunxi: declare OF clock provider
Date: Wed, 18 Sep 2013 19:53:39 +0200
Message-Id: <1379526839-14798-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common clock framework allows to register clock providers to get called
on of_clk_init() by using CLK_OF_DECLARE. This converts sunxi clock
providers to make use of it and get rid of the mach specific clk init
call. As sunxi has a bunch of independent clk provider nodes, we hook
current clock init to board compatible to make it called once.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-sunxi/sunxi.c   |    4 +---
 drivers/clk/sunxi/clk-sunxi.c |   11 ++++++-----
 include/linux/clk/sunxi.h     |   22 ----------------------
 3 files changed, 7 insertions(+), 30 deletions(-)
 delete mode 100644 include/linux/clk/sunxi.h

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index e79fb34..e5a6975 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -20,8 +20,6 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 
-#include <linux/clk/sunxi.h>
-
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
@@ -118,7 +116,7 @@ static void sunxi_setup_restart(void)
 
 static void __init sunxi_timer_init(void)
 {
-	sunxi_init_clocks();
+	of_clk_init(NULL);
 	clocksource_of_init();
 }
 
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 34ee69f..9bbd035 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -16,7 +16,6 @@
 
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
-#include <linux/clk/sunxi.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 
@@ -617,11 +616,8 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
 	}
 }
 
-void __init sunxi_init_clocks(void)
+static void __init sunxi_init_clocks(struct device_node *np)
 {
-	/* Register all the simple and basic clocks on DT */
-	of_clk_init(NULL);
-
 	/* Register factor clocks */
 	of_sunxi_table_clock_setup(clk_factors_match, sunxi_factors_clk_setup);
 
@@ -634,3 +630,8 @@ void __init sunxi_init_clocks(void)
 	/* Register gate clocks */
 	of_sunxi_table_clock_setup(clk_gates_match, sunxi_gates_clk_setup);
 }
+CLK_OF_DECLARE(sun4i_a10_clk_init, "allwinner,sun4i-a10", sunxi_init_clocks);
+CLK_OF_DECLARE(sun5i_a10s_clk_init, "allwinner,sun5i-a10s", sunxi_init_clocks);
+CLK_OF_DECLARE(sun5i_a13_clk_init, "allwinner,sun5i-a13", sunxi_init_clocks);
+CLK_OF_DECLARE(sun6i_a31_clk_init, "allwinner,sun6i-a31", sunxi_init_clocks);
+CLK_OF_DECLARE(sun7i_a20_clk_init, "allwinner,sun7i-a20", sunxi_init_clocks);
diff --git a/include/linux/clk/sunxi.h b/include/linux/clk/sunxi.h
deleted file mode 100644
index e074fdd..0000000
--- a/include/linux/clk/sunxi.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __LINUX_CLK_SUNXI_H_
-#define __LINUX_CLK_SUNXI_H_
-
-void __init sunxi_init_clocks(void);
-
-#endif
-- 
1.7.10.4

