Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbbAGHmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:42:54 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64650 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbbAGHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:42:05 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes.
Date: Wed, 7 Jan 2015 15:36:00 +0800
Message-ID: <1420616160-43110-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the main logic of early kprobe.

If register_kprobe() is called before kprobes_initialized, an early
kprobe is allocated. Try to utilize existing OPTPROBE mechanism to
replace the target instruction by a branch instead of breakpoint,
because interrupt handlers may not been initialized yet.

All resources required by early kprobes are allocated statically.
CONFIG_NR_EARLY_KPROBES_SLOTS is used to control number of possible
early kprobes.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 include/linux/kprobes.h |   4 ++
 kernel/kprobes.c        | 151 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 149 insertions(+), 6 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 27a27ed..a54947d 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -434,6 +434,10 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 
+struct early_kprobe_slot {
+	struct optimized_kprobe op;
+};
+
 #endif /* CONFIG_OPTPROBES */
 #ifdef CONFIG_KPROBES_ON_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1882bfa..9c3ea9b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -71,6 +71,10 @@ int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
+#ifdef CONFIG_EARLY_KPROBES
+static HLIST_HEAD(early_kprobe_hlist);
+#endif
+
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobes_all_disarmed;
 
@@ -320,7 +324,12 @@ struct kprobe *get_kprobe(void *addr)
 	struct hlist_head *head;
 	struct kprobe *p;
 
-	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
+#ifdef CONFIG_EARLY_KPROBES
+	if (unlikely(!kprobes_initialized))
+		head = &early_kprobe_hlist;
+	else
+#endif
+		head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
 	hlist_for_each_entry_rcu(p, head, hlist) {
 		if (p->addr == addr)
 			return p;
@@ -377,14 +386,18 @@ void opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 NOKPROBE_SYMBOL(opt_pre_handler);
 
 /* Free optimized instructions and optimized_kprobe */
+static int ek_free_early_kprobe(struct early_kprobe_slot *slot);
 static void free_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
+	struct early_kprobe_slot *ep;
 
 	op = container_of(p, struct optimized_kprobe, kp);
 	arch_remove_optimized_kprobe(op);
 	arch_remove_kprobe(p);
-	kfree(op);
+	ep = container_of(op, struct early_kprobe_slot, op);
+	if (likely(!ek_free_early_kprobe(ep)))
+		kfree(op);
 }
 
 /* Return true(!0) if the kprobe is ready for optimization. */
@@ -601,9 +614,15 @@ static void optimize_kprobe(struct kprobe *p)
 	struct optimized_kprobe *op;
 
 	/* Check if the kprobe is disabled or not ready for optimization. */
-	if (!kprobe_optready(p) || !kprobes_allow_optimization ||
-	    (kprobe_disabled(p) || kprobes_all_disarmed))
-		return;
+	if (unlikely(!kprobes_initialized)) {
+		BUG_ON(!(p->flags & KPROBE_FLAG_EARLY));
+		if (!kprobe_optready(p) || kprobe_disabled(p))
+			return;
+	} else {
+		if (!kprobe_optready(p) || !kprobes_allow_optimization ||
+		    (kprobe_disabled(p) || kprobes_all_disarmed))
+			return;
+	}
 
 	/* Both of break_handler and post_handler are not supported. */
 	if (p->break_handler || p->post_handler)
@@ -625,7 +644,10 @@ static void optimize_kprobe(struct kprobe *p)
 		list_del_init(&op->list);
 	else {
 		list_add(&op->list, &optimizing_list);
-		kick_kprobe_optimizer();
+		if (unlikely(!kprobes_initialized))
+			arch_optimize_kprobes(&optimizing_list);
+		else
+			kick_kprobe_optimizer();
 	}
 }
 
@@ -1491,6 +1513,8 @@ out:
 	return ret;
 }
 
