Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3FXTbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:33 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54002 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FXTb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 09/32] arm64: delete __cpuinit usage from all users
Date: Mon, 24 Jun 2013 15:30:14 -0400
Message-ID: <1372102237-8757-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/arm64 uses of the __cpuinit macros from
all C files.  Currently arm64 does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/arm64/include/asm/arch_timer.h | 2 +-
 arch/arm64/kernel/debug-monitors.c  | 6 +++---
 arch/arm64/kernel/hw_breakpoint.c   | 4 ++--
 arch/arm64/kernel/smp.c             | 8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index d56ed11..98abd47 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -97,7 +97,7 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline void __cpuinit arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(void)
 {
 	u32 cntkctl;
 
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 08018e3..cbfacf7 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -141,7 +141,7 @@ static void clear_os_lock(void *unused)
 	isb();
 }
 
-static int __cpuinit os_lock_notify(struct notifier_block *self,
+static int os_lock_notify(struct notifier_block *self,
 				    unsigned long action, void *data)
 {
 	int cpu = (unsigned long)data;
@@ -150,11 +150,11 @@ static int __cpuinit os_lock_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata os_lock_nb = {
+static struct notifier_block os_lock_nb = {
 	.notifier_call = os_lock_notify,
 };
 
-static int __cpuinit debug_monitors_init(void)
+static int debug_monitors_init(void)
 {
 	/* Clear the OS lock. */
 	smp_call_function(clear_os_lock, NULL, 1);
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 5ab825c..329218c 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -821,7 +821,7 @@ static void reset_ctrl_regs(void *unused)
 	}
 }
 
-static int __cpuinit hw_breakpoint_reset_notify(struct notifier_block *self,
+static int hw_breakpoint_reset_notify(struct notifier_block *self,
 						unsigned long action,
 						void *hcpu)
 {
@@ -831,7 +831,7 @@ static int __cpuinit hw_breakpoint_reset_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata hw_breakpoint_reset_nb = {
+static struct notifier_block hw_breakpoint_reset_nb = {
 	.notifier_call = hw_breakpoint_reset_notify,
 };
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 5d54e37..4a053b3 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -71,7 +71,7 @@ static DEFINE_RAW_SPINLOCK(boot_lock);
  * in coherency or not.  This is necessary for the hotplug code to work
  * reliably.
  */
-static void __cpuinit write_pen_release(u64 val)
+static void write_pen_release(u64 val)
 {
 	void *start = (void *)&secondary_holding_pen_release;
 	unsigned long size = sizeof(secondary_holding_pen_release);
@@ -84,7 +84,7 @@ static void __cpuinit write_pen_release(u64 val)
  * Boot a secondary CPU, and assign it the specified idle task.
  * This also gives us the initial stack to use for this CPU.
  */
-static int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
@@ -122,7 +122,7 @@ static int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 static DECLARE_COMPLETION(cpu_running);
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
 
@@ -162,7 +162,7 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void __cpuinit secondary_start_kernel(void)
+asmlinkage void secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu = smp_processor_id();
-- 
1.8.1.2

