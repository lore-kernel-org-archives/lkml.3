Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIYKPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:15:03 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:46639 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaIYKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAGS+omD055Bk+czk5=SDMRu1g-HGZHBobgasKC9PjF80Ci-czA@mail.gmail.com>
References: <1408891857-14258-1-git-send-email-djkurtz@chromium.org>
	<CAMuHMdUoh6+gDcZty76HJhcQcJvM5DyBiD4YrZGuAX9e+F32-w@mail.gmail.com>
	<CAGS+omD055Bk+czk5=SDMRu1g-HGZHBobgasKC9PjF80Ci-czA@mail.gmail.com>
Date: Thu, 25 Sep 2014 12:14:59 +0200
X-Google-Sender-Auth: UrmwIg5MMDoK_3FeOHq3ZGjRBSU
Message-ID: <CAMuHMdVrd0fLEhv+uSfKeJ_skHTSiJbAWqW-Q4WjL1xAvb=YwA@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos/fbdev: set smem_len for fbdev
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>,
        Siarhei Siamashka <siarhei.siamashka@gmail.com>,
        =?UTF-8?Q?G=C3=BCnther_Noack?= <me@guenthernoack.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:07 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Thu, Sep 25, 2014 at 5:32 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sun, Aug 24, 2014 at 4:50 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>>> Commit [0] stopped setting fix.smem_start and fix.smem_len when creating
>>> the fbdev.
>>>
>>> [0] 2f1eab8d8ab59e799f7d51d62410b398607a7bc3
>>>   drm/exynos/fbdev: don't set fix.smem/mmio_{start,len}
>>>
>>> However, smem_len is used by some userland applications to calculate the
>>> size for mmap.  In particular, it is used by xf86-video-fbdev:
>>>
>>> http://cgit.freedesktop.org/xorg/xserver/tree/hw/xfree86/fbdevhw/fbdevhw.c?id=xorg-server-1.15.99.903#n571
>>>
>>> So, let's restore setting the smem_len to unbreak things for these users.
>>>
>>> Note: we are still leaving smem_start set to 0.
>>
>> Doesn't this cause a system crash when userspace (e.g. fbtest) writes into
>> the mmap()ed /dev/fb*, as the wrong MMIO region is mapped?
>
> Do you see a crash during testing, or is your question hypothetical?

It was hypothetical.

> I don't think there will be one.  exynos's fbev defines its own
> fb_ops.fb_mmap, which uses dma_mmap_attrs() to mmap the fb's gem
> buffer, which was allocated by dma_alloc_attrs().  This bypasses the
> code in drivers/video/fbmem.c:fb_mmap() that references
> fix.smem_start.
>
> But, perhaps I am missing something?

Thanks, having your own mapping function explains the lack of crashes.

Still, some weird software may map /dev/mem instead of /dev/fb0, and
use fb_fix.smem_start. But that's also unsafe in the context of LPAE.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
