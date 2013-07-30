Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3G3S7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:59:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3G3Spc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 35/75] arm64: mm: don't treat user cache maintenance faults as writes
Date: Tue, 30 Jul 2013 11:44:39 -0700
Message-Id: <1375209919-1768-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit db6f41063cbdb58b14846e600e6bc3f4e4c2e888 upstream.

On arm64, cache maintenance faults appear as data aborts with the CM
bit set in the ESR. The WnR bit, usually used to distinguish between
faulting loads and stores, always reads as 1 and (slightly confusingly)
the instructions are treated as reads by the architecture.

This patch fixes our fault handling code to treat cache maintenance
faults in the same way as loads.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/mm/fault.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0782eaf..af4cd30 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -151,25 +151,8 @@ void do_bad_area(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 #define ESR_CM			(1 << 8)
 #define ESR_LNX_EXEC		(1 << 24)
 
-/*
- * Check that the permissions on the VMA allow for the fault which occurred.
- * If we encountered a write fault, we must have write permission, otherwise
- * we allow any permission.
- */
-static inline bool access_error(unsigned int esr, struct vm_area_struct *vma)
-{
-	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
-
-	if (esr & ESR_WRITE)
-		mask = VM_WRITE;
-	if (esr & ESR_LNX_EXEC)
-		mask = VM_EXEC;
-
-	return vma->vm_flags & mask ? false : true;
-}
-
 static int __do_page_fault(struct mm_struct *mm, unsigned long addr,
-			   unsigned int esr, unsigned int flags,
+			   unsigned int mm_flags, unsigned long vm_flags,
 			   struct task_struct *tsk)
 {
 	struct vm_area_struct *vma;
@@ -187,12 +170,17 @@ static int __do_page_fault(struct mm_struct *mm, unsigned long addr,
 	 * it.
 	 */
 good_area:
-	if (access_error(esr, vma)) {
+	/*
+	 * Check that the permissions on the VMA allow for the fault which
+	 * occurred. If we encountered a write or exec fault, we must have
+	 * appropriate permissions, otherwise we allow any permission.
+	 */
+	if (!(vma->vm_flags & vm_flags)) {
 		fault = VM_FAULT_BADACCESS;
 		goto out;
 	}
 
-	return handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
+	return handle_mm_fault(mm, vma, addr & PAGE_MASK, mm_flags);
 
 check_stack:
 	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
@@ -207,9 +195,15 @@ static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	int fault, sig, code;
-	bool write = (esr & ESR_WRITE) && !(esr & ESR_CM);
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
-		(write ? FAULT_FLAG_WRITE : 0);
+	unsigned long vm_flags = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned int mm_flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
+	if (esr & ESR_LNX_EXEC) {
+		vm_flags = VM_EXEC;
+	} else if ((esr & ESR_WRITE) && !(esr & ESR_CM)) {
+		vm_flags = VM_WRITE;
+		mm_flags |= FAULT_FLAG_WRITE;
+	}
 
 	tsk = current;
 	mm  = tsk->mm;
@@ -247,7 +241,7 @@ retry:
 #endif
 	}
 
-	fault = __do_page_fault(mm, addr, esr, flags, tsk);
+	fault = __do_page_fault(mm, addr, mm_flags, vm_flags, tsk);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
@@ -264,7 +258,7 @@ retry:
 	 */
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+	if (mm_flags & FAULT_FLAG_ALLOW_RETRY) {
 		if (fault & VM_FAULT_MAJOR) {
 			tsk->maj_flt++;
 			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs,
@@ -279,7 +273,7 @@ retry:
 			 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk of
 			 * starvation.
 			 */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			mm_flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			goto retry;
 		}
 	}
-- 
1.8.1.2

