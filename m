Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaJTWl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:41:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJTWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:41:56 -0400
Message-Id: <20141020222841.562595816@infradead.org>
User-Agent: quilt/0.61-1
Date: Mon, 20 Oct 2014 23:56:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: [RFC][PATCH 6/6] mm,x86: Add speculative pagefault handling
References: <20141020215633.717315139@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-mm-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try a speculative fault before acquiring mmap_sem, if it returns with
VM_FAULT_RETRY continue with the mmap_sem acquisition and do the
traditional fault.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/mm/fault.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -844,11 +844,8 @@ do_sigbus(struct pt_regs *regs, unsigned
 	  unsigned int fault)
 {
 	struct task_struct *tsk = current;
-	struct mm_struct *mm = tsk->mm;
 	int code = BUS_ADRERR;
 
-	up_read(&mm->mmap_sem);
-
 	/* Kernel mode? Handle exceptions or die: */
 	if (!(error_code & PF_USER)) {
 		no_context(regs, error_code, address, SIGBUS, BUS_ADRERR);
@@ -879,7 +876,6 @@ mm_fault_error(struct pt_regs *regs, uns
 	       unsigned long address, unsigned int fault)
 {
 	if (fatal_signal_pending(current) && !(error_code & PF_USER)) {
-		up_read(&current->mm->mmap_sem);
 		no_context(regs, error_code, address, 0, 0);
 		return;
 	}
@@ -887,14 +883,11 @@ mm_fault_error(struct pt_regs *regs, uns
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
-			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address,
 				   SIGSEGV, SEGV_MAPERR);
 			return;
 		}
 
-		up_read(&current->mm->mmap_sem);
-
 		/*
 		 * We ran out of memory, call the OOM killer, and return the
 		 * userspace (which will retry the fault, or kill us if we got
@@ -1141,6 +1134,16 @@ __do_page_fault(struct pt_regs *regs, un
 	if (error_code & PF_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 
+	if (error_code & PF_USER) {
+		fault = handle_speculative_fault(mm, address,
+					flags & ~FAULT_FLAG_ALLOW_RETRY);
+
+		if (fault & VM_FAULT_RETRY)
+			goto retry;
+
+		goto done;
+	}
+
 	/*
 	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in
@@ -1225,9 +1228,15 @@ __do_page_fault(struct pt_regs *regs, un
 	 * signal first. We do not need to release the mmap_sem because it
 	 * would already be released in __lock_page_or_retry in mm/filemap.c.
 	 */
-	if (unlikely((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)))
-		return;
+	if (unlikely(fault & VM_FAULT_RETRY)) {
+		if (fatal_signal_pending(current))
+			return;
+
+		goto done;
+	}
 
+	up_read(&mm->mmap_sem);
+done:
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		mm_fault_error(regs, error_code, address, fault);
 		return;
@@ -1249,8 +1258,10 @@ __do_page_fault(struct pt_regs *regs, un
 				      regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation. */
+			/*
+			 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk of
+			 * starvation.
+			 */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 			goto retry;
@@ -1258,8 +1269,6 @@ __do_page_fault(struct pt_regs *regs, un
 	}
 
 	check_v8086_mode(regs, address, tsk);
-
-	up_read(&mm->mmap_sem);
 }
 NOKPROBE_SYMBOL(__do_page_fault);
 


