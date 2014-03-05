Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaCEAEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:04:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaCEAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:04:06 -0500
Date: Tue, 4 Mar 2014 16:03:25 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, seiji.aguchi@hds.com, jolsa@redhat.com,
        vincent.weaver@maine.edu, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20140228160526.GD1133@krava.brq.redhat.com>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
	<20140228160526.GD1133@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, trace:
  Fix CR2 corruption when tracing page faults
Git-Commit-ID: 0ac09f9f8cd1fb028a48330edba6023d347d3cea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ac09f9f8cd1fb028a48330edba6023d347d3cea
Gitweb:     http://git.kernel.org/tip/0ac09f9f8cd1fb028a48330edba6023d347d3cea
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 28 Feb 2014 17:05:26 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 4 Mar 2014 16:00:14 -0800

x86, trace: Fix CR2 corruption when tracing page faults

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

v2: Moving the cr2 read before exception_enter, because
    it could trigger tracepoint as well.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu
Link: http://lkml.kernel.org/r/20140228160526.GD1133@krava.brq.redhat.com
---
 arch/x86/mm/fault.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6dea040..e7fa28b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1022,11 +1022,11 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
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
@@ -1034,9 +1034,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	/* Get the faulting address: */
-	address = read_cr2();
-
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
@@ -1252,9 +1249,11 @@ dotraplinkage void __kprobes
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	/* Get the faulting address: */
+	unsigned long address = read_cr2();
 
 	prev_state = exception_enter();
-	__do_page_fault(regs, error_code);
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
 
@@ -1271,9 +1270,16 @@ dotraplinkage void __kprobes
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	/*
+	 * The exception_enter and tracepoint processing could
+	 * trigger another page faults (user space callchain
+	 * reading) and destroy the original cr2 value, so read
+	 * the faulting address now.
+	 */
+	unsigned long address = read_cr2();
 
 	prev_state = exception_enter();
 	trace_page_fault_entries(regs, error_code);
-	__do_page_fault(regs, error_code);
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
