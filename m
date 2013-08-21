Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3HUMCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:02:00 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:51357 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3HUMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:01:23 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/3] kprobes: provide new dmainsn cache
Date: Wed, 21 Aug 2013 14:01:04 +0200
Message-Id: <1377086465-6471-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082111-0542-0000-0000-00000633F589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kpropes insn caches allocate memory areas for insn slots with
module_alloc(). The assumption is that the kernel image and module area
are both within the same +/- 2GB memory area.
This however is not true for s390 where the kernel image resides within
the first 2GB (DMA memory area), but the module area is far away in the
vmalloc area, usually somewhere close below the 4TB area.

For new pc relative instructions s390 needs insn slots that are within
+/- 2GB of each area. That way we can patch displacements of pc-relative
instructions within the insn slots just like x86 and powerpc.

The module area works already with the normal insn slot allocator, however
there is currently no way to get insn slots that are within the first 2GB
on s390 (aka DMA area).

Therefore this patch introduces the dmainsn slot cache. Slots can be
allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig            |    7 +++++++
 include/linux/kprobes.h |    5 +++++
 kernel/kprobes.c        |   28 ++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..7010d68 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -76,6 +76,13 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
+config DMAPROBES
+	bool
+	help
+	  Architectures may want to put kprobes instruction slots into
+	  the dma memory region. E.g. s390 has the kernel image in the
+	  dma memory region but the module area far away.
+
 config KPROBES_ON_FTRACE
 	def_bool y
 	depends on KPROBES && HAVE_KPROBES_ON_FTRACE
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index ffd9171..a5290f6 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -320,6 +320,11 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 #endif
 
 #endif /* CONFIG_OPTPROBES */
+
+#ifdef CONFIG_DMAPROBES
+DEFINE_INSN_CACHE_OPS(dmainsn);
+#endif
+
 #ifdef CONFIG_KPROBES_ON_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				  struct ftrace_ops *ops, struct pt_regs *regs);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 30659b3..3b8b073 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -114,6 +114,7 @@ struct kprobe_insn_page {
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
 	int nused;
 	int ngarbage;
+	bool dma_alloc;
 	char slot_used[];
 };
 
@@ -126,6 +127,7 @@ struct kprobe_insn_cache {
 	struct list_head pages;	/* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
+	bool dma_alloc;
 };
 
 static int slots_per_page(struct kprobe_insn_cache *c)
@@ -144,6 +146,7 @@ struct kprobe_insn_cache kprobe_insn_slots = {
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
+	.dma_alloc = false,
 };
 static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
 
@@ -189,7 +192,10 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	 * kernel image and loaded module images reside. This is required
 	 * so x86_64 can correctly handle the %rip-relative fixups.
 	 */
-	kip->insns = module_alloc(PAGE_SIZE);
+	if (c->dma_alloc)
+		kip->insns = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	else
+		kip->insns = module_alloc(PAGE_SIZE);
 	if (!kip->insns) {
 		kfree(kip);
 		goto out;
@@ -199,6 +205,7 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	kip->dma_alloc = c->dma_alloc;
 	list_add(&kip->list, &c->pages);
 	slot = kip->insns;
 out:
@@ -220,7 +227,10 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 */
 		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
-			module_free(NULL, kip->insns);
+			if (kip->dma_alloc)
+				free_page((unsigned long)kip->insns);
+			else
+				module_free(NULL, kip->insns);
 			kfree(kip);
 		}
 		return 1;
@@ -284,6 +294,20 @@ struct kprobe_insn_cache kprobe_optinsn_slots = {
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
+	.dma_alloc = false,
+};
+#endif
+#ifdef CONFIG_DMAPROBES
+/*
+ * Special buffer for architectures which require insn slots
+ * to be in the GFP_DMA memory range.
+ */
+struct kprobe_insn_cache kprobe_dmainsn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
+	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+	.nr_garbage = 0,
+	.dma_alloc = true,
 };
 #endif
 #endif
-- 
1.7.10.4

