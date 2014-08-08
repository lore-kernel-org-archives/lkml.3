Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbaHHWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:33:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbaHHUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/259] x86/xen: safely map and unmap grant frames when in atomic context
Date: Fri,  8 Aug 2014 13:37:18 -0700
Message-Id: <1407530482-4483-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit b7dd0e350e0bd4c0fddcc9b8958342700b00b168 upstream.

arch_gnttab_map_frames() and arch_gnttab_unmap_frames() are called in
atomic context but were calling alloc_vm_area() which might sleep.

Also, if a driver attempts to allocate a grant ref from an interrupt
and the table needs expanding, then the CPU may already by in lazy MMU
mode and apply_to_page_range() will BUG when it tries to re-enable
lazy MMU mode.

These two functions are only used in PV guests.

Introduce arch_gnttab_init() to allocates the virtual address space in
advance.

Avoid the use of apply_to_page_range() by using saving and using the
array of PTE addresses from the alloc_vm_area() call (which ensures
that the required page tables are pre-allocated).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[ David Vrabel: Backported to 3.13.10. ]
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/xen/grant-table.c |   5 ++
 arch/x86/xen/grant-table.c | 148 ++++++++++++++++++++++++++++-----------------
 drivers/xen/grant-table.c  |   5 ++
 include/xen/grant_table.h  |   1 +
 4 files changed, 102 insertions(+), 57 deletions(-)

diff --git a/arch/arm/xen/grant-table.c b/arch/arm/xen/grant-table.c
index 859a9bb..91cf08b 100644
--- a/arch/arm/xen/grant-table.c
+++ b/arch/arm/xen/grant-table.c
@@ -51,3 +51,8 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
 {
 	return -ENOSYS;
 }
+
+int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status)
+{
+	return 0;
+}
diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 3a5f55d..4d2c9bf 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -36,92 +36,126 @@
 
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <xen/xen.h>
 
 #include <asm/pgtable.h>
 
-static int map_pte_fn(pte_t *pte, struct page *pmd_page,
-		      unsigned long addr, void *data)
-{
-	unsigned long **frames = (unsigned long **)data;
-
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
-	return 0;
-}
-
-/*
- * This function is used to map shared frames to store grant status. It is
- * different from map_pte_fn above, the frames type here is uint64_t.
- */
-static int map_pte_fn_status(pte_t *pte, struct page *pmd_page,
-			     unsigned long addr, void *data)
-{
-	uint64_t **frames = (uint64_t **)data;
-
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
-	return 0;
-}
-
-static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
-			unsigned long addr, void *data)
-{
-
-	set_pte_at(&init_mm, addr, pte, __pte(0));
-	return 0;
-}
+static struct gnttab_vm_area {
+	struct vm_struct *area;
+	pte_t **ptes;
+} gnttab_shared_vm_area, gnttab_status_vm_area;
 
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   void **__shared)
 {
-	int rc;
 	void *shared = *__shared;
+	unsigned long addr;
+	unsigned long i;
+
+	if (shared == NULL)
+		*__shared = shared = gnttab_shared_vm_area.area->addr;
 
-	if (shared == NULL) {
-		struct vm_struct *area =
-			alloc_vm_area(PAGE_SIZE * max_nr_gframes, NULL);
-		BUG_ON(area == NULL);
-		shared = area->addr;
-		*__shared = shared;
+	addr = (unsigned long)shared;
+
+	for (i = 0; i < nr_gframes; i++) {
+		set_pte_at(&init_mm, addr, gnttab_shared_vm_area.ptes[i],
+			   mfn_pte(frames[i], PAGE_KERNEL));
+		addr += PAGE_SIZE;
 	}
 
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn, &frames);
-	return rc;
+	return 0;
 }
 
 int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   grant_status_t **__shared)
 {
-	int rc;
 	grant_status_t *shared = *__shared;
+	unsigned long addr;
+	unsigned long i;
+
+	if (shared == NULL)
+		*__shared = shared = gnttab_status_vm_area.area->addr;
 
-	if (shared == NULL) {
-		/* No need to pass in PTE as we are going to do it
-		 * in apply_to_page_range anyhow. */
-		struct vm_struct *area =
-			alloc_vm_area(PAGE_SIZE * max_nr_gframes, NULL);
-		BUG_ON(area == NULL);
-		shared = area->addr;
-		*__shared = shared;
+	addr = (unsigned long)shared;
+
+	for (i = 0; i < nr_gframes; i++) {
+		set_pte_at(&init_mm, addr, gnttab_status_vm_area.ptes[i],
+			   mfn_pte(frames[i], PAGE_KERNEL));
+		addr += PAGE_SIZE;
 	}
 
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn_status, &frames);
-	return rc;
+	return 0;
 }
 
 void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 {
-	apply_to_page_range(&init_mm, (unsigned long)shared,
-			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
+	pte_t **ptes;
+	unsigned long addr;
+	unsigned long i;
+
+	if (shared == gnttab_status_vm_area.area->addr)
+		ptes = gnttab_status_vm_area.ptes;
+	else
+		ptes = gnttab_shared_vm_area.ptes;
+
+	addr = (unsigned long)shared;
+
+	for (i = 0; i < nr_gframes; i++) {
+		set_pte_at(&init_mm, addr, ptes[i], __pte(0));
+		addr += PAGE_SIZE;
+	}
+}
+
+static int arch_gnttab_valloc(struct gnttab_vm_area *area, unsigned nr_frames)
+{
+	area->ptes = kmalloc(sizeof(pte_t *) * nr_frames, GFP_KERNEL);
+	if (area->ptes == NULL)
+		return -ENOMEM;
+
+	area->area = alloc_vm_area(PAGE_SIZE * nr_frames, area->ptes);
+	if (area->area == NULL) {
+		kfree(area->ptes);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void arch_gnttab_vfree(struct gnttab_vm_area *area)
+{
+	free_vm_area(area->area);
+	kfree(area->ptes);
+}
+
+int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status)
+{
+	int ret;
+
+	if (!xen_pv_domain())
+		return 0;
+
+	ret = arch_gnttab_valloc(&gnttab_shared_vm_area, nr_shared);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Always allocate the space for the status frames in case
+	 * we're migrated to a host with V2 support.
+	 */
+	ret = arch_gnttab_valloc(&gnttab_status_vm_area, nr_status);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+  err:
+	arch_gnttab_vfree(&gnttab_shared_vm_area);
+	return -ENOMEM;
 }
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..b983a99 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1250,6 +1250,11 @@ int gnttab_init(void)
 		}
 	}
 
+	ret = arch_gnttab_init(boot_max_nr_grant_frames,
+			       nr_status_frames(boot_max_nr_grant_frames));
+	if (ret < 0)
+		goto ini_nomem;
+
 	if (gnttab_setup() < 0) {
 		ret = -ENODEV;
 		goto ini_nomem;
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 694dcaf..bbb6c50 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -170,6 +170,7 @@ gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
 	unmap->dev_bus_addr = 0;
 }
 
+int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status);
 int arch_gnttab_map_shared(xen_pfn_t *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   void **__shared);
-- 
1.9.1

