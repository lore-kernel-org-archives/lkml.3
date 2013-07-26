Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3GZHPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:15:19 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60254 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3GZHPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:15:16 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130725232556.GF13295@cantiga.alporthouse.com>
References: <CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
	<20130725184504.GC11514@cantiga.alporthouse.com>
	<CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
	<20130725190006.GD11514@cantiga.alporthouse.com>
	<CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
	<20130725192248.GA13295@cantiga.alporthouse.com>
	<CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
	<CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
	<20130725215259.GB13295@cantiga.alporthouse.com>
	<CA+icZUXZKndg7==Y6v2Z45WZDp+tDC5FzaOC=KWTf4m=rjUKnA@mail.gmail.com>
	<20130725232556.GF13295@cantiga.alporthouse.com>
Date: Fri, 26 Jul 2013 09:15:14 +0200
Message-ID: <CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Cc: "s.dilek" <s.dilek@jpberlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 1:25 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, Jul 26, 2013 at 01:21:07AM +0200, Sedat Dilek wrote:
>> On Thu, Jul 25, 2013 at 11:52 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > On Thu, Jul 25, 2013 at 10:07:02PM +0200, Sedat Dilek wrote:
>> >> What means the bang line?
>> >>
>> >> [    54.564] (II) GLX: Initialized DRI2 GL provider for screen 0
>> >> [    54.565] bang: 1159
>> >> [    54.565]
>> >> Fatal server error:
>> >> [    54.565] failed to create screen resources
>> >
>> > That means between the kernel reporting success for
>> > DRM_IOCTL_I915_GEM_MMAP_GTT and libdrm returning from
>> > drm_intel_gem_bo_map_gtt(), something went wrong. This implies that the
>> > call to mmap() failed.
>> >
>> > I don't see how changing versions of the ddx would unmask the bug, nor
>> > why the mmap() should suddenly start failing. Anybody have any
>> > suggestions other than
>> >
>> > diff --git a/src/intel_uxa.c b/src/intel_uxa.c
>> > index 2f14173..3872258 100644
>> > --- a/src/intel_uxa.c
>> > +++ b/src/intel_uxa.c
>> > @@ -1149,12 +1149,15 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
>> >         PixmapPtr pixmap;
>> >         intel_screen_private *intel = intel_get_screen_private(scrn);
>> >         dri_bo *bo = intel->front_buffer;
>> > +       int ret;
>> >
>> >         if (!uxa_resources_init(screen))
>> >                 return FALSE;
>> >
>> > -       if (drm_intel_gem_bo_map_gtt(bo))
>> > +       if ((ret = drm_intel_gem_bo_map_gtt(bo))) {
>> > +               ErrorF("%s:%d bang, errno=%d\n", __func__, __LINE__, -ret);
>> >                 return FALSE;
>> > +       }
>> >
>> >         pixmap = screen->GetScreenPixmap(screen);
>> >         intel_set_pixmap_bo(pixmap, bo);
>> >
>> > which is most likely to report EINVAL (22)?
>>
>> Yupp, this shows me...
>>
>> [    28.542] (II) GLX: Initialized DRI2 GL provider for screen 0
>> [    28.543] intel_uxa_create_screen_resources:1158 bang, errno=22
>> [    28.543]
>> Fatal server error:
>> [    28.543] failed to create screen resources
>
> I'm out of ideas, could you bisect this? Either kernel, userspace or
> both. Thanks,

I will wait for today's official Linux-next (next-20130726) release
and check if the issue still exists (might be I mismerged).
Cannot promise for bisecting, but for me it seems to be a
"kernel-related" issue.
So, my 1st bisect-strategy would be to see before/after drm-intel
merge into -next.

For example: I could start my X with even doing ugly hacks like this...

[ intel-ddx (git) ]
...
Bool intel_uxa_create_screen_resources(ScreenPtr screen)
...
#if 0
	if (drm_intel_gem_bo_map_gtt(bo))
		return FALSE;
#endif
...

...with any other kernel.

- Sedat -

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
