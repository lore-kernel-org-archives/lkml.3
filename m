Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3FZIwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:52:45 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36303 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3FZIwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:52:40 -0400
Date: Wed, 26 Jun 2013 10:52:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130626085235.GA26652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: c790b0ad23f427c7522ffed264706238c57c007e hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Three small fixlets.

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (1):
      kprobes: Fix arch_prepare_kprobe to handle copy insn failures

Oleg Nesterov (2):
      hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()


 arch/x86/kernel/kprobes/core.c | 14 ++++++++++----
 kernel/events/hw_breakpoint.c  |  6 +++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 9895a9a..211bce4 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -365,10 +365,14 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 	return insn.length;
 }
 
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
+static int __kprobes arch_copy_kprobe(struct kprobe *p)
 {
+	int ret;
+
 	/* Copy an instruction with recovering if other optprobe modifies it.*/
-	__copy_instruction(p->ainsn.insn, p->addr);
+	ret = __copy_instruction(p->ainsn.insn, p->addr);
+	if (!ret)
+		return -EINVAL;
 
 	/*
 	 * __copy_instruction can modify the displacement of the instruction,
@@ -384,6 +388,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 
 	/* Also, displacement change doesn't affect the first byte */
 	p->opcode = p->ainsn.insn[0];
+
+	return 0;
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
@@ -397,8 +403,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
 		return -ENOMEM;
-	arch_copy_kprobe(p);
-	return 0;
+
+	return arch_copy_kprobe(p);
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index a64f8ae..20185ea 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
 		if (iter->hw.bp_target == tsk &&
 		    find_slot_idx(iter) == type &&
-		    cpu == iter->cpu)
+		    (iter->cpu < 0 || cpu == iter->cpu))
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -149,7 +149,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -235,7 +235,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
