Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbbAOKsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:48:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbAOKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:48:37 -0500
Date: Thu, 15 Jan 2015 10:48:56 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@intel.com>, Thomas Voegtle <tv@lio96.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 3.16.y-ckt 075/216] drm/i915: Disallow pin ioctl
 completely for kms drivers
Message-ID: <20150115104856.GA5176@charon>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
 <1421085933-32536-76-git-send-email-luis.henriques@canonical.com>
 <20150113193357.GB24809@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150113193357.GB24809@charon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 07:33:57PM +0000, Luis Henriques wrote:
> On Mon, Jan 12, 2015 at 06:03:12PM +0000, Luis Henriques wrote:
> > 3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.
> >
> 
> Hi Daniel and Chris,
> 
> Thomas Voegtle (on Cc:) reported a regression in 3.16.7-ckt4, and he
> traced the issue to this commit.  You can see the whole thread in the
> 3.16.7-ckt4 stable review email, or here:
> 
>  http://thread.gmane.org/gmane.linux.kernel.stable/119818/focus=120043
> 
> Any suggestions/ideas before I drop this patch?  It seems odd to me
> that this patch causes a memory leak, but I don't really know the
> code.
>

This patch has been dropped from 3.16.7-ckt4.

Cheers,
--
Luís

> Cheers,
> --
> Luís
> 
> > ------------------
> > 
> > From: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > commit d472fcc8379c062bd56a3876fc6ef22258f14a91 upstream.
> > 
> > The problem here is that SNA pins batchbuffers to etch out a bit more
> > performance. Iirc it started out as a w/a for i830M (which we've
> > implemented in the kernel since a long time already). The problem is
> > that the pin ioctl wasn't added in
> > 
> > commit d23db88c3ab233daed18709e3a24d6c95344117f
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Fri May 23 08:48:08 2014 +0200
> > 
> >     drm/i915: Prevent negative relocation deltas from wrapping
> > 
> > Fix this by simply disallowing pinning from userspace so that the
> > kernel is in full control of batch placement again. Especially since
> > distros are moving towards running X as non-root, so most users won't
> > even be able to see any benefits.
> > 
> > UMS support is dead now, but we need this minimal patch for
> > backporting. Follow-up patch will remove the pin ioctl code
> > completely.
> > 
> > Note to backporters: You must have both
> > 
> > commit b45305fce5bb1abec263fcff9d81ebecd6306ede
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Mon Dec 17 16:21:27 2012 +0100
> > 
> >     drm/i915: Implement workaround for broken CS tlb on i830/845
> > 
> > which laned in 3.8 and
> > 
> > commit c4d69da167fa967749aeb70bc0e94a457e5d00c1
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Mon Sep 8 14:25:41 2014 +0100
> > 
> >     drm/i915: Evict CS TLBs between batches
> > 
> > which is also marked cc: stable. Otherwise this could introduce a
> > regression by disabling the userspace w/a without the kernel w/a being
> > fully functional on i830/45.
> > 
> > References: https://bugs.freedesktop.org/show_bug.cgi?id=76554#c116
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index ef3b4798da02..05cf35a972e5 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -4129,7 +4129,7 @@ i915_gem_pin_ioctl(struct drm_device *dev, void *data,
> >  	struct drm_i915_gem_object *obj;
> >  	int ret;
> >  
> > -	if (INTEL_INFO(dev)->gen >= 6)
> > +	if (drm_core_check_feature(dev, DRIVER_MODESET))
> >  		return -ENODEV;
> >  
> >  	ret = i915_mutex_lock_interruptible(dev);
> > @@ -4222,6 +4222,9 @@ i915_gem_busy_ioctl(struct drm_device *dev, void *data,
> >  	struct drm_i915_gem_object *obj;
> >  	int ret;
> >  
> > +	if (drm_core_check_feature(dev, DRIVER_MODESET))
> > +		return -ENODEV;
> > +
> >  	ret = i915_mutex_lock_interruptible(dev);
> >  	if (ret)
> >  		return ret;
> > -- 
> > 2.1.4
> > 
> 
> -- 
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
