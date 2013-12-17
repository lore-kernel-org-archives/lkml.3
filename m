Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3LQU5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:57:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28446 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3LQUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 10/12] xen/pvh: Piggyback on PVHVM for grant driver.
Date: Tue, 17 Dec 2013 15:51:41 -0500
Message-Id: <1387313503-31362-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PVH the shared grant frame is the PFN and not MFN,
hence its mapped via the same code path as HVM.

The allocation of the grant frame is done differently - we
do not use the early platform-pci driver and have an
ioremap area - instead we use balloon memory and stitch
all of the non-contingous pages in a virtualized area.

That means when we call the hypervisor to replace the GMFN
with a XENMAPSPACE_grant_table type, we need to lookup the
old PFN for every iteration instead of assuming a flat
contingous PFN allocation.

Lastly, we only use v1 for grants. This is because PVHVM
is not able to use v2 due to no XENMEM_add_to_physmap
calls on the error status page (see commit
69e8f430e243d657c2053f097efebc2e2cd559f0
 xen/granttable: Disable grant v2 for HVM domains.)

Until that is implemented this workaround has to
be in place.

Also per suggestions by Stefano utilize the PVHVM paths
as they share common functionality.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/gntdev.c       |  2 +-
 drivers/xen/grant-table.c  | 80 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/xen/platform-pci.c |  2 +-
 include/xen/grant_table.h  |  2 +-
 4 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index e41c79c..073b4a1 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -846,7 +846,7 @@ static int __init gntdev_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	use_ptemod = xen_pv_domain();
+	use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);
 
 	err = misc_register(&gntdev_miscdev);
 	if (err != 0) {
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..c0ded9f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -47,6 +47,7 @@
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <xen/balloon.h>
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
 #include <xen/swiotlb-xen.h>
@@ -66,8 +67,8 @@ static unsigned int boot_max_nr_grant_frames;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
-unsigned long xen_hvm_resume_frames;
-EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
+unsigned long xen_auto_xlat_grant_frames;
+EXPORT_SYMBOL_GPL(xen_auto_xlat_grant_frames);
 
 static union {
 	struct grant_entry_v1 *v1;
@@ -1060,7 +1061,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
 
-	if (xen_hvm_domain()) {
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 		struct xen_add_to_physmap xatp;
 		unsigned int i = end_idx;
 		rc = 0;
@@ -1069,10 +1070,24 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		 * index, ensuring that the table will grow only once.
 		 */
 		do {
+			unsigned long vaddr;
+			unsigned int level;
+			pte_t *pte;
+
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
 			xatp.space = XENMAPSPACE_grant_table;
-			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
+
+			/*
+			 * Don't assume the memory is contingous. Lookup each.
+			 */
+			vaddr = xen_auto_xlat_grant_frames + (i * PAGE_SIZE);
+			if (xen_hvm_domain())
+				xatp.gpfn = vaddr >> PAGE_SHIFT;
+			else {
+				pte = lookup_address(vaddr, &level);
+				xatp.gpfn = pte_mfn(*pte);
+			}
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
 			if (rc != 0) {
 				pr_warn("grant table add_to_physmap failed, err=%d\n",
@@ -1135,7 +1150,7 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	if (xen_hvm_domain())
+	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		gsv.version = 1;
 	else
 		gsv.version = 2;
@@ -1161,6 +1176,46 @@ static void gnttab_request_version(void)
 	pr_info("Grant tables using version %d layout\n", grant_table_version);
 }
 
+static int xlated_setup_gnttab_pages(unsigned long nr_grant_frames,
+				     unsigned long max, void *addr)
+{
+	struct page **pages;
+	unsigned long *pfns;
+	int rc, i;
+
+	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
+	if (!pfns) {
+		kfree(pages);
+		return -ENOMEM;
+	}
+	rc = alloc_xenballooned_pages(nr_grant_frames, pages, 0 /* lowmem */);
+	if (rc) {
+		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
+			nr_grant_frames, rc);
+		kfree(pages);
+		kfree(pfns);
+		return rc;
+	}
+	for (i = 0; i < nr_grant_frames; i++)
+		pfns[i] = page_to_pfn(pages[i]);
+
+	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, max, addr);
+
+	kfree(pages);
+	kfree(pfns);
+	if (rc) {
+		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
+			nr_grant_frames, rc);
+		free_xenballooned_pages(nr_grant_frames, pages);
+		return rc;
+	}
+	return rc;
+}
+
 static int gnttab_setup(void)
 {
 	unsigned int max_nr_gframes;
@@ -1169,15 +1224,26 @@ static int gnttab_setup(void)
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
+	if (xen_feature(XENFEAT_auto_translated_physmap) && !xen_auto_xlat_grant_frames) {
+		/*
+		 * xen_auto_xlat_grant_frames is setup for PVHVM by
+		 * alloc_xen_mmio by the time this is called.
+		 */
+		int rc = xlated_setup_gnttab_pages(max_nr_gframes, max_nr_gframes,
+						   &gnttab_shared.addr);
+		if (rc)
+			return rc;
+		xen_auto_xlat_grant_frames = (unsigned long)gnttab_shared.addr;
+	}
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);
 
 	if (gnttab_shared.addr == NULL) {
-		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
+		gnttab_shared.addr = xen_remap(xen_auto_xlat_grant_frames,
 						PAGE_SIZE * max_nr_gframes);
 		if (gnttab_shared.addr == NULL) {
 			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
-					xen_hvm_resume_frames);
+					xen_auto_xlat_grant_frames);
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 2f3528e..44bc5a6 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -154,7 +154,7 @@ static int platform_pci_init(struct pci_dev *pdev,
 	}
 
 	max_nr_gframes = gnttab_max_grant_frames();
-	xen_hvm_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
+	xen_auto_xlat_grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
 	ret = gnttab_init();
 	if (ret)
 		goto out;
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 694dcaf..24280ac 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -178,7 +178,7 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
 			   grant_status_t **__shared);
 void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
 
-extern unsigned long xen_hvm_resume_frames;
+extern unsigned long xen_auto_xlat_grant_frames;
 unsigned int gnttab_max_grant_frames(void);
 
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
-- 
1.8.3.1

