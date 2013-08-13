Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3HMGdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3HMGdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 55/60] drm/radeon: fix halting UVD
Date: Mon, 12 Aug 2013 23:34:22 -0700
Message-Id: <20130813063338.794132203@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 2858c00d2823c83acce2a1175dbabb2cebee8678 upstream.

Removing the clock/power or resetting the VCPU can cause
hangs if that happens in the middle of a register write.

Stall the memory and register bus before putting the VCPU
into reset. Keep it in reset when unloading the module or
suspending.

v2: rebased on 3.10-stable tree

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c   |    3 ++-
 drivers/gpu/drm/radeon/ni.c          |    3 ++-
 drivers/gpu/drm/radeon/r600.c        |   28 +++++++++++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_asic.h |    2 +-
 drivers/gpu/drm/radeon/rv770.c       |    2 ++
 drivers/gpu/drm/radeon/si.c          |    6 ++++--
 6 files changed, 34 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4854,10 +4854,10 @@ int evergreen_resume(struct radeon_devic
 int evergreen_suspend(struct radeon_device *rdev)
 {
 	r600_audio_fini(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_suspend(rdev);
 	r700_cp_stop(rdev);
 	r600_dma_stop(rdev);
-	r600_uvd_rbc_stop(rdev);
 	evergreen_irq_suspend(rdev);
 	radeon_wb_disable(rdev);
 	evergreen_pcie_gart_disable(rdev);
@@ -4988,6 +4988,7 @@ void evergreen_fini(struct radeon_device
 	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	evergreen_pcie_gart_fini(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_fini(rdev);
 	r600_vram_scratch_fini(rdev);
 	radeon_gem_fini(rdev);
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -2133,7 +2133,7 @@ int cayman_suspend(struct radeon_device
 	radeon_vm_manager_fini(rdev);
 	cayman_cp_enable(rdev, false);
 	cayman_dma_stop(rdev);
-	r600_uvd_rbc_stop(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_suspend(rdev);
 	evergreen_irq_suspend(rdev);
 	radeon_wb_disable(rdev);
@@ -2265,6 +2265,7 @@ void cayman_fini(struct radeon_device *r
 	radeon_vm_manager_fini(rdev);
 	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_fini(rdev);
 	cayman_pcie_gart_fini(rdev);
 	r600_vram_scratch_fini(rdev);
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2675,12 +2675,29 @@ int r600_uvd_rbc_start(struct radeon_dev
 	return 0;
 }
 
-void r600_uvd_rbc_stop(struct radeon_device *rdev)
+void r600_uvd_stop(struct radeon_device *rdev)
 {
 	struct radeon_ring *ring = &rdev->ring[R600_RING_TYPE_UVD_INDEX];
 
 	/* force RBC into idle state */
 	WREG32(UVD_RBC_RB_CNTL, 0x11010101);
+
+	/* Stall UMC and register bus before resetting VCPU */
+	WREG32_P(UVD_LMI_CTRL2, 1 << 8, ~(1 << 8));
+	WREG32_P(UVD_RB_ARB_CTRL, 1 << 3, ~(1 << 3));
+	mdelay(1);
+
+	/* put VCPU into reset */
+	WREG32(UVD_SOFT_RESET, VCPU_SOFT_RESET);
+	mdelay(5);
+
+	/* disable VCPU clock */
+	WREG32(UVD_VCPU_CNTL, 0x0);
+
+	/* Unstall UMC and register bus */
+	WREG32_P(UVD_LMI_CTRL2, 0, ~(1 << 8));
+	WREG32_P(UVD_RB_ARB_CTRL, 0, ~(1 << 3));
+
 	ring->ready = false;
 }
 
@@ -2700,6 +2717,11 @@ int r600_uvd_init(struct radeon_device *
 	/* disable interupt */
 	WREG32_P(UVD_MASTINT_EN, 0, ~(1 << 1));
 
+	/* Stall UMC and register bus before resetting VCPU */
+	WREG32_P(UVD_LMI_CTRL2, 1 << 8, ~(1 << 8));
+	WREG32_P(UVD_RB_ARB_CTRL, 1 << 3, ~(1 << 3));
+	mdelay(1);
+
 	/* put LMI, VCPU, RBC etc... into reset */
 	WREG32(UVD_SOFT_RESET, LMI_SOFT_RESET | VCPU_SOFT_RESET |
 	       LBSI_SOFT_RESET | RBC_SOFT_RESET | CSM_SOFT_RESET |
@@ -2729,10 +2751,6 @@ int r600_uvd_init(struct radeon_device *
 	WREG32(UVD_MPC_SET_ALU, 0);
 	WREG32(UVD_MPC_SET_MUX, 0x88);
 
-	/* Stall UMC */
-	WREG32_P(UVD_LMI_CTRL2, 1 << 8, ~(1 << 8));
-	WREG32_P(UVD_RB_ARB_CTRL, 1 << 3, ~(1 << 3));
-
 	/* take all subblocks out of reset, except VCPU */
 	WREG32(UVD_SOFT_RESET, VCPU_SOFT_RESET);
 	mdelay(5);
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -399,7 +399,7 @@ uint64_t r600_get_gpu_clock_counter(stru
 /* uvd */
 int r600_uvd_init(struct radeon_device *rdev);
 int r600_uvd_rbc_start(struct radeon_device *rdev);
-void r600_uvd_rbc_stop(struct radeon_device *rdev);
+void r600_uvd_stop(struct radeon_device *rdev);
 int r600_uvd_ib_test(struct radeon_device *rdev, struct radeon_ring *ring);
 void r600_uvd_fence_emit(struct radeon_device *rdev,
 			 struct radeon_fence *fence);
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1983,6 +1983,7 @@ int rv770_resume(struct radeon_device *r
 int rv770_suspend(struct radeon_device *rdev)
 {
 	r600_audio_fini(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_suspend(rdev);
 	r700_cp_stop(rdev);
 	r600_dma_stop(rdev);
@@ -2098,6 +2099,7 @@ void rv770_fini(struct radeon_device *rd
 	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	rv770_pcie_gart_fini(rdev);
+	r600_uvd_stop(rdev);
 	radeon_uvd_fini(rdev);
 	r600_vram_scratch_fini(rdev);
 	radeon_gem_fini(rdev);
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5473,7 +5473,7 @@ int si_suspend(struct radeon_device *rde
 	si_cp_enable(rdev, false);
 	cayman_dma_stop(rdev);
 	if (rdev->has_uvd) {
-		r600_uvd_rbc_stop(rdev);
+		r600_uvd_stop(rdev);
 		radeon_uvd_suspend(rdev);
 	}
 	si_irq_suspend(rdev);
@@ -5613,8 +5613,10 @@ void si_fini(struct radeon_device *rdev)
 	radeon_vm_manager_fini(rdev);
 	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
-	if (rdev->has_uvd)
+	if (rdev->has_uvd) {
+		r600_uvd_stop(rdev);
 		radeon_uvd_fini(rdev);
+	}
 	si_pcie_gart_fini(rdev);
 	r600_vram_scratch_fini(rdev);
 	radeon_gem_fini(rdev);


