Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbaGATYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:24:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaGATXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:23:51 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 2/4] RAS: Add a Corrected Errors Collector
Date: Tue,  1 Jul 2014 21:23:41 +0200
Message-Id: <1404242623-10094-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404242623-10094-1-git-send-email-bp@alien8.de>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

A simple data structure for collecting correctable errors along with
accessors. Larger description in the code itself.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/ras/Kconfig  |  11 ++
 drivers/ras/Makefile |   3 +-
 drivers/ras/ce.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ras.h  |   2 +
 4 files changed, 311 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ras/ce.c

diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
index f9da613052c2..c6977b943506 100644
--- a/drivers/ras/Kconfig
+++ b/drivers/ras/Kconfig
@@ -1,2 +1,13 @@
 config RAS
 	bool
+
+config RAS_CE
+	bool "Correctable Errors Collector"
+	default y if X86_MCE
+	select MEMORY_FAILURE
+	---help---
+	  This is a small cache which collects correctable memory errors per 4K page
+	  PFN and counts their repeated occurrance. Once the counter for a PFN overflows,
+	  we try to soft-offline that page as we take it to mean that it has reached a
+	  relatively high error count and would probably be best if we don't use it
+	  anymore.
diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
index d7f73341ced3..7e7f3f9aa948 100644
--- a/drivers/ras/Makefile
+++ b/drivers/ras/Makefile
@@ -1 +1,2 @@
-obj-$(CONFIG_RAS) += ras.o debugfs.o
+obj-$(CONFIG_RAS)	+= ras.o debugfs.o
+obj-$(CONFIG_RAS_CE)	+= ce.o
diff --git a/drivers/ras/ce.c b/drivers/ras/ce.c
new file mode 100644
index 000000000000..4cab8e8a4ef0
--- /dev/null
+++ b/drivers/ras/ce.c
@@ -0,0 +1,296 @@
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
+				 * number of element insertions/incrementations
+				 * since the last spring cleaning.
+				 */
+} ce_arr;
+/* ^^^^^
+ * |
+ * | This variable is passed in internally from the API functions.
+ */
+
+static DEFINE_MUTEX(ce_mutex);
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
+static u64 del_lru_elem_unlocked(struct ce_array *ca)
+{
+	unsigned int min = FULL_COUNT_MASK;
+	int i, min_idx = 0;
+
+	for (i = 0; i < ca->n; i++) {
+		unsigned int this = FULL_COUNT(ca->array[i]);
+		if (min > this) {
+			min = this;
+			min_idx = i;
+		}
+	}
+
+	__del_elem(ca, min_idx);
+
+	return PFN(ca->array[min_idx]);
+}
+
+/*
+ * We return the 0th pfn in the error case under the assumption that it cannot
+ * be poisoned and excessive CEs in there are a serious deal anyway.
+ */
+static u64 __maybe_unused del_lru_elem(void)
+{
+	struct ce_array *ca = &ce_arr;
+	u64 pfn;
+
+	if (!ca->n)
+		return 0;
+
+	mutex_lock(&ce_mutex);
+	pfn = del_lru_elem_unlocked(ca);
+	mutex_unlock(&ce_mutex);
+
+	return pfn;
+}
+
+
+int ce_add_elem(u64 pfn)
+{
+	struct ce_array *ca = &ce_arr;
+	unsigned to;
+	int count, ret = 0;
+
+	/*
+	 * We can be called very early on the identify_cpu path where we are not
+	 * initialized yet. We ignore the error for simplicity.
+	 */
+	if (!ce_arr.array)
+		return 0;
+
+	mutex_lock(&ce_mutex);
+
+	if (ca->n == MAX_ELEMS)
+		WARN_ON(!del_lru_elem_unlocked(ca));
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
+		ca->n++;
+		ret = 0;
+
+		goto decay;
+	}
+
+	count = COUNT(ca->array[to]);
+
+	if (count < COUNT_MASK) {
+		ca->array[to] |= (DECAY_MASK << COUNT_BITS);
+		ca->array[to]++;
+
+		goto decay;
+	} else {
+		u64 pfn = ca->array[to] >> PAGE_SHIFT;
+
+		/*
+		 * We have reached max count for this page, soft-offline it.
+		 */
+		pr_err("Soft-offlining pfn: 0x%llx\n", pfn);
+		memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
+		__del_elem(ca, to);
+
+		ret = 0;
+
+		goto unlock;
+	}
+
+decay:
+	ca->decay_count++;
+
+	if (ca->decay_count >= CLEAN_ELEMS)
+		do_spring_cleaning(ca);
+
+unlock:
+	mutex_unlock(&ce_mutex);
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
diff --git a/include/linux/ras.h b/include/linux/ras.h
index 2aceeafd6fe5..24e82fb0fe99 100644
--- a/include/linux/ras.h
+++ b/include/linux/ras.h
@@ -11,4 +11,6 @@ static inline void ras_debugfs_init(void) { return; }
 static inline int ras_add_daemon_trace(void) { return 0; }
 #endif
 
+void __init ce_init(void);
+int ce_add_elem(u64 pfn);
 #endif
-- 
2.0.0

