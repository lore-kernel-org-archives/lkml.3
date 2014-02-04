Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaBDFQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 00:16:22 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63641 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 00:16:14 -0500
Message-ID: <52F077A1.3020701@gmail.com>
Date: Tue, 04 Feb 2014 13:16:17 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hskinnemoen@gmail.com,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        egtvedt@samfundet.no,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH] kernel: kprobe: move all *kretprobe* generic implementation
 to CONFIG_KRETPROBES enabled area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com>
In-Reply-To: <52F04FA8.8040008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_KRETPROBES disabled, all *kretprobe* generic implementation
are useless, so need move them to CONFIG_KPROBES enabled area.

Now, *kretprobe* generic implementation are all implemented in 2 files:

 - in "include/linux/kprobes.h":

     move inline kretprobe*() to CONFIG_KPROBES area and dummy outside.
     move some *kprobe() declarations which kretprobe*() call, to front.
     not touch kretprobe_blacklist[] which is architecture's variable.

 - in "kernel/kprobes.c":

     move all kretprobe* to CONFIG_KPROBES area and dummy outside.
     define kretprobe_flush_task() to let kprobe_flush_task() call.
     define init_kretprobes() to let init_kprobes() call.

The patch passes compiling (get "kernel/kprobes.o" and "kernel/built-
in.o") under avr32 and x86_64 allmodconfig, and passes building (get
bzImage and Modpost modules) under x86_64 defconfig.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 include/linux/kprobes.h |  58 +++++----
 kernel/kprobes.c        | 328 +++++++++++++++++++++++++++---------------------
 2 files changed, 222 insertions(+), 164 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf2..c0d1212 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -223,10 +223,36 @@ static inline int kprobes_built_in(void)
 	return 1;
 }
 
+int disable_kprobe(struct kprobe *kp);
+int enable_kprobe(struct kprobe *kp);
+
+void dump_kprobe(struct kprobe *kp);
+
+extern struct kretprobe_blackpoint kretprobe_blacklist[];
+
 #ifdef CONFIG_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
+static inline void kretprobe_assert(struct kretprobe_instance *ri,
+	unsigned long orig_ret_address, unsigned long trampoline_address)
+{
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk(KERN_ERR
+			"kretprobe BUG!: Processing kretprobe %p @ %p\n",
+			ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+}
+static inline int disable_kretprobe(struct kretprobe *rp)
+{
+	return disable_kprobe(&rp->kp);
+}
+static inline int enable_kretprobe(struct kretprobe *rp)
+{
+	return enable_kprobe(&rp->kp);
+}
+
 #else /* CONFIG_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
@@ -236,19 +262,20 @@ static inline int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
-#endif /* CONFIG_KRETPROBES */
-
-extern struct kretprobe_blackpoint kretprobe_blacklist[];
-
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	unsigned long orig_ret_address, unsigned long trampoline_address)
 {
-	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
-		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
-				ri->rp, ri->rp->kp.addr);
-		BUG();
-	}
 }
+static inline int disable_kretprobe(struct kretprobe *rp)
+{
+	return 0;
+}
+static inline int enable_kretprobe(struct kretprobe *rp)
+{
+	return 0;
+}
+
+#endif /* CONFIG_KRETPROBES */
 
 #ifdef CONFIG_KPROBES_SANITY_TEST
 extern int init_test_probes(void);
@@ -379,11 +406,6 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 
-int disable_kprobe(struct kprobe *kp);
-int enable_kprobe(struct kprobe *kp);
-
-void dump_kprobe(struct kprobe *kp);
-
 #else /* !CONFIG_KPROBES: */
 
 static inline int kprobes_built_in(void)
@@ -459,14 +481,6 @@ static inline int enable_kprobe(struct kprobe *kp)
 	return -ENOSYS;
 }
 #endif /* CONFIG_KPROBES */
