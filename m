Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaCEL7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:59:33 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48046 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaCEL71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:59:27 -0500
Subject: [PATCH -tip v8 05/26] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Date: Wed, 05 Mar 2014 20:59:18 +0900
Message-ID: <20140305115918.22766.74108.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
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
index cca53d8..cddee83 100644
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
 


