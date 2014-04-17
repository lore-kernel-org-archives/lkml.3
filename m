Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbaDQJ6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:58:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaDQJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:58:47 -0400
Date: Thu, 17 Apr 2014 02:58:07 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-6381c24cd6d5d6373620426ab0a96c80ed953e20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, sandeepa.prabhu@linaro.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, sandeepa.prabhu@linaro.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140417081644.26341.52351.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081644.26341.52351.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86: Fix page-fault handling logic
Git-Commit-ID: 6381c24cd6d5d6373620426ab0a96c80ed953e20
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

Commit-ID:  6381c24cd6d5d6373620426ab0a96c80ed953e20
Gitweb:     http://git.kernel.org/tip/6381c24cd6d5d6373620426ab0a96c80ed953e20
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:16:44 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Apr 2014 10:57:02 +0200

kprobes/x86: Fix page-fault handling logic

Current kprobes in-kernel page fault handler doesn't
expect that its single-stepping can be interrupted by
an NMI handler which may cause a page fault(e.g. perf
with callback tracing).

In that case, the page-fault handled by kprobes and it
misunderstands the page-fault has been caused by the
single-stepping code and tries to recover IP address
to probed address.

But the truth is the page-fault has been caused by the
NMI handler, and do_page_fault failes to handle real
page fault because the IP address is modified and
causes Kernel BUGs like below.

 ----
 [ 2264.726905] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
 [ 2264.727190] IP: [<ffffffff813c46e0>] copy_user_generic_string+0x0/0x40

To handle this correctly, I fixed the kprobes fault
handler to ensure the faulted ip address is its own
single-step buffer instead of checking current kprobe
state.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: fche@redhat.com
Cc: systemtap@sourceware.org
Link: http://lkml.kernel.org/r/20140417081644.26341.52351.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f96..61b17dc 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -897,9 +897,10 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
-	switch (kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
+	if (unlikely(regs->ip == (unsigned long)cur->ainsn.insn)) {
+		/* This must happen on single-stepping */
+		WARN_ON(kcb->kprobe_status != KPROBE_HIT_SS &&
+			kcb->kprobe_status != KPROBE_REENTER);
 		/*
 		 * We are here because the instruction being single
 		 * stepped caused a page fault. We reset the current
@@ -914,9 +915,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		else
 			reset_current_kprobe();
 		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
+	} else if (kcb->kprobe_status == KPROBE_HIT_ACTIVE ||
+		   kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 		/*
 		 * We increment the nmissed count for accounting,
 		 * we can also use npre/npostfault count for accounting
@@ -945,10 +945,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
 		 */
-		break;
-	default:
-		break;
 	}
+
 	return 0;
 }
 
