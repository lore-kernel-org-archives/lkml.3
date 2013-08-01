Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3HAO0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:26:30 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47655 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3HAO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:26:29 -0400
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        David Vrabel <david.vrabel@citrix.com>, boris.ostrovsky@oracle.com
Subject: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
Date: Thu,  1 Aug 2013 14:26:10 +0000
Message-Id: <1375367170-13151-1-git-send-email-andreslc@gridcentric.ca>
X-Mailer: git-send-email 1.7.1
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
---
 drivers/xen/privcmd.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index f8e5dd7..6ebdf98 100644
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
@@ -422,14 +425,15 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
 	vma = find_vma(mm, m.addr);
 	if (!vma ||
 	    vma->vm_ops != &privcmd_vm_ops ||
-	    (m.addr != vma->vm_start) ||
-	    ((m.addr + (nr_pages << PAGE_SHIFT)) != vma->vm_end) ||
-	    !privcmd_enforce_singleshot_mapping(vma)) {
+	    (m.addr < vma->vm_start) ||
+	    ((m.addr + (nr_pages << PAGE_SHIFT)) > vma->vm_end) ||
+	    !privcmd_enforce_singleshot_mapping_granular(vma, m.addr, nr_pages)) {
 		up_write(&mm->mmap_sem);
 		ret = -EINVAL;
 		goto out;
 	}
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+	if (xen_feature(XENFEAT_auto_translated_physmap) &&
+	    privcmd_enforce_singleshot_mapping(vma)) {
 		ret = alloc_empty_pages(vma, m.num);
 		if (ret < 0) {
 			up_write(&mm->mmap_sem);
@@ -540,11 +544,36 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*
+ * For Asserting on a whole VMA. This is used by the legacy PRIVCMD_MMAP
+ * call and autotranslated physmap mode to allocate the ballooned pages that
+ * back a mapping only once.
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

