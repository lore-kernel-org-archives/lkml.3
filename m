Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaEZP37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:29:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaEZP34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:29:56 -0400
Message-Id: <20140526152107.962265143@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 26 May 2014 16:56:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: [RFC][PATCH 3/5] mm,ib,umem: Use VM_PINNED
References: <20140526145605.016140154@infradead.org>
Content-Disposition: inline; filename=peterz-mm-pinned-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mm_mpin() call to prepare the vm for a 'persistent'
get_user_pages() call.

Cc: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 drivers/infiniband/core/umem.c |   51 ++++++++++++++++-------------------------
 include/rdma/ib_umem.h         |    3 +-
 2 files changed, 23 insertions(+), 31 deletions(-)

--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -81,15 +81,12 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	struct ib_umem *umem;
 	struct page **page_list;
 	struct vm_area_struct **vma_list;
-	unsigned long locked;
-	unsigned long lock_limit;
 	unsigned long cur_base;
 	unsigned long npages;
 	int ret;
 	int i;
 	DEFINE_DMA_ATTRS(attrs);
 	struct scatterlist *sg, *sg_list_start;
-	int need_release = 0;
 
 	if (dmasync)
 		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
@@ -135,26 +132,23 @@ struct ib_umem *ib_umem_get(struct ib_uc
 
 	down_write(&current->mm->mmap_sem);
 
-	locked     = npages + current->mm->pinned_vm;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	cur_base = addr & PAGE_MASK;
+	umem->start_addr = cur_base;
+	umem->nr_pages = npages;
 
 	if (npages == 0) {
 		ret = -EINVAL;
-		goto out;
+		goto err;
 	}
 
+	ret = mm_mpin(umem->start_addr, npages * PAGE_SIZE);
+	if (ret)
+		goto err;
+
 	ret = sg_alloc_table(&umem->sg_head, npages, GFP_KERNEL);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
-	need_release = 1;
 	sg_list_start = umem->sg_head.sgl;
 
 	while (npages) {
@@ -164,7 +158,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 				     1, !umem->writable, page_list, vma_list);
 
 		if (ret < 0)
-			goto out;
+			goto err_release;
 
 		umem->npages += ret;
 		cur_base += ret * PAGE_SIZE;
@@ -189,25 +183,26 @@ struct ib_umem *ib_umem_get(struct ib_uc
 
 	if (umem->nmap <= 0) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_release;
 	}
 
 	ret = 0;
 
-out:
-	if (ret < 0) {
-		if (need_release)
-			__ib_umem_release(context->device, umem, 0);
-		kfree(umem);
-	} else
-		current->mm->pinned_vm = locked;
-
+unlock:
 	up_write(&current->mm->mmap_sem);
 	if (vma_list)
 		free_page((unsigned long) vma_list);
 	free_page((unsigned long) page_list);
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
+
+err_release:
+	__ib_umem_release(context->device, umem, 0);
+err_unpin:
+	mm_munpin(umem->start_addr, umem->nr_pages * PAGE_SIZE);
+err:
+	kfree(umem);
+	goto unlock;
 }
 EXPORT_SYMBOL(ib_umem_get);
 
@@ -216,7 +211,7 @@ static void ib_umem_account(struct work_
 	struct ib_umem *umem = container_of(work, struct ib_umem, work);
 
 	down_write(&umem->mm->mmap_sem);
-	umem->mm->pinned_vm -= umem->diff;
+	mm_munpin(umem->start_addr, umem->nr_pages * PAGE_SIZE);
 	up_write(&umem->mm->mmap_sem);
 	mmput(umem->mm);
 	kfree(umem);
@@ -230,7 +225,6 @@ void ib_umem_release(struct ib_umem *ume
 {
 	struct ib_ucontext *context = umem->context;
 	struct mm_struct *mm;
-	unsigned long diff;
 
 	__ib_umem_release(umem->context->device, umem, 1);
 
@@ -240,8 +234,6 @@ void ib_umem_release(struct ib_umem *ume
 		return;
 	}
 
-	diff = PAGE_ALIGN(umem->length + umem->offset) >> PAGE_SHIFT;
-
 	/*
 	 * We may be called with the mm's mmap_sem already held.  This
 	 * can happen when a userspace munmap() is the call that drops
@@ -254,7 +246,6 @@ void ib_umem_release(struct ib_umem *ume
 		if (!down_write_trylock(&mm->mmap_sem)) {
 			INIT_WORK(&umem->work, ib_umem_account);
 			umem->mm   = mm;
-			umem->diff = diff;
 
 			queue_work(ib_wq, &umem->work);
 			return;
@@ -262,7 +253,7 @@ void ib_umem_release(struct ib_umem *ume
 	} else
 		down_write(&mm->mmap_sem);
 
-	current->mm->pinned_vm -= diff;
+	mm_munpin(umem->start_addr, umem->nr_pages * PAGE_SIZE);
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 	kfree(umem);
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -41,6 +41,8 @@ struct ib_ucontext;
 
 struct ib_umem {
 	struct ib_ucontext     *context;
+	unsigned long		start_addr;
+	unsigned long		nr_pages;
 	size_t			length;
 	int			offset;
 	int			page_size;
@@ -48,7 +50,6 @@ struct ib_umem {
 	int                     hugetlb;
 	struct work_struct	work;
 	struct mm_struct       *mm;
-	unsigned long		diff;
 	struct sg_table sg_head;
 	int             nmap;
 	int             npages;


