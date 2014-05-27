Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaE0N2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:28:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52059 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaE0N1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:27:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 1/3] MCE, CE: Corrected errors collecting thing
Date: Tue, 27 May 2014 15:27:13 +0200
Message-Id: <1401197235-13440-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401197235-13440-1-git-send-email-bp@alien8.de>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

A simple data structure for collecting correctable errors.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/mce.h          |   4 +
 arch/x86/kernel/cpu/mcheck/Makefile |   2 +-
 arch/x86/kernel/cpu/mcheck/ce.c     | 281 ++++++++++++++++++++++++++++++++++++
 3 files changed, 286 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/ce.c

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6e4ce2df87cf..b4581392df66 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -247,4 +247,8 @@ struct cper_sec_mem_err;
 extern void apei_mce_report_mem_error(int corrected,
 				      struct cper_sec_mem_err *mem_err);
 
+void __init ce_init(void);
+int ce_add_elem(u64 pfn);
+u64 ce_del_lru_elem(void);
+
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index bb34b03af252..97f03043a674 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,4 +1,4 @@
-obj-y				=  mce.o mce-severity.o
+obj-y				=  mce.o mce-severity.o ce.o
 
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
diff --git a/arch/x86/kernel/cpu/mcheck/ce.c b/arch/x86/kernel/cpu/mcheck/ce.c
new file mode 100644
index 000000000000..3020415f27f4
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/ce.c
@@ -0,0 +1,281 @@
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+
+#include <asm/bug.h>
+
+/*
+ * RAS Correctable Errors Collector
+ *
+ * This is a simple gadget which collects correctable errors and counts their
+ * occurrence per physical page address.
+ *
+ * We've opted for possibly the simplest data structure to collect those - an
+ * array of the size of a memory page. It stores 512 u64's with the following
+ * structure:
+ *
+ * [63 ... PFN ... 12 | 11 ... generation ... 10 | 9 ... count ... 0]
+ *
+ * The generation in the two highest order bits is two bits which are set to 11b
+ * on every insertion. During the course of this entry's existence, it
+ * gets decremented during spring cleaning to 10b, then 01b and then 00b.
+ *
+ * This way we're employing the numeric ordering to make sure that newly
+ * inserted/touched elements have higher 12-bit counts (which we've
+ * manufactured) and thus iterating over the array initially won't kick out
+ * those last inserted elements.
+ *
+ * Spring cleaning is what we do when we reach a certain number CLEAN_ELEMS of
+ * elements entered into the page; during which, we're decaying all elements.
+ * If, after decay, an element gets inserted again, its generation is set to 11b
+ * to make sure it has higher numerical count than other, older elements and
+ * thus emulate an an LRU-like behavior when deleting elements to free up space
+ * in the page.
+ *
+ * When an element reaches it's max count of COUNT_MASK, we try to poison it by
+ * assuming that errors triggered COUNT_MASK times in a single page are
+ * excessive and that page shouldn't be used anymore.
+ *
+ * To the question why we've chosen a page and moving elements around with
+ * memmove, it is because it is a very simple structure to handle and max data
+ * movement is 4K which on highly optimized modern CPUs is almost unnoticeable.
+ * We wanted to avoid the pointer traversal of more complex structures like a
+ * linked list or some sort of a balancing search tree.
+ *
+ * Deleting an element takes O(n) but since it is only a single page, it should
+ * be fast enough and it shouldn't happen all too often depending on error
+ * patterns.
+ */
+
+#undef pr_fmt
+#define pr_fmt(fmt) "RAS: " fmt
+
+/*
+ * We use DECAY_BITS bits of PAGE_SHIFT bits for counting decay, i.e., how long
+ * elements have stayed in the array without accessed again.
+ */
+#define DECAY_BITS		2
+#define DECAY_MASK		((1ULL << DECAY_BITS) - 1)
+#define MAX_ELEMS		(PAGE_SIZE / sizeof(u64))
+
+/*
+ * Threshold amount of inserted elements after which we start spring
+ * cleaning.
+ */
+#define CLEAN_ELEMS		(MAX_ELEMS >> DECAY_BITS)
+
+/* Bits which count the number of errors happened in this 4K page. */
+#define COUNT_BITS		(PAGE_SHIFT - DECAY_BITS)
+#define COUNT_MASK		((1ULL << COUNT_BITS) - 1)
+#define FULL_COUNT_MASK		(PAGE_SIZE - 1)
+
+/*
+ * u64: [ 63 ... 12 | DECAY_BITS | COUNT_BITS ]
+ */
+
+#define PFN(e)			((e) >> PAGE_SHIFT)
+#define DECAY(e)		(((e) >> COUNT_BITS) & DECAY_MASK)
+#define COUNT(e)		((unsigned int)(e) & COUNT_MASK)
+#define FULL_COUNT(e)		((e) & (PAGE_SIZE - 1))
+
+static struct ce_array {
+	u64 *array;		/* container page */
+	unsigned n;		/* number of elements in the array */
+
+	unsigned decay_count;	/*
+				 * number of elements inserted since the last
+				 * spring cleaning.
+				 */
+} ce_arr;
+/* ^^^^^
+ * |
+ * | This variable is passed in internally from the API functions.
+ */
+
+static DEFINE_MUTEX(ce_lock);
+
+/*
+ * Decrement decay value. We're using DECAY_BITS bits to denote decay of an
+ * element in the array. On insertion and any access, it gets maxed
+ */
+static void do_spring_cleaning(struct ce_array *ca)
+{
+	int i;
+
+	for (i = 0; i < ca->n; i++) {
+		u8 decay = DECAY(ca->array[i]);
+
+		if (!decay)
+			continue;
+
+		decay--;
+
+		ca->array[i] &= ~(DECAY_MASK << COUNT_BITS);
+		ca->array[i] |= (decay << COUNT_BITS);
+	}
+	ca->decay_count = 0;
+}
+
+/*
+ * @to: index of the smallest element which is >= then @pfn.
+ *
+ * Return the index of the pfn if found, otherwise negative value.
+ */
+static int __find_elem(struct ce_array *ca, u64 pfn, unsigned *to)
+{
+	u64 this_pfn;
+	int min = 0, max = ca->n;
+
+	while (min < max) {
+		int tmp = (max + min) >> 1;
+
+		this_pfn = PFN(ca->array[tmp]);
+
+		if (this_pfn < pfn)
+			min = tmp + 1;
+		else if (this_pfn > pfn)
+			max = tmp;
+		else {
+			min = tmp;
+			break;
+		}
+	}
+
+	if (to)
+		*to = min;
+
+	this_pfn = PFN(ca->array[min]);
+
+	if (this_pfn == pfn)
+		return min;
+
+	return -ENOKEY;
+}
+
+static int find_elem(struct ce_array *ca, u64 pfn, unsigned *to)
+{
+	WARN_ON(!to);
+
+	if (!ca->n) {
+		*to = 0;
+		return -ENOKEY;
+	}
+	return __find_elem(ca, pfn, to);
+}
+
+static void __del_elem(struct ce_array *ca, int idx)
+{
+	/*
+	 * Save us a function call when deleting the last element.
+	 */
+	if (ca->n - (idx + 1))
+		memmove((void *)&ca->array[idx],
+			(void *)&ca->array[idx + 1],
+			(ca->n - (idx + 1)) * sizeof(u64));
+
+	ca->n--;
+}
+
+/*
+ * We return the 0th pfn in the error case under the assumption that it cannot
+ * be poisoned and excessive CEs in there are a serious deal anyway.
+ */
+u64 ce_del_lru_elem(void)
+{
+	unsigned int min = FULL_COUNT_MASK;
+	struct ce_array *ca = &ce_arr;
+	int i, min_idx = 0;
+	u64 pfn;
+
+	if (!ca->n)
+		return 0;
+
+	mutex_lock(&ce_lock);
+
+	for (i = 0; i < ca->n; i++) {
+		unsigned int this = FULL_COUNT(ca->array[i]);
+		if (min > this) {
+			min = this;
+			min_idx = i;
+		}
+	}
+
+	pfn = PFN(ca->array[min_idx]);
+
+	__del_elem(ca, min_idx);
+
+	mutex_unlock(&ce_lock);
+
+	return pfn;
+}
+
+int ce_add_elem(u64 pfn)
+{
+	struct ce_array *ca = &ce_arr;
+	unsigned to;
+	int count, ret = 0;
+
+	mutex_lock(&ce_lock);
+
+	if (ca->n == MAX_ELEMS) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	ret = find_elem(ca, pfn, &to);
+	if (ret < 0) {
+		/*
+		 * Shift range [to-end] to make room for one more element.
+		 */
+		memmove((void *)&ca->array[to + 1],
+			(void *)&ca->array[to],
+			(ca->n - to) * sizeof(u64));
+
+		ca->array[to] = (pfn << PAGE_SHIFT) |
+				(DECAY_MASK << COUNT_BITS) | 1;
+
+		ca->decay_count++;
+		ca->n++;
+
+		if (ca->decay_count >= CLEAN_ELEMS)
+			do_spring_cleaning(ca);
+
+		ret = 0;
+
+		goto unlock;
+	}
+
+	count = COUNT(ca->array[to]);
+
+	if (count < COUNT_MASK) {
+		ca->array[to] |= (DECAY_MASK << COUNT_BITS);
+		ca->array[to]++;
+	} else {
+		u64 pfn = ca->array[to] >> PAGE_SHIFT;
+		/*
+		 * We have reached max count for this page, poison it.
+		 */
+		if (!memory_failure(pfn, MCE_VECTOR, 0))
+			pr_err("Poisoning pfn 0x%llx\n", pfn);
+
+		__del_elem(ca, to);
+
+		ret = 0;
+	}
+
+unlock:
+	mutex_unlock(&ce_lock);
+
+	return ret;
+}
+
+void __init ce_init(void)
+{
+	ce_arr.array = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!ce_arr.array) {
+		pr_err("Error allocating CE array page!\n");
+		return;
+	}
+
+	pr_info("Correctable Errors collector initialized.\n");
+}
-- 
1.9.0

