Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3JYA1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 20:27:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:16390 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3JYA1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 20:27:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,566,1378882800"; 
   d="scan'208";a="416815399"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ben Widawsky <ben@bwidawsk.net>, Chris Wilson <chris@chris-wilson.co.uk>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Fei" <fei.li@intel.com>
Subject: RE: [Intel-gfx] drm/i915: Avoid accessing the stolen address when
 it is unavailable
Thread-Topic: [Intel-gfx] drm/i915: Avoid accessing the stolen address when
 it is unavailable
Thread-Index: AQHO0LL8vT55RiL87kOeZt7OSfWywZoDz5wAgAC+CdA=
Date: Fri, 25 Oct 2013 00:27:42 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B7369C@SHSMSX101.ccr.corp.intel.com>
References: <1382632427.26153.94.camel@cliu38-desktop-build>
 <20131024121706.GB3233@nuc-i3427.alporthouse.com>
 <20131024205650.GC28973@bwidawsk.net>
In-Reply-To: <20131024205650.GC28973@bwidawsk.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris and Ben,

> -----Original Message-----
> From: Ben Widawsky [mailto:ben@bwidawsk.net]
> Sent: Friday, October 25, 2013 4:57 AM
> To: Chris Wilson; Liu, Chuansheng; daniel.vetter@ffwll.ch; airlied@linux.ie;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org;
> linux-kernel@vger.kernel.org; Li, Fei
> Subject: Re: [Intel-gfx] drm/i915: Avoid accessing the stolen address when it is
> unavailable
> 
> On Thu, Oct 24, 2013 at 01:17:06PM +0100, Chris Wilson wrote:
> > On Fri, Oct 25, 2013 at 12:33:47AM +0800, Chuansheng Liu wrote:
> > >
> > > In our platform, we hit the the stolen region initialization failure case,
> > > such as below log:
> > > [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen
> region: [0x7b000000]
> > >
> > > And it causes the dev_priv->mm.stolen_base is NULL, in this case, we
> should
> > > avoid accessing it any more.
> > >
> > > Here is possible call trace:
> > > intel_enable_gt_powersave -- >
> > > valleyview_enable_rps -- >
> > > valleyview_setup_pctx
> >
> > The two create_stolen routines are no-ops in that case so all that
> > happens instead is that we read VLV_PCBR. However, really if
> > i915_gem_object_create_stolen_for_preallocated() fails we should abort
> > loading the driver as it means we have a hardware conflict and undefined
> > behaviour.
In case of dev_priv->mm.stolen_base == NULL, and the valleyview_setup_pctx() is called
at the first time, it will call i915_gem_object_create_stolen_for_preallocated(), which should
should return NULL always due to (!drm_mm_initialized(&dev_priv->mm.stolen)).

After that, every time specially when doing pm operation, the above scenario will
be called again and again.

Here this patch is to save some time for PM operation, we do not need to read
VLV_PCBR and pcbr_offset calculation in case of stolen_base == NULL.

Is it making sense? Thanks.

> 
> I agree. We should start treating these things as errors since no
> RPS/RC6 is essentially not what anyone wants.
> 
> DRM_DEBUG_DRIVER, and add a check in valleyview_enable_rps for the pctx
> value.
The pctx is already checked in valleyview_disable_rps().
Do we need more checking in case of pctx == NULL?

