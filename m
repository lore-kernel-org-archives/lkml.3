Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaIBHeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:34:14 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:49146 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbaIBHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:34:13 -0400
Message-ID: <540572EC.4070909@daenzer.net>
Date: Tue, 02 Sep 2014 16:34:04 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mikael Pettersson <mikpelinux@gmail.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [BISECTED] 3.17-rc1 radeon screen corruption due to "Always flush
 the HDP cache before submitting a CS to the GPU"
References: <21505.55482.547592.906934@gargle.gargle.HOWL>
In-Reply-To: <21505.55482.547592.906934@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.08.2014 22:59, Mikael Pettersson wrote:
> Since 3.17-rc1 my radeon card (RV370 / X1050 card) causes screen corruption
> after a while in X + firefox.  This still occurs with yesterday's HEAD
> of Linus' repo.  3.16 and ealier kernels are fine.
> 
> I ran a bisect, which identified:
> 
> commit 72a9987edcedb89db988079a03c9b9c65b6ec9ac
> Author: Michel DÃ¤nzer <michel.daenzer@amd.com>
> Date:   Thu Jul 31 18:43:49 2014 +0900
> 
>      drm/radeon: Always flush the HDP cache before submitting a CS to the GPU
> 
> as the cause of my screen corruption.  Reverting this from 3.17-rc2
> (which requires manual intervention due to subsequent changes in
> radeon_ring_commit()) eliminates the screen corruption.

Does the patch below help?

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 4c5ec44..3ff9c53 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1070,6 +1070,20 @@ void r100_ring_hdp_flush(struct radeon_device *rdev, struct radeon_ring *ring)
 	radeon_ring_write(ring, rdev->config.r100.hdp_cntl);
 }
 
+/**
+ * r100_mmio_hdp_flush - flush Host Data Path via MMIO
+ * rdev: radeon device structure
+ */
+void r100_mmio_hdp_flush(struct radeon_device *rdev)
+{
+	WREG32(RADEON_HOST_PATH_CNTL,
+	       rdev->config.r100.hdp_cntl | RADEON_HDP_READ_BUFFER_INVALIDATE);
+	(void)RREG32(RADEON_HOST_PATH_CNTL);
+	WREG32(RADEON_HOST_PATH_CNTL,
+	       rdev->config.r100.hdp_cntl);
+	(void)RREG32(RADEON_HOST_PATH_CNTL);
+}
+
 static void r100_cp_load_microcode(struct radeon_device *rdev)
 {
 	const __be32 *fw_data;
diff --git a/drivers/gpu/drm/radeon/radeon_asic.c b/drivers/gpu/drm/radeon/radeon_asic.c
index eeeeabe..c23a123 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -408,7 +408,7 @@ static struct radeon_asic r300_asic_pcie = {
 	.resume = &r300_resume,
 	.vga_set_state = &r100_vga_set_state,
 	.asic_reset = &r300_asic_reset,
-	.mmio_hdp_flush = NULL,
+	.mmio_hdp_flush = r100_mmio_hdp_flush,
 	.gui_idle = &r100_gui_idle,
 	.mc_wait_for_idle = &r300_mc_wait_for_idle,
 	.gart = {
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 275a5dc..e9b1c35 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -150,6 +150,8 @@ void r100_gfx_set_wptr(struct radeon_device *rdev,
 		       struct radeon_ring *ring);
 void r100_ring_hdp_flush(struct radeon_device *rdev,
 			 struct radeon_ring *ring);
+void r100_mmio_hdp_flush(struct radeon_device *rdev);
+
 /*
  * r200,rv250,rs300,rv280
  */
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index bfd7e1b..3d0f564 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -368,6 +368,7 @@ int radeon_gem_wait_idle_ioctl(struct drm_device *dev, void *data,
 	r = radeon_bo_wait(robj, &cur_placement, false);
 	/* Flush HDP cache via MMIO if necessary */
 	if (rdev->asic->mmio_hdp_flush &&
+	    !rdev->asic->ring[RADEON_RING_TYPE_GFX_INDEX]->hdp_flush &&
 	    radeon_mem_type_to_domain(cur_placement) == RADEON_GEM_DOMAIN_VRAM)
 		robj->rdev->asic->mmio_hdp_flush(rdev);
 	drm_gem_object_unreference_unlocked(gobj);
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index d656079..b82843b 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -188,7 +188,8 @@ void radeon_ring_commit(struct radeon_device *rdev, struct radeon_ring *ring,
 	/* If we are emitting the HDP flush via the ring buffer, we need to
 	 * do it before padding.
 	 */
-	if (hdp_flush && rdev->asic->ring[ring->idx]->hdp_flush)
+	if (hdp_flush && rdev->asic->ring[ring->idx]->hdp_flush &&
+	    !rdev->asic->mmio_hdp_flush)
 		rdev->asic->ring[ring->idx]->hdp_flush(rdev, ring);
 	/* We pad to match fetch size */
 	while (ring->wptr & ring->align_mask) {



-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
