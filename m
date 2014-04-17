Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaDQITp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:19:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41298 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaDQITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:19:39 -0400
Subject: [PATCH -tip v9 25/26] kprobes: Introduce kprobe cache to reduce
 cache misshits
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:19:31 +0900
Message-ID: <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kprobe cache to reduce cache misshits for
massive multiple kprobes.
For stress testing kprobes, we need to activate kprobes
as many as possible. This situation causes cache miss
hit storm on kprobe hash-list. kprobe hashlist is already
enlarged to 4k entries and this is still small for 40k
kprobes.

For example, when registering 40k probes on the hlist and
enabling 20k probes, perf tools shows still a lot of
cache-misses are on the get_kprobe.
  ----
  Samples: 633  of event 'cache-misses', Event count (approx.): 3414776
  +  68.13%  [k] get_kprobe
  +   4.38%  [k] ftrace_lookup_ip
  +   2.54%  [k] kprobe_ftrace_handler
  ----

Also, I found that the most of the kprobes are not hit.
In that case, to reduce cache-misses, we can reduce the
random memory access by introducing a per-cpu cache which
caches the address of frequently used kprobe data structure
and its probe address.

With kpcache enabled, the get_kprobe_cached goes down to
around 4-5% of cache-misses with 20k probes.
  ----
  Samples: 729  of event 'cache-misses', Event count (approx.): 690125
  +  14.49%  [k] ftrace_lookup_ip
  +   5.61%  [k] kprobe_trace_func
  +   5.17%  [k] kprobe_ftrace_handler
  +   4.62%  [k] get_kprobe_cached
  ----

Of course this reduces the enabling time too.

Without this fix (just enlarge hash table):
(2934 sec, 1 min intervals for each 2000 probes enabled)

  ----
  Enabling trace events: start at 1393921862
  0 1393921864 a2mp_chan_alloc_skb_cb_38581
  ...
  19999 1393924928 nfs4_open_confirm_done_11785
  ----

With this fix:
(2025 sec, 1 min intervals for each 2000 probes enabled)
  ----
  Enabling trace events: start at 1393912623
  0 1393912625 a2mp_chan_alloc_skb_cb_38800
  ....
  19999 1393914648 nfs2_xdr_dec_readlinkres_11628
  ----

This patch implements a simple per-cpu 4way/512entry cache
for kprobes hlist. All get_kprobe on hot-path uses the cache
and if the cache miss-hit, it searches kprobes on the hlist
and inserts the found kprobes to the cache entry.
When removing kprobes, it clears cache entries by using IPI,
because it is per-cpu cache.

Note that this consumes some memory (34KB/cpu) only for
kprobes, and this is only good for the users who use
thousands of probes at a time, e.g. kprobe stress testing.
Thus I've added CONFIG_KPROBE_CACHE option for this feature.
If you aren't interested in the stress testing, you should
set CONFIG_KPROBE_CACHE=n.

Changes from v7:
 - Re-evaluate the performance improvements with 512 entry size.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/Kconfig                     |   10 +++
 arch/x86/kernel/kprobes/core.c   |    2 -
 arch/x86/kernel/kprobes/ftrace.c |    2 -
 include/linux/kprobes.h          |    1 
 kernel/kprobes.c                 |  125 +++++++++++++++++++++++++++++++++++---
 5 files changed, 128 insertions(+), 12 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 97ff872..080ddb3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -46,6 +46,16 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KPROBE_CACHE
+	bool "Kprobe per-cpu cache for massive multiple probes"
+	depends on KPROBES
+	help
+	  For handling massive multiple kprobes with better performance,
+	  kprobe per-cpu cache is enabled by this option. This cache is
+	  only for users who would like to use more than 10,000 probes
+	  at a time, which is usually stress testing, debugging etc.
+	  If in doubt, say "N".
+
 config JUMP_LABEL
        bool "Optimize very unlikely/likely branches"
        depends on HAVE_ARCH_JUMP_LABEL
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 3a922b7..569ee2b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -576,7 +576,7 @@ int kprobe_int3_handler(struct pt_regs *regs)
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 
 	kcb = get_kprobe_ctlblk();
