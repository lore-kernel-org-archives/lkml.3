Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252Ab3DCTQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:16:01 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50178 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763221Ab3DCTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:15:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] sparc32: make show_stack() acquire %fp if @_ksp is not specified
Date: Wed,  3 Apr 2013 12:14:52 -0700
Message-Id: <1365016497-32033-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_stack(current or NULL, NULL) is used by arch-independent code to
dump backtrace of the current task; however, sparc32 show_stack()
doesn't implement it and wouldn't print any backtrace when NULL @_ksp
is specfied.

Make show_stack() acquire and use %fp if @tsk is NULL or current and
@_ksp is NULL.  This makes %fp fetching in dump_stack() unnecessary.
Make it use NULL for @_ksp instead.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/process_32.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 62eede1..0d57b24 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -153,11 +153,13 @@ void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 	struct reg_window32 *rw;
 	int count = 0;
 
-	if (tsk != NULL)
-		task_base = (unsigned long) task_stack_page(tsk);
-	else
-		task_base = (unsigned long) current_thread_info();
+	if (!tsk)
+		tsk = current;
 
+	if (tsk == current && !_ksp)
+		__asm__ __volatile__("mov	%%fp, %0" : "=r" (_ksp));
+
+	task_base = (unsigned long) task_stack_page(tsk);
 	fp = (unsigned long) _ksp;
 	do {
 		/* Bogus frame pointer? */
@@ -175,11 +177,7 @@ void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 
 void dump_stack(void)
 {
-	unsigned long *ksp;
-
-	__asm__ __volatile__("mov	%%fp, %0"
-			     : "=r" (ksp));
-	show_stack(current, ksp);
+	show_stack(current, NULL);
 }
 
 EXPORT_SYMBOL(dump_stack);
-- 
1.8.1.4

