Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaDQIuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:50:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54404 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbaDQIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:11 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 4/8] ARM: sun6i: Protect CPU clock
Date: Thu, 17 Apr 2014 10:46:15 +0200
Message-Id: <1397724379-15398-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, AHB is an indirect child clock of the CPU clock. If that happens to
change, since the CPU clock has no other consumers declared in Linux, it would
be shut down, which is not really a good idea.

Prevent this by forcing it enabled.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sun6i.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-sunxi/sun6i.c b/arch/arm/mach-sunxi/sun6i.c
index c5dc81988ce9..6b3905505fe0 100644
--- a/arch/arm/mach-sunxi/sun6i.c
+++ b/arch/arm/mach-sunxi/sun6i.c
@@ -10,6 +10,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/clocksource.h>
 #include <linux/init.h>
@@ -22,9 +23,17 @@
 
 static void __init sun6i_dt_init(void)
 {
+	struct clk *clk;
+
 	sunxi_setup_restart();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* Make sure the clocks we absolutely need are enabled */
+	/* CPU clock */
+	clk = clk_get(NULL, "cpu");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
 }
 
 extern void __init sun6i_reset_init(void);
-- 
1.9.1

