Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3IRRy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:28 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:38189 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IRRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:12 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/26] clk: vt8500: parse pmc_base from clock driver
Date: Wed, 18 Sep 2013 19:53:40 +0200
Message-Id: <1379526839-14798-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, clock providers for vt8500 depend on machine_init providing
pmc_base address before calling of_clk_init. With upcoming arch-wide
.time_init calling of_clk_init, we should make clock providers independent
of mach code. This adds a pmc_base parsing helper to current clock provider
that gets called if there is no pmc_base set, yet.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk-vt8500.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 82306f5..a5ee01c 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -15,11 +15,14 @@
 
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 
+#define LEGACY_PMC_BASE		0xD8130000
+
 /* All clocks share the same lock as none can be changed concurrently */
 static DEFINE_SPINLOCK(_lock);
 
@@ -626,6 +629,21 @@ const struct clk_ops vtwm_pll_ops = {
 	.recalc_rate = vtwm_pll_recalc_rate,
 };
 
+static __init void vtwm_set_pmc_base(void)
+{
+	struct device_node *np =
+		of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
+
+	if (np)
+		pmc_base = of_iomap(np, 0);
+	else
+		pmc_base = ioremap(LEGACY_PMC_BASE, 0x1000);
+	of_node_put(np);
+
+	if (!pmc_base)
+		pr_err("%s:of_iomap(pmc) failed\n", __func__);
+}
+
 static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 {
 	u32 reg;
@@ -636,6 +654,9 @@ static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 	struct clk_init_data init;
 	int rc;
 
+	if (!pmc_base)
+		vtwm_set_pmc_base();
+
 	rc = of_property_read_u32(node, "reg", &reg);
 	if (WARN_ON(rc))
 		return;
-- 
1.7.10.4