-	p = get_kprobe(addr);
+	p = get_kprobe_cached(addr);
 
 	if (p) {
 		if (kprobe_running()) {
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 717b02a..8178dd4 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -63,7 +63,7 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	/* Disable irq for emulating a breakpoint and avoiding preempt */
 	local_irq_save(flags);
 
-	p = get_kprobe((kprobe_opcode_t *)ip);
+	p = get_kprobe_cached((kprobe_opcode_t *)ip);
 	if (unlikely(!p) || kprobe_disabled(p))
 		goto end;
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e81bced..70c3314 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -339,6 +339,7 @@ extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
+struct kprobe *get_kprobe_cached(void *addr);
 void kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags);
 void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a29e622..465e912 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -91,6 +91,84 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 static LIST_HEAD(kprobe_blacklist);
 static DEFINE_MUTEX(kprobe_blacklist_mutex);
 
+#ifdef CONFIG_KPROBE_CACHE
+/* Kprobe cache */
+#define KPCACHE_BITS	2
+#define KPCACHE_SIZE	(1 << KPCACHE_BITS)
+#define KPCACHE_INDEX(i)	((i) & (KPCACHE_SIZE - 1))
+
+struct kprobe_cache_entry {
+	unsigned long addr;
+	struct kprobe *kp;
+};
+
+struct kprobe_cache {
+	struct kprobe_cache_entry table[KPROBE_TABLE_SIZE][KPCACHE_SIZE];
+	int index[KPROBE_TABLE_SIZE];
+};
+
+static DEFINE_PER_CPU(struct kprobe_cache, kpcache);
+
+static inline
+struct kprobe *kpcache_get(unsigned long hash, unsigned long addr)
+{
+	struct kprobe_cache *cache = this_cpu_ptr(&kpcache);
+	struct kprobe_cache_entry *ent = &cache->table[hash][0];
+	struct kprobe *ret;
+	int idx = ACCESS_ONCE(cache->index[hash]);
+	int i;
+
+	for (i = 0; i < KPCACHE_SIZE; i++)
+		if (ent[i].addr == addr) {
+			ret = ent[i].kp;
+			/* Check the cache is updated */
+			if (unlikely(idx != cache->index[hash]))
+				break;
+			return ret;
+		}
+	return NULL;
+}
+
+static inline void kpcache_set(unsigned long hash, unsigned long addr,
+				struct kprobe *kp)
+{
+	struct kprobe_cache *cache = this_cpu_ptr(&kpcache);
+	struct kprobe_cache_entry *ent = &cache->table[hash][0];
+	int i = KPCACHE_INDEX(cache->index[hash]++);
+
+	/*
+	 * Setting must be done in this order for avoiding interruption;
+	 * (1)invalidate entry, (2)set the value, and (3)enable entry.
+	 */
+	ent[i].addr = 0;
+	barrier();
+	ent[i].kp = kp;
+	barrier();
+	ent[i].addr = addr;
+}
+
+static void kpcache_invalidate_this_cpu(void *addr)
+{
+	unsigned long hash = hash_ptr(addr, KPROBE_HASH_BITS);
+	struct kprobe_cache *cache = this_cpu_ptr(&kpcache);
+	struct kprobe_cache_entry *ent = &cache->table[hash][0];
+	int i;
+
+	for (i = 0; i < KPCACHE_SIZE; i++)
+		if (ent[i].addr == (unsigned long)addr)
+			ent[i].addr = 0;
+}
+
+/* This must be called after ensuring the kprobe is removed from hlist */
+static void kpcache_invalidate(unsigned long addr)
+{
+	on_each_cpu(kpcache_invalidate_this_cpu, (void *)addr, 1);
+}
+#else
+#define kpcache_get(hash, addr)		(NULL)
+#define kpcache_set(hash, addr, kp)	do {} while (0)
+#define kpcache_invalidate(addr)	do {} while (0)
+#endif
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -297,18 +375,13 @@ static inline void reset_kprobe_instance(void)
 	__this_cpu_write(kprobe_instance, NULL);
 }
 
-/*
- * This routine is called either:
- * 	- under the kprobe_mutex - during kprobe_[un]register()
- * 				OR
- * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
- */
-struct kprobe *get_kprobe(void *addr)
+static nokprobe_inline
+struct kprobe *__get_kprobe(void *addr, unsigned long hash)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
 
-	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
+	head = &kprobe_table[hash];
 	hlist_for_each_entry_rcu(p, head, hlist) {
 		if (p->addr == addr)
 			return p;
@@ -316,8 +389,37 @@ struct kprobe *get_kprobe(void *addr)
 
 	return NULL;
 }
+
+/*
+ * This routine is called either:
+ *  - under the kprobe_mutex - during kprobe_[un]register()
+ * OR
+ *  - with preemption disabled - from arch/xxx/kernel/kprobes.c
+ */
+struct kprobe *get_kprobe(void *addr)
+{
+	return __get_kprobe(addr, hash_ptr(addr, KPROBE_HASH_BITS));
+}
 NOKPROBE_SYMBOL(get_kprobe);
 
+/* This is called with preemption disabed from arch-depend functions */
+struct kprobe *get_kprobe_cached(void *addr)
+{
+	unsigned long hash = hash_ptr(addr, KPROBE_HASH_BITS);
+	struct kprobe *p;
+
+	p = kpcache_get(hash, (unsigned long)addr);
+	if (likely(p))
+		return p;
+
+	p = __get_kprobe(addr, hash);
+	if (likely(p))
+		kpcache_set(hash, (unsigned long)addr, p);
+	return p;
+}
+NOKPROBE_SYMBOL(get_kprobe_cached);
+
+
 static int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
 
 /* Return true if the kprobe is an aggregator */
@@ -518,6 +620,7 @@ static void do_free_cleaned_kprobes(void)
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		BUG_ON(!kprobe_unused(&op->kp));
 		list_del_init(&op->list);
+		kpcache_invalidate((unsigned long)op->kp.addr);
 		free_aggr_kprobe(&op->kp);
 	}
 }
@@ -1639,13 +1742,15 @@ static void __unregister_kprobe_bottom(struct kprobe *p)
 {
 	struct kprobe *ap;
 
-	if (list_empty(&p->list))
+	if (list_empty(&p->list)) {
 		/* This is an independent kprobe */
+		kpcache_invalidate((unsigned long)p->addr);
 		arch_remove_kprobe(p);
-	else if (list_is_singular(&p->list)) {
+	} else if (list_is_singular(&p->list)) {
 		/* This is the last child of an aggrprobe */
 		ap = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
+		kpcache_invalidate((unsigned long)p->addr);
 		free_aggr_kprobe(ap);
 	}
 	/* Otherwise, do nothing. */


