Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaEUTfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41741 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752447AbaEUTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:35:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/2] ARM: topology: Use a clock if possible to get the CPU frequency
Date: Wed, 21 May 2014 21:33:15 +0200
Message-Id: <1400700796-5763-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400700796-5763-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1400700796-5763-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cortex-A7 and Cortex-A15 based SoCs need a clock-frequency property in the
topology code.

Allow to use a clock to provide the same information.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/kernel/topology.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 0bc94b1fd1ae..2885993ccf53 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -11,6 +11,7 @@
  * for more details.
  */
 
+#include <linux/clk.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
@@ -100,8 +101,8 @@ static void __init parse_dt_topology(void)
 	__cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);
 
 	for_each_possible_cpu(cpu) {
-		const u32 *rate;
-		int len;
+		struct clk *clk;
+		u32 rate = 0;
 
 		/* too early to use cpu->of_node */
 		cn = of_get_cpu_node(cpu, NULL);
@@ -117,14 +118,23 @@ static void __init parse_dt_topology(void)
 		if (cpu_eff->compatible == NULL)
 			continue;
 
-		rate = of_get_property(cn, "clock-frequency", &len);
-		if (!rate || len != 4) {
-			pr_err("%s missing clock-frequency property\n",
-				cn->full_name);
+		clk = of_clk_get(cn, 0);
+		if (!IS_ERR(clk)) {
+			rate = clk_get_rate(clk);
+		} else {
+			if (of_property_read_u32(cn, "clock-frequency", &rate)) {
+				pr_err("%s missing clocks or clock-frequency properties\n",
+				       cn->full_name);
+				continue;
+			}
+		}
+
+		if (!rate) {
+			pr_err("%s invalid CPU frequency", cn->full_name);
 			continue;
 		}
 
-		capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
+		capacity = ((rate) >> 20) * cpu_eff->efficiency;
 
 		/* Save min capacity of the system */
 		if (capacity < min_capacity)
-- 
1.9.3

