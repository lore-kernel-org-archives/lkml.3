Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbaAGACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:02:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaAFWiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Dolinak <kanilo2@yahoo.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.12 063/144] drm/ttm: Fix accesses through vmas with only partial coverage
Date: Mon,  6 Jan 2014 14:37:04 -0800
Message-Id: <20140106223747.155191420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit d386735588c3e22129c2bc6eb64fc1d37a8f805c upstream.

VMAs covering a bo but that didn't start at the same address space offset as
the bo they were mapping were incorrectly generating SEGFAULT errors in
the fault handler.

Reported-by: Joseph Dolinak <kanilo2@yahoo.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo_vm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -116,9 +116,9 @@ static int ttm_bo_vm_fault(struct vm_are
 	}
 
 	page_offset = ((address - vma->vm_start) >> PAGE_SHIFT) +
-	    drm_vma_node_start(&bo->vma_node) - vma->vm_pgoff;
-	page_last = vma_pages(vma) +
-	    drm_vma_node_start(&bo->vma_node) - vma->vm_pgoff;
+		vma->vm_pgoff - drm_vma_node_start(&bo->vma_node);
+	page_last = vma_pages(vma) + vma->vm_pgoff -
+		drm_vma_node_start(&bo->vma_node);
 
 	if (unlikely(page_offset >= bo->num_pages)) {
 		retval = VM_FAULT_SIGBUS;


