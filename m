Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3LMCLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:20 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:64154 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3LMCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:50 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 12/14] xen/pvh: Use ballooning to allocate grant table pages [v2]
Date: Thu, 12 Dec 2013 21:10:19 -0500
Message-Id: <1386900621-27528-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

This patch fixes a fixme in Linux to use alloc_xenballooned_pages() to
allocate pfns for grant table pages instead of kmalloc. This also
simplifies add to physmap on the xen side a bit.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v1: Rebase on xen/grant-table: correctly initialize grant table version 1]

Conflicts:
	drivers/xen/grant-table.c
[v2: Rebase on xen: Convert printks to pr_<level>]
---
 drivers/xen/grant-table.c |   67 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1fcf75b..4467d54 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -50,6 +50,7 @@
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
 #include <xen/swiotlb-xen.h>
+#include <xen/balloon.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
@@ -1053,10 +1054,22 @@ static void gnttab_unmap_frames_v2(void)
 	arch_gnttab_unmap(grstatus, nr_status_frames(nr_grant_frames));
 }
 
+static xen_pfn_t pvh_get_grant_pfn(int grant_idx)
+{
+	unsigned long vaddr;
+	unsigned int level;
+	pte_t *pte;
+
+	vaddr = (unsigned long)(gnttab_shared.addr) + grant_idx * PAGE_SIZE;
+	pte = lookup_address(vaddr, &level);
+	BUG_ON(pte == NULL);
+	return pte_mfn(*pte);
+}
+
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
-	unsigned long start_gpfn;
+	unsigned long start_gpfn = 0;
 	xen_pfn_t *frames;
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
@@ -1068,8 +1081,6 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 		if (xen_hvm_domain())
 			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
-		else
-			start_gpfn = virt_to_pfn(gnttab_shared.addr);
 		/*
 		 * Loop backwards, so that the first hypercall has the largest
 		 * index, ensuring that the table will grow only once.
@@ -1078,7 +1089,11 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
 			xatp.space = XENMAPSPACE_grant_table;
-			xatp.gpfn = start_gpfn + i;
+			if (xen_hvm_domain())
+				xatp.gpfn = start_gpfn + i;
+			else
+				xatp.gpfn = pvh_get_grant_pfn(i);
+
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
 			if (rc != 0) {
 				pr_warn("grant table add_to_physmap failed, err=%d\n",
@@ -1167,26 +1182,50 @@ static void gnttab_request_version(void)
 	pr_info("Grant tables using version %d layout\n", grant_table_version);
 }
 
+/*
+ * PVH: we need three things: virtual address, pfns, and mfns. The pfns
+ * are allocated via ballooning, then we call arch_gnttab_map_shared to
+ * allocate the VA and put pfn's in the pte's for the VA. The mfn's are
+ * finally allocated in gnttab_map() by xen which also populates the P2M.
+ */
+static int xlated_setup_gnttab_pages(unsigned long numpages, void **addr)
+{
+	int i, rc;
+	unsigned long pfns[numpages];
+	struct page *pages[numpages];
+
+	rc = alloc_xenballooned_pages(numpages, pages, 0);
+	if (rc != 0) {
+		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
+			numpages, rc);
+		return rc;
+	}
+	for (i = 0; i < numpages; i++)
+		pfns[i] = page_to_pfn(pages[i]);
+
+	rc = arch_gnttab_map_shared(pfns, numpages, numpages, addr);
+	if (rc != 0)
+		free_xenballooned_pages(numpages, pages);
+
+	return rc;
+}
+
 static int gnttab_setup(void)
 {
+	int rc;
 	unsigned int max_nr_gframes;
-	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
 
 	max_nr_gframes = gnttab_max_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
-	/* PVH note: xen will free existing kmalloc'd mfn in
-	 * XENMEM_add_to_physmap. TBD/FIXME: use xen ballooning instead of
-	 * kmalloc(). */
 	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
 	    !gnttab_shared.addr) {
-		gnttab_shared.addr =
-			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
-		if (!gnttab_shared.addr) {
-			pr_warn("%s", kmsg);
-			return -ENOMEM;
-		}
+
+		rc = xlated_setup_gnttab_pages((unsigned long)max_nr_gframes,
+					       &gnttab_shared.addr);
+		if (rc != 0)
+			return rc;
 	}
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);
-- 
1.7.7.6

