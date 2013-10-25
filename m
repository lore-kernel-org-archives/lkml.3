Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3JYIHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:07:54 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:34289
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542Ab3JYIHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:07:47 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 25 Oct 2013 09:07:38 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Ben Widawsky <ben@bwidawsk.net>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Fei" <fei.li@intel.com>
Subject: Re: [Intel-gfx] drm/i915: Avoid accessing the stolen address when it
 is unavailable
Message-ID: <20131025080738.GD7752@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	"Liu, Chuansheng" <chuansheng.liu@intel.com>,
	Ben Widawsky <ben@bwidawsk.net>,
	"daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
	"airlied@linux.ie" <airlied@linux.ie>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Li, Fei" <fei.li@intel.com>
References: <1382632427.26153.94.camel@cliu38-desktop-build>
 <20131024121706.GB3233@nuc-i3427.alporthouse.com>
 <20131024205650.GC28973@bwidawsk.net>
 <27240C0AC20F114CBF8149A2696CBE4A01B7369C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B7369C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:27:42AM +0000, Liu, Chuansheng wrote:
> Hello Chris and Ben,
> 
> > -----Original Message-----
> > From: Ben Widawsky [mailto:ben@bwidawsk.net]
> > Sent: Friday, October 25, 2013 4:57 AM
> > To: Chris Wilson; Liu, Chuansheng; daniel.vetter@ffwll.ch; airlied@linux.ie;
> > intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org;
> > linux-kernel@vger.kernel.org; Li, Fei
> > Subject: Re: [Intel-gfx] drm/i915: Avoid accessing the stolen address when it is
> > unavailable
> > 
> > On Thu, Oct 24, 2013 at 01:17:06PM +0100, Chris Wilson wrote:
> > > On Fri, Oct 25, 2013 at 12:33:47AM +0800, Chuansheng Liu wrote:
> > > >
> > > > In our platform, we hit the the stolen region initialization failure case,
> > > > such as below log:
> > > > [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen
> > region: [0x7b000000]
> > > >
> > > > And it causes the dev_priv->mm.stolen_base is NULL, in this case, we
> > should
> > > > avoid accessing it any more.
> > > >
> > > > Here is possible call trace:
> > > > intel_enable_gt_powersave -- >
> > > > valleyview_enable_rps -- >
> > > > valleyview_setup_pctx
> > >
> > > The two create_stolen routines are no-ops in that case so all that
> > > happens instead is that we read VLV_PCBR. However, really if
> > > i915_gem_object_create_stolen_for_preallocated() fails we should abort
> > > loading the driver as it means we have a hardware conflict and undefined
> > > behaviour.
> In case of dev_priv->mm.stolen_base == NULL, and the valleyview_setup_pctx() is called
> at the first time, it will call i915_gem_object_create_stolen_for_preallocated(), which should
> should return NULL always due to (!drm_mm_initialized(&dev_priv->mm.stolen)).
> 
> After that, every time specially when doing pm operation, the above scenario will
> be called again and again.
> 
> Here this patch is to save some time for PM operation, we do not need to read
> VLV_PCBR and pcbr_offset calculation in case of stolen_base == NULL.
> 
> Is it making sense? Thanks.

I see. No, it is a pointless optimisation that leaks knowledge about
internals of another subsystem to paper over a kernel bug.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
