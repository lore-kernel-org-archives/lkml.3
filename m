Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3JKHsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:48:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:46590 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab3JKHsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:48:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="391465108"
Subject: [PATCH] drm: Add the mutex protection in drm_do_vm_fault.
From: Jun Chen <jun.d.chen@intel.com>
To: airlied@linux.ie, viro@zeniv.linux.org.uk, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jun Chen <jun.d.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Oct 2013 11:47:30 -0400
Message-ID: <1381506450.7844.4.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are no mutex protection for the dev->map_hash while calling
the drm_ht_find_item in the function drm_do_vm_fault. So try to
mutex firstly and then find the list for using to avoid this race
condition.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 drivers/gpu/drm/drm_vm.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index b5c5af7..1d95221 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -107,8 +107,11 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!dev->agp || !dev->agp->cant_use_aperture)
 		goto vm_fault_error;
 
-	if (drm_ht_find_item(&dev->map_hash, vma->vm_pgoff, &hash))
+	mutex_lock(&dev->struct_mutex);
+	if (drm_ht_find_item(&dev->map_hash, vma->vm_pgoff, &hash)) {
+		mutex_unlock(&dev->struct_mutex);
 		goto vm_fault_error;
+	}
 
 	r_list = drm_hash_entry(hash, struct drm_map_list, hash);
 	map = r_list->map;
@@ -140,8 +143,10 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 				break;
 		}
 
-		if (&agpmem->head == &dev->agp->memory)
+		if (&agpmem->head == &dev->agp->memory) {
+			mutex_unlock(&dev->struct_mutex);
 			goto vm_fault_error;
+		}
 
 		/*
 		 * Get the page, inc the use count, and return it
@@ -151,6 +156,7 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		get_page(page);
 		vmf->page = page;
 
+		mutex_unlock(&dev->struct_mutex);
 		DRM_DEBUG
 		    ("baddr = 0x%llx page = 0x%p, offset = 0x%llx, count=%d\n",
 		     (unsigned long long)baddr,
@@ -159,6 +165,7 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		     page_count(page));
 		return 0;
 	}
+	mutex_unlock(&dev->struct_mutex);
 vm_fault_error:
 	return VM_FAULT_SIGBUS;	/* Disallow mremap */
 }
-- 
1.7.4.1



