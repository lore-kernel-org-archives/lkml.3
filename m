Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaDAMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:25:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDALP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:15:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 002/144] ARM: highbank: avoid L2 cache smc calls when PL310 is not present
Date: Tue,  1 Apr 2014 12:13:26 +0100
Message-Id: <1396350948-29910-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit a56a5cf1f2ec895599eace0ac6eba1e4a489e4bf upstream.

While Midway firmware handles L2 smc calls as nops, the custom smc calls
present a problem when running virtualized Midway guest. They aren't
needed so just avoid calling them.

In the process, cleanup the L2X0 ifdefs and use IS_ENABLED instead.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-highbank/highbank.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 4a929a2..f283f1c 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -68,14 +68,12 @@ void highbank_set_cpu_jump(int cpu, void *jump_addr)
 			  HB_JUMP_TABLE_PHYS(cpu) + 15);
 }
 
-#ifdef CONFIG_CACHE_L2X0
 static void highbank_l2x0_disable(void)
 {
 	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	highbank_smc1(0x102, 0x0);
 }
-#endif
 
 static void __init highbank_init_irq(void)
 {
@@ -84,12 +82,13 @@ static void __init highbank_init_irq(void)
 	if (of_find_compatible_node(NULL, NULL, "arm,cortex-a9"))
 		highbank_scu_map_io();
 
-#ifdef CONFIG_CACHE_L2X0
 	/* Enable PL310 L2 Cache controller */
-	highbank_smc1(0x102, 0x1);
-	l2x0_of_init(0, ~0UL);
-	outer_cache.disable = highbank_l2x0_disable;
-#endif
+	if (IS_ENABLED(CONFIG_CACHE_L2X0) &&
+	    of_find_compatible_node(NULL, NULL, "arm,pl310-cache")) {
+		highbank_smc1(0x102, 0x1);
+		l2x0_of_init(0, ~0UL);
+		outer_cache.disable = highbank_l2x0_disable;
+	}
 }
 
 static void __init highbank_timer_init(void)
-- 
1.9.1

