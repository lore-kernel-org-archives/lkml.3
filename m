Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaDQISI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:18:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36921 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaDQISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:18:02 -0400
Subject: [PATCH -tip v9 11/26] kprobes: Allow probe on some kprobe functions
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 17 Apr 2014 17:17:54 +0900
Message-ID: <20140417081753.26341.57889.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to prohibit probing on the functions
used for preparation, registeration, optimization,
controll etc. Those are safely probed because those are
not invoked from breakpoint/fault/debug handlers,
there is no chance to cause recursive exceptions.

Following functions are now removed from the kprobes blacklist.
add_new_kprobe
aggr_kprobe_disabled
alloc_aggr_kprobe
alloc_aggr_kprobe
arm_all_kprobes
__arm_kprobe
arm_kprobe
arm_kprobe_ftrace
check_kprobe_address_safe
collect_garbage_slots
collect_garbage_slots
collect_one_slot
debugfs_kprobe_init
__disable_kprobe
disable_kprobe
disarm_all_kprobes
__disarm_kprobe
disarm_kprobe
disarm_kprobe_ftrace
do_free_cleaned_kprobes
do_optimize_kprobes
do_unoptimize_kprobes
enable_kprobe
force_unoptimize_kprobe
free_aggr_kprobe
free_aggr_kprobe
__free_insn_slot
__get_insn_slot
get_optimized_kprobe
__get_valid_kprobe
init_aggr_kprobe
init_aggr_kprobe
in_nokprobe_functions
kick_kprobe_optimizer
kill_kprobe
kill_optimized_kprobe
kprobe_addr
kprobe_optimizer
kprobe_queued
kprobe_seq_next
kprobe_seq_start
kprobe_seq_stop
kprobes_module_callback
kprobes_open
optimize_all_kprobes
optimize_kprobe
prepare_kprobe
prepare_optimized_kprobe
register_aggr_kprobe
register_jprobe
register_jprobes
register_kprobe
register_kprobes
register_kretprobe
register_kretprobe
register_kretprobes
register_kretprobes
report_probe
show_kprobe_addr
try_to_optimize_kprobe
unoptimize_all_kprobes
unoptimize_kprobe
unregister_jprobe
unregister_jprobes
unregister_kprobe
__unregister_kprobe_bottom
unregister_kprobes
__unregister_kprobe_top
unregister_kretprobe
unregister_kretprobe
unregister_kretprobes
unregister_kretprobes
wait_for_kprobe_optimizer

I tested those functions by putting kprobes on all
instructions in the functions with the bash script
I sent to LKML. See below,

https://lkml.org/lkml/2014/3/27/33

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |  153 +++++++++++++++++++++++++++---------------------------
 1 file changed, 76 insertions(+), 77 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5ffc687..4db2cc6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -138,13 +138,13 @@ struct kprobe_insn_cache kprobe_insn_slots = {
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
 };
-static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
+static int collect_garbage_slots(struct kprobe_insn_cache *c);
 
 /**
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
+kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
 	kprobe_opcode_t *slot = NULL;
@@ -201,7 +201,7 @@ out:
 }
 
 /* Return 1 if all garbages are collected, otherwise 0. */
-static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
+static int collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
 	kip->slot_used[idx] = SLOT_CLEAN;
 	kip->nused--;
@@ -222,7 +222,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 	return 0;
 }
 
-static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
+static int collect_garbage_slots(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip, *next;
 
@@ -244,8 +244,8 @@ static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
 	return 0;
 }
 
-void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
-				kprobe_opcode_t *slot, int dirty)
+void __free_insn_slot(struct kprobe_insn_cache *c,
+		      kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
@@ -361,7 +361,7 @@ void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 }
 
 /* Free optimized instructions and optimized_kprobe */
-static __kprobes void free_aggr_kprobe(struct kprobe *p)
+static void free_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -399,7 +399,7 @@ static inline int kprobe_disarmed(struct kprobe *p)
 }
 
 /* Return true(!0) if the probe is queued on (un)optimizing lists */
