Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbbADSgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:36:39 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62829 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbADSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:36:36 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [PATCH 2/2] x86_64, perf: Improve user regs sampling
Date: Sun,  4 Jan 2015 10:36:20 -0800
Message-Id: <243560c26ff0f739978e2459e203f6515367634d.1420396372.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1420396372.git.luto@amacapital.net>
References: <20150104174105.GA29388@krava.brq.redhat.com>
 <cover.1420396372.git.luto@amacapital.net>
In-Reply-To: <cover.1420396372.git.luto@amacapital.net>
References: <cover.1420396372.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf reports user regs for kernel-mode samples so that samples can
be backtraced through user code.  The old code was very broken in
syscall context, resulting in useless backtraces.

The new code, in contrast, is still dangerously racy, but it should
at least work most of the time.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/perf_regs.c | 78 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index 3bbbb1a4fb52..781861cc5ee8 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -115,7 +115,81 @@ void perf_get_regs_user(struct perf_regs *regs_user,
 			struct pt_regs *regs,
 			struct pt_regs *regs_user_copy)
 {
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
+	struct pt_regs *user_regs = task_pt_regs(current);
+
+	/*
+	 * If we're in an NMI that interrupted task_pt_regs setup, then
+	 * we can't sample user regs at all.  This check isn't really
+	 * sufficient, though, as we could be in an NMI inside an interrupt
+	 * that happened during task_pt_regs setup.
+	 */
+	if (regs->sp > (unsigned long)&user_regs->r11 &&
+	    regs->sp <= (unsigned long)(user_regs + 1)) {
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_user->regs = NULL;
+		return;
+	}
+
+	/*
+	 * RIP, flags, and the argument registers are usually saved.
+	 * orig_ax is probably okay, too.
+	 */
+	regs_user_copy->ip = user_regs->ip;
+	regs_user_copy->cx = user_regs->cx;
+	regs_user_copy->dx = user_regs->dx;
+	regs_user_copy->si = user_regs->si;
+	regs_user_copy->di = user_regs->di;
+	regs_user_copy->r8 = user_regs->r8;
+	regs_user_copy->r9 = user_regs->r9;
+	regs_user_copy->r10 = user_regs->r10;
+	regs_user_copy->r11 = user_regs->r11;
+	regs_user_copy->orig_ax = user_regs->orig_ax;
+	regs_user_copy->flags = user_regs->flags;
+
+	/*
+	 * Don't even try to report the "rest" regs.
+	 */
+	regs_user_copy->bx = -1;
+	regs_user_copy->bp = -1;
+	regs_user_copy->r12 = -1;
+	regs_user_copy->r13 = -1;
+	regs_user_copy->r14 = -1;
+	regs_user_copy->r15 = -1;
+
+	/*
+	 * For this to be at all useful, we need a reasonable guess for
+	 * sp and the ABI.  Be careful: we're in NMI context, and we're
+	 * considering current to be the current task, so we should
+	 * be careful not to look at any other percpu variables that might
+	 * change during context switches.
+	 */
+	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
+	    task_thread_info(current)->status & TS_COMPAT) {
+		/* Easy case: we're in a compat syscall. */
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_32;
+		regs_user_copy->sp = user_regs->sp;
+		regs_user_copy->cs = user_regs->cs;
+		regs_user_copy->ss = user_regs->ss;
+	} else if (user_regs->orig_ax != -1) {
+		/*
+		 * We're probably in a 64-bit syscall.
+		 * Warning: this code is severely racy.  At least it's better
+		 * than just blindly copying user_regs.
+		 */
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_64;
+		regs_user_copy->sp = this_cpu_read(old_rsp);
+		regs_user_copy->cs = __USER_CS;
+		regs_user_copy->ss = __USER_DS;
+		regs_user_copy->cx = -1;  /* usually contains garbage */
+	} else {
+		/* We're probably in an interrupt or exception. */
+		regs_user->abi = user_64bit_mode(user_regs) ?
+			PERF_SAMPLE_REGS_ABI_64 : PERF_SAMPLE_REGS_ABI_32;
+		regs_user_copy->sp = user_regs->sp;
+		regs_user_copy->cs = user_regs->cs;
+		regs_user_copy->ss = user_regs->ss;
+	}
+
+	regs_user->regs = regs_user_copy;
 }
 #endif /* CONFIG_X86_32 */
-- 
2.1.0

