Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3GYUHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:07:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33808 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:07:05 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
References: <20130725170144.GE6493@cantiga.alporthouse.com>
	<CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
	<20130725172616.GA11514@cantiga.alporthouse.com>
	<CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
	<CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
	<CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
	<20130725184504.GC11514@cantiga.alporthouse.com>
	<CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
	<20130725190006.GD11514@cantiga.alporthouse.com>
	<CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
	<20130725192248.GA13295@cantiga.alporthouse.com>
	<CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
Date: Thu, 25 Jul 2013 22:07:02 +0200
Message-ID: <CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 9:32 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Jul 25, 2013 at 9:22 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Thu, Jul 25, 2013 at 09:12:41PM +0200, Sedat Dilek wrote:
>>> New -3 dmesg.
>>
>> That puts the ball back in the ddx's court. Next debugging patch:
>>
>> diff --git a/src/intel_driver.c b/src/intel_driver.c
>> index f4d76bb..1f4f299 100644
>> --- a/src/intel_driver.c
>> +++ b/src/intel_driver.c
>> @@ -170,6 +170,7 @@ static Bool i830CreateScreenResources(ScreenPtr screen)
>>                 return FALSE;
>>
>>         intel_copy_fb(scrn);
>> +       ErrorF("%s: Success\n", __func__);
>>         return TRUE;
>>  }
>>
>> diff --git a/src/intel_uxa.c b/src/intel_uxa.c
>> index 2f14173..6be7ebe 100644
>> --- a/src/intel_uxa.c
>> +++ b/src/intel_uxa.c
>> @@ -1150,11 +1150,15 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
>>         intel_screen_private *intel = intel_get_screen_private(scrn);
>>         dri_bo *bo = intel->front_buffer;
>>
>> -       if (!uxa_resources_init(screen))
>> +       if (!uxa_resources_init(screen)) {
>> +               ErrorF("bang: %d\n", __LINE__);
>>                 return FALSE;
>> +       }
>>
>> -       if (drm_intel_gem_bo_map_gtt(bo))
>> +       if (drm_intel_gem_bo_map_gtt(bo)) {
>> +               ErrorF("bang: %d\n", __LINE__);
>>                 return FALSE;
>> +       }
>>
>>         pixmap = screen->GetScreenPixmap(screen);
>>         intel_set_pixmap_bo(pixmap, bo);
>> @@ -1167,8 +1171,10 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
>>                                    NULL);
>>         scrn->displayWidth = intel->front_pitch / intel->cpp;
>>
>> -       if (!intel_glamor_create_screen_resources(screen))
>> +       if (!intel_glamor_create_screen_resources(screen)) {
>> +               ErrorF("bang: %d\n", __LINE__);
>>                 return FALSE;
>> +       }
>>
>>         return TRUE;
>>  }
>>
>> --
>
> dmesg -4 and X.log attached.
>

What means the bang line?

[    54.564] (II) GLX: Initialized DRI2 GL provider for screen 0
[    54.565] bang: 1159
[    54.565]
Fatal server error:
[    54.565] failed to create screen resources

>From [1];
...
Bool intel_uxa_create_screen_resources(ScreenPtr screen)
{
	ScrnInfoPtr scrn = xf86ScreenToScrn(screen);
	PixmapPtr pixmap;
	intel_screen_private *intel = intel_get_screen_private(scrn);
	dri_bo *bo = intel->front_buffer;

	if (!uxa_resources_init(screen))
		return FALSE;

	if (drm_intel_gem_bo_map_gtt(bo))
		return FALSE;

	pixmap = screen->GetScreenPixmap(screen); <--- Line #1159 ?
	intel_set_pixmap_bo(pixmap, bo);
	intel_get_pixmap_private(pixmap)->pinned |= PIN_SCANOUT;
	screen->ModifyPixmapHeader(pixmap,
				   scrn->virtualX,
				   scrn->virtualY,
				   -1, -1,
				   intel->front_pitch,
				   NULL);
	scrn->displayWidth = intel->front_pitch / intel->cpp;

	if (!intel_glamor_create_screen_resources(screen))
		return FALSE;

	return TRUE;
}
...

- Sedat -

[1] http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/tree/src/intel_uxa.c?id=6f5fd772c7ca656b86394a0f036d4e0cf5b33d8e#n1159


> - S.
>
>> Chris Wilson, Intel Open Source Technology Centre
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-next" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
