Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaGKJKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:10:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:35144 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaGKJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:34 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Fix preemption disable in iwmmxt_task_enable()
Date: Fri, 11 Jul 2014 11:10:13 +0200
Message-Id: <1405069813-9270-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <20140706080845.723e9787@armhf>
References: <20140706080845.723e9787@armhf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 431a84b1a4f7d1a0085d5b91330c5053cc8e8b12
 ("ARM: 8034/1: Disable preemption in iwmmxt_task_enable()")
introduced macros {inc,dec}_preempt_count to iwmmxt_task_enable
to make it run with preemption disabled.

Unfortunately, other functions in iwmmxt.S also use concan_{save,dump,load}
sections located in iwmmxt_task_enable() to deal with iWMMXt coprocessor.
This causes an unbalanced preempt_count due to excessive dec_preempt_count
and destroyed return addresses in callers of concan_ labels due to a register
collision:

Linux version 3.16.0-rc3-00062-gd92a333-dirty (jef@armhf) (gcc version 4.8.3 (Debian 4.8.3-4) ) #5 PREEMPT Thu Jul 3 19:46:39 CEST 2014
CPU: ARMv7 Processor [560f5815] revision 5 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
Machine model: SolidRun CuBox
...
PJ4 iWMMXt v2 coprocessor enabled.
...
Unable to handle kernel paging request at virtual address fffffffe
pgd = bb25c000
[fffffffe] *pgd=3bfde821, *pte=00000000, *ppte=00000000
Internal error: Oops: 80000007 [#1] PREEMPT ARM
Modules linked in:
CPU: 0 PID: 62 Comm: startpar Not tainted 3.16.0-rc3-00062-gd92a333-dirty #5
task: bb230b80 ti: bb256000 task.ti: bb256000
PC is at 0xfffffffe
LR is at iwmmxt_task_copy+0x44/0x4c
pc : [<fffffffe>]    lr : [<800130ac>]    psr: 40000033
sp : bb257de8  ip : 00000013  fp : bb257ea4
r10: bb256000  r9 : fffffdfe  r8 : 76e898e6
r7 : bb257ec8  r6 : bb256000  r5 : 7ea12760  r4 : 000000a0
r3 : ffffffff  r2 : 00000003  r1 : bb257df8  r0 : 00000000
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
Control: 10c5387d  Table: 3b25c019  DAC: 00000015
Process startpar (pid: 62, stack limit = 0xbb256248)

This patch fixes the issue by moving concan_{save,dump,load} into separate
code sections and make iwmmxt_task_enable() call them in the same way the
other functions use concan_ symbols. The test for valid ownership is moved
to concan_save and is safe for the other user of it, iwmmxt_task_disable().
The register collision is also resolved by moving concan_ symbols as
{inc,dec}_preempt_count are now local to iwmmxt_task_enable().

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reported-by: Jean-Francois Moine <moinejf@free.fr>
Fixes: 431a84b1a4f7 ("ARM: 8034/1: Disable preemption in iwmmxt_task_enable()")
---
The offending commit was intoduced past v3.15-rc1 and the corresponding fix
should also be queued up for stable v3.15+

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/kernel/iwmmxt.S |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/iwmmxt.S b/arch/arm/kernel/iwmmxt.S
index a5599cf..fc95b89 100644
--- a/arch/arm/kernel/iwmmxt.S
+++ b/arch/arm/kernel/iwmmxt.S
@@ -94,13 +94,19 @@ ENTRY(iwmmxt_task_enable)
 
 	mrc	p15, 0, r2, c2, c0, 0
 	mov	r2, r2				@ cpwait
+	bl	concan_save
 
-	teq	r1, #0				@ test for last ownership
-	mov	lr, r9				@ normal exit from exception
-	beq	concan_load			@ no owner, skip save
+#ifdef CONFIG_PREEMPT_COUNT
+	get_thread_info r10
+#endif
+4:	dec_preempt_count r10, r3
+	mov	pc, r9				@ normal exit from exception
 
 concan_save:
 
+	teq	r1, #0				@ test for last ownership
+	beq	concan_load			@ no owner, skip save
+
 	tmrc	r2, wCon
 
 	@ CUP? wCx
@@ -175,10 +181,6 @@ concan_load:
 	tmcr	wCon, r2
 
 3:
-#ifdef CONFIG_PREEMPT_COUNT
-	get_thread_info r10
-#endif
-4:	dec_preempt_count r10, r3
 	mov	pc, lr
 
 /*
-- 
1.7.2.5

