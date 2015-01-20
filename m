Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbbATFph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:45:37 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:37184 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbATFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:45:15 -0500
Date: Tue, 20 Jan 2015 06:45:09 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Stephane Viau <sviau@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Beeresh Gopal <gbeeresh@codeaurora.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] drm/msm/mdp5: Add hardware cursor support
Message-ID: <20150120054509.GM26519@phenom.ffwll.local>
Mail-Followup-To: Rob Clark <robdclark@gmail.com>,
	Stephane Viau <sviau@codeaurora.org>,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	Beeresh Gopal <gbeeresh@codeaurora.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
 <1421187484-13875-3-git-send-email-sviau@codeaurora.org>
 <CAKMK7uH0GUjkksG5RJ03qtf=bqdPvAK1PpayQ6Wz9dq2KMe9Tw@mail.gmail.com>
 <CAF6AEGvCf=7bQWJMxXgzn6DKWPR6TKXJ3+06aRrCg9nV62J7cA@mail.gmail.com>
 <CAKMK7uFCO5ytkckRVtT66pqpwEa9jK=J2CJqjWRS7BuXoJkjig@mail.gmail.com>
 <CAF6AEGvmGbmUQarTHeY2ZSSpTcPJTqpt8eax9Wg=gS=jpnTY_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGvmGbmUQarTHeY2ZSSpTcPJTqpt8eax9Wg=gS=jpnTY_w@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 08:46:05AM -0500, Rob Clark wrote:
> On Fri, Jan 16, 2015 at 11:06 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Thu, Jan 15, 2015 at 08:46:46AM -0500, Rob Clark wrote:
> >> On Wed, Jan 14, 2015 at 7:55 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >> > On Tue, Jan 13, 2015 at 05:18:04PM -0500, Stephane Viau wrote:
> >> >> From: Beeresh Gopal <gbeeresh@codeaurora.org>
> >> >>
> >> >> This patch implements the hardware accelarated cursor
> >> >> support for MDP5 platforms.
> >> >>
> >> >> Signed-off-by: Beeresh Gopal <gbeeresh@codeaurora.org>
> >> >> Signed-off-by: Wentao Xu <wentaox@codeaurora.org>
> >> >> Signed-off-by: Stephane Viau <sviau@codeaurora.org>
> >> >
> >> > Imo implementing legacy cursor support instead of with universal planes
> >> > makes no sense. Especially since msm is converted to atomic already, and
> >> > you can't move the cursor with atomic when it's legacy only. See the
> >> > cursor argument for the drm_crtc_init_with_planes function and how it's
> >> > used in e.g. i915.
> >> >
> >>
> >> well, I'm still not 100% convinced about going through the whole
> >> atomic mechanism for cursors..  in particular stuff that tries to
> >> enable/disable the cursor at 1000fps, goes *really* badly when things
> >> start waiting for vsync.
> >>
> >> I'll probably try some experiments with it at some point, but at this
> >> point something that works with x11 is a lot more interesting for me
> >> (since every time I switch from mdp4 device to mdp5 device I forget to
> >> disable hw cursor the first time I start x)
> >
> > Well for one this uses the legacy cursor callbacks directly, at least a
> > cursor plane is imo in order.
> >
> > Otoh we just need to fix up the cursor atomic implementation to allow
> > drivers to do fully async updates which get merged down to one update.
> > Which Ville's original atomic stuff already had. So all recoverable by
> > adding a flag somewhere and setting that in the plane_update-on-atomic
> > function.
> 
> something that could merge multiple intra-vsync updates would, I
> think, make cursor planes usable
> 
> > Merging legacy code just because the new stuff isn't 100% perfect yet imo
> > just doesn't make that much sense.
> 
> but merging legacy because new stuff isn't usable yet does ;-)

I've thought up a quick&tiny hack which should give us perfect (as in
"matches old i915 semantics") legacy cursor ioctls on top of universal
planes + atomic helpers. I need it for i915 too ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
