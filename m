Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaAWRHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:07:06 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50131 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaAWRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:07:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140123165115.GB23869@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
	<1390486503-1504-3-git-send-email-dh.herrmann@gmail.com>
	<20140123165115.GB23869@gmail.com>
Date: Thu, 23 Jan 2014 18:07:02 +0100
Message-ID: <CANq1E4QQE2qeEz1AaN1NO3p2TE006jHfz8uaJ_LLHptKdHecxQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: sysfb: remove sysfb when probing real hw
From: David Herrmann <dh.herrmann@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jan 23, 2014 at 5:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Just a couple of small nits:
>
> * David Herrmann <dh.herrmann@gmail.com> wrote:
>
>> --- a/arch/x86/kernel/sysfb.c
>> +++ b/arch/x86/kernel/sysfb.c
>> @@ -33,11 +33,76 @@
>>  #include <linux/init.h>
>>  #include <linux/kernel.h>
>>  #include <linux/mm.h>
>> +#include <linux/mutex.h>
>>  #include <linux/platform_data/simplefb.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/screen_info.h>
>>  #include <asm/sysfb.h>
>>
>> +static DEFINE_MUTEX(sysfb_lock);
>> +static struct platform_device *sysfb_dev;
>> +
>> +int __init sysfb_register(const char *name, int id,
>> +                       const struct resource *res, unsigned int res_num,
>> +                       const void *data, size_t data_size)
>> +{
>> +     struct platform_device *pd;
>> +     int ret = 0;
>> +
>> +     mutex_lock(&sysfb_lock);
>> +     if (!sysfb_dev) {
>> +             pd = platform_device_register_resndata(NULL, name, id,
>> +                                                    res, res_num,
>> +                                                    data, data_size);
>> +             if (IS_ERR(pd))
>> +                     ret = PTR_ERR(pd);
>> +             else
>> +                     sysfb_dev = pd;
>> +     }
>> +     mutex_unlock(&sysfb_lock);
>> +
>> +     return ret;
>> +}
>> +
>> +static bool sysfb_match(const struct apertures_struct *apert)
>> +{
>> +     struct screen_info *si = &screen_info;
>> +     unsigned int i;
>> +     const struct aperture *a;
>> +
>> +     for (i = 0; i < apert->count; ++i) {
>> +             a = &apert->ranges[i];
>> +             if (a->base >= si->lfb_base &&
>> +                 a->base < si->lfb_base + ((u64)si->lfb_size << 16))
>> +                     return true;
>> +             if (si->lfb_base >= a->base &&
>> +                 si->lfb_base < a->base + a->size)
>> +                     return true;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>> +/* Remove sysfb and disallow new sysfbs from now on. Can be called from any
>> + * context except recursively (see also remove_conflicting_framebuffers()). */
>> +void sysfb_unregister(const struct apertures_struct *apert, bool primary)
>
> Please use the customary (multi-line) comment style:
>
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
>
> specified in Documentation/CodingStyle.

Whoops, will fix it up. Still used to that from HID code.

>> +#ifdef CONFIG_X86_SYSFB
>> +#  include <asm/sysfb.h>
>> +#endif
>
> I guess a single space is sufficient?
>
> Better yet, I'd include sysfb.h unconditionally:

Unconditionally won't work as only x86 has this header. If there's a
way to place a dummy into asm-generic which is picked if
arch/xy/include/asm/ doesn't have the header, let me know. But if I
include it unconditionally without any fallback, this will fail on
non-x86.
And adding the header to all archs seems overkill.

>> @@ -1773,6 +1780,10 @@ register_framebuffer(struct fb_info *fb_info)
>>  {
>>       int ret;
>>
>> +#ifdef CONFIG_X86_SYSFB
>> +     sysfb_unregister(fb_info->apertures, fb_is_primary_device(fb_info));
>> +#endif
>
> So, if a dummy sysfb_unregister() inline was defined in the
> !CONFIG_X86_SYSFB case then this ugly #ifdef could possibly be
> removed? Especially as it's used twice.

Again, this is fine for x86, but not for other archs. I would still
need the #ifdef x86.
Note that patch #6 introduces linux/sysfb.h and removes all these ugly
#ifdefs again. They're only needed to fix the x86 code *now*. Patch #6
generalizes the x86-sysfb infrastructure and makes it
arch-independent. But Patch #6 introduces new features and thus
shouldn't go to stable or 3.14.

As Patch #1 already fixes nearly all issues with sysfb, let me know if
you want to drop this patch and just wait for the arch-independent
sysfb to get merged. This patch is only needed if people enable
X86_SYSFB *and* FB_SIMPLE *purposely* and want hw-handover. The case
were people enable it accidentally is fixed by Patch #1.
The situation is kind of screwed.. sorry for that.

Thanks
David