-static int __kprobes kprobe_queued(struct kprobe *p)
+static int kprobe_queued(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -415,7 +415,7 @@ static int __kprobes kprobe_queued(struct kprobe *p)
  * Return an optimized kprobe whose optimizing code replaces
  * instructions including addr (exclude breakpoint).
  */
-static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
+static struct kprobe *get_optimized_kprobe(unsigned long addr)
 {
 	int i;
 	struct kprobe *p = NULL;
@@ -447,7 +447,7 @@ static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
  * Optimize (replace a breakpoint with a jump) kprobes listed on
  * optimizing_list.
  */
-static __kprobes void do_optimize_kprobes(void)
+static void do_optimize_kprobes(void)
 {
 	/* Optimization never be done when disarmed */
 	if (kprobes_all_disarmed || !kprobes_allow_optimization ||
@@ -475,7 +475,7 @@ static __kprobes void do_optimize_kprobes(void)
  * Unoptimize (replace a jump with a breakpoint and remove the breakpoint
  * if need) kprobes listed on unoptimizing_list.
  */
-static __kprobes void do_unoptimize_kprobes(void)
+static void do_unoptimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -507,7 +507,7 @@ static __kprobes void do_unoptimize_kprobes(void)
 }
 
 /* Reclaim all kprobes on the free_list */
-static __kprobes void do_free_cleaned_kprobes(void)
+static void do_free_cleaned_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -519,13 +519,13 @@ static __kprobes void do_free_cleaned_kprobes(void)
 }
 
 /* Start optimizer after OPTIMIZE_DELAY passed */
-static __kprobes void kick_kprobe_optimizer(void)
+static void kick_kprobe_optimizer(void)
 {
 	schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
 }
 
 /* Kprobe jump optimizer */
-static __kprobes void kprobe_optimizer(struct work_struct *work)
+static void kprobe_optimizer(struct work_struct *work)
 {
 	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
@@ -561,7 +561,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 }
 
 /* Wait for completing optimization and unoptimization */
-static __kprobes void wait_for_kprobe_optimizer(void)
+static void wait_for_kprobe_optimizer(void)
 {
 	mutex_lock(&kprobe_mutex);
 
@@ -580,7 +580,7 @@ static __kprobes void wait_for_kprobe_optimizer(void)
 }
 
 /* Optimize kprobe if p is ready to be optimized */
-static __kprobes void optimize_kprobe(struct kprobe *p)
+static void optimize_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -614,7 +614,7 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 }
 
 /* Short cut to direct unoptimizing */
-static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
+static void force_unoptimize_kprobe(struct optimized_kprobe *op)
 {
 	get_online_cpus();
 	arch_unoptimize_kprobe(op);
@@ -624,7 +624,7 @@ static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
 }
 
 /* Unoptimize a kprobe if p is optimized */
-static __kprobes void unoptimize_kprobe(struct kprobe *p, bool force)
+static void unoptimize_kprobe(struct kprobe *p, bool force)
 {
 	struct optimized_kprobe *op;
 
@@ -684,7 +684,7 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 }
 
 /* Remove optimized instructions */
-static void __kprobes kill_optimized_kprobe(struct kprobe *p)
+static void kill_optimized_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -710,7 +710,7 @@ static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 }
 
 /* Try to prepare optimized instructions */
-static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
+static void prepare_optimized_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -719,7 +719,7 @@ static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
 }
 
 /* Allocate new optimized_kprobe and try to prepare optimized instructions */
-static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -734,13 +734,13 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 	return &op->kp;
 }
 
-static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
+static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
 
 /*
  * Prepare an optimized_kprobe and optimize it
  * NOTE: p must be a normal registered kprobe
  */
-static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
+static void try_to_optimize_kprobe(struct kprobe *p)
 {
 	struct kprobe *ap;
 	struct optimized_kprobe *op;
@@ -774,7 +774,7 @@ out:
 }
 
 #ifdef CONFIG_SYSCTL
