Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbbAXLZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:25:06 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:55349 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbAXLZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:25:01 -0500
Date: Sat, 24 Jan 2015 12:24:55 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [BUG, bisect] drm/i915: mouse pointer lags and
 overshoots
Message-ID: <20150124112455.GE10113@phenom.ffwll.local>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Ander Conselvan de Oliveira <conselvan2@gmail.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <20150117100635.GA1281@hudson.localdomain>
 <20150119090847.GQ10649@intel.com>
 <54BCE1BF.5050808@intel.com>
 <20150119110404.GA26577@nuc-i3427.alporthouse.com>
 <20150119164024.GI22549@intel.com>
 <20150120054842.GN26519@phenom.ffwll.local>
 <20150124065732.GA17057@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124065732.GA17057@hudson.localdomain>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:57:32PM -0800, Jeremiah Mahler wrote:
> all,
> 
> On Tue, Jan 20, 2015 at 06:48:42AM +0100, Daniel Vetter wrote:
> > On Mon, Jan 19, 2015 at 08:40:24AM -0800, Matt Roper wrote:
> > > On Mon, Jan 19, 2015 at 11:04:04AM +0000, Chris Wilson wrote:
> > > > On Mon, Jan 19, 2015 at 11:51:43AM +0100, Daniel Vetter wrote:
> > > > > There's also an issue in (most) X drivers which exaberates this
> > > > > issues: When changing the cursor buffer the X cursor code does a a)
> > > > > disable cursor b) update cursor image c) enable cursor cycle.
> > > > 
> > > > Notably not -intel on which the bug has been observed. And more
> > > > importantly, the slow downs don't seem to correlate with cursor change,
> > > > just cursor movement.
> > > > -Chris
> > > > 
> > > > -- 
> > > > Chris Wilson, Intel Open Source Technology Centre
> > > 
> > > It seems that the simple fix for this case (movement only) is to just
> > > skip the prepare_fb/cleanup_fb calls (and the associated vblank wait) in
> > > the transitional plane helper when newfb == oldfb.  I just posted a
> > > small patch that makes that change (and solves the cursor lag for me).
> > > 
> > > This won't solve the case if userspace uses a different framebuffer for
> > > each update (while trying to update faster than the refresh rate).  Is
> > > there any existing userspace that behaves this way that we can test
> > > with?
> > 
> > Hm, I've thought I've merged that patch already:
> > 
> > commit ab58e3384b9f9863bfd029b458ff337d381bf6d2
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Mon Nov 24 20:42:42 2014 +0100
> > 
> >     drm/atomic-helper: Skip vblank waits for unchanged fbs
> > 
> > Or is the problem here that the transitional plane helpers aren't up to
> > the task? If so please reference that in your patch.
> > 
> > And we still need a hack for the "changed fb cursor" issue, I'll whip
> > something up.
> > -Daniel
> > -- 
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> Just checking if anyone has come up with a fix.  I am still stuck at
> next-20150112 because of this bug.

I've merged a patch from Matt Roper:

commit d99b70ce7d73d78a88311453ccdd0fa0a670dd50
Author: Matt Roper <matthew.d.roper@intel.com>
Date:   Mon Jan 19 08:31:49 2015 -0800

    drm/plane-helper: Skip prepare_fb/cleanup_fb when newfb==oldfb

that should rectify the sluggish i915 cursor. But it's in a separate topic
branch which isn't in linux-next. Should show up in drm-next next week
though.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
