Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3GZIZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:25:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58846 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZIZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:25:28 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130726072646.GH13295@cantiga.alporthouse.com>
References: <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
	<20130725190006.GD11514@cantiga.alporthouse.com>
	<CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
	<20130725192248.GA13295@cantiga.alporthouse.com>
	<CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
	<CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
	<20130725215259.GB13295@cantiga.alporthouse.com>
	<CA+icZUXZKndg7==Y6v2Z45WZDp+tDC5FzaOC=KWTf4m=rjUKnA@mail.gmail.com>
	<20130725232556.GF13295@cantiga.alporthouse.com>
	<CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
	<20130726072646.GH13295@cantiga.alporthouse.com>
Date: Fri, 26 Jul 2013 10:25:26 +0200
Message-ID: <CA+icZUXuj1O3oUvr_43BZDD_ikWyY9GxfOdzb3GLWJ1X1hvxyQ@mail.gmail.com>
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
        linux-next <linux-next@vger.kernel.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 9:26 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, Jul 26, 2013 at 09:15:14AM +0200, Sedat Dilek wrote:
>> For example: I could start my X with even doing ugly hacks like this...
>>
>> [ intel-ddx (git) ]
>> ...
>> Bool intel_uxa_create_screen_resources(ScreenPtr screen)
>> ...
>> #if 0
>>       if (drm_intel_gem_bo_map_gtt(bo))
>>               return FALSE;
>> #endif
>> ...
>>
>> ...with any other kernel.
>
> Yes. Acquiring the map there is just a bit of paranoia to ensure we
> having the mapping into the scanout already in place in case of
> emergencies (and so don't fail along failure paths due to resource
> conflicts).
>
> Hmm, though we only started checking for map failures in 2.20.10 - which
> would explain why going back to the older ddx masks the issue. And yes,
> this means we do require a kernel bisect - or some passing inspiron.

First confirmation...
OK, next-20130726 shows the same symptoms!

I tried diverse intel-ddx release and went back to v2.21.9... and
searched for a version like v2.20.0 which has no checking for map
failures...

[ intel-ddx (v2.20.0) ]
...
Bool intel_uxa_create_screen_resources(ScreenPtr screen)
{
        ScrnInfoPtr scrn = xf86ScreenToScrn(screen);
        intel_screen_private *intel = intel_get_screen_private(scrn);
        dri_bo *bo = intel->front_buffer;

        if (!uxa_resources_init(screen))
                return FALSE;

        drm_intel_gem_bo_map_gtt(bo);

        if (intel->use_shadow) {
                intel_shadow_create(intel);
        } else {
                PixmapPtr pixmap = screen->GetScreenPixmap(screen);
                intel_set_pixmap_bo(pixmap, bo);
                intel_get_pixmap_private(pixmap)->pinned = 1;
                screen->ModifyPixmapHeader(pixmap,
                                           scrn->virtualX,
                                           scrn->virtualY,
                                           -1, -1,
                                           intel->front_pitch,
                                           NULL);
                scrn->displayWidth = intel->front_pitch / intel->cpp;
        }
...
... but does not start as well, so it seems to be a kernel-issue as
assumed (2nd confirmation).

X.log attached.

- Sedat -

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
