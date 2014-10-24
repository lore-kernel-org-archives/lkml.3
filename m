Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaJXTlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:41:17 -0400
Received: from gproxy2-pub.mail.unifiedlayer.com ([69.89.18.3]:38464 "HELO
	gproxy2-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751377AbaJXTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:41:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 15:41:15 EDT
X-Authority-Analysis: v=2.1 cv=e5mVF8Z/ c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=TBVoxVdAAAAA:8 a=QyXUC8HyAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=I6b9oLjGAi8hB1UVyA4A:9 a=bCht6v-pe87LC_55:21
 a=DXvlEdeLGI0LFHAo:21
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Cc: jroedel@suse.de
Subject: [PATCH 2/2] iommu/amd: use handle_mm_fault directly
Date: Fri, 24 Oct 2014 12:34:31 -0700
Message-Id: <1414179271-7621-2-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This could be useful for debug in the future if we want to track
major/minor faults more closely, and also avoids the put_page trick we
used with gup.

In order to do this, we also track the task struct in the PASID state
structure.  This lets us update the appropriate task stats after the
fault has been handled, and may aid with debug in the future as well.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/iommu/amd_iommu_v2.c | 93 +++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 90d734b..b23481b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -47,6 +47,7 @@ struct pasid_state {
 	atomic_t count;				/* Reference count */
 	unsigned mmu_notifier_count;		/* Counting nested mmu_notifier
 						   calls */
+	struct task_struct *task;		/* task_struct for accounting */
 	struct mm_struct *mm;			/* mm_struct for the faults */
 	struct mmu_notifier mn;                 /* mmu_notifier handle */
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
@@ -513,45 +514,74 @@ static void finish_pri_tag(struct device_state *dev_state,
 	spin_unlock_irqrestore(&pasid_state->lock, flags);
 }
 
+static void handle_fault_error(struct fault *fault)
+{
+	int status;
+
+	if (!fault->dev_state->inv_ppr_cb) {
+		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+		return;
+	}
+
+	status = fault->dev_state->inv_ppr_cb(fault->dev_state->pdev,
+					      fault->pasid,
+					      fault->address,
+					      fault->flags);
+	switch (status) {
+	case AMD_IOMMU_INV_PRI_RSP_SUCCESS:
+		set_pri_tag_status(fault->state, fault->tag, PPR_SUCCESS);
+		break;
+	case AMD_IOMMU_INV_PRI_RSP_INVALID:
+		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+		break;
+	case AMD_IOMMU_INV_PRI_RSP_FAIL:
+		set_pri_tag_status(fault->state, fault->tag, PPR_FAILURE);
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void do_fault(struct work_struct *work)
 {
 	struct fault *fault = container_of(work, struct fault, work);
-	int npages, write;
-	struct page *page;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct task_struct *task;
+	u64 address;
+	int ret, write;
 
 	write = !!(fault->flags & PPR_FAULT_WRITE);
 
-	down_read(&fault->state->mm->mmap_sem);
-	npages = get_user_pages(NULL, fault->state->mm,
-				fault->address, 1, write, 0, &page, NULL);
-	up_read(&fault->state->mm->mmap_sem);
-
-	if (npages == 1) {
-		put_page(page);
-	} else if (fault->dev_state->inv_ppr_cb) {
-		int status;
-
-		status = fault->dev_state->inv_ppr_cb(fault->dev_state->pdev,
-						      fault->pasid,
-						      fault->address,
-						      fault->flags);
-		switch (status) {
-		case AMD_IOMMU_INV_PRI_RSP_SUCCESS:
-			set_pri_tag_status(fault->state, fault->tag, PPR_SUCCESS);
-			break;
-		case AMD_IOMMU_INV_PRI_RSP_INVALID:
-			set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
-			break;
-		case AMD_IOMMU_INV_PRI_RSP_FAIL:
-			set_pri_tag_status(fault->state, fault->tag, PPR_FAILURE);
-			break;
-		default:
-			BUG();
-		}
-	} else {
-		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+	task = fault->state->task;
+	mm = fault->state->mm;
+	address = fault->address;
+
+	down_read(&mm->mmap_sem);
+	vma = find_extend_vma(mm, address);
+	if (!vma || address < vma->vm_start) {
+		/* failed to get a vma in the right range */
+		up_read(&mm->mmap_sem);
+		handle_fault_error(fault);
+		goto out;
 	}
 
+	ret = handle_mm_fault(mm, vma, address, write);
+	if (ret & VM_FAULT_ERROR) {
+		/* failed to service fault */
+		up_read(&mm->mmap_sem);
+		handle_fault_error(fault);
+		goto out;
+	}
+
+	if (ret & VM_FAULT_MAJOR)
+		task->maj_flt++;
+	else
+		task->min_flt++;
+
+	up_read(&mm->mmap_sem);
+
+out:
 	finish_pri_tag(fault->dev_state, fault->state, fault->tag);
 
 	put_pasid_state(fault->state);
@@ -663,6 +693,7 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	spin_lock_init(&pasid_state->lock);
 
 	mm                        = get_task_mm(task);
+	pasid_state->task	  = task;
 	pasid_state->mm           = mm;
 	pasid_state->device_state = dev_state;
 	pasid_state->pasid        = pasid;
-- 
1.9.1

