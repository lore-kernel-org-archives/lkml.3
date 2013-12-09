Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab3LIK5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:57:19 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36157 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961Ab3LIKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:08 -0500
Subject: [PATCH -tip v5 03/18] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:25 +0000
Message-ID: <20131209104725.13397.2017.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prohibit probing on debug_stack_reset and debug_stack_set_zero.
Since the both functions are called from TRACE_IRQS_ON/OFF_DEBUG
macros which run in int3 ist entry, probing it may cause a soft
lockup.

This happens when the kernel built with CONFIG_DYNAMIC_FTRACE=y
and CONFIG_TRACE_IRQFLAGS=y.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/kernel/cpu/common.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6abc172..220de22 100644
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
@@ -1153,6 +1154,7 @@ int is_debug_stack(unsigned long addr)
 		(addr <= __get_cpu_var(debug_stack_addr) &&
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
+NOKPROBE_SYMBOL(is_debug_stack);
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);
 
@@ -1161,6 +1163,7 @@ void debug_stack_set_zero(void)
 	this_cpu_inc(debug_idt_ctr);
 	load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_set_zero);
 
 void debug_stack_reset(void)
 {
@@ -1169,6 +1172,7 @@ void debug_stack_reset(void)
 	if (this_cpu_dec_return(debug_idt_ctr) == 0)
 		load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_reset);
 
 #else	/* CONFIG_X86_64 */
 


