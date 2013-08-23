Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab3HWLEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:04:47 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:44555 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3HWLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:04:23 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Patch v2 2/3] kprobes: allow to specify custum allocator for insn caches
Date: Fri, 23 Aug 2013 13:04:13 +0200
Message-Id: <1377255854-30163-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082310-6892-0000-0000-00000616684D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current two insn slot caches both use module_alloc/module_free
to allocate and free insn slot cache pages.
For s390 this is not sufficient since there is the need to allocate
insn slots that are either within the vmalloc module area or within
dma memory.
Therefore add a mechanism which allows to specify an own allocator
for an own insn slot cache.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/kprobes.h |    2 ++
 kernel/kprobes.c        |   20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 077f653..925eaf2 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -268,6 +268,8 @@ extern void kprobes_inc_nmissed_count(struct kprobe *p);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
+	void *(*alloc)(void);	/* allocate insn page */
+	void (*free)(void *);	/* free insn page */
 	struct list_head pages; /* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9e4912d..a0d367a 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -112,6 +112,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 struct kprobe_insn_page {
 	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
+	struct kprobe_insn_cache *cache;
 	int nused;
 	int ngarbage;
 	char slot_used[];
@@ -132,8 +133,20 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };
 
+static void *alloc_insn_page(void)
+{
+	return module_alloc(PAGE_SIZE);
+}
+
+static void free_insn_page(void *page)
+{
+	module_free(NULL, page);
+}
+
 struct kprobe_insn_cache kprobe_insn_slots = {
 	.mutex = __MUTEX_INITIALIZER(kprobe_insn_slots.mutex),
+	.alloc = alloc_insn_page,
+	.free = free_insn_page,
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
@@ -182,7 +195,7 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	 * kernel image and loaded module images reside. This is required
 	 * so x86_64 can correctly handle the %rip-relative fixups.
 	 */
-	kip->insns = module_alloc(PAGE_SIZE);
+	kip->insns = c->alloc();
 	if (!kip->insns) {
 		kfree(kip);
 		goto out;
@@ -192,6 +205,7 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	kip->cache = c;
 	list_add(&kip->list, &c->pages);
 	slot = kip->insns;
 out:
@@ -213,7 +227,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 */
 		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
-			module_free(NULL, kip->insns);
+			kip->cache->free(kip->insns);
 			kfree(kip);
 		}
 		return 1;
@@ -274,6 +288,8 @@ out:
 /* For optimized_kprobe buffer */
 struct kprobe_insn_cache kprobe_optinsn_slots = {
 	.mutex = __MUTEX_INITIALIZER(kprobe_optinsn_slots.mutex),
+	.alloc = alloc_insn_page,
+	.free = free_insn_page,
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
-- 
1.7.10.4

