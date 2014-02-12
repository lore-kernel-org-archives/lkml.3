Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaBLIbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:31:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbaBLIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Joseph Dolinak" <kanilo2@yahoo.com>,
        "Jakob Bornecrantz" <jakob@vmware.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.726864176@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 45/79] drm/ttm: Fix accesses through vmas with only
 partial coverage
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit d386735588c3e22129c2bc6eb64fc1d37a8f805c upstream.

VMAs covering a bo but that didn't start at the same address space offset as
the bo they were mapping were incorrectly generating SEGFAULT errors in
the fault handler.

Reported-by: Joseph Dolinak <kanilo2@yahoo.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
[bwh: Backported to 3.2: drm_vma_node_start() is open-coded;
 vma_pages() was open-coded]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -144,9 +144,9 @@ static int ttm_bo_vm_fault(struct vm_are
 	}
 
 	page_offset = ((address - vma->vm_start) >> PAGE_SHIFT) +
-	    bo->vm_node->start - vma->vm_pgoff;
-	page_last = ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) +
-	    bo->vm_node->start - vma->vm_pgoff;
+		vma->vm_pgoff - bo->vm_node->start;
+	page_last = vma_pages(vma) + vma->vm_pgoff -
+		bo->vm_node->start;
 
 	if (unlikely(page_offset >= bo->num_pages)) {
 		retval = VM_FAULT_SIGBUS;

