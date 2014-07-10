Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaGJV5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:50 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56123 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaGJV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:47 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 82/83] drm/radeon: Remove lock functions from kfd2kgd interface
Date: Fri, 11 Jul 2014 00:54:38 +0300
Message-Id: <1405029279-6894-54-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 44 -------------------------------------
 include/linux/radeon_kfd.h          | 10 ---------
 2 files changed, 54 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 738c2b3..7e8e041 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -115,12 +115,6 @@ static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
 static uint64_t get_vmem_size(struct kgd_dev *kgd);
 static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd);
 
-static void lock_srbm_gfx_cntl(struct kgd_dev *kgd);
-static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
-
-static void lock_grbm_gfx_idx(struct kgd_dev *kgd);
-static void unlock_grbm_gfx_idx(struct kgd_dev *kgd);
-
 static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd);
 
 /*
@@ -146,10 +140,6 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.unkmap_mem = unkmap_mem,
 	.get_vmem_size = get_vmem_size,
 	.get_gpu_clock_counter = get_gpu_clock_counter,
-	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
-	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
-	.lock_grbm_gfx_idx = lock_grbm_gfx_idx,
-	.unlock_grbm_gfx_idx = unlock_grbm_gfx_idx,
 	.get_max_engine_clock_in_mhz = get_max_engine_clock_in_mhz,
 	.program_sh_mem_settings = kgd_program_sh_mem_settings,
 	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
@@ -200,8 +190,6 @@ void radeon_kfd_device_init(struct radeon_device *rdev)
 {
 	if (rdev->kfd) {
 		struct kgd2kfd_shared_resources gpu_resources = {
-			.mmio_registers = rdev->rmmio,
-
 			.compute_vmid_bitmap = 0xFF00,
 
 			.first_compute_pipe = 1,
@@ -363,38 +351,6 @@ static uint64_t get_vmem_size(struct kgd_dev *kgd)
 	return rdev->mc.real_vram_size;
 }
 
-static void lock_srbm_gfx_cntl(struct kgd_dev *kgd)
-{
-	struct radeon_device *rdev = (struct radeon_device *)kgd;
-
-	mutex_lock(&rdev->srbm_mutex);
-}
-
-static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd)
-{
-	struct radeon_device *rdev = (struct radeon_device *)kgd;
-
-	mutex_unlock(&rdev->srbm_mutex);
-}
-
-static void lock_grbm_gfx_idx(struct kgd_dev *kgd)
-{
-	struct radeon_device *rdev = (struct radeon_device *)kgd;
-
-	BUG_ON(kgd == NULL);
-
-	mutex_lock(&rdev->grbm_idx_mutex);
-}
-
-static void unlock_grbm_gfx_idx(struct kgd_dev *kgd)
-{
-	struct radeon_device *rdev = (struct radeon_device *)kgd;
-
-	BUG_ON(kgd == NULL);
-
-	mutex_unlock(&rdev->grbm_idx_mutex);
-}
-
 static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
 {
 	struct radeon_device *rdev = (struct radeon_device *)kgd;
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index aa021fb..2fffe32 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -45,8 +45,6 @@ enum kgd_memory_pool {
 };
 
 struct kgd2kfd_shared_resources {
-	void __iomem *mmio_registers; /* Mapped pointer to GFX MMIO registers. */
-
 	unsigned int compute_vmid_bitmap; /* Bit n == 1 means VMID n is available for KFD. */
 
 	unsigned int first_compute_pipe; /* Compute pipes are counted starting from MEC0/pipe0 as 0. */
@@ -86,14 +84,6 @@ struct kfd2kgd_calls {
 	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
 	uint64_t (*get_gpu_clock_counter)(struct kgd_dev *kgd);
 
-	/* SRBM_GFX_CNTL mutex */
-	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
-	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
-
-	/* GRBM_GFX_INDEX mutex */
-	void (*lock_grbm_gfx_idx)(struct kgd_dev *kgd);
-	void (*unlock_grbm_gfx_idx)(struct kgd_dev *kgd);
-
 	uint32_t (*get_max_engine_clock_in_mhz)(struct kgd_dev *kgd);
 
 	/* Register access functions */
-- 
1.9.1

