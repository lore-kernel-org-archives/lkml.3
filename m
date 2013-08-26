Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3HZLjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26718 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3HZLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:17 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7b-521b3e64c73f
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH RFC 3/5] ARM: samsung: add clock setup for FIMC and FIMD
Date: Mon, 26 Aug 2013 13:38:32 +0200
Message-id: <1377517114-20222-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoG6KnXSQwf0bmhbzj5xjtXjT28Fi
	0bvgKpvF2aY37BabHl9jtVjYtoTF4vKuOWwWM87vY7K4fZnX4uI6eYvTa04xW7zuO8xisfT6
	RSaLpxMusllMmL6WxeLwigNMFuteTgey3rSzWrw62MZisX7GaxaLee0vWS2OzVjCaLFq1x9G
	B3GPNfPWMHq0NPeweSz4fIXd4/XkCYweO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWM
	Ht2fbrF6fN4k57FxbmgAbxSXTUpqTmZZapG+XQJXxolti1gLtgtXvJ38gKmBcZ9AFyMnh4SA
	icTBe3OYIGwxiQv31rN1MXJxCAlMZ5RYuPkpK4TTziRx9uw2sCo2AXOJic82sYDYIgKSEk0N
	f5hBipgFbrBILDj6lxEkISzgIfFq5nRWEJtFQFViwbdHQM0cHLwCfhI3DhtDbFOQ+Hn5BBuI
	zSngL7GnpY8dxBYCKjm3/BvLBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4+eZ
	9A7GVQ0WhxgFOBiVeHgD2KSDhFgTy4orcw8xSnAwK4nwmosChXhTEiurUovy44tKc1KLDzFK
	c7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTBaib1rD7CesE3p+PsYv07jeUc4TOZ/0NRq
	Mzqm99hieum2rzLz2vhZP263YetiiLYverz2dtiXisI2yyMWKy5lLpXQLgqN43iyWtJpvoG+
	clly75zKVUdbki876e3Q0Z2c4qjjxZkgbOswp69I0F20MrZ48/OP318L3ioOnrwz4+bNyz3x
	x5RYijMSDbWYi4oTAcrnjAibAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code that sets correct parents and rates for clocks
used by FIMC and FIMD on Goni board.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 arch/arm/mach-s5pv210/mach-goni.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index e5cd9fb..309b5ad 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -55,6 +55,7 @@
 #include <media/s5p_fimc.h>
 #include <media/noon010pc30.h>
 
+#include <linux/clk.h>
 #include "common.h"
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
@@ -195,6 +196,49 @@ static struct platform_device goni_spi_gpio = {
 	},
 };
 
+static void set_fimd_clock(void)
+{
+	struct clk *lcd_clk, *parent_clk;
+
+	lcd_clk = clk_get(NULL, "sclk_fimd");
+	parent_clk = clk_get(NULL, "mout_mpll");
+	clk_set_parent(lcd_clk, parent_clk);
+	clk_set_rate(lcd_clk, clk_get_rate(parent_clk)/3);
+
+	clk_put(parent_clk);
+	clk_put(lcd_clk);
+}
+
+static void set_fimc_clock(void)
+{
+	struct clk *cam0_clk, *cam1_clk, *fimc2_clk, *fimc1_clk,
+			*fimc0_clk, *parent_clk, *vpll_clk, *csis_clk;
+
+	parent_clk = clk_get(NULL, "mout_mpll");
+	vpll_clk = clk_get(NULL, "mout_vpll");
+	cam0_clk = clk_get(NULL, "mout_cam0");
+	cam1_clk = clk_get(NULL, "mout_cam1");
+	fimc2_clk = clk_get(NULL, "mout_fimc2");
+	fimc1_clk = clk_get(NULL, "mout_fimc1");
+	fimc0_clk = clk_get(NULL, "mout_fimc0");
+	csis_clk = clk_get(NULL, "mout_csis");
+
+	clk_set_parent(cam0_clk, vpll_clk);
+	clk_set_parent(cam1_clk, vpll_clk);
+	clk_set_parent(fimc2_clk, parent_clk);
+	clk_set_parent(fimc1_clk, parent_clk);
+	clk_set_parent(fimc0_clk, parent_clk);
+	clk_set_parent(csis_clk, parent_clk);
+
+	clk_put(parent_clk);
+	clk_put(vpll_clk);
+	clk_put(cam0_clk);
+	clk_put(cam1_clk);
+	clk_put(fimc2_clk);
+	clk_put(fimc1_clk);
+	clk_put(fimc0_clk);
+}
+
 /* KEYPAD */
 static uint32_t keymap[] __initdata = {
 	/* KEY(row, col, keycode) */
@@ -931,6 +975,10 @@ static void __init goni_machine_init(void)
 	s3c_i2c2_set_platdata(&i2c2_data);
 	i2c_register_board_info(2, i2c2_devs, ARRAY_SIZE(i2c2_devs));
 
+	/* FIMD AND FIMC set clock config */
+	set_fimd_clock();
+	set_fimc_clock();
+
 	/* PMIC */
 	goni_pmic_init();
 	i2c_register_board_info(AP_I2C_GPIO_PMIC_BUS_4, i2c_gpio_pmic_devs,
-- 
1.8.1.2

