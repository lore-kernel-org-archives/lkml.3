Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3H0KPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:15:35 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:42420 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3H0KPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:15:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367971200"; 
   d="scan'208";a="8129065"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2] p2m: use GNTTABOP_unmap_and_duplicate if available
Date: Tue, 27 Aug 2013 12:13:26 +0200
Message-ID: <1377598406-1434-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
mapping passed in new_addr, allowing us to perform batch unmaps in p2m
code without requiring the use of a multicall.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
Changes since v1:
 * Append check_duplicate_mfn at the end of remove_page_override.

Changes since RFC:
 * Move shared code between _single and _batch to helper
   functions.
---
I don't currently have a NFS server (the one I had is currently not
working due to SD card corruption) and I cannot set up one right now,
so I've only tested this with a raw image stored in a local disk.
---
 arch/x86/include/asm/xen/page.h     |    4 +-
 arch/x86/xen/p2m.c                  |  132 ++++++++++++++++++++++++++++++-----
 drivers/xen/grant-table.c           |   24 ++----
 include/xen/interface/grant_table.h |   22 ++++++
 4 files changed, 146 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 6aef9fb..ea1dce6 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -51,8 +51,8 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 
 extern int m2p_add_override(unsigned long mfn, struct page *page,
 			    struct gnttab_map_grant_ref *kmap_op);
-extern int m2p_remove_override(struct page *page,
-				struct gnttab_map_grant_ref *kmap_op);
+extern int m2p_remove_override(struct page **pages,
+				struct gnttab_map_grant_ref *kmap_ops, int count);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 0d4ec35..88c6229 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -154,6 +154,8 @@
 #include <linux/hash.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/hardirq.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -853,6 +855,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
 static DEFINE_SPINLOCK(m2p_override_lock);
+extern bool gnttab_supports_duplicate;
 
 static void __init m2p_override_init(void)
 {
@@ -933,8 +936,8 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
-int m2p_remove_override(struct page *page,
-		struct gnttab_map_grant_ref *kmap_op)
+
+static inline int remove_page_override(struct page *page)
 {
 	unsigned long flags;
 	unsigned long mfn;
@@ -965,6 +968,41 @@ int m2p_remove_override(struct page *page,
 	ClearPagePrivate(page);
 
 	set_phys_to_machine(pfn, page->index);
+
+	/*
+	 * p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
+	 * somewhere in this domain, even before being added to the
+	 * m2p_override (see comment above in m2p_add_override).
+	 * If there are no other entries in the m2p_override corresponding
+	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
+	 * the original pfn (the one shared by the frontend): the backend
+	 * cannot do any IO on this page anymore because it has been
+	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
+	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
+	 * pfn again.
+	 */
+	mfn &= ~FOREIGN_FRAME_BIT;
+	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
+	if (ret == 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
+			m2p_find_override(mfn) == NULL)
+		set_phys_to_machine(pfn, mfn);
+
+	return ret;
+}
+
+int m2p_remove_override_single(struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
+{
+	unsigned long mfn;
+	unsigned long pfn;
+	int ret = 0;
+
+	pfn = page_to_pfn(page);
+	mfn = get_phys_to_machine(pfn);
+	ret = remove_page_override(page);
+	if (ret)
+		return ret;
+
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
 			struct multicall_space mcs;
@@ -1016,24 +1054,82 @@ int m2p_remove_override(struct page *page,
 		}
 	}
 
-	/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
-	 * somewhere in this domain, even before being added to the
-	 * m2p_override (see comment above in m2p_add_override).
-	 * If there are no other entries in the m2p_override corresponding
-	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
-	 * the original pfn (the one shared by the frontend): the backend
-	 * cannot do any IO on this page anymore because it has been
-	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
-	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
-	 * pfn again. */
-	mfn &= ~FOREIGN_FRAME_BIT;
-	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
-	if (ret == 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
-			m2p_find_override(mfn) == NULL)
-		set_phys_to_machine(pfn, mfn);
-
 	return 0;
 }
+
+int m2p_remove_override_batch(struct page **pages,
+		struct gnttab_map_grant_ref *kmap_ops, int count)
+{
+	struct gnttab_unmap_and_duplicate *unmap_ops = NULL;
+	int ret = 0, i;
+
+	for (i = 0; i < count; i++) {
+		ret = remove_page_override(pages[i]);
+		if (ret)
+			goto out;
+	}
+
+	if (kmap_ops != NULL) {
+		struct page *scratch_page = get_balloon_scratch_page();
+		unsigned long scratch_page_address = (unsigned long)
+					__va(page_to_pfn(scratch_page) << PAGE_SHIFT);
+		int invcount = 0;
+
+		unmap_ops = kcalloc(count, sizeof(unmap_ops[0]), GFP_KERNEL);
+		if (!unmap_ops) {
+			put_balloon_scratch_page();
+			ret = -ENOMEM;
+			goto out;
+		}
+		for (i = 0; i < count; i++) {
+			if (!PageHighMem(pages[i])) {
+				unmap_ops[invcount].host_addr = kmap_ops[i].host_addr;
+				unmap_ops[invcount].new_addr = scratch_page_address;
+				unmap_ops[invcount].handle = kmap_ops[i].handle;
+				invcount++;
+			}
+		}
+		ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_and_duplicate, unmap_ops, invcount);
+		if (ret) {
+			pr_warning("m2p_remove_override_batch: GNTTABOP_unmap_and_duplicate failed");
+			put_balloon_scratch_page();
+			ret = -1;
+			goto out;
+		}
+		put_balloon_scratch_page();
+	}
+
+out:
+	kfree(unmap_ops);
+	return ret;
+}
+
+int m2p_remove_override(struct page **pages,
+		struct gnttab_map_grant_ref *kmap_ops, int count)
+{
+	int i, ret;
+	bool lazy = false;
+
+	if (gnttab_supports_duplicate) {
+		ret = m2p_remove_override_batch(pages, kmap_ops, count);
+		if (ret)
+			return ret;
+	} else {
+		if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+			arch_enter_lazy_mmu_mode();
+			lazy = true;
+		}
+		for (i = 0; i < count; i++) {
+			ret = m2p_remove_override_single(pages[i], kmap_ops ?
+					       &kmap_ops[i] : NULL);
+			if (ret)
+				return ret;
+		}
+		if (lazy)
+			arch_leave_lazy_mmu_mode();
+	}
+	return ret;
+}
 EXPORT_SYMBOL_GPL(m2p_remove_override);
 
 struct page *m2p_find_override(unsigned long mfn)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c4d2298..34a4909 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -66,6 +66,7 @@ static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
 unsigned long xen_hvm_resume_frames;
