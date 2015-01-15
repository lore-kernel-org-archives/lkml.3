Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbbAOP52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:57:28 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54483 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbbAOP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:57:26 -0500
Message-ID: <1421337444.12868.4.camel@x220>
Subject: Re: [PATCH] drm/radeon/rv515: Remove unused function
From: Paul Bolle <pebolle@tiscali.nl>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Jan 2015 16:57:24 +0100
In-Reply-To: <CAH3drwacXXPMNDTEaBHFOzOY9PdYgSp9XhimVvHrP3xJg6eEuA@mail.gmail.com>
References: <1421175345-6635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <CADnq5_PnbTcdUezO5q4RzWUW=YWcEBty_J=b9e0FQFgMO6yKMw@mail.gmail.com>
	 <CAH3drwacXXPMNDTEaBHFOzOY9PdYgSp9XhimVvHrP3xJg6eEuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2015 15:57:24.0525 (UTC) FILETIME=[F41CE5D0:01D030DB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 10:43 -0500, Jerome Glisse wrote:
> This one looks highly suspicious, i need to check, but i would think
> that this function should be use !

Have a look at commit 76a0df859def ("drm/radeon: rework ring function
handling"), which removed the two users of rv515_ring_start.

I don't think Rickard ever included information like that in this
seemingly unending series. I'd guess looking for information like that
might slow things down, but it would aid the reviewers and improve the
overall quality of the series.

> On Wed, Jan 14, 2015 at 4:44 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Tue, Jan 13, 2015 at 1:55 PM, Rickard Strandqvist
> > <rickard_strandqvist@spectrumdigital.se> wrote:
> >> Remove the function rv515_ring_start() that is not used anywhere.
> >>
> >> This was partially found by using a static code analysis program called cppcheck.
> >>
> >> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >
> > Applied.  thanks!
> >
> > Alex
> >
> >> ---
> >>  drivers/gpu/drm/radeon/radeon_asic.h |    1 -
> >>  drivers/gpu/drm/radeon/rv515.c       |   68 ----------------------------------
> >>  2 files changed, 69 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
> >> index d8ace5b..52667b3 100644
> >> --- a/drivers/gpu/drm/radeon/radeon_asic.h
> >> +++ b/drivers/gpu/drm/radeon/radeon_asic.h
> >> @@ -280,7 +280,6 @@ int rv515_init(struct radeon_device *rdev);
> >>  void rv515_fini(struct radeon_device *rdev);
> >>  uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg);
> >>  void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
> >> -void rv515_ring_start(struct radeon_device *rdev, struct radeon_ring *ring);
> >>  void rv515_bandwidth_update(struct radeon_device *rdev);
> >>  int rv515_resume(struct radeon_device *rdev);
> >>  int rv515_suspend(struct radeon_device *rdev);
> >> diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
> >> index 8a477bf..cb966e6 100644
> >> --- a/drivers/gpu/drm/radeon/rv515.c
> >> +++ b/drivers/gpu/drm/radeon/rv515.c
> >> @@ -59,74 +59,6 @@ void rv515_debugfs(struct radeon_device *rdev)
> >>         }
> >>  }
> >>
> >> -void rv515_ring_start(struct radeon_device *rdev, struct radeon_ring *ring)
> >> -{
> >> -       int r;
> >> -
> >> -       r = radeon_ring_lock(rdev, ring, 64);
> >> -       if (r) {
> >> -               return;
> >> -       }
> >> -       radeon_ring_write(ring, PACKET0(ISYNC_CNTL, 0));
> >> -       radeon_ring_write(ring,
> >> -                         ISYNC_ANY2D_IDLE3D |
> >> -                         ISYNC_ANY3D_IDLE2D |
> >> -                         ISYNC_WAIT_IDLEGUI |
> >> -                         ISYNC_CPSCRATCH_IDLEGUI);
> >> -       radeon_ring_write(ring, PACKET0(WAIT_UNTIL, 0));
> >> -       radeon_ring_write(ring, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
> >> -       radeon_ring_write(ring, PACKET0(R300_DST_PIPE_CONFIG, 0));
> >> -       radeon_ring_write(ring, R300_PIPE_AUTO_CONFIG);
> >> -       radeon_ring_write(ring, PACKET0(GB_SELECT, 0));
> >> -       radeon_ring_write(ring, 0);
> >> -       radeon_ring_write(ring, PACKET0(GB_ENABLE, 0));
> >> -       radeon_ring_write(ring, 0);
> >> -       radeon_ring_write(ring, PACKET0(R500_SU_REG_DEST, 0));
> >> -       radeon_ring_write(ring, (1 << rdev->num_gb_pipes) - 1);
> >> -       radeon_ring_write(ring, PACKET0(VAP_INDEX_OFFSET, 0));
> >> -       radeon_ring_write(ring, 0);
> >> -       radeon_ring_write(ring, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
> >> -       radeon_ring_write(ring, RB3D_DC_FLUSH | RB3D_DC_FREE);
> >> -       radeon_ring_write(ring, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
> >> -       radeon_ring_write(ring, ZC_FLUSH | ZC_FREE);
> >> -       radeon_ring_write(ring, PACKET0(WAIT_UNTIL, 0));
> >> -       radeon_ring_write(ring, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
> >> -       radeon_ring_write(ring, PACKET0(GB_AA_CONFIG, 0));
> >> -       radeon_ring_write(ring, 0);
> >> -       radeon_ring_write(ring, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
> >> -       radeon_ring_write(ring, RB3D_DC_FLUSH | RB3D_DC_FREE);
> >> -       radeon_ring_write(ring, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
> >> -       radeon_ring_write(ring, ZC_FLUSH | ZC_FREE);
> >> -       radeon_ring_write(ring, PACKET0(GB_MSPOS0, 0));
> >> -       radeon_ring_write(ring,
> >> -                         ((6 << MS_X0_SHIFT) |
> >> -                          (6 << MS_Y0_SHIFT) |
> >> -                          (6 << MS_X1_SHIFT) |
> >> -                          (6 << MS_Y1_SHIFT) |
> >> -                          (6 << MS_X2_SHIFT) |
> >> -                          (6 << MS_Y2_SHIFT) |
> >> -                          (6 << MSBD0_Y_SHIFT) |
> >> -                          (6 << MSBD0_X_SHIFT)));
> >> -       radeon_ring_write(ring, PACKET0(GB_MSPOS1, 0));
> >> -       radeon_ring_write(ring,
> >> -                         ((6 << MS_X3_SHIFT) |
> >> -                          (6 << MS_Y3_SHIFT) |
> >> -                          (6 << MS_X4_SHIFT) |
> >> -                          (6 << MS_Y4_SHIFT) |
> >> -                          (6 << MS_X5_SHIFT) |
> >> -                          (6 << MS_Y5_SHIFT) |
> >> -                          (6 << MSBD1_SHIFT)));
> >> -       radeon_ring_write(ring, PACKET0(GA_ENHANCE, 0));
> >> -       radeon_ring_write(ring, GA_DEADLOCK_CNTL | GA_FASTSYNC_CNTL);
> >> -       radeon_ring_write(ring, PACKET0(GA_POLY_MODE, 0));
> >> -       radeon_ring_write(ring, FRONT_PTYPE_TRIANGE | BACK_PTYPE_TRIANGE);
> >> -       radeon_ring_write(ring, PACKET0(GA_ROUND_MODE, 0));
> >> -       radeon_ring_write(ring, GEOMETRY_ROUND_NEAREST | COLOR_ROUND_NEAREST);
> >> -       radeon_ring_write(ring, PACKET0(0x20C8, 0));
> >> -       radeon_ring_write(ring, 0);
> >> -       radeon_ring_unlock_commit(rdev, ring, false);
> >> -}
> >> -
> >>  int rv515_mc_wait_for_idle(struct radeon_device *rdev)
> >>  {
> >>         unsigned i;
> >> --
> >> 1.7.10.4


Paul Bolle

