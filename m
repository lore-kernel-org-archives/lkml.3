Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaH2P7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:59:55 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:48254 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbaH2P7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:59:54 -0400
X-Greylist: delayed 3045 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 11:59:54 EDT
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] sparc: leon: Fix race condition between leon_cycles_offset and timer_interrupt
Date: Fri, 29 Aug 2014 17:09:18 +0200
Message-Id: <1409324958-22902-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that leon_cycles_offset takes the pending bit into
account and that leon_clear_clock_irq clears the pending bit. Otherwise,
if leon_cycles_offset is executed after the timer has wrapped but before
timer_interrupt has increased timer_cs_internal_counter, time can be
perceived to go backwards.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/kernel/leon_kernel.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
index 683c4af..9bbb8f2 100644
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -37,6 +37,7 @@ unsigned long amba_system_id;
 static DEFINE_SPINLOCK(leon_irq_lock);
 
 static unsigned long leon3_gptimer_idx; /* Timer Index (0..6) within Timer Core */
+static unsigned long leon3_gptimer_ackmask; /* For clearing pending bit */
 unsigned long leon3_gptimer_irq; /* interrupt controller irq number */
 unsigned int sparc_leon_eirq;
 #define LEON_IMASK(cpu) (&leon3_irqctrl_regs->mask[cpu])
@@ -260,11 +261,19 @@ void leon_update_virq_handling(unsigned int virq,
 
 static u32 leon_cycles_offset(void)
 {
-	u32 rld, val, off;
+	u32 rld, val, ctrl, off;
+
 	rld = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].rld);
 	val = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].val);
-	off = rld - val;
-	return rld - val;
+	ctrl = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl);
+	if (LEON3_GPTIMER_CTRL_ISPENDING(ctrl)) {
+		val = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].val);
+		off = 2 * rld - val;
+	} else {
+		off = rld - val;
+	}
+
+	return off;
 }
 
 #ifdef CONFIG_SMP
@@ -302,6 +311,7 @@ void __init leon_init_timers(void)
 	int ampopts;
 	int err;
 	u32 config;
+	u32 ctrl;
 
 	sparc_config.get_cycles_offset = leon_cycles_offset;
 	sparc_config.cs_period = 1000000 / HZ;
@@ -374,6 +384,16 @@ void __init leon_init_timers(void)
 	if (!(leon3_gptimer_regs && leon3_irqctrl_regs && leon3_gptimer_irq))
 		goto bad;
 
+	ctrl = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl);
+	LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl,
+			      ctrl | LEON3_GPTIMER_CTRL_PENDING);
+	ctrl = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl);
+
+	if ((ctrl & LEON3_GPTIMER_CTRL_PENDING) != 0)
+		leon3_gptimer_ackmask = ~LEON3_GPTIMER_CTRL_PENDING;
+	else
+		leon3_gptimer_ackmask = ~0;
+
 	LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].val, 0);
 	LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].rld,
 				(((1000000 / HZ) - 1)));
@@ -452,6 +472,11 @@ bad:
 
 static void leon_clear_clock_irq(void)
 {
+	u32 ctrl;
+
+	ctrl = LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl);
+	LEON3_BYPASS_STORE_PA(&leon3_gptimer_regs->e[leon3_gptimer_idx].ctrl,
+			      ctrl & leon3_gptimer_ackmask);
 }
 
 static void leon_load_profile_irq(int cpu, unsigned int limit)
-- 
1.7.10.4

