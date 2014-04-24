Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaDXK7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:59:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaDXK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:59:09 -0400
Date: Thu, 24 Apr 2014 03:58:26 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-0f46efeb44e360b78f54a968b4d92e6877c35891@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, JBeulich@suse.com, tglx@linutronix.de, bp@suse.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, JBeulich@suse.com, tglx@linutronix.de, bp@suse.de,
        paul.gortmaker@windriver.com
In-Reply-To: <20140417081712.26341.32994.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081712.26341.32994.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes, x86:
  Prohibit probing on debug_stack_*()
Git-Commit-ID: 0f46efeb44e360b78f54a968b4d92e6877c35891
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

Commit-ID:  0f46efeb44e360b78f54a968b4d92e6877c35891
Gitweb:     http://git.kernel.org/tip/0f46efeb44e360b78f54a968b4d92e6877c35891
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:17:12 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:02:57 +0200

kprobes, x86: Prohibit probing on debug_stack_*()

Prohibit probing on debug_stack_reset and debug_stack_set_zero.
Since the both functions are called from TRACE_IRQS_ON/OFF_DEBUG
macros which run in int3 ist entry, probing it may cause a soft
lockup.

This happens when the kernel built with CONFIG_DYNAMIC_FTRACE=y
and CONFIG_TRACE_IRQFLAGS=y.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/20140417081712.26341.32994.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..5af696d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -8,6 +8,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/kprobes.h>
 #include <linux/kgdb.h>
 #include <linux/smp.h>
 #include <linux/io.h>
@@ -1160,6 +1161,7 @@ int is_debug_stack(unsigned long addr)
 		(addr <= __get_cpu_var(debug_stack_addr) &&
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
+NOKPROBE_SYMBOL(is_debug_stack);
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);
 
@@ -1168,6 +1170,7 @@ void debug_stack_set_zero(void)
 	this_cpu_inc(debug_idt_ctr);
 	load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_set_zero);
 
 void debug_stack_reset(void)
 {
@@ -1176,6 +1179,7 @@ void debug_stack_reset(void)
 	if (this_cpu_dec_return(debug_idt_ctr) == 0)
 		load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_reset);
 
 #else	/* CONFIG_X86_64 */
 
