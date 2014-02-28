Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaB1PeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:34:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbaB1PeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:34:02 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [PATCH] x86 trace: Fix page fault tracing bug
Date: Fri, 28 Feb 2014 16:33:40 +0100
Message-Id: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_do_page_fault function trigger tracepoint
and then handles the actual page fault.

This could lead to error if the tracepoint caused page
fault. The original cr2 value gets lost and the original
page fault handler kills current process with SIGSEGV.

This happens if you record page faults with callchain
data, the user part of it will cause tracepoint handler
to page fault:

  # perf record -g -e exceptions:page_fault_user ls

Fixing this by saving the original cr2 value
and using it after tracepoint handler is done.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/mm/fault.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d591c8..52fad6c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1016,11 +1016,11 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * routines.
  */
 static void __kprobes
-__do_page_fault(struct pt_regs *regs, unsigned long error_code)
+__do_page_fault(struct pt_regs *regs, unsigned long error_code,
+		unsigned long address)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	unsigned long address;
 	struct mm_struct *mm;
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
@@ -1028,9 +1028,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	/* Get the faulting address: */
-	address = read_cr2();
-
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
@@ -1248,9 +1245,14 @@ dotraplinkage void __kprobes
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	unsigned long address;
 
 	prev_state = exception_enter();
-	__do_page_fault(regs, error_code);
+
+	/* Get the faulting address: */
+	address = read_cr2();
+
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
 
@@ -1267,9 +1269,18 @@ dotraplinkage void __kprobes
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	unsigned long address;
 
 	prev_state = exception_enter();
+
+	/*
+	 * The tracepoint processing could trigger another page
+	 * fault (user space callchain reading) and destroy the
+	 * original cr2 value, so read the faulting address now.
+	 */
+	address = read_cr2();
+
 	trace_page_fault_entries(regs, error_code);
-	__do_page_fault(regs, error_code);
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
-- 
1.7.11.7

