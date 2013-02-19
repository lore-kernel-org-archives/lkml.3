Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3BSPVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:21:07 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53762 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3BSPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:21:05 -0500
Date: Tue, 19 Feb 2013 16:21:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 cleanups for v3.9
Message-ID: <20130219152100.GA14819@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: 19348e749e9515c429f5d561d2f2c724862a4bee x86: ptrace.c only needs export.h and not the full module.h

Misc smaller cleanups.

 Thanks,

	Ingo

------------------>
Paul Gortmaker (1):
      x86: ptrace.c only needs export.h and not the full module.h

Sasha Levin (3):
      arch/x86/platform/uv: use ARRAY_SIZE where possible
      um: don't compare a pointer to 0
      x86, apb_timer: remove unused variable percpu_timer


 arch/x86/kernel/apb_timer.c   | 8 ++------
 arch/x86/kernel/ptrace.c      | 2 +-
 arch/x86/platform/uv/tlb_uv.c | 4 ++--
 arch/x86/um/fault.c           | 2 +-
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index afdc3f75..cc74fd0 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -311,7 +311,6 @@ void __init apbt_time_init(void)
 #ifdef CONFIG_SMP
 	int i;
 	struct sfi_timer_table_entry *p_mtmr;
-	unsigned int percpu_timer;
 	struct apbt_dev *adev;
 #endif
 
@@ -346,13 +345,10 @@ void __init apbt_time_init(void)
 		return;
 	}
 	pr_debug("%s: %d CPUs online\n", __func__, num_online_cpus());
-	if (num_possible_cpus() <= sfi_mtimer_num) {
-		percpu_timer = 1;
+	if (num_possible_cpus() <= sfi_mtimer_num)
 		apbt_num_timers_used = num_possible_cpus();
-	} else {
-		percpu_timer = 0;
+	else
 		apbt_num_timers_used = 1;
-	}
 	pr_debug("%s: %d APB timers used\n", __func__, apbt_num_timers_used);
 
 	/* here we set up per CPU timer data structure */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b629bbe..29a8120 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,7 +22,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/context_tracking.h>
 
 #include <asm/uaccess.h>
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index b8b3a37..933bea5 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1463,7 +1463,7 @@ static ssize_t ptc_proc_write(struct file *file, const char __user *user,
 	}
 
 	if (input_arg == 0) {
-		elements = sizeof(stat_description)/sizeof(*stat_description);
+		elements = ARRAY_SIZE(stat_description);
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
 		for (i = 0; i < elements; i++)
@@ -1504,7 +1504,7 @@ static int parse_tunables_write(struct bau_control *bcp, char *instr,
 	char *q;
 	int cnt = 0;
 	int val;
-	int e = sizeof(tunables) / sizeof(*tunables);
+	int e = ARRAY_SIZE(tunables);
 
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
diff --git a/arch/x86/um/fault.c b/arch/x86/um/fault.c
index 8784ab3..84ac7f7 100644
--- a/arch/x86/um/fault.c
+++ b/arch/x86/um/fault.c
@@ -20,7 +20,7 @@ int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if (fixup != 0) {
+	if (fixup) {
 		UPT_IP(regs) = fixup->fixup;
 		return 1;
 	}
