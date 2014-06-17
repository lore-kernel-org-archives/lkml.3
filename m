Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967272AbaFQVxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:53:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967254AbaFQVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 154/212] drm/radeon: avoid segfault on device open when accel is not working.
Date: Tue, 17 Jun 2014 14:44:08 -0700
Message-Id: <1403041506-13646-155-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>

commit 24f47acc78b0ab5e2201f859fe1f693ae90c7c83 upstream.

When accel is not working on device with virtual address space radeon
segfault because the ib buffer is NULL and trying to map it inside the
virtual address space trigger segfault. This patch only map the ib
buffer if accel is working.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 57 +++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index e0315d2..5ef56ad 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -542,28 +542,29 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 		radeon_vm_init(rdev, &fpriv->vm);
 
-		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
-		if (r) {
-			radeon_vm_fini(rdev, &fpriv->vm);
-			kfree(fpriv);
-			return r;
-		}
+		if (rdev->accel_working) {
+			r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
+			if (r) {
+				radeon_vm_fini(rdev, &fpriv->vm);
+				kfree(fpriv);
+				return r;
+			}
 
-		/* map the ib pool buffer read only into
-		 * virtual address space */
-		bo_va = radeon_vm_bo_add(rdev, &fpriv->vm,
-					 rdev->ring_tmp_bo.bo);
-		r = radeon_vm_bo_set_addr(rdev, bo_va, RADEON_VA_IB_OFFSET,
-					  RADEON_VM_PAGE_READABLE |
-					  RADEON_VM_PAGE_SNOOPED);
-
-		radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
-		if (r) {
-			radeon_vm_fini(rdev, &fpriv->vm);
-			kfree(fpriv);
-			return r;
-		}
+			/* map the ib pool buffer read only into
+			 * virtual address space */
+			bo_va = radeon_vm_bo_add(rdev, &fpriv->vm,
+						 rdev->ring_tmp_bo.bo);
+			r = radeon_vm_bo_set_addr(rdev, bo_va, RADEON_VA_IB_OFFSET,
+						  RADEON_VM_PAGE_READABLE |
+						  RADEON_VM_PAGE_SNOOPED);
 
+			radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
+			if (r) {
+				radeon_vm_fini(rdev, &fpriv->vm);
+				kfree(fpriv);
+				return r;
+			}
+		}
 		file_priv->driver_priv = fpriv;
 	}
 
@@ -591,13 +592,15 @@ void radeon_driver_postclose_kms(struct drm_device *dev,
 		struct radeon_bo_va *bo_va;
 		int r;
 
-		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
-		if (!r) {
-			bo_va = radeon_vm_bo_find(&fpriv->vm,
-						  rdev->ring_tmp_bo.bo);
-			if (bo_va)
-				radeon_vm_bo_rmv(rdev, bo_va);
-			radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
+		if (rdev->accel_working) {
+			r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
+			if (!r) {
+				bo_va = radeon_vm_bo_find(&fpriv->vm,
+							  rdev->ring_tmp_bo.bo);
+				if (bo_va)
+					radeon_vm_bo_rmv(rdev, bo_va);
+				radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
+			}
 		}
 
 		radeon_vm_fini(rdev, &fpriv->vm);
-- 
1.9.1

