Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaIEQtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:49:24 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:37002 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaIEQtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:49:23 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <21513.59790.188508.307463@gargle.gargle.HOWL>
Date: Fri, 5 Sep 2014 18:49:18 +0200
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [BISECTED] 3.17-rc1 radeon screen corruption due to "Always flush
 the HDP cache before submitting a CS to the GPU"
In-Reply-To: <540572EC.4070909@daenzer.net>
References: <21505.55482.547592.906934@gargle.gargle.HOWL>
	<540572EC.4070909@daenzer.net>
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Dänzer writes:
 > On 30.08.2014 22:59, Mikael Pettersson wrote:
 > > Since 3.17-rc1 my radeon card (RV370 / X1050 card) causes screen corruption
 > > after a while in X + firefox.  This still occurs with yesterday's HEAD
 > > of Linus' repo.  3.16 and ealier kernels are fine.
 > > 
 > > I ran a bisect, which identified:
 > > 
 > > commit 72a9987edcedb89db988079a03c9b9c65b6ec9ac
 > > Author: Michel DÃ¤nzer <michel.daenzer@amd.com>
 > > Date:   Thu Jul 31 18:43:49 2014 +0900
 > > 
 > >      drm/radeon: Always flush the HDP cache before submitting a CS to the GPU
 > > 
 > > as the cause of my screen corruption.  Reverting this from 3.17-rc2
 > > (which requires manual intervention due to subsequent changes in
 > > radeon_ring_commit()) eliminates the screen corruption.
 > 
 > Does the patch below help?

Tested, sorry no joy.  I first reconfirmed the screen corruption with 3.17-rc3.
I then applied this and rebuilt/rebooted, and after a few minutes X had a hickup
(screen went black, came back after a few seconds, but then no cursor or
reaction to mouse events), but I was able to kill it via my Terminate_Server
key binding.  The kernel log showed:

[ 1641.247760] radeon 0000:01:00.0: ring 0 stalled for more than 10000msec
[ 1641.247765] radeon 0000:01:00.0: GPU lockup (waiting for 0x0000000000006241 last fence id 0x0000000000006240 on ring 0)
[ 1641.247768] radeon 0000:01:00.0: failed to get a new IB (-35)
[ 1641.247770] [drm:radeon_cs_ib_fill] *ERROR* Failed to get ib !
[ 1641.404052] Failed to wait GUI idle while programming pipes. Bad things might happen.
[ 1641.405075] radeon 0000:01:00.0: Saved 859 dwords of commands on ring 0.
[ 1641.405084] radeon 0000:01:00.0: (r300_asic_reset:394) RBBM_STATUS=0x80010140
[ 1641.910649] radeon 0000:01:00.0: (r300_asic_reset:413) RBBM_STATUS=0x80010140
[ 1642.412182] radeon 0000:01:00.0: (r300_asic_reset:425) RBBM_STATUS=0x00000140
[ 1642.412218] radeon 0000:01:00.0: GPU reset succeed
[ 1642.412220] radeon 0000:01:00.0: GPU reset succeeded, trying to resume
[ 1642.412224] radeon 0000:01:00.0: ffff88060274f800 unpin not necessary
[ 1642.626303] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[ 1642.626325] [drm] PCIE GART of 512M enabled (table at 0x00000000E0040000).
[ 1642.626328] radeon 0000:01:00.0: WB enabled
[ 1642.626331] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x00000000c0000000 and cpu addr 0xffff8800d9b9f000
[ 1642.626375] [drm] radeon: ring at 0x00000000C0001000
[ 1642.783220] [drm:r100_ring_test] *ERROR* radeon: ring test failed (scratch(0x15E8)=0xCAFEDEAD)
[ 1642.783222] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
[ 1642.783224] radeon 0000:01:00.0: failed initializing CP (-22).

With a revert of the HDP flush patch things are stable.