+bool gnttab_supports_duplicate;
 EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
 
 static union {
@@ -935,8 +936,7 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct gnttab_map_grant_ref *kmap_ops,
 		      struct page **pages, unsigned int count)
 {
-	int i, ret;
-	bool lazy = false;
+	int ret;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
 	if (ret)
@@ -945,20 +945,7 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			return ret;
-	}
-
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
+	ret = m2p_remove_override(pages, kmap_ops, count);
 
 	return ret;
 }
@@ -1246,6 +1233,11 @@ int gnttab_init(void)
 	gnttab_free_count = nr_init_grefs - NR_RESERVED_ENTRIES;
 	gnttab_free_head  = NR_RESERVED_ENTRIES;
 
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_and_duplicate, NULL, 0))
+		gnttab_supports_duplicate = false;
+	else
+		gnttab_supports_duplicate = true;
+
 	printk("Grant table initialized\n");
 	return 0;
 
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index e40fae9..1f49dc1 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -428,6 +428,27 @@ struct gnttab_unmap_and_replace {
 DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_and_replace);
 
 /*
+ * GNTTABOP_unmap_and_duplicate: Destroy one or more grant-reference mappings
+ * tracked by <handle> but atomically replace the page table entry with one
+ * pointing to the machine address under <new_addr>.
+ * NOTES:
+ *  1. The call may fail in an undefined manner if either mapping is not
+ *     tracked by <handle>.
+ *  2. After executing a batch of unmaps, it is guaranteed that no stale
+ *     mappings will remain in the device or host TLBs.
+ */
+#define GNTTABOP_unmap_and_duplicate  12
+struct gnttab_unmap_and_duplicate {
+    /* IN parameters. */
+    uint64_t host_addr;
+    uint64_t new_addr;
+    grant_handle_t handle;
+    /* OUT parameters. */
+    int16_t  status;              /* => enum grant_status */
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_and_duplicate_t);
+
+/*
  * GNTTABOP_set_version: Request a particular version of the grant
  * table shared table structure.  This operation can only be performed
  * once in any given domain.  It must be performed before any grants
@@ -522,6 +543,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
 #define GNTST_bad_copy_arg    (-10) /* copy arguments cross page boundary.   */
 #define GNTST_address_too_big (-11) /* transfer page address too large.      */
 #define GNTST_eagain          (-12) /* Operation not done; try again.        */
+#define GNTST_enosys          (-13) /* Operation not implemented.            */
 
 #define GNTTABOP_error_msgs {                   \
     "okay",                                     \
-- 
1.7.7.5 (Apple Git-26)

