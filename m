Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3G3PST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 16/75] drm/radeon: allow selection of alignment in the sub-allocator
Date: Tue, 30 Jul 2013 08:16:45 -0700
Message-Id: <1375197464-27962-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6c4f978b357bc779c703fda1f200e9179623d3e9 upstream.

There are cases where we need more than 4k alignment.  No
functional change with this commit.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h        | 1 +
 drivers/gpu/drm/radeon/radeon_gart.c   | 1 +
 drivers/gpu/drm/radeon/radeon_object.h | 2 +-
 drivers/gpu/drm/radeon/radeon_ring.c   | 1 +
 drivers/gpu/drm/radeon/radeon_sa.c     | 7 ++++---
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index a08f657..aa2d2e2 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -387,6 +387,7 @@ struct radeon_sa_manager {
 	uint64_t		gpu_addr;
 	void			*cpu_ptr;
 	uint32_t		domain;
+	uint32_t		align;
 };
 
 struct radeon_sa_bo;
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index daf9710..dfa0ca1 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -467,6 +467,7 @@ int radeon_vm_manager_init(struct radeon_device *rdev)
 		size *= 2;
 		r = radeon_sa_bo_manager_init(rdev, &rdev->vm_manager.sa_manager,
 					      RADEON_GPU_PAGE_ALIGN(size),
+					      RADEON_GPU_PAGE_SIZE,
 					      RADEON_GEM_DOMAIN_VRAM);
 		if (r) {
 			dev_err(rdev->dev, "failed to allocate vm bo (%dKB)\n",
diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
index 5fc86b0..ec18ad5 100644
--- a/drivers/gpu/drm/radeon/radeon_object.h
+++ b/drivers/gpu/drm/radeon/radeon_object.h
@@ -158,7 +158,7 @@ static inline void * radeon_sa_bo_cpu_addr(struct radeon_sa_bo *sa_bo)
 
 extern int radeon_sa_bo_manager_init(struct radeon_device *rdev,
 				     struct radeon_sa_manager *sa_manager,
-				     unsigned size, u32 domain);
+				     unsigned size, u32 align, u32 domain);
 extern void radeon_sa_bo_manager_fini(struct radeon_device *rdev,
 				      struct radeon_sa_manager *sa_manager);
 extern int radeon_sa_bo_manager_start(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 3760eff..cac9f20 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -205,6 +205,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 	}
 	r = radeon_sa_bo_manager_init(rdev, &rdev->ring_tmp_bo,
 				      RADEON_IB_POOL_SIZE*64*1024,
+				      RADEON_GPU_PAGE_SIZE,
 				      RADEON_GEM_DOMAIN_GTT);
 	if (r) {
 		return r;
diff --git a/drivers/gpu/drm/radeon/radeon_sa.c b/drivers/gpu/drm/radeon/radeon_sa.c
index 0abe5a9..f0bac68 100644
--- a/drivers/gpu/drm/radeon/radeon_sa.c
+++ b/drivers/gpu/drm/radeon/radeon_sa.c
@@ -49,7 +49,7 @@ static void radeon_sa_bo_try_free(struct radeon_sa_manager *sa_manager);
 
 int radeon_sa_bo_manager_init(struct radeon_device *rdev,
 			      struct radeon_sa_manager *sa_manager,
-			      unsigned size, u32 domain)
+			      unsigned size, u32 align, u32 domain)
 {
 	int i, r;
 
@@ -57,13 +57,14 @@ int radeon_sa_bo_manager_init(struct radeon_device *rdev,
 	sa_manager->bo = NULL;
 	sa_manager->size = size;
 	sa_manager->domain = domain;
+	sa_manager->align = align;
 	sa_manager->hole = &sa_manager->olist;
 	INIT_LIST_HEAD(&sa_manager->olist);
 	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 		INIT_LIST_HEAD(&sa_manager->flist[i]);
 	}
 
-	r = radeon_bo_create(rdev, size, RADEON_GPU_PAGE_SIZE, true,
+	r = radeon_bo_create(rdev, size, align, true,
 			     domain, NULL, &sa_manager->bo);
 	if (r) {
 		dev_err(rdev->dev, "(%d) failed to allocate bo for manager\n", r);
@@ -317,7 +318,7 @@ int radeon_sa_bo_new(struct radeon_device *rdev,
 	unsigned tries[RADEON_NUM_RINGS];
 	int i, r;
 
-	BUG_ON(align > RADEON_GPU_PAGE_SIZE);
+	BUG_ON(align > sa_manager->align);
 	BUG_ON(size > sa_manager->size);
 
 	*sa_bo = kmalloc(sizeof(struct radeon_sa_bo), GFP_KERNEL);
-- 
1.8.1.2

