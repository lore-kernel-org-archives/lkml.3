Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3BQQby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 11:31:54 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59450 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3BQQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 11:31:52 -0500
Date: Sun, 17 Feb 2013 08:31:03 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <20130217133814.GK5813@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1302170820140.893@eggly.anvils>
References: <alpine.LNX.2.00.1302122121170.15020@eggly.anvils> <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
 <CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com> <alpine.LNX.2.00.1302161302290.21380@eggly.anvils> <CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com> <alpine.LNX.2.00.1302161522130.22723@eggly.anvils>
 <alpine.LNX.2.00.1302161803430.23675@eggly.anvils> <20130217133814.GK5813@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2013, Daniel Vetter wrote:
> On Sun, Feb 17, 2013 at 3:21 AM, Hugh Dickins <hughd@google.com> wrote:
> > On Sat, 16 Feb 2013, Hugh Dickins wrote:
> >> On Sat, 16 Feb 2013, Linus Torvalds wrote:
> >> >
> >> > I think it's worth it to give them a heads-up already. So I've cc'd
> >> > the main suspects here..
> >>
> >> Okay, thanks.
> >>
> >> >
> >> > Daniel, Dave - any comments about a NULL fb in
> >> > intel_choose_pipe_bpp_dither() during either suspend or resume? Some
> >> > googling shows this:
> >> >
> >> >     https://bugzilla.redhat.com/show_bug.cgi?id=895123
> >>
> >> Great, yes, I'm sure that's the same (though it says "suspend"
> >> and I say "resume").
> >>
> >> >
> >> > which sounds remarkably similar, and is also during a suspend attempt
> >> > (but apparently Satish got a full oops out).. Some timing race with a
> >> > worker entry?
> >
> > Comparing Satish's backtrace and drivers/gpu/drm history, it's clear that
> > the oops comes from Daniel's 3.8-rc2 45e2b5f640b3 "drm/i915: force restore
> > on lid open", whose force_restore case now passes down crtc->base.fb.  But
> > I wouldn't have a clue why that's usually non-NULL but occasionally NULL:
> > your timing race with a worker entry, perhaps.
> >
> > And 45e2b5f640b3 contains a fine history of going back and forth, so I
> > wouldn't want to play further with it out of ignorance - though tempted
> > to replace the "if (force_restore) {" by an interim safe-seeming
> > compromise of "if (force_restore && crtc->base.fb) {".

My suggestion there in the line above was stupidly wrong :(

> 
> Two things to try while I try to grow a clue on what exactly is going on:

Thank you.

By the way, I hope you've looked back through this thread, and realize
that Dave and I both had ThinkPad T4?0s suspend/resume display problems,
but they've gone off in different directions: so a lot of the discussion
comes from Dave having CONFIG_PROVE_RCU_DELAY, and has nothing to do with
what we now know to be my oops in i915/intel_display.c.

> 
> 1. Related to new ACPI sleep states we've recently made the lid_notifier
> locking more sound, maybe that helps:
> 
> http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-next-queued&id=b8efb17b3d687695b81485f606fc4e6c35a50f9a

Looks like it may be relevant, but I'll ignore it for now:
preferring first to test the more minimal safety you suggest below.

> 
> 2. The new i915 force restore code is indeed missing a safety check
> compared to the old crtc helper based one:
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 6eb3882..095094c 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -9153,7 +9153,13 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
>  
>  	if (force_restore) {
>  		for_each_pipe(pipe) {
> -			intel_crtc_restore_mode(dev_priv->pipe_to_crtc_mapping[pipe]);
> +			struct drm_crtc * crtc =
> +				dev_priv->pipe_to_crtc_mapping[pipe];
> +
> +			if (!crtc->enabled)
> +				continue;
> +
> +			intel_crtc_restore_mode(crtc);
>  		}
>  
>  		i915_redisable_vga(dev);

I see your followup, where you observe that intel_modeset_affected_pipes()
should already have made this check; but you do say it would still be good
to prove one way or the other, so I'll run from now with the patch below.

Note that we haven't got to worrying about what will be in 3.9 yet
(linux-next tells me to expect hangcheck timer problems): it's Linus's
current git for 3.8 final that we're working on at present.

And since quick resumes have always worked for me, it's only occasionally
that a long suspend (e.g. overnight) fails for me in this way, so I won't
be able to report success for several days - but failure may come sooner.

And, it being very tiresome to debug when it does fail, I have inserted
WARN_ONs and more safety: here's what I'm running with now.

--- 3.8-rc7/drivers/gpu/drm/i915/intel_display.c	2013-01-17 20:06:11.384002362 -0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2013-02-17 07:50:28.012075150 -0800
@@ -4156,7 +4156,9 @@ static bool intel_choose_pipe_bpp_dither
 	 * also stays within the max display bpc discovered above.
 	 */
 
-	switch (fb->depth) {
+	if (WARN_ON(!fb))
+		bpc = 8;
+	else switch (fb->depth) {
 	case 8:
 		bpc = 8; /* since we go through a colormap */
 		break;
@@ -9302,6 +9304,10 @@ void intel_modeset_setup_hw_state(struct
 	if (force_restore) {
 		for_each_pipe(pipe) {
 			crtc = to_intel_crtc(dev_priv->pipe_to_crtc_mapping[pipe]);
+			if (WARN_ON(!crtc->base.enabled))
+				continue;
+			if (WARN_ON(!crtc->base.fb))
+				continue;
 			intel_set_mode(&crtc->base, &crtc->base.mode,
 				       crtc->base.x, crtc->base.y, crtc->base.fb);
 		}