-static inline int disable_kretprobe(struct kretprobe *rp)
-{
-	return disable_kprobe(&rp->kp);
-}
-static inline int enable_kretprobe(struct kretprobe *rp)
-{
-	return enable_kprobe(&rp->kp);
-}
 static inline int disable_jprobe(struct jprobe *jp)
 {
 	return disable_kprobe(&jp->kp);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..e305a81 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -69,7 +69,6 @@
 
 static int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
-static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobes_all_disarmed;
@@ -77,14 +76,6 @@ static bool kprobes_all_disarmed;
 /* This protects kprobe_table and optimizing_list */
 static DEFINE_MUTEX(kprobe_mutex);
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
-static struct {
-	raw_spinlock_t lock ____cacheline_aligned_in_smp;
-} kretprobe_table_locks[KPROBE_TABLE_SIZE];
-
-static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
-{
-	return &(kretprobe_table_locks[hash].lock);
-}
 
 /*
  * Normally, functions that we'd want to prohibit kprobes in, are marked
@@ -1079,125 +1070,6 @@ void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 	return;
 }
 
-void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
-				struct hlist_head *head)
-{
-	struct kretprobe *rp = ri->rp;
-
-	/* remove rp inst off the rprobe_inst_table */
-	hlist_del(&ri->hlist);
-	INIT_HLIST_NODE(&ri->hlist);
-	if (likely(rp)) {
-		raw_spin_lock(&rp->lock);
-		hlist_add_head(&ri->hlist, &rp->free_instances);
-		raw_spin_unlock(&rp->lock);
-	} else
-		/* Unregistering */
-		hlist_add_head(&ri->hlist, head);
-}
-
-void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
-			 struct hlist_head **head, unsigned long *flags)
-__acquires(hlist_lock)
-{
-	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	raw_spinlock_t *hlist_lock;
-
-	*head = &kretprobe_inst_table[hash];
-	hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_lock_irqsave(hlist_lock, *flags);
-}
-
-static void __kprobes kretprobe_table_lock(unsigned long hash,
-	unsigned long *flags)
-__acquires(hlist_lock)
-{
-	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_lock_irqsave(hlist_lock, *flags);
-}
-
-void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
-	unsigned long *flags)
-__releases(hlist_lock)
-{
-	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	raw_spinlock_t *hlist_lock;
-
-	hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_unlock_irqrestore(hlist_lock, *flags);
-}
-
-static void __kprobes kretprobe_table_unlock(unsigned long hash,
-       unsigned long *flags)
-__releases(hlist_lock)
-{
-	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_unlock_irqrestore(hlist_lock, *flags);
-}
-
-/*
- * This function is called from finish_task_switch when task tk becomes dead,
- * so that we can recycle any function-return probe instances associated
- * with this task. These left over instances represent probed functions
- * that have been called but will never return.
- */
-void __kprobes kprobe_flush_task(struct task_struct *tk)
-{
-	struct kretprobe_instance *ri;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *tmp;
-	unsigned long hash, flags = 0;
-
-	if (unlikely(!kprobes_initialized))
-		/* Early boot.  kretprobe_table_locks not yet initialized. */
-		return;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	hash = hash_ptr(tk, KPROBE_HASH_BITS);
-	head = &kretprobe_inst_table[hash];
-	kretprobe_table_lock(hash, &flags);
-	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
-		if (ri->task == tk)
-			recycle_rp_inst(ri, &empty_rp);
-	}
-	kretprobe_table_unlock(hash, &flags);
-	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-}
-
-static inline void free_rp_inst(struct kretprobe *rp)
-{
-	struct kretprobe_instance *ri;
-	struct hlist_node *next;
-
-	hlist_for_each_entry_safe(ri, next, &rp->free_instances, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-}
-
-static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
-{
-	unsigned long flags, hash;
-	struct kretprobe_instance *ri;
-	struct hlist_node *next;
-	struct hlist_head *head;
-
-	/* No race here */
-	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
-		kretprobe_table_lock(hash, &flags);
-		head = &kretprobe_inst_table[hash];
-		hlist_for_each_entry_safe(ri, next, head, hlist) {
-			if (ri->rp == rp)
-				ri->rp = NULL;
-		}
-		kretprobe_table_unlock(hash, &flags);
-	}
-	free_rp_inst(rp);
-}
-
 /*
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
@@ -1764,6 +1636,55 @@ void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 EXPORT_SYMBOL_GPL(unregister_jprobes);
 
 #ifdef CONFIG_KRETPROBES
+static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
+static struct {
+	raw_spinlock_t lock ____cacheline_aligned_in_smp;
+} kretprobe_table_locks[KPROBE_TABLE_SIZE];
+
+static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
+{
+	return &(kretprobe_table_locks[hash].lock);
+}
+
+void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags)
+__acquires(hlist_lock)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	raw_spinlock_t *hlist_lock;
+
+	*head = &kretprobe_inst_table[hash];
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
+}
+
+void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
+	unsigned long *flags)
+__releases(hlist_lock)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	raw_spinlock_t *hlist_lock;
+
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
+}
+
+static void __kprobes kretprobe_table_lock(unsigned long hash,
+	unsigned long *flags)
+__acquires(hlist_lock)
+{
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
+}
+
+static void __kprobes kretprobe_table_unlock(unsigned long hash,
+	unsigned long *flags)
+__releases(hlist_lock)
+{
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
+}
+
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -1808,6 +1729,17 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 	return 0;
 }
 
+static inline void free_rp_inst(struct kretprobe *rp)
+{
+	struct kretprobe_instance *ri;
+	struct hlist_node *next;
+
+	hlist_for_each_entry_safe(ri, next, &rp->free_instances, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+}
+
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
@@ -1885,6 +1817,26 @@ void __kprobes unregister_kretprobe(struct kretprobe *rp)
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
+static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+{
+	unsigned long flags, hash;
+	struct kretprobe_instance *ri;
+	struct hlist_node *next;
+	struct hlist_head *head;
+
+	/* No race here */
+	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
+		kretprobe_table_lock(hash, &flags);
+		head = &kretprobe_inst_table[hash];
+		hlist_for_each_entry_safe(ri, next, head, hlist) {
+			if (ri->rp == rp)
+				ri->rp = NULL;
+		}
+		kretprobe_table_unlock(hash, &flags);
+	}
+	free_rp_inst(rp);
+}
+
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
 	int i;
