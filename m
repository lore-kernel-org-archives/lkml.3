Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbbAGHmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:42:11 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:56685 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbbAGHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:42:09 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 08/11] kprobes: allows __alloc_insn_slot() from early kprobes slots.
Date: Wed, 7 Jan 2015 15:35:56 +0800
Message-ID: <1420616156-43066-1-git-send-email-wangnan0@huawei.com>
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

Introduces early_slots_start/end and bitmap for struct kprobe_insn_cache
then uses previous introduced macro to generate allocator. This patch
makes get/free_insn_slot() and get/free_optinsn_slot() transparent to
early kprobes.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 include/linux/kprobes.h | 33 +++++++++++++++++++++++++++++++++
 kernel/kprobes.c        | 14 ++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 9a18188..27a27ed 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -316,6 +316,10 @@ static inline int ek_free_##__name(__t *__s)				\
 			(__ek_##__name##_bitmap));			\
 }
 
+extern kprobe_opcode_t __early_kprobes_code_area_start[];
+extern kprobe_opcode_t __early_kprobes_code_area_end[];
+extern kprobe_opcode_t __early_kprobes_insn_slot_start[];
+extern kprobe_opcode_t __early_kprobes_insn_slot_end[];
 
 #else
 #define __DEFINE_EKPROBE_ALLOC_OPS(__t, __name)				\
@@ -339,6 +343,8 @@ static inline void ek_free_##__name(__t *__s)				\
 
 #endif
 
+__DEFINE_EKPROBE_ALLOC_OPS(kprobe_opcode_t, opcode)
+
 struct kprobe_insn_cache {
 	struct mutex mutex;
 	void *(*alloc)(void);	/* allocate insn page */
@@ -346,8 +352,35 @@ struct kprobe_insn_cache {
 	struct list_head pages; /* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
+#ifdef CONFIG_EARLY_KPROBES
+# define slots_start(c)	((c)->early_slots_start)
+# define slots_end(c)	((c)->early_slots_end)
+# define slots_bitmap(c)	((c)->early_slots_bitmap)
+	kprobe_opcode_t *early_slots_start;
+	kprobe_opcode_t *early_slots_end;
+	unsigned long early_slots_bitmap[EARLY_KPROBES_BITMAP_SZ];
+#else
+# define slots_start(c)	NULL
+# define slots_end(c)	NULL
+# define slots_bitmap(c)	NULL
+#endif
 };
 
+static inline kprobe_opcode_t *
+__get_insn_slot_early(struct kprobe_insn_cache *c)
+{
+	return __ek_alloc_opcode(slots_start(c),
+			slots_end(c), slots_bitmap(c));
+}
+
+static inline int
+__free_insn_slot_early(struct kprobe_insn_cache *c,
+		kprobe_opcode_t *slot)
+{
+	return __ek_free_opcode(slot, slots_start(c),
+			slots_end(c), slots_bitmap(c));
+}
+
 extern kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c);
 extern void __free_insn_slot(struct kprobe_insn_cache *c,
 			     kprobe_opcode_t *slot, int dirty);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 4591cae..1882bfa 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -137,6 +137,10 @@ struct kprobe_insn_cache kprobe_insn_slots = {
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
+#ifdef CONFIG_EARLY_KPROBES
+	.early_slots_start = __early_kprobes_insn_slot_start,
+	.early_slots_end = __early_kprobes_insn_slot_end,
+#endif
 };
 static int collect_garbage_slots(struct kprobe_insn_cache *c);
 
@@ -149,6 +153,9 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 	struct kprobe_insn_page *kip;
 	kprobe_opcode_t *slot = NULL;
 
+	if (unlikely(!kprobes_initialized))
+		return __get_insn_slot_early(c);
+
 	mutex_lock(&c->mutex);
  retry:
 	list_for_each_entry(kip, &c->pages, list) {
@@ -249,6 +256,9 @@ void __free_insn_slot(struct kprobe_insn_cache *c,
 {
 	struct kprobe_insn_page *kip;
 
+	if (unlikely(__free_insn_slot_early(c, slot)))
+		return;
+
 	mutex_lock(&c->mutex);
 	list_for_each_entry(kip, &c->pages, list) {
 		long idx = ((long)slot - (long)kip->insns) /
@@ -280,6 +290,10 @@ struct kprobe_insn_cache kprobe_optinsn_slots = {
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
+#ifdef CONFIG_EARLY_KPROBES
+	.early_slots_start = __early_kprobes_code_area_start,
+	.early_slots_end = __early_kprobes_code_area_end,
+#endif
 };
 #endif
 #endif
-- 
1.8.4

