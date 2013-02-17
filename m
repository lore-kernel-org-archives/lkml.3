Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3BQOyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:54:07 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:52861 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3BQOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:54:05 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130217133814.GK5813@phenom.ffwll.local>
References: <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
	<20130213193411.GA15928@redhat.com>
	<CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
	<20130215011503.GA11914@redhat.com>
	<alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
	<CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com>
	<alpine.LNX.2.00.1302161302290.21380@eggly.anvils>
	<CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com>
	<alpine.LNX.2.00.1302161522130.22723@eggly.anvils>
	<alpine.LNX.2.00.1302161803430.23675@eggly.anvils>
	<20130217133814.GK5813@phenom.ffwll.local>
Date: Sun, 17 Feb 2013 15:54:03 +0100
Message-ID: <CAKMK7uFR5U-Fq60Y3i4VtdD5jTCEjjKJPW8E=WmK-1XdboYC3A@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 2:38 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> 2. The new i915 force restore code is indeed missing a safety check
> compared to the old crtc helper based one:
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 6eb3882..095094c 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -9153,7 +9153,13 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
>
>         if (force_restore) {
>                 for_each_pipe(pipe) {
> -                       intel_crtc_restore_mode(dev_priv->pipe_to_crtc_mapping[pipe]);
> +                       struct drm_crtc * crtc =
> +                               dev_priv->pipe_to_crtc_mapping[pipe];
> +
> +                       if (!crtc->enabled)
> +                               continue;
> +
> +                       intel_crtc_restore_mode(crtc);
>                 }
>
>                 i915_redisable_vga(dev);
>
> The issue is that we save a pointer to the fb (since those are refcounted)
> but copy the mode into the crtc struct (since modes are not refcounted).
> So on restore the mode will always be non-NULL, which is wrong if the crtc
> is off (and so also has a NULL fb).
>
> The problem I have with that patch is figuring out how this ever worked. I
> think I need more coffee ;-)

Ok, coffee seems to be working now. I think the above diff shouldn't
change anything, since we already have a crtc->enabled check in
intel_modeset_affected_pipes in intel_display.c. Still would be good
if you can prove this one way or the other.

For those wondering why this check is buried this deeply: We're in the
middle of a massive rework of our modeset code, moving from
one-crtc-at-a-time to global modeset. We need that to implement some
fancy features like fastboot or better handling of global resource
constraints (shared clocks, bw limits, ...). In the new world we set
up the desired state in staging pointers/data structures. Then the
modeset code diffs that with the current state and computes the best
way to do the transition. But since we're still converting code some
pieces pass in the new state explicitly, but lower levels then ignore
some pieces when not required to reach the desired state.

The new lid restore code relies on that by updating the tracked hw
state from the real hw one and restoring the last desired state (which
is still around from the last modeset call).

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