-static void __kprobes optimize_all_kprobes(void)
+static void optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -797,7 +797,7 @@ out:
 	mutex_unlock(&kprobe_mutex);
 }
 
-static void __kprobes unoptimize_all_kprobes(void)
+static void unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -848,7 +848,7 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 #endif /* CONFIG_SYSCTL */
 
 /* Put a breakpoint for a probe. Must be called with text_mutex locked */
-static void __kprobes __arm_kprobe(struct kprobe *p)
+static void __arm_kprobe(struct kprobe *p)
 {
 	struct kprobe *_p;
 
@@ -863,7 +863,7 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 }
 
 /* Remove the breakpoint of a probe. Must be called with text_mutex locked */
-static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
+static void __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
@@ -898,13 +898,13 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 	BUG_ON(kprobe_unused(ap));
 }
 
-static __kprobes void free_aggr_kprobe(struct kprobe *p)
+static void free_aggr_kprobe(struct kprobe *p)
 {
 	arch_remove_kprobe(p);
 	kfree(p);
 }
 
-static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 {
 	return kzalloc(sizeof(struct kprobe), GFP_KERNEL);
 }
@@ -918,7 +918,7 @@ static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 static int kprobe_ftrace_enabled;
 
 /* Must ensure p->addr is really on ftrace */
-static int __kprobes prepare_kprobe(struct kprobe *p)
+static int prepare_kprobe(struct kprobe *p)
 {
 	if (!kprobe_ftrace(p))
 		return arch_prepare_kprobe(p);
@@ -927,7 +927,7 @@ static int __kprobes prepare_kprobe(struct kprobe *p)
 }
 
 /* Caller must lock kprobe_mutex */
-static void __kprobes arm_kprobe_ftrace(struct kprobe *p)
+static void arm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
@@ -942,7 +942,7 @@ static void __kprobes arm_kprobe_ftrace(struct kprobe *p)
 }
 
 /* Caller must lock kprobe_mutex */
-static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
+static void disarm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
@@ -962,7 +962,7 @@ static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
 #endif
 
 /* Arm a kprobe with text_mutex */