@@ -1907,6 +1859,73 @@ void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
+void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
+				struct hlist_head *head)
+{
+	struct kretprobe *rp = ri->rp;
+
+	/* remove rp inst off the rprobe_inst_table */
+	hlist_del(&ri->hlist);
+	INIT_HLIST_NODE(&ri->hlist);
+	if (likely(rp)) {
+		raw_spin_lock(&rp->lock);
+		hlist_add_head(&ri->hlist, &rp->free_instances);
+		raw_spin_unlock(&rp->lock);
+	} else
+		/* Unregistering */
+		hlist_add_head(&ri->hlist, head);
+}
+
+static void __kprobes kretprobe_flush_task(struct task_struct *tk)
+{
+	struct kretprobe_instance *ri;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *tmp;
+	unsigned long hash, flags = 0;
+
+	if (unlikely(!kprobes_initialized))
+		/* Early boot.  kretprobe_table_locks not yet initialized. */
+		return;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	hash = hash_ptr(tk, KPROBE_HASH_BITS);
+	head = &kretprobe_inst_table[hash];
+	kretprobe_table_lock(hash, &flags);
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task == tk)
+			recycle_rp_inst(ri, &empty_rp);
+	}
+	kretprobe_table_unlock(hash, &flags);
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+}
+
+static void __init init_kretprobes(void)
+{
+	int i;
+
+	/* FIXME allocate the probe table, currently defined statically */
+	/* initialize all list heads */
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
+		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
+	}
+
+	if (kretprobe_blacklist_size) {
+		/* lookup the function address from its name */
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			kprobe_lookup_name(kretprobe_blacklist[i].name,
+					   kretprobe_blacklist[i].addr);
+			if (!kretprobe_blacklist[i].addr)
+				printk(KERN_WARNING
+					"kretprobe: lookup failed: %s\n",
+					kretprobe_blacklist[i].name);
+		}
+	}
+}
+
 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
@@ -1936,8 +1955,44 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 	return 0;
 }
 
+void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
+				struct hlist_head *head)
+{
+}
+
+void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags)
+__acquires(hlist_lock)
+{
+}
+
+void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
+	unsigned long *flags)
+__releases(hlist_lock)
+{
+}
+
+static void __kprobes kretprobe_flush_task(struct task_struct *tk)
+{
+}
+
+static void __init init_kretprobes(void)
+{
+}
+
 #endif /* CONFIG_KRETPROBES */
 
+/*
+ * This function is called from finish_task_switch when task tk becomes dead,
+ * so that we can recycle any function-return probe instances associated
+ * with this task. These left over instances represent probed functions
+ * that have been called but will never return.
+ */
+void __kprobes kprobe_flush_task(struct task_struct *tk)
+{
+	kretprobe_flush_task(tk);
+}
+
 /* Set the kprobe gone and remove its instruction buffer. */
 static void __kprobes kill_kprobe(struct kprobe *p)
 {
@@ -2073,11 +2128,8 @@ static int __init init_kprobes(void)
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
-	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&kprobe_table[i]);
-		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
-		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
-	}
 
 	/*
 	 * Lookup and populate the kprobe_blacklist.
@@ -2101,16 +2153,8 @@ static int __init init_kprobes(void)
 			kb->range = size;
 	}
 
-	if (kretprobe_blacklist_size) {
-		/* lookup the function address from its name */
-		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-			kprobe_lookup_name(kretprobe_blacklist[i].name,
-					   kretprobe_blacklist[i].addr);
-			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
-				       kretprobe_blacklist[i].name);
-		}
-	}
+	/* Initialize kretprobes */
+	init_kretprobes();
 
 #if defined(CONFIG_OPTPROBES)
 #if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
-- 
1.7.11.7
