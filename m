Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3BQNf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 08:35:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55571 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3BQNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 08:35:57 -0500
Date: Sun, 17 Feb 2013 14:38:14 +0100
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130217133814.GK5813@phenom.ffwll.local>
Mail-Followup-To: Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul McKenney <paul.mckenney@linaro.org>,
	DRI <dri-devel@lists.freedesktop.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302161803430.23675@eggly.anvils>
X-Originating-IP: [178.83.130.250]
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 3:21 AM, Hugh Dickins <hughd@google.com> wrote:
> On Sat, 16 Feb 2013, Hugh Dickins wrote:
>> On Sat, 16 Feb 2013, Linus Torvalds wrote:
>> >
>> > I think it's worth it to give them a heads-up already. So I've cc'd
>> > the main suspects here..
>>
>> Okay, thanks.
>>
>> >
>> > Daniel, Dave - any comments about a NULL fb in
>> > intel_choose_pipe_bpp_dither() during either suspend or resume? Some
>> > googling shows this:
>> >
>> >     https://bugzilla.redhat.com/show_bug.cgi?id=895123
>>
>> Great, yes, I'm sure that's the same (though it says "suspend"
>> and I say "resume").
>>
>> >
>> > which sounds remarkably similar, and is also during a suspend attempt
>> > (but apparently Satish got a full oops out).. Some timing race with a
>> > worker entry?
>
> Comparing Satish's backtrace and drivers/gpu/drm history, it's clear that
> the oops comes from Daniel's 3.8-rc2 45e2b5f640b3 "drm/i915: force restore
> on lid open", whose force_restore case now passes down crtc->base.fb.  But
> I wouldn't have a clue why that's usually non-NULL but occasionally NULL:
> your timing race with a worker entry, perhaps.
>
> And 45e2b5f640b3 contains a fine history of going back and forth, so I
> wouldn't want to play further with it out of ignorance - though tempted
> to replace the "if (force_restore) {" by an interim safe-seeming
> compromise of "if (force_restore && crtc->base.fb) {".

Two things to try while I try to grow a clue on what exactly is going on:

1. Related to new ACPI sleep states we've recently made the lid_notifier
locking more sound, maybe that helps:

http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-next-queued&id=b8efb17b3d687695b81485f606fc4e6c35a50f9a

2. The new i915 force restore code is indeed missing a safety check
compared to the old crtc helper based one:

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 6eb3882..095094c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9153,7 +9153,13 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 
 	if (force_restore) {
 		for_each_pipe(pipe) {
-			intel_crtc_restore_mode(dev_priv->pipe_to_crtc_mapping[pipe]);
+			struct drm_crtc * crtc =
+				dev_priv->pipe_to_crtc_mapping[pipe];
+
+			if (!crtc->enabled)
+				continue;
+
+			intel_crtc_restore_mode(crtc);
 		}
 
 		i915_redisable_vga(dev);

The issue is that we save a pointer to the fb (since those are refcounted)
but copy the mode into the crtc struct (since modes are not refcounted).
So on restore the mode will always be non-NULL, which is wrong if the crtc
is off (and so also has a NULL fb).

The problem I have with that patch is figuring out how this ever worked. I
think I need more coffee ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
