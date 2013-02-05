Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3BEWzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:55:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23525 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3BEWzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:55:32 -0500
Date: Tue, 5 Feb 2013 14:55:22 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] PVH linux: Use ballooning to allocate grant table pages
Message-ID: <20130205145522.654abf30@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a fixme in Linux to use alloc_xenballooned_pages() to
allocate pfns for grant table pages instead of kmalloc. This also
simplifies add to physmap on the xen side a bit.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 9c0019d..fdb1d88 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -47,6 +47,7 @@
 #include <xen/grant_table.h>
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
+#include <xen/balloon.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
@@ -1026,10 +1027,22 @@ static void gnttab_unmap_frames_v2(void)
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
-	unsigned long *frames, start_gpfn;
+	unsigned long *frames, start_gpfn = 0;
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
 
@@ -1040,8 +1053,6 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 		if (xen_hvm_domain())
 			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
-		else
-			start_gpfn = virt_to_pfn(gnttab_shared.addr);
 		/*
 		 * Loop backwards, so that the first hypercall has the largest
 		 * index, ensuring that the table will grow only once.
@@ -1050,7 +1061,11 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
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
 				printk(KERN_WARNING
@@ -1138,27 +1153,51 @@ static void gnttab_request_version(void)
 		grant_table_version);
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
 int gnttab_resume(void)
 {
+	int rc;
 	unsigned int max_nr_gframes;
-	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
 
 	gnttab_request_version();
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
