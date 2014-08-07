Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaHGM4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:56:05 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50655 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbaHGM4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:56:03 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: add initcall to set clk defaults after syscons are available
Date: Thu, 07 Aug 2014 14:57:38 +0200
Message-ID: <1566610.B4NH8lpaoI@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLs on Rockchip platforms report their locking state in an external
register situated in the "General Register Files" which is provided
through a syscon device.

When the initial clk init runs, this syscon is of course not yet
available, making it impossible to set PLLs to other frequencies
through the assigned-rate property of the clock-controller node.

Syscon devices are initialized through a postcore initcall, so add an
arch_initcall to rerun the rockchip specific clock initalization when
the GRF is available.

As the clock init already runs two times (through of_clk_add_provider
and of_clk_init), a third time shouldn't hurt to much and in the best
case wouldn't change any settings at all.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clk/rockchip/clk.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 9a3adb1..e14b108 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include "clk.h"
@@ -126,6 +127,18 @@ void __init rockchip_clk_init(struct device_node *np, void __iomem *base,
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
 
+/**
+ * Set clock-defaults again, after grf regmap is available for PLLs.
+ */
+static int __init rockchip_clk_set_defaults(void)
+{
+	if (cru_node)
+		return of_clk_set_defaults(cru_node, true);
+
+	return 0;
+}
+arch_initcall(rockchip_clk_set_defaults);
+
 struct regmap *rockchip_clk_get_grf(void)
 {
 	if (IS_ERR(grf))
-- 
2.0.1


