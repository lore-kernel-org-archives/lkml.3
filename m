Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3HWLEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:04:25 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:60032 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3HWLEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:04:21 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Patch v2 1/3] kprobes: unify insn caches
Date: Fri, 23 Aug 2013 13:04:12 +0200
Message-Id: <1377255854-30163-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082310-2966-0000-0000-00000889B920
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two insn caches (insn, and optinsn) each have an own mutex and
alloc/free functions (get_[opt]insn_slot() / free_[opt]insn_slot()).

Since there is the need for yet another insn cache which satifies
dma allocations on s390, unify and simplify the current implementation:

- Move the per insn cache mutex into struct kprobe_insn_cache.
- Move the alloc/free functions to kprobe.h so they are simply
  wrappers for the generic __get_insn_slot/__free_insn_slot functions.
  The implementation is done with a DEFINE_INSN_CACHE_OPS() macro
  which provides the alloc/free functions for each cache if needed.
- move the struct kprobe_insn_cache to kprobe.h which allows to generate
  architecture specific insn slot caches outside of the core kprobes
  code.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/kprobes.h |   32 +++++++++++++++++---
 kernel/kprobes.c        |   75 +++++++++++++----------------------------------
 2 files changed, 49 insertions(+), 58 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index ca1d27a..077f653 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -264,10 +264,34 @@ extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
-extern kprobe_opcode_t *get_insn_slot(void);
-extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 
+struct kprobe_insn_cache {
+	struct mutex mutex;
+	struct list_head pages; /* list of kprobe_insn_page */
+	size_t insn_size;	/* size of instruction slot */
+	int nr_garbage;
+};
+
+extern kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c);
+extern void __free_insn_slot(struct kprobe_insn_cache *c,
+			     kprobe_opcode_t *slot, int dirty);
+
+#define DEFINE_INSN_CACHE_OPS(__name)					\
+extern struct kprobe_insn_cache kprobe_##__name##_slots;		\
+									\
+static inline kprobe_opcode_t *get_##__name##_slot(void)		\
+{									\
+	return __get_insn_slot(&kprobe_##__name##_slots);		\
+}									\
+									\
+static inline void free_##__name##_slot(kprobe_opcode_t *slot, int dirty)\
+{									\
+	__free_insn_slot(&kprobe_##__name##_slots, slot, dirty);	\
+}									\
+
+DEFINE_INSN_CACHE_OPS(insn);
+
 #ifdef CONFIG_OPTPROBES
 /*
  * Internal structure for direct jump optimized probe
@@ -287,13 +311,13 @@ extern void arch_optimize_kprobes(struct list_head *oplist);
 extern void arch_unoptimize_kprobes(struct list_head *oplist,
 				    struct list_head *done_list);
 extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
-extern kprobe_opcode_t *get_optinsn_slot(void);
-extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
 extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
 					unsigned long addr);
 
 extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
 
+DEFINE_INSN_CACHE_OPS(optinsn);
+
 #ifdef CONFIG_SYSCTL
 extern int sysctl_kprobes_optimization;
 extern int proc_kprobes_optimization_handler(struct ctl_table *table,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 6e33498..9e4912d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -121,12 +121,6 @@ struct kprobe_insn_page {
 	(offsetof(struct kprobe_insn_page, slot_used) +	\
 	 (sizeof(char) * (slots)))
 
-struct kprobe_insn_cache {
-	struct list_head pages;	/* list of kprobe_insn_page */
-	size_t insn_size;	/* size of instruction slot */
-	int nr_garbage;
-};
-
 static int slots_per_page(struct kprobe_insn_cache *c)
 {
 	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
@@ -138,8 +132,8 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };
 
-static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_slots */
-static struct kprobe_insn_cache kprobe_insn_slots = {
+struct kprobe_insn_cache kprobe_insn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_insn_slots.mutex),
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
@@ -150,10 +144,12 @@ static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
+kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
+	kprobe_opcode_t *slot = NULL;
 
+	mutex_lock(&c->mutex);
  retry:
 	list_for_each_entry(kip, &c->pages, list) {
 		if (kip->nused < slots_per_page(c)) {
@@ -162,7 +158,8 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 				if (kip->slot_used[i] == SLOT_CLEAN) {
 					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
-					return kip->insns + (i * c->insn_size);
+					slot = kip->insns + (i * c->insn_size);
+					goto out;
 				}
 			}
 			/* kip->nused is broken. Fix it. */
@@ -178,7 +175,7 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	/* All out of space.  Need to allocate a new page. */
 	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(slots_per_page(c)), GFP_KERNEL);
 	if (!kip)
-		return NULL;
+		goto out;
 
 	/*
 	 * Use module_alloc so this page is within +/- 2GB of where the
@@ -188,7 +185,7 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	kip->insns = module_alloc(PAGE_SIZE);
 	if (!kip->insns) {
 		kfree(kip);
-		return NULL;
+		goto out;
 	}
 	INIT_LIST_HEAD(&kip->list);
 	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
@@ -196,19 +193,10 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	kip->nused = 1;
 	kip->ngarbage = 0;
 	list_add(&kip->list, &c->pages);
-	return kip->insns;
-}
-
-
-kprobe_opcode_t __kprobes *get_insn_slot(void)
-{
-	kprobe_opcode_t *ret = NULL;
-
-	mutex_lock(&kprobe_insn_mutex);
-	ret = __get_insn_slot(&kprobe_insn_slots);
-	mutex_unlock(&kprobe_insn_mutex);
-
-	return ret;
+	slot = kip->insns;
+out:
+	mutex_unlock(&c->mutex);
+	return slot;
 }
 
 /* Return 1 if all garbages are collected, otherwise 0. */
@@ -255,11 +243,12 @@ static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
 	return 0;
 }
 
-static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
-				       kprobe_opcode_t *slot, int dirty)
+void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
+				kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
+	mutex_lock(&c->mutex);
 	list_for_each_entry(kip, &c->pages, list) {
 		long idx = ((long)slot - (long)kip->insns) /
 				(c->insn_size * sizeof(kprobe_opcode_t));
@@ -272,45 +261,23 @@ static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
 					collect_garbage_slots(c);
 			} else
 				collect_one_slot(kip, idx);
-			return;
+			goto out;
 		}
 	}
 	/* Could not free this slot. */
 	WARN_ON(1);
+out:
+	mutex_unlock(&c->mutex);
 }
 
-void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
-{
-	mutex_lock(&kprobe_insn_mutex);
-	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
-	mutex_unlock(&kprobe_insn_mutex);
-}
 #ifdef CONFIG_OPTPROBES
 /* For optimized_kprobe buffer */
-static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
-static struct kprobe_insn_cache kprobe_optinsn_slots = {
+struct kprobe_insn_cache kprobe_optinsn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_optinsn_slots.mutex),
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
 };
-/* Get a slot for optimized_kprobe buffer */
-kprobe_opcode_t __kprobes *get_optinsn_slot(void)
-{
-	kprobe_opcode_t *ret = NULL;
-
-	mutex_lock(&kprobe_optinsn_mutex);
-	ret = __get_insn_slot(&kprobe_optinsn_slots);
-	mutex_unlock(&kprobe_optinsn_mutex);
-
-	return ret;
-}
-
-void __kprobes free_optinsn_slot(kprobe_opcode_t * slot, int dirty)
-{
-	mutex_lock(&kprobe_optinsn_mutex);
-	__free_insn_slot(&kprobe_optinsn_slots, slot, dirty);
-	mutex_unlock(&kprobe_optinsn_mutex);
-}
 #endif
 #endif
 
-- 
1.7.10.4

