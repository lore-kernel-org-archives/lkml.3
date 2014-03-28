Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaC1Ryl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:54:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaC1Rap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3.10 14/22] ARM: highbank: avoid L2 cache smc calls when PL310 is not present
Date: Fri, 28 Mar 2014 10:32:06 -0700
Message-Id: <20140328173111.334876983@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit a56a5cf1f2ec895599eace0ac6eba1e4a489e4bf upstream.

While Midway firmware handles L2 smc calls as nops, the custom smc calls
present a problem when running virtualized Midway guest. They aren't
needed so just avoid calling them.

In the process, cleanup the L2X0 ifdefs and use IS_ENABLED instead.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-highbank/highbank.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -65,14 +65,12 @@ void highbank_set_cpu_jump(int cpu, void
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
@@ -81,12 +79,13 @@ static void __init highbank_init_irq(voi
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