+static int register_early_kprobe(struct kprobe *p);
+
 int register_kprobe(struct kprobe *p)
 {
 	int ret;
@@ -1504,6 +1528,14 @@ int register_kprobe(struct kprobe *p)
 		return PTR_ERR(addr);
 	p->addr = addr;
 
+	if (unlikely(!kprobes_initialized)) {
+		p->flags |= KPROBE_FLAG_EARLY;
+		return register_early_kprobe(p);
+	}
+
+	WARN(p->flags & KPROBE_FLAG_EARLY,
+		"register early kprobe after kprobes initialized\n");
+
 	ret = check_kprobe_rereg(p);
 	if (ret)
 		return ret;
@@ -2136,6 +2168,8 @@ static struct notifier_block kprobe_module_nb = {
 extern unsigned long __start_kprobe_blacklist[];
 extern unsigned long __stop_kprobe_blacklist[];
 
+static void convert_early_kprobes(void);
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
@@ -2184,6 +2218,7 @@ static int __init init_kprobes(void)
 	if (!err)
 		err = register_module_notifier(&kprobe_module_nb);
 
+	convert_early_kprobes();
 	kprobes_initialized = (err == 0);
 
 	if (!err)
@@ -2477,3 +2512,107 @@ module_init(init_kprobes);
 
 /* defined in arch/.../kernel/kprobes.c */
 EXPORT_SYMBOL_GPL(jprobe_return);
+
+#ifdef CONFIG_EARLY_KPROBES
+DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, static);
+
+static int register_early_kprobe(struct kprobe *p)
+{
+	struct early_kprobe_slot *slot;
+	int err;
+
+	if (p->break_handler || p->post_handler)
+		return -EINVAL;
+	if (p->flags & KPROBE_FLAG_DISABLED)
+		return -EINVAL;
+
+	slot = ek_alloc_early_kprobe();
+	if (!slot) {
+		pr_err("No enough early kprobe slots.\n");
+		return -ENOMEM;
+	}
+
+	p->flags &= KPROBE_FLAG_DISABLED;
+	p->flags |= KPROBE_FLAG_EARLY;
+	p->nmissed = 0;
+
+	err = arch_prepare_kprobe(p);
+	if (err) {
+		pr_err("arch_prepare_kprobe failed\n");
+		goto free_slot;
+	}
+
+	INIT_LIST_HEAD(&p->list);
+	INIT_HLIST_NODE(&p->hlist);
+	INIT_LIST_HEAD(&slot->op.list);
+	slot->op.kp.addr = p->addr;
+	slot->op.kp.flags = p->flags | KPROBE_FLAG_EARLY;
+
+	err = arch_prepare_optimized_kprobe(&slot->op, p);
+	if (err) {
+		pr_err("Failed to prepare optimized kprobe.\n");
+		goto remove_optimized;
+	}
+
+	if (!arch_prepared_optinsn(&slot->op.optinsn)) {
+		pr_err("Failed to prepare optinsn.\n");
+		err = -ENOMEM;
+		goto remove_optimized;
+	}
+
+	hlist_add_head_rcu(&p->hlist, &early_kprobe_hlist);
+	init_aggr_kprobe(&slot->op.kp, p);
+	optimize_kprobe(&slot->op.kp);
+	return 0;
+
+remove_optimized:
+	arch_remove_optimized_kprobe(&slot->op);
+free_slot:
+	ek_free_early_kprobe(slot);
+	return err;
+}
+
+static void
+convert_early_kprobe(struct kprobe *kp)
+{
+	struct module *probed_mod;
+	int err;
+
+	BUG_ON(!kprobe_aggrprobe(kp));
+
+	err = check_kprobe_address_safe(kp, &probed_mod);
+	if (err)
+		panic("Insert kprobe at %p is not safe!", kp->addr);
+
+	/*
+	 * FIXME:
+	 * convert kprobe to ftrace if CONFIG_KPROBES_ON_FTRACE is on
+	 * and kp is on ftrace location.
+	 */
+
+	mutex_lock(&kprobe_mutex);
+	hlist_del_rcu(&kp->hlist);
+
+	INIT_HLIST_NODE(&kp->hlist);
+	hlist_add_head_rcu(&kp->hlist,
+		       &kprobe_table[hash_ptr(kp->addr, KPROBE_HASH_BITS)]);
+	mutex_unlock(&kprobe_mutex);
+
+	if (probed_mod)
+		module_put(probed_mod);
+}
+
+static void
+convert_early_kprobes(void)
+{
+	struct kprobe *p;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(p, tmp, &early_kprobe_hlist, hlist)
+		convert_early_kprobe(p);
+};
+#else
+static int register_early_kprobe(struct kprobe *p) { return -ENOSYS; }
+static int ek_free_early_kprobe(struct early_kprobe_slot *slot) { return 0; }
+static void convert_early_kprobes(void) {};
+#endif
-- 
1.8.4

