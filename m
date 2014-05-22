Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaEVJYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:24:22 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49688 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaEVJYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:24:21 -0400
Message-ID: <1400750659.16832.24.camel@x220>
Subject: [PATCH] MIPS: BCM1480: remove checks for CONFIG_SIBYTE_BCM1480_PROF
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 11:24:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 09:24:19.0318 (UTC) FILETIME=[9BEB6960:01CF759F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for CONFIG_SIBYTE_BCM1480_PROF in the tree since
v2.6.15. The related Kconfig symbol has never been added to the tree. So
these checks have always evaluated to false. Besides, one of these
checks guards a call of sbprof_cpu_intr(). But that function is not
defined. Remove all this.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Until v2.6.23 there also were checks for CONFIG_SIBYTE_SB1250_PROF in
the tree. There also was a Kconfig symbol SIBYTE_SB1250_PROF so it was
possible to make these checks evaluate to true. But, since one of these
checks also guarded a call of sbprof_cpu_intr(), that should have made
the build fail with an error.

 arch/mips/sibyte/bcm1480/irq.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 59cfe2659771..373fbbc8425c 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -347,19 +347,8 @@ asmlinkage void plat_irq_dispatch(void)
 	unsigned int cpu = smp_processor_id();
 	unsigned int pending;
 
-#ifdef CONFIG_SIBYTE_BCM1480_PROF
-	/* Set compare to count to silence count/compare timer interrupts */
-	write_c0_compare(read_c0_count());
-#endif
-
 	pending = read_c0_cause() & read_c0_status();
 
-#ifdef CONFIG_SIBYTE_BCM1480_PROF
-	if (pending & CAUSEF_IP7)	/* Cpu performance counter interrupt */
-		sbprof_cpu_intr();
-	else
-#endif
-
 	if (pending & CAUSEF_IP4)
 		do_IRQ(K_BCM1480_INT_TIMER_0 + cpu);
 #ifdef CONFIG_SMP
-- 
1.9.0

