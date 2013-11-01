Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3KALZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:25:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42280 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3KALZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:25:38 -0400
Subject: [PATCH -tip v2 2/3] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Date: Fri, 01 Nov 2013 11:25:34 +0000
Message-ID: <20131101112534.14657.22729.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
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
 arch/x86/kernel/cpu/common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1789b06..928a4fd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1157,7 +1157,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
 DEFINE_PER_CPU(int, debug_stack_usage);
 
-int is_debug_stack(unsigned long addr)
+int nokprobe is_debug_stack(unsigned long addr)
 {
 	return __get_cpu_var(debug_stack_usage) ||
 		(addr <= __get_cpu_var(debug_stack_addr) &&
@@ -1166,13 +1166,13 @@ int is_debug_stack(unsigned long addr)
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);
 
-void debug_stack_set_zero(void)
+void nokprobe debug_stack_set_zero(void)
 {
 	this_cpu_inc(debug_idt_ctr);
 	load_current_idt();
 }
 
-void debug_stack_reset(void)
+void nokprobe debug_stack_reset(void)
 {
 	if (WARN_ON(!this_cpu_read(debug_idt_ctr)))
 		return;


