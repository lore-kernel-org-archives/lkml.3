Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3LND1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:50 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38139 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3LND1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 104/115] ion: use vm_insert_pfn for faulted pages
Date: Fri, 13 Dec 2013 19:26:24 -0800
Message-Id: <1386991595-6251-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Most ion userspace mappings are created with remap_pfn_range.  Use
vm_insert_pfn instead of vm_insert_page to make faulted cached
mappings look more like uncached mappings.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index fc77aa6..45127f5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -890,14 +890,15 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct ion_buffer *buffer = vma->vm_private_data;
+	unsigned long pfn;
 	int ret;
 
 	mutex_lock(&buffer->lock);
 	ion_buffer_page_dirty(buffer->pages + vmf->pgoff);
-
 	BUG_ON(!buffer->pages || !buffer->pages[vmf->pgoff]);
-	ret = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
-			     ion_buffer_page(buffer->pages[vmf->pgoff]));
+
+	pfn = page_to_pfn(ion_buffer_page(buffer->pages[vmf->pgoff]));
+	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 	mutex_unlock(&buffer->lock);
 	if (ret)
 		return VM_FAULT_ERROR;
@@ -956,6 +957,8 @@ static int ion_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 	}
 
 	if (ion_buffer_fault_user_mappings(buffer)) {
+		vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND |
+							VM_DONTDUMP;
 		vma->vm_private_data = buffer;
 		vma->vm_ops = &ion_vma_ops;
 		ion_vm_open(vma);
-- 
1.8.3.2

