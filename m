Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3HADau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:30:50 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51305 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3HADat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:30:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
In-Reply-To: <1375203632-23854-1-git-send-email-andres@lagarcavilla.org>
Date: Wed, 31 Jul 2013 23:30:47 -0400
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.com>,
        boris.ostrovsky@oracle.com
Content-Transfer-Encoding: 8BIT
Message-Id: <2BE2F119-7375-4C8D-933D-9BCD5A9B7552@gridcentric.ca>
References: <1375203632-23854-1-git-send-email-andres@lagarcavilla.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- Resend as I haven't seen this hit the lists. Maybe some smtp misconfig. Apologies. Also expanded cc --

When a foreign mapper attempts to map guest frames that are paged out,
the mapper receives an ENOENT response and will have to try again
while a helper process pages the target frame back in.

Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
of mapping calls.

Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
---
drivers/xen/privcmd.c |   32 +++++++++++++++++++++++++++-----
1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index f8e5dd7..44a26c6 100644
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
@@ -422,9 +425,9 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
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
@@ -540,11 +543,30 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
	return 0;
}

+/* For MMAP */
static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
{
	return !cmpxchg(&vma->vm_private_data, NULL, PRIV_VMA_LOCKED);
}

+/* For MMAPBATCH*. This allows asserting the singleshot mapping
+ * on a per pfn/pte basis. Mapping calls that fail with ENOENT
+ * can be then retried until success. */
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
> 

