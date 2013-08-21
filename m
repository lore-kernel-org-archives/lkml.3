Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3HUTot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:44:49 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:34796 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3HUTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:44:48 -0400
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Cc: Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, boris.ostrovsky@oracle.com
Subject: [PATCH v4] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
Date: Wed, 21 Aug 2013 19:44:32 +0000
Message-Id: <1377114272-9995-1-git-send-email-andreslc@gridcentric.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Lagar-Cavilla <andres@lagarcavilla.org>

When a foreign mapper attempts to map guest frames that are paged out,
the mapper receives an ENOENT response and will have to try again
while a helper process pages the target frame back in.

Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
of mapping calls.

V2: Fixed autotranslated physmap mode breakage introduced by V1.
V3: Enforce full range mapping for first ioctl call on a given VMA.
V4: Shuffle logic to minimize page table walking.

Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
---
 drivers/xen/privcmd.c |   63 +++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index f8e5dd7..f1b2462 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -43,9 +43,12 @@ MODULE_LICENSE("GPL");
 
 #define PRIV_VMA_LOCKED ((void *)1)
 
-#ifndef HAVE_ARCH_PRIVCMD_MMAP
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma);
-#endif
+
+static int privcmd_enforce_singleshot_mapping_granular(
+               struct vm_area_struct *vma,
+               unsigned long addr,
+               unsigned long nr_pages);
 
 static long privcmd_ioctl_hypercall(void __user *udata)
 {
@@ -421,20 +424,34 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
 
 	vma = find_vma(mm, m.addr);
 	if (!vma ||
-	    vma->vm_ops != &privcmd_vm_ops ||
-	    (m.addr != vma->vm_start) ||
-	    ((m.addr + (nr_pages << PAGE_SHIFT)) != vma->vm_end) ||
-	    !privcmd_enforce_singleshot_mapping(vma)) {
-		up_write(&mm->mmap_sem);
+	    vma->vm_ops != &privcmd_vm_ops) {
 		ret = -EINVAL;
+		up_write(&mm->mmap_sem);
 		goto out;
 	}
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		ret = alloc_empty_pages(vma, m.num);
-		if (ret < 0) {
+
+	/*
+	 * Use singleshot mapping to enforce first-time requirements. Must map the
+	 * whole VMA range, if ARM or x86-PVH must allocate balloon pages.
+	 */
+	if (privcmd_enforce_singleshot_mapping(vma)) {
+		if ((m.addr != vma->vm_start) ||
+		    ((m.addr + (nr_pages << PAGE_SHIFT)) != vma->vm_end) ||
+		    (xen_feature(XENFEAT_auto_translated_physmap) &&
+		     ((ret = alloc_empty_pages(vma, m.num)) < 0))) {
+			if (ret == 0)
+				ret = -EINVAL;
 			up_write(&mm->mmap_sem);
 			goto out;
 		}
+	} else {
+		if ((m.addr < vma->vm_start) ||
+		    ((m.addr + (nr_pages << PAGE_SHIFT)) > vma->vm_end) ||
+		    !privcmd_enforce_singleshot_mapping_granular(vma, m.addr, nr_pages)) {
+			up_write(&mm->mmap_sem);
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	state.domain        = m.dom;
@@ -540,11 +557,37 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*
+ * For asserting on a whole VMA. This is used by the legacy PRIVCMD_MMAP
+ * call, for MMAPBATCH* to ensure the first ioctl is called on the whole
+ * mapping range, and for autotranslated physmap mode to allocate the ballooned
+ * pages that back a mapping only once.
+ */
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
 {
 	return !cmpxchg(&vma->vm_private_data, NULL, PRIV_VMA_LOCKED);
 }
 
+/*
+ * For MMAPBATCH*. This allows asserting the singleshot mapping
+ * on a per pfn/pte basis. Mapping calls that fail with ENOENT
+ * can be then retried until success.
+ */
+static int enforce_singleshot_mapping_fn(pte_t *pte, struct page *pmd_page,
+	                unsigned long addr, void *data)
+{
+	return pte_none(*pte) ? 0 : -EBUSY;
+}
+
+static int privcmd_enforce_singleshot_mapping_granular(
+	           struct vm_area_struct *vma,
+	           unsigned long addr,
+	           unsigned long nr_pages)
+{
+	return apply_to_page_range(vma->vm_mm, addr, nr_pages << PAGE_SHIFT,
+	              enforce_singleshot_mapping_fn, NULL) == 0;
+}
+
 const struct file_operations xen_privcmd_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = privcmd_ioctl,
-- 
1.7.1