-static void __kprobes arm_kprobe(struct kprobe *kp)
+static void arm_kprobe(struct kprobe *kp)
 {
 	if (unlikely(kprobe_ftrace(kp))) {
 		arm_kprobe_ftrace(kp);
@@ -979,7 +979,7 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 }
 
 /* Disarm a kprobe with text_mutex */
-static void __kprobes disarm_kprobe(struct kprobe *kp, bool reopt)
+static void disarm_kprobe(struct kprobe *kp, bool reopt)
 {
 	if (unlikely(kprobe_ftrace(kp))) {
 		disarm_kprobe_ftrace(kp);
@@ -1189,7 +1189,7 @@ static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
-static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
+static int add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 
@@ -1213,7 +1213,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
  * Fill in the required fields of the "manager kprobe". Replace the
  * earlier kprobe in the hlist with the manager kprobe
  */
-static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
+static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	/* Copy p's insn slot to ap */
 	copy_kprobe(p, ap);
@@ -1239,8 +1239,7 @@ static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
  * This is the second or subsequent kprobe at the address - handle
  * the intricacies
  */
-static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
-					  struct kprobe *p)
+static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
 {
 	int ret = 0;
 	struct kprobe *ap = orig_p;
@@ -1318,7 +1317,7 @@ bool __weak arch_within_kprobe_blacklist(unsigned long addr)
 	       addr < (unsigned long)__kprobes_text_end;
 }
 
-static bool __kprobes within_kprobe_blacklist(unsigned long addr)
+static bool within_kprobe_blacklist(unsigned long addr)
 {
 	struct kprobe_blacklist_entry *ent;
 
@@ -1342,7 +1341,7 @@ static bool __kprobes within_kprobe_blacklist(unsigned long addr)
  * This returns encoded errors if it fails to look up symbol or invalid
  * combination of parameters.
  */
-static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
+static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
 
@@ -1365,7 +1364,7 @@ invalid:
 }
 
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
-static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
+static struct kprobe *__get_valid_kprobe(struct kprobe *p)
 {
 	struct kprobe *ap, *list_p;
 
@@ -1397,8 +1396,8 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-static __kprobes int check_kprobe_address_safe(struct kprobe *p,
-					       struct module **probed_mod)
+static int check_kprobe_address_safe(struct kprobe *p,
+				     struct module **probed_mod)
 {
 	int ret = 0;
 	unsigned long ftrace_addr;
@@ -1460,7 +1459,7 @@ out:
 	return ret;
 }
 
-int __kprobes register_kprobe(struct kprobe *p)
+int register_kprobe(struct kprobe *p)
 {
 	int ret;
 	struct kprobe *old_p;
@@ -1522,7 +1521,7 @@ out:
 EXPORT_SYMBOL_GPL(register_kprobe);
 
 /* Check if all probes on the aggrprobe are disabled */
-static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
+static int aggr_kprobe_disabled(struct kprobe *ap)
 {
 	struct kprobe *kp;
 
@@ -1538,7 +1537,7 @@ static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
 }
 
 /* Disable one kprobe: Make sure called under kprobe_mutex is locked */
-static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
+static struct kprobe *__disable_kprobe(struct kprobe *p)
 {
 	struct kprobe *orig_p;
 
@@ -1565,7 +1564,7 @@ static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
-static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+static int __unregister_kprobe_top(struct kprobe *p)
 {
 	struct kprobe *ap, *list_p;
 
@@ -1622,7 +1621,7 @@ disarmed:
 	return 0;
 }
 
-static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
+static void __unregister_kprobe_bottom(struct kprobe *p)
 {
 	struct kprobe *ap;
 
@@ -1638,7 +1637,7 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 	/* Otherwise, do nothing. */
 }
 
-int __kprobes register_kprobes(struct kprobe **kps, int num)
+int register_kprobes(struct kprobe **kps, int num)
 {
 	int i, ret = 0;
 
@@ -1656,13 +1655,13 @@ int __kprobes register_kprobes(struct kprobe **kps, int num)
 }
 EXPORT_SYMBOL_GPL(register_kprobes);
 
-void __kprobes unregister_kprobe(struct kprobe *p)
+void unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 
-void __kprobes unregister_kprobes(struct kprobe **kps, int num)
+void unregister_kprobes(struct kprobe **kps, int num)
 {
 	int i;
 
@@ -1691,7 +1690,7 @@ unsigned long __weak arch_deref_entry_point(void *entry)
 	return (unsigned long)entry;
 }
 
-int __kprobes register_jprobes(struct jprobe **jps, int num)
+int register_jprobes(struct jprobe **jps, int num)
 {
 	struct jprobe *jp;
 	int ret = 0, i;
@@ -1722,19 +1721,19 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 }
 EXPORT_SYMBOL_GPL(register_jprobes);
 
-int __kprobes register_jprobe(struct jprobe *jp)
+int register_jprobe(struct jprobe *jp)
 {
 	return register_jprobes(&jp, 1);
 }
 EXPORT_SYMBOL_GPL(register_jprobe);
 
-void __kprobes unregister_jprobe(struct jprobe *jp)
+void unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 
-void __kprobes unregister_jprobes(struct jprobe **jps, int num)
+void unregister_jprobes(struct jprobe **jps, int num)
 {
 	int i;
 
@@ -1799,7 +1798,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 	return 0;
 }
 
-int __kprobes register_kretprobe(struct kretprobe *rp)
+int register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
 	struct kretprobe_instance *inst;
@@ -1852,7 +1851,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 }
 EXPORT_SYMBOL_GPL(register_kretprobe);
 
-int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+int register_kretprobes(struct kretprobe **rps, int num)
 {
 	int ret = 0, i;
 
@@ -1870,13 +1869,13 @@ int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 }
 EXPORT_SYMBOL_GPL(register_kretprobes);
 
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
+void unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
-void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+void unregister_kretprobes(struct kretprobe **rps, int num)
 {
 	int i;
 
@@ -1899,24 +1898,24 @@ void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 #else /* CONFIG_KRETPROBES */
-int __kprobes register_kretprobe(struct kretprobe *rp)
+int register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(register_kretprobe);
 
-int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+int register_kretprobes(struct kretprobe **rps, int num)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(register_kretprobes);
 
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
+void unregister_kretprobe(struct kretprobe *rp)
 {
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
-void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+void unregister_kretprobes(struct kretprobe **rps, int num)
 {
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
@@ -1930,7 +1929,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 #endif /* CONFIG_KRETPROBES */
 
 /* Set the kprobe gone and remove its instruction buffer. */
-static void __kprobes kill_kprobe(struct kprobe *p)
+static void kill_kprobe(struct kprobe *p)
 {
 	struct kprobe *kp;
 
@@ -1954,7 +1953,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 }
 
 /* Disable one kprobe */
-int __kprobes disable_kprobe(struct kprobe *kp)
+int disable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
 
@@ -1970,7 +1969,7 @@ int __kprobes disable_kprobe(struct kprobe *kp)
 EXPORT_SYMBOL_GPL(disable_kprobe);
 
 /* Enable one kprobe */
-int __kprobes enable_kprobe(struct kprobe *kp)
+int enable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
 	struct kprobe *p;
@@ -2043,8 +2042,8 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
 }
 
 /* Module notifier call back, checking kprobes on the module */
-static int __kprobes kprobes_module_callback(struct notifier_block *nb,
-					     unsigned long val, void *data)
+static int kprobes_module_callback(struct notifier_block *nb,
+				   unsigned long val, void *data)
 {
 	struct module *mod = data;
 	struct hlist_head *head;
@@ -2145,7 +2144,7 @@ static int __init init_kprobes(void)
 }
 
 #ifdef CONFIG_DEBUG_FS
-static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+static void report_probe(struct seq_file *pi, struct kprobe *p,
 		const char *sym, int offset, char *modname, struct kprobe *pp)
 {
 	char *kprobe_type;
@@ -2174,12 +2173,12 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 		(kprobe_ftrace(pp) ? "[FTRACE]" : ""));
 }
 
-static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+static void *kprobe_seq_start(struct seq_file *f, loff_t *pos)
 {
 	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
 }
 
-static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+static void *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
 	if (*pos >= KPROBE_TABLE_SIZE)
@@ -2187,12 +2186,12 @@ static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 	return pos;
 }
 
-static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+static void kprobe_seq_stop(struct seq_file *f, void *v)
 {
 	/* Nothing to do */
 }
 
-static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+static int show_kprobe_addr(struct seq_file *pi, void *v)
 {
 	struct hlist_head *head;
 	struct kprobe *p, *kp;
@@ -2223,7 +2222,7 @@ static const struct seq_operations kprobes_seq_ops = {
 	.show  = show_kprobe_addr
 };
 
-static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+static int kprobes_open(struct inode *inode, struct file *filp)
 {
 	return seq_open(filp, &kprobes_seq_ops);
 }
@@ -2235,7 +2234,7 @@ static const struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
-static void __kprobes arm_all_kprobes(void)
+static void arm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -2263,7 +2262,7 @@ already_enabled:
 	return;
 }
 
-static void __kprobes disarm_all_kprobes(void)
+static void disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -2347,7 +2346,7 @@ static const struct file_operations fops_kp = {
 	.llseek =	default_llseek,
 };
 
-static int __kprobes debugfs_kprobe_init(void)
+static int __init debugfs_kprobe_init(void)
 {
 	struct dentry *dir, *file;
 	unsigned int value = 1;


