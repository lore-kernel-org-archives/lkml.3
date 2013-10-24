Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3JXVGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 17:06:53 -0400
Received: from bwidawsk.net ([166.78.191.112]:50112 "EHLO mail.bwidawsk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab3JXVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 17:06:52 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 17:06:52 EDT
Date: Thu, 24 Oct 2013 13:56:50 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Chuansheng Liu <chuansheng.liu@intel.com>, daniel.vetter@ffwll.ch,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        fei.li@intel.com
Subject: Re: [Intel-gfx] drm/i915: Avoid accessing the stolen address when it
 is unavailable
Message-ID: <20131024205650.GC28973@bwidawsk.net>
References: <1382632427.26153.94.camel@cliu38-desktop-build>
 <20131024121706.GB3233@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024121706.GB3233@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 01:17:06PM +0100, Chris Wilson wrote:
> On Fri, Oct 25, 2013 at 12:33:47AM +0800, Chuansheng Liu wrote:
> > 
> > In our platform, we hit the the stolen region initialization failure case,
> > such as below log:
> > [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7b000000]
> > 
> > And it causes the dev_priv->mm.stolen_base is NULL, in this case, we should
> > avoid accessing it any more.
> > 
> > Here is possible call trace:
> > intel_enable_gt_powersave -- >
> > valleyview_enable_rps -- >
> > valleyview_setup_pctx
> 
> The two create_stolen routines are no-ops in that case so all that
> happens instead is that we read VLV_PCBR. However, really if
> i915_gem_object_create_stolen_for_preallocated() fails we should abort
> loading the driver as it means we have a hardware conflict and undefined
> behaviour.
> -Chris
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre

I agree. We should start treating these things as errors since no
RPS/RC6 is essentially not what anyone wants.

For another immediate solution it seems you can demote the DRM_ERROR to
DRM_DEBUG_DRIVER, and add a check in valleyview_enable_rps for the pctx
value.

-- 
Ben Widawsky, Intel Open Source Technology Center
