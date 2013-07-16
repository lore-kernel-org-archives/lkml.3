Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3GPHpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:45:00 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59856 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3GPHo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:44:58 -0400
Date: Tue, 16 Jul 2013 09:44:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
Message-ID: <20130716074458.GM5784@phenom.ffwll.local>
Mail-Followup-To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20130714163009.22374.22100.stgit@zurg>
 <CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
 <51E2E65D.5050803@openvz.org>
 <20130716063101.GK5784@phenom.ffwll.local>
 <CALYGNiOtt7FUCTqcyBELoHYEVw_zqmA=bpmHy_nDkhXCduB9qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiOtt7FUCTqcyBELoHYEVw_zqmA=bpmHy_nDkhXCduB9qg@mail.gmail.com>
X-Operating-System: Linux phenom 3.10.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:34:25AM +0400, Konstantin Khlebnikov wrote:
> On Tue, Jul 16, 2013 at 10:31 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Sun, Jul 14, 2013 at 09:56:45PM +0400, Konstantin Khlebnikov wrote:
> > > Daniel Vetter wrote:
> > > >On Sun, Jul 14, 2013 at 6:30 PM, Konstantin Khlebnikov
> > > ><khlebnikov@openvz.org>  wrote:
> > > >>This patch fixes regression in power consumtion of sandy bridge gpu,
> > which
> > > >>exists since v3.6 Sometimes after resuming from s2ram gpu starts
> > thinking that
> > > >>it's extremely busy. After that it never reaches rc6 state.
> > > >>
> > > >>Bug was introduce by commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
> > > >>("drm/i915: load boot context at driver init time"). Without
> > documentation
> > > >>it's not clear what is happening here, probably this breaks internal
> > state of
> > > >>hardware ring buffers and confuses RPS engine. Fortunately keeping
> > forcewake
> > > >>during whole initialization sequence in gen6_init_clock_gating() fixes
> > this bug.
> > > >>
> > > >>References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
> > > >>Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > >
> > > >We already hold an forcewake reference while setting up the rps stuff,
> > > >should we maybe hold the forcewake for the entire duration, i.e. grab
> > > >it here in clock_gating and release it only in gen6/vlv_enable_rps?
> > > >Can you please test that version, too?
> > >
> > > This will be racy because rps stuff is done in separate work which might
> > be canceled
> > > if intel_disable_gt_powersave() happens before its completion.
> >
> > Can be fixed with a flush_delayed_work. And since that has the same
> > requirements wrt locking to prevent deadlocks as cancel_work_sync it would
> > be a drop-in replacement. Can I volunteer you to look into testing that
> > out a bit? Otherwise I could volunteer someone from our team.
> >
> > In any case I think we should apply this trick to all platforms where
> > we've added the MBCTL write (i.e. snb, ivb, hsw & vlv) since rps/rc6 works
> > _very_ similar on all of those.
> >
> 
> I've tested that patch and it really works for me. If you want change
> something for other hardware or
> extend range where forcewake is held prease do it in a separate patch.
> This will be good for bisecting new bugs in the future.

The issue I have with the current patch is that it looks a bit like
duct-tape since the point where we drop the forcewake references seems to
lack justification. The write to MBCTL itself will temporarily wake up the
chip, so just wrapping that up in with forcewake is very likely not good
enough. So I fear that we'll only hold forcewake long enough on most
systems and still have a bunch of oddball broken systems out there.

Holding forcewake otoh until we've fully set up rps/rc6 makes imo tons of
sense, hence why I've brought up the idea. Same reasoning applies to
extending the w/a to all systems supporting rc6.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