/Mikael

 > 
 > diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
 > index 4c5ec44..3ff9c53 100644
 > --- a/drivers/gpu/drm/radeon/r100.c
 > +++ b/drivers/gpu/drm/radeon/r100.c
 > @@ -1070,6 +1070,20 @@ void r100_ring_hdp_flush(struct radeon_device *rdev, struct radeon_ring *ring)
 >  	radeon_ring_write(ring, rdev->config.r100.hdp_cntl);
 >  }
 >  
 > +/**
 > + * r100_mmio_hdp_flush - flush Host Data Path via MMIO
 > + * rdev: radeon device structure
 > + */
 > +void r100_mmio_hdp_flush(struct radeon_device *rdev)
 > +{
 > +	WREG32(RADEON_HOST_PATH_CNTL,
 > +	       rdev->config.r100.hdp_cntl | RADEON_HDP_READ_BUFFER_INVALIDATE);
 > +	(void)RREG32(RADEON_HOST_PATH_CNTL);
 > +	WREG32(RADEON_HOST_PATH_CNTL,
 > +	       rdev->config.r100.hdp_cntl);
 > +	(void)RREG32(RADEON_HOST_PATH_CNTL);
 > +}
 > +
 >  static void r100_cp_load_microcode(struct radeon_device *rdev)
 >  {
 >  	const __be32 *fw_data;
 > diff --git a/drivers/gpu/drm/radeon/radeon_asic.c b/drivers/gpu/drm/radeon/radeon_asic.c
 > index eeeeabe..c23a123 100644
 > --- a/drivers/gpu/drm/radeon/radeon_asic.c
 > +++ b/drivers/gpu/drm/radeon/radeon_asic.c
 > @@ -408,7 +408,7 @@ static struct radeon_asic r300_asic_pcie = {
 >  	.resume = &r300_resume,
 >  	.vga_set_state = &r100_vga_set_state,
 >  	.asic_reset = &r300_asic_reset,
 > -	.mmio_hdp_flush = NULL,
 > +	.mmio_hdp_flush = r100_mmio_hdp_flush,
 >  	.gui_idle = &r100_gui_idle,
 >  	.mc_wait_for_idle = &r300_mc_wait_for_idle,
 >  	.gart = {
 > diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
 > index 275a5dc..e9b1c35 100644
 > --- a/drivers/gpu/drm/radeon/radeon_asic.h
 > +++ b/drivers/gpu/drm/radeon/radeon_asic.h
 > @@ -150,6 +150,8 @@ void r100_gfx_set_wptr(struct radeon_device *rdev,
 >  		       struct radeon_ring *ring);
 >  void r100_ring_hdp_flush(struct radeon_device *rdev,
 >  			 struct radeon_ring *ring);
 > +void r100_mmio_hdp_flush(struct radeon_device *rdev);
 > +
 >  /*
 >   * r200,rv250,rs300,rv280
 >   */
 > diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
 > index bfd7e1b..3d0f564 100644
 > --- a/drivers/gpu/drm/radeon/radeon_gem.c
 > +++ b/drivers/gpu/drm/radeon/radeon_gem.c
 > @@ -368,6 +368,7 @@ int radeon_gem_wait_idle_ioctl(struct drm_device *dev, void *data,
 >  	r = radeon_bo_wait(robj, &cur_placement, false);
 >  	/* Flush HDP cache via MMIO if necessary */
 >  	if (rdev->asic->mmio_hdp_flush &&
 > +	    !rdev->asic->ring[RADEON_RING_TYPE_GFX_INDEX]->hdp_flush &&
 >  	    radeon_mem_type_to_domain(cur_placement) == RADEON_GEM_DOMAIN_VRAM)
 >  		robj->rdev->asic->mmio_hdp_flush(rdev);
 >  	drm_gem_object_unreference_unlocked(gobj);
 > diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
 > index d656079..b82843b 100644
 > --- a/drivers/gpu/drm/radeon/radeon_ring.c
 > +++ b/drivers/gpu/drm/radeon/radeon_ring.c
 > @@ -188,7 +188,8 @@ void radeon_ring_commit(struct radeon_device *rdev, struct radeon_ring *ring,
 >  	/* If we are emitting the HDP flush via the ring buffer, we need to
 >  	 * do it before padding.
 >  	 */
 > -	if (hdp_flush && rdev->asic->ring[ring->idx]->hdp_flush)
 > +	if (hdp_flush && rdev->asic->ring[ring->idx]->hdp_flush &&
 > +	    !rdev->asic->mmio_hdp_flush)
 >  		rdev->asic->ring[ring->idx]->hdp_flush(rdev, ring);
 >  	/* We pad to match fetch size */
 >  	while (ring->wptr & ring->align_mask) {
 > 
 > 
 > 
 > -- 
 > Earthling Michel Dänzer            |                  http://www.amd.com
 > Libre software enthusiast          |                Mesa and X developer

-- 
