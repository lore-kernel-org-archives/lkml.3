Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3CQVvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:51:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:56543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab3CQVvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:51:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,860,1355126400"; 
   d="scan'208";a="215766572"
Date: Sun, 17 Mar 2013 21:51:42 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Ben Widawsky <ben@bwidawsk.net>,
        Tommi Rantala <tt.rantala@gmail.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Jones <davej@redhat.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
Message-ID: <20130317215142.GC26102@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Dave Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Widawsky <ben@bwidawsk.net>,
	Tommi Rantala <tt.rantala@gmail.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Dave Jones <davej@redhat.com>
References: <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
 <20130315045004.GA14747@bwidawsk.net>
 <20130315082403.GA29916@cantiga.alporthouse.com>
 <20130315163606.GA17773@bwidawsk.net>
 <20130315220619.GA17405@cantiga.alporthouse.com>
 <20130315234942.GB715@bwidawsk.net>
 <20130316101920.GB17405@cantiga.alporthouse.com>
 <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
 <20130317214049.GB26102@cantiga.alporthouse.com>
 <CAPM=9txw7pPT195p1nJrr5=TvTBGsd6G+a7N5C+fxQgP0Eof3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txw7pPT195p1nJrr5=TvTBGsd6G+a7N5C+fxQgP0Eof3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 07:42:58AM +1000, Dave Airlie wrote:
> On Mon, Mar 18, 2013 at 7:40 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Sun, Mar 17, 2013 at 08:50:03PM +0100, Daniel Vetter wrote:
> >> On Sat, Mar 16, 2013 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> > If *userspace* doesn't request either IOC_IN | IOC_OUT in their ioctl
> >> > command (which are seperate from the ioctl number), then kdata is set to
> >> > NULL.
> >>
> >> Doesn't that mean that we need these checks everywhere? Or at least a
> >> fixup in drm core proper?
> >
> > That's my conclusion. We either add a flag to ask drm_ioctl to prevent
> > passing NULL pointers (as the existing behaviour may be useful
> > somewhere, and I have not checked all callees) or saturate our callbacks
> > with NULL checks.
> 
> Do we have the kernel's expected IOC_IN/IOC_OUT flags at that point as well?
> 
> we could check them and block NULL in that case.

Yes. For the core ioctls, we use drm_ioctls[nr].cmd rather than the
value passed in by userspace for the IOC_IN|IN_OUT bits. So:

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 25f91cd..79b8bd1 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -408,6 +408,7 @@ long drm_ioctl(struct file *filp,
                usize = asize = _IOC_SIZE(cmd);
                if (drv_size > asize)
                        asize = drv_size;
+               cmd = ioctl->cmd;
        }
        else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
                ioctl = &drm_ioctls[nr];


-- 
Chris Wilson, Intel Open Source Technology Centre
