Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaLRMY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 07:24:29 -0500
Received: from vsp-authed01.binero.net ([195.74.38.224]:27699 "EHLO
	bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752278AbaLRMY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:24:28 -0500
X-Halon-ID: cfe93669-86b0-11e4-a1ae-005056917a89
Authorized-sender: andreas@gaisler.com
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] sparc32: destroy_context() and switch_mm() needs to disable interrupts.
Date: Thu, 18 Dec 2014 13:23:23 +0100
Message-Id: <1418905403-11154-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load balancing can be triggered in the critical sections protected by
srmmu_context_spinlock in destroy_context() and switch_mm() and can hang
the cpu waiting for the rq lock of another cpu that in turn has called
switch_mm hangning on srmmu_context_spinlock leading to deadlock.

So, disable interrupt while taking srmmu_context_spinlock in
destroy_context() and switch_mm() so we don't deadlock.

See also commit 77b838fa1ef0 ("[SPARC64]: destroy_context() needs to disable
interrupts.")

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/mm/srmmu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index be65f03..5cbc96d 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -460,10 +460,12 @@ static void __init sparc_context_init(int numctx)
 void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm,
 	       struct task_struct *tsk)
 {
+	unsigned long flags;
+
 	if (mm->context == NO_CONTEXT) {
-		spin_lock(&srmmu_context_spinlock);
+		spin_lock_irqsave(&srmmu_context_spinlock, flags);
 		alloc_context(old_mm, mm);
-		spin_unlock(&srmmu_context_spinlock);
+		spin_unlock_irqrestore(&srmmu_context_spinlock, flags);
 		srmmu_ctxd_set(&srmmu_context_table[mm->context], mm->pgd);
 	}
 
@@ -986,14 +988,15 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 void destroy_context(struct mm_struct *mm)
 {
+	unsigned long flags;
 
 	if (mm->context != NO_CONTEXT) {
 		flush_cache_mm(mm);
 		srmmu_ctxd_set(&srmmu_context_table[mm->context], srmmu_swapper_pg_dir);
 		flush_tlb_mm(mm);
-		spin_lock(&srmmu_context_spinlock);
+		spin_lock_irqsave(&srmmu_context_spinlock, flags);
 		free_context(mm->context);
-		spin_unlock(&srmmu_context_spinlock);
+		spin_unlock_irqrestore(&srmmu_context_spinlock, flags);
 		mm->context = NO_CONTEXT;
 	}
 }
-- 
1.7.10.4

