Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaACUbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:31:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaACUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 17/19] xen/pvh: Piggyback on PVHVM for grant driver (v4)
Date: Fri,  3 Jan 2014 14:38:34 -0500
Message-Id: <1388777916-1328-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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

v2 of this patch moves most of the PVH code out in the
arch/x86/xen/grant-table driver and touches only minimally
the generic driver.

v3, v4: fixes us some of the code due to earlier patches.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/grant-table.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/gntdev.c       |  2 +-
 drivers/xen/grant-table.c  |  9 ++++---
 3 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 3a5f55d..2d71979 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -125,3 +125,65 @@ void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 	apply_to_page_range(&init_mm, (unsigned long)shared,
 			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
 }
+#ifdef CONFIG_XEN_PVH
+#include <xen/balloon.h>
+#include <xen/events.h>
+#include <linux/slab.h>
+static int __init xlated_setup_gnttab_pages(void)
+{
+	struct page **pages;
+	xen_pfn_t *pfns;
+	int rc;
+	unsigned int i;
+	unsigned long nr_grant_frames = gnttab_max_grant_frames();
+
+	BUG_ON(nr_grant_frames == 0);
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
+	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
+				    &xen_auto_xlat_grant_frames.vaddr);
+
+	kfree(pages);
+	if (rc) {
+		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
+			nr_grant_frames, rc);
+		free_xenballooned_pages(nr_grant_frames, pages);
+		kfree(pfns);
+		return rc;
+	}
+
+	xen_auto_xlat_grant_frames.pfn = pfns;
+	xen_auto_xlat_grant_frames.count = nr_grant_frames;
+
+	return 0;
+}
+
+static int __init xen_pvh_gnttab_setup(void)
+{
+	if (!xen_pvh_domain())
+		return -ENODEV;
+
+	return xlated_setup_gnttab_pages();
+}
+/* Call it _before_ __gnttab_init as we need to initialize the
+ * xen_auto_xlat_grant_frames first. */
+core_initcall(xen_pvh_gnttab_setup);
+#endif
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
index 6c78fd21..3d04c1c 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1108,7 +1108,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
 
-	if (xen_hvm_domain()) {
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 		struct xen_add_to_physmap xatp;
 		unsigned int i = end_idx;
 		rc = 0;
@@ -1184,7 +1184,7 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	if (xen_hvm_domain())
+	if (xen_feature(XENFEAT_auto_translated_physmap))
 		gsv.version = 1;
 	else
 		gsv.version = 2;
@@ -1328,5 +1328,6 @@ static int __gnttab_init(void)
 
 	return gnttab_init();
 }
-
-core_initcall(__gnttab_init);
+/* Starts after core_initcall so that xen_pvh_gnttab_setup can be called
+ * beforehand to initialize xen_auto_xlat_grant_frames. */
+core_initcall_sync(__gnttab_init);
-- 
1.8.3.1

