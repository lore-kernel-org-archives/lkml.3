Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3EVJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:37:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60528 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3EVJhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:37:01 -0400
X-AuditID: 85900ec0-d60ccb900000151e-da-519c91baf819
Subject: [PATCH 1/2] [BUGFIX] kprobes: Fix to free gone and unused optprobes
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Date: Wed, 22 May 2013 18:34:09 +0900
Message-ID: <20130522093409.9084.63554.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to free gone and unused optprobes. This bug will
cause a kernel panic if the user reuse the killed and
unused probe.

Reported: http://sourceware.org/ml/systemtap/2013-q2/msg00142.html

In the normal path, an optprobe on an init function is
unregistered when a module goes live.

unregister_kprobe(kp)
 -> __unregister_kprobe_top
   ->__disable_kprobe
     ->disarm_kprobe(ap == op)
       ->__disarm_kprobe
        ->unoptimize_kprobe : the op is queued
                              on unoptimizing_list
and do nothing in __unregister_kprobe_bottom

After a while (usually wait 5 jiffies), kprobe_optimizer
runs to unoptimize and free optprobe.

kprobe_optimizer
 ->do_unoptimize_kprobes
   ->arch_unoptimize_kprobes : moved to free_list
 ->do_free_cleaned_kprobes
   ->hlist_del: the op is removed
   ->free_aggr_kprobe
     ->arch_remove_optimized_kprobe
     ->arch_remove_kprobe
     ->kfree: the op is freed

Here, if kprobes_module_callback is called and the delayed
unoptimizing probe is picked BEFORE kprobe_optimizer runs,

kprobes_module_callback
 ->kill_kprobe
   ->kill_optimized_kprobe : dequeued from unoptimizing_list <=!!!
     ->arch_remove_optimized_kprobe
   ->arch_remove_kprobe
   (but op is not freed, and on the kprobe hash table)

This doesn't happen if the probe unregistration is done AFTER
kprobes_module_callback is called (because at that time the op
is gone), and kprobe-tracer does it.

To fix this bug, this patch changes kprobes_module_callback to
enqueue the op to freeing_list at kill_optimized_kprobe only
if the op is unused. The unused probes on freeing_list will
be freed in do_free_cleaned_kprobes.

Note that this calls arch_remove_*kprobe twice on the
same probe. Thus those functions have to check the double free.
Fortunately, most of arch codes already checked that except
for mips. This will be fixed in the next patch.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3fed7f0..e46a13b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -467,6 +467,7 @@ static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
 /* Optimization staging list, protected by kprobe_mutex */
 static LIST_HEAD(optimizing_list);
 static LIST_HEAD(unoptimizing_list);
+static LIST_HEAD(freeing_list);
 
 static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
@@ -504,7 +505,7 @@ static __kprobes void do_optimize_kprobes(void)
  * Unoptimize (replace a jump with a breakpoint and remove the breakpoint
  * if need) kprobes listed on unoptimizing_list.
  */
-static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
+static __kprobes void do_unoptimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -515,9 +516,9 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 	/* Ditto to do_optimize_kprobes */
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	arch_unoptimize_kprobes(&unoptimizing_list, free_list);
+	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 	/* Loop free_list for disarming */
-	list_for_each_entry_safe(op, tmp, free_list, list) {
+	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		/* Disarm probes if marked disabled */
 		if (kprobe_disabled(&op->kp))
 			arch_disarm_kprobe(&op->kp);
@@ -536,11 +537,11 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 }
 
 /* Reclaim all kprobes on the free_list */
-static __kprobes void do_free_cleaned_kprobes(struct list_head *free_list)
+static __kprobes void do_free_cleaned_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
-	list_for_each_entry_safe(op, tmp, free_list, list) {
+	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		BUG_ON(!kprobe_unused(&op->kp));
 		list_del_init(&op->list);
 		free_aggr_kprobe(&op->kp);
@@ -556,8 +557,6 @@ static __kprobes void kick_kprobe_optimizer(void)
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
-	LIST_HEAD(free_list);
-
 	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
@@ -566,7 +565,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
 	 * kprobes before waiting for quiesence period.
 	 */
-	do_unoptimize_kprobes(&free_list);
+	do_unoptimize_kprobes();
 
 	/*
 	 * Step 2: Wait for quiesence period to ensure all running interrupts
@@ -581,7 +580,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	do_optimize_kprobes();
 
 	/* Step 4: Free cleaned kprobes after quiesence period */
-	do_free_cleaned_kprobes(&free_list);
+	do_free_cleaned_kprobes();
 
 	mutex_unlock(&module_mutex);
 	mutex_unlock(&kprobe_mutex);
@@ -723,8 +722,19 @@ static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 	if (!list_empty(&op->list))
 		/* Dequeue from the (un)optimization queue */
 		list_del_init(&op->list);
-
 	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+
+	if (kprobe_unused(p)) {
+		/* Enqueue if it is unused */
+		list_add(&op->list, &freeing_list);
+		/*
+		 * Remove unused probes from hash list. After waiting
+		 * for synchronization, this probe is reclaimed.
+		 * (reclaiming is done by do_free_cleaned_kprobes.)
+		 */
+		hlist_del_rcu(&op->kp.hlist);
+	}
+
 	/* Don't touch the code, because it is already freed. */
 	arch_remove_optimized_kprobe(op);
 }

