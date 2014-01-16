Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaAPNj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:39:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaAPNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:55 -0500
Date: Thu, 16 Jan 2014 05:39:13 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c026b3591e4f2a4993df773183704bb31634e0bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        acme@ghostprotocols.net, peterz@infradead.org, luto@amacapital.net,
        akpm@linux-foundation.org, tglx@linutronix.de, scott.norton@hp.com,
        aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        waiman.long@hp.com, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@ghostprotocols.net, luto@amacapital.net,
        akpm@linux-foundation.org, tglx@linutronix.de, scott.norton@hp.com,
        aswin@hp.com
In-Reply-To: <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
References: <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mm, perf:
  Allow recursive faults from interrupts
Git-Commit-ID: c026b3591e4f2a4993df773183704bb31634e0bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c026b3591e4f2a4993df773183704bb31634e0bd
Gitweb:     http://git.kernel.org/tip/c026b3591e4f2a4993df773183704bb31634e0bd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 10 Jan 2014 21:06:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:19:48 +0100

x86, mm, perf: Allow recursive faults from interrupts

Waiman managed to trigger a PMI while in a emulate_vsyscall() fault,
the PMI in turn managed to trigger a fault while obtaining a stack
trace. This triggered the sig_on_uaccess_error recursive fault logic
and killed the process dead.

Fix this by explicitly excluding interrupts from the recursive fault
logic.

Reported-and-Tested-by: Waiman Long <waiman.long@hp.com>
Fixes: e00b12e64be9 ("perf/x86: Further optimize copy_from_user_nmi()")
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140110200603.GJ7572@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/fault.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ff85bb..9d591c8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -641,6 +641,20 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs)) {
+		/*
+		 * Any interrupt that takes a fault gets the fixup. This makes
+		 * the below recursive fault logic only apply to a faults from
+		 * task context.
+		 */
+		if (in_interrupt())
+			return;
+
+		/*
+		 * Per the above we're !in_interrupt(), aka. task context.
+		 *
+		 * In this case we need to make sure we're not recursively
+		 * faulting through the emulate_vsyscall() logic.
+		 */
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
 			tsk->thread.trap_nr = X86_TRAP_PF;
 			tsk->thread.error_code = error_code | PF_USER;
@@ -649,6 +663,10 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 			/* XXX: hwpoison faults will set the wrong code. */
 			force_sig_info_fault(signal, si_code, address, tsk, 0);
 		}
+
+		/*
+		 * Barring that, we can do the fixup and be happy.
+		 */
 		return;
 	}
 
