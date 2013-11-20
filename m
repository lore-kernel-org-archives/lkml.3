Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3KTEW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:22:57 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59950 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3KTEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:16 -0500
Subject: [PATCH -tip v3 09/23] kprobes: Use NOKPROBE_SYMBOL macro instead of
 __kprobes
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:11 +0000
Message-ID: <20131120042211.15296.93512.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from
kprobes instead of __kprobes annotation.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |   67 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index fa68d83..0a206ec 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -302,7 +302,7 @@ static inline void reset_kprobe_instance(void)
  * 				OR
  * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
  */
-struct kprobe __kprobes *get_kprobe(void *addr)
+struct kprobe *get_kprobe(void *addr)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -315,8 +315,9 @@ struct kprobe __kprobes *get_kprobe(void *addr)
 
 	return NULL;
 }
+NOKPROBE_SYMBOL(get_kprobe);
 
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
+static int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
 
 /* Return true if the kprobe is an aggregator */
 static inline int kprobe_aggrprobe(struct kprobe *p)
@@ -348,7 +349,7 @@ static bool kprobes_allow_optimization;
  * Call all pre_handler on the list, but ignores its return value.
  * This must be called from arch-dep optimized caller.
  */
-void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
+void opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *kp;
 
@@ -360,6 +361,7 @@ void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 		reset_kprobe_instance();
 	}
 }
+NOKPROBE_SYMBOL(opt_pre_handler);
 
 /* Free optimized instructions and optimized_kprobe */
 static void free_aggr_kprobe(struct kprobe *p)
@@ -996,7 +998,7 @@ static void disarm_kprobe(struct kprobe *kp, bool reopt)
  * Aggregate handlers for multiple kprobes support - these handlers
  * take care of invoking the individual kprobe handlers on p->list
  */
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
+static int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *kp;
 
@@ -1010,9 +1012,10 @@ static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(aggr_pre_handler);
 
-static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
-					unsigned long flags)
+static void aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
+			      unsigned long flags)
 {
 	struct kprobe *kp;
 
@@ -1024,9 +1027,10 @@ static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
 		}
 	}
 }
+NOKPROBE_SYMBOL(aggr_post_handler);
 
-static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
-					int trapnr)
+static int aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
+			      int trapnr)
 {
 	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 
@@ -1040,8 +1044,9 @@ static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(aggr_fault_handler);
 
-static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
+static int aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 	int ret = 0;
@@ -1053,9 +1058,10 @@ static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 	reset_kprobe_instance();
 	return ret;
 }
+NOKPROBE_SYMBOL(aggr_break_handler);
 
 /* Walks the list and increments nmissed count for multiprobe case */
-void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
+void kprobes_inc_nmissed_count(struct kprobe *p)
 {
 	struct kprobe *kp;
 	if (!kprobe_aggrprobe(p)) {
@@ -1066,9 +1072,10 @@ void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 	}
 	return;
 }
+NOKPROBE_SYMBOL(kprobes_inc_nmissed_count);
 
-void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
-				struct hlist_head *head)
+void recycle_rp_inst(struct kretprobe_instance *ri,
+		     struct hlist_head *head)
 {
 	struct kretprobe *rp = ri->rp;
 
@@ -1083,8 +1090,9 @@ void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
 }
+NOKPROBE_SYMBOL(recycle_rp_inst);
 
-void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
+void kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 __acquires(hlist_lock)
 {
@@ -1095,17 +1103,19 @@ __acquires(hlist_lock)
 	hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_hash_lock);
 
-static void __kprobes kretprobe_table_lock(unsigned long hash,
-	unsigned long *flags)
+static void kretprobe_table_lock(unsigned long hash,
+				 unsigned long *flags)
 __acquires(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_table_lock);
 
-void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
-	unsigned long *flags)
+void kretprobe_hash_unlock(struct task_struct *tsk,
+			   unsigned long *flags)
 __releases(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
@@ -1114,14 +1124,16 @@ __releases(hlist_lock)
 	hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_hash_unlock);
 
-static void __kprobes kretprobe_table_unlock(unsigned long hash,
-       unsigned long *flags)
+static void kretprobe_table_unlock(unsigned long hash,
+				   unsigned long *flags)
 __releases(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_table_unlock);
 
 /*
  * This function is called from finish_task_switch when task tk becomes dead,
@@ -1129,7 +1141,7 @@ __releases(hlist_lock)
  * with this task. These left over instances represent probed functions
  * that have been called but will never return.
  */
-void __kprobes kprobe_flush_task(struct task_struct *tk)
+void kprobe_flush_task(struct task_struct *tk)
 {
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
@@ -1154,6 +1166,7 @@ void __kprobes kprobe_flush_task(struct task_struct *tk)
 		kfree(ri);
 	}
 }
+NOKPROBE_SYMBOL(kprobe_flush_task);
 
 static inline void free_rp_inst(struct kretprobe *rp)
 {
@@ -1166,7 +1179,7 @@ static inline void free_rp_inst(struct kretprobe *rp)
 	}
 }
 
-static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+static void cleanup_rp_inst(struct kretprobe *rp)
 {
 	unsigned long flags, hash;
 	struct kretprobe_instance *ri;
@@ -1185,6 +1198,7 @@ static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 	}
 	free_rp_inst(rp);
 }
+NOKPROBE_SYMBOL(cleanup_rp_inst);
 
 /*
 * Add the new probe to ap->list. Fail if this is the
@@ -1762,8 +1776,7 @@ EXPORT_SYMBOL_GPL(unregister_jprobes);
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
  */
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
 	unsigned long hash, flags = 0;
@@ -1801,6 +1814,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
 int register_kretprobe(struct kretprobe *rp)
 {
@@ -1924,11 +1938,11 @@ void unregister_kretprobes(struct kretprobe **rps, int num)
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	return 0;
 }
+NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
 #endif /* CONFIG_KRETPROBES */
 
@@ -2006,12 +2020,13 @@ out:
 }
 EXPORT_SYMBOL_GPL(enable_kprobe);
 
-void __kprobes dump_kprobe(struct kprobe *kp)
+void dump_kprobe(struct kprobe *kp)
 {
 	printk(KERN_WARNING "Dumping kprobe:\n");
 	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
 	       kp->symbol_name, kp->addr, kp->offset);
 }
+NOKPROBE_SYMBOL(dump_kprobe);
 
 static void populate_kprobe_blacklist(struct kprobe_blackpoint **start,
 				      struct kprobe_blackpoint **end);


