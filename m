Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaIHJKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:10:10 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:43663 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753125AbaIHJKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:10:08 -0400
Message-ID: <540D7267.6040003@daenzer.net>
Date: Mon, 08 Sep 2014 18:09:59 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mikael Pettersson <mikpelinux@gmail.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [BISECTED] 3.17-rc1 radeon screen corruption due to "Always flush
 the HDP cache before submitting a CS to the GPU"
References: <21505.55482.547592.906934@gargle.gargle.HOWL> <540572EC.4070909@daenzer.net> <21513.59790.188508.307463@gargle.gargle.HOWL>
In-Reply-To: <21513.59790.188508.307463@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.2014 01:49, Mikael Pettersson wrote:
> Michel Dänzer writes:
>   > On 30.08.2014 22:59, Mikael Pettersson wrote:
>   > > Since 3.17-rc1 my radeon card (RV370 / X1050 card) causes screen corruption
>   > > after a while in X + firefox.  This still occurs with yesterday's HEAD
>   > > of Linus' repo.  3.16 and ealier kernels are fine.
>   > >
>   > > I ran a bisect, which identified:
>   > >
>   > > commit 72a9987edcedb89db988079a03c9b9c65b6ec9ac
>   > > Author: Michel DÃ¤nzer <michel.daenzer@amd.com>
>   > > Date:   Thu Jul 31 18:43:49 2014 +0900
>   > >
>   > >      drm/radeon: Always flush the HDP cache before submitting a CS to the GPU
>   > >
>   > > as the cause of my screen corruption.  Reverting this from 3.17-rc2
>   > > (which requires manual intervention due to subsequent changes in
>   > > radeon_ring_commit()) eliminates the screen corruption.
>   >
>   > Does the patch below help?
> 
> Tested, sorry no joy.  I first reconfirmed the screen corruption with 3.17-rc3.
> I then applied this and rebuilt/rebooted, and after a few minutes X had a hickup
> (screen went black, came back after a few seconds, but then no cursor or
> reaction to mouse events), but I was able to kill it via my Terminate_Server
> key binding.

I was afraid so, thanks for testing it.


I can't see any other option than the patch below then. Can you confirm that this
fixes the screen corruption?


diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 4c5ec44..b0098e7 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -821,6 +821,20 @@ u32 r100_get_vblank_counter(struct radeon_device *rdev, int crtc)
 		return RREG32(RADEON_CRTC2_CRNT_FRAME);
 }
 
+/**
+ * r100_ring_hdp_flush - flush Host Data Path via the ring buffer
+ * rdev: radeon device structure
+ * ring: ring buffer struct for emitting packets
+ */
+static void r100_ring_hdp_flush(struct radeon_device *rdev, struct radeon_ring *ring)
+{
+	radeon_ring_write(ring, PACKET0(RADEON_HOST_PATH_CNTL, 0));
+	radeon_ring_write(ring, rdev->config.r100.hdp_cntl |
+				RADEON_HDP_READ_BUFFER_INVALIDATE);
+	radeon_ring_write(ring, PACKET0(RADEON_HOST_PATH_CNTL, 0));
+	radeon_ring_write(ring, rdev->config.r100.hdp_cntl);
+}
+
 /* Who ever call radeon_fence_emit should call ring_lock and ask
  * for enough space (today caller are ib schedule and buffer move) */
 void r100_fence_ring_emit(struct radeon_device *rdev,
@@ -1056,20 +1070,6 @@ void r100_gfx_set_wptr(struct radeon_device *rdev,
 	(void)RREG32(RADEON_CP_RB_WPTR);
 }
 
-/**
- * r100_ring_hdp_flush - flush Host Data Path via the ring buffer
- * rdev: radeon device structure
- * ring: ring buffer struct for emitting packets
- */
-void r100_ring_hdp_flush(struct radeon_device *rdev, struct radeon_ring *ring)
-{
-	radeon_ring_write(ring, PACKET0(RADEON_HOST_PATH_CNTL, 0));
-	radeon_ring_write(ring, rdev->config.r100.hdp_cntl |
-				RADEON_HDP_READ_BUFFER_INVALIDATE);
-	radeon_ring_write(ring, PACKET0(RADEON_HOST_PATH_CNTL, 0));
-	radeon_ring_write(ring, rdev->config.r100.hdp_cntl);
-}
-
 static void r100_cp_load_microcode(struct radeon_device *rdev)
 {
 	const __be32 *fw_data;
diff --git a/drivers/gpu/drm/radeon/radeon_asic.c b/drivers/gpu/drm/radeon/radeon_asic.c
index eeeeabe..2dd5847 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -185,7 +185,6 @@ static struct radeon_asic_ring r100_gfx_ring = {
 	.get_rptr = &r100_gfx_get_rptr,
 	.get_wptr = &r100_gfx_get_wptr,
 	.set_wptr = &r100_gfx_set_wptr,
-	.hdp_flush = &r100_ring_hdp_flush,
 };
 
 static struct radeon_asic r100_asic = {
@@ -332,7 +331,6 @@ static struct radeon_asic_ring r300_gfx_ring = {
 	.get_rptr = &r100_gfx_get_rptr,
 	.get_wptr = &r100_gfx_get_wptr,
 	.set_wptr = &r100_gfx_set_wptr,
-	.hdp_flush = &r100_ring_hdp_flush,
 };
 
 static struct radeon_asic r300_asic = {
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 275a5dc..7756bc1 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -148,8 +148,7 @@ u32 r100_gfx_get_wptr(struct radeon_device *rdev,
 		      struct radeon_ring *ring);
 void r100_gfx_set_wptr(struct radeon_device *rdev,
 		       struct radeon_ring *ring);
-void r100_ring_hdp_flush(struct radeon_device *rdev,
-			 struct radeon_ring *ring);
+
 /*
  * r200,rv250,rs300,rv280
  */
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index a773830..ef5b60a 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -83,7 +83,7 @@
  *            CIK: 1D and linear tiling modes contain valid PIPE_CONFIG
  *   2.39.0 - Add INFO query for number of active CUs
  *   2.40.0 - Add RADEON_GEM_GTT_WC/UC, flush HDP cache before submitting
- *            CS to GPU
+ *            CS to GPU on >= r600
  */
 #define KMS_DRIVER_MAJOR	2
 #define KMS_DRIVER_MINOR	40



-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
