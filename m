Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab3IHAN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 20:13:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52283 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3IHAN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 20:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqUG=Ocd6qZuy6LYRA49NvyKnguSdnpDgX1Br17SWvkS1A@mail.gmail.com>
References: <CAG-2HqVruXZxO1xLvYeAPa1RYmy044UiBXFLAtX5WcHVQVAtfA@mail.gmail.com>
	<CANq1E4RAoLo2=fdZ4SCAnOtbCuJkAAf-BOfUFuK5S+gijpS8ng@mail.gmail.com>
	<CAG-2HqVpAGOgvYKAsOCAac5F4SHB8nEtKtyTor2TYqp_fi7S7w@mail.gmail.com>
	<CANq1E4QPMKvDu5wA9meSt6hKRA7yTA1RhGY6NsSCMTBFmR5f0w@mail.gmail.com>
	<CANq1E4QYrQ-YcL9eGAA4LUozVnPaDNisVex8eMe+Xpj8TaWdeA@mail.gmail.com>
	<CAG-2HqXrpmZCsqXTG7pE9rtgPVrtvkU8gDxngGMtRjkoyqBMHA@mail.gmail.com>
	<CAG-2HqUG=Ocd6qZuy6LYRA49NvyKnguSdnpDgX1Br17SWvkS1A@mail.gmail.com>
Date: Sun, 8 Sep 2013 02:13:26 +0200
Message-ID: <CANq1E4QLCp4xzGsgceuGgX-k7JpiA_ayJy3e0iYoWAMAsc7fCA@mail.gmail.com>
Subject: Re: [REGRESSION] v3.12-rc1: i915_driver_load oopses when sysfb enabled
From: David Herrmann <dh.herrmann@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Sep 8, 2013 at 1:22 AM, Tom Gundersen <teg@jklm.no> wrote:
> Hi David,
>
> On Sat, Sep 7, 2013 at 11:57 PM, Tom Gundersen <teg@jklm.no> wrote:
>> On Sat, Sep 7, 2013 at 4:30 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>> Attached are two patches. The first one should fix this issue, the
>>> second one is the rebased ioremap_wc() patch from the other thread.
>>>
>>> Does this fix the issue (and the speed-problems)?
>>
>> Sadly, no. I added a few printk's to verify that the function you
>> added is called (it is), but still the same oops.
>
> A few more datapoints:
>
> Triggers:
> X86_SYSFB=y and FB_SIMPLE=n (so no fbdev until i915 is loaded)
> X86_SYSFB=y and FB_SIMPLE=y
>
> Does not trigger:
> X86_SYSFB=y, FB_EFI=yes, and without the overflow fix (i.e., so we
> fall back to efifb)
> X86_SYSFB=n and FB_EFI=y
> X86_SYSFB=n and FB_EFI=n (so no fbdev until i915 is loaded)
>
> Does this make any sense?

Thanks a lot for these results. I think I got it know. I will write a
patch that marks the resource as busy. See:
  kernel/resource.c iomem_map_sanity_check()
It also contains a hint that we should set this for driver-resources
which not directly map to hardware resources (such as veasfb and,
obviously, simplefb).

Following a diff which hopefully fixes this. The other two patches
should still be required, though. I will try to write a proper patch
tomorrow.

Thanks a lot for these extensive tests, Tom!
David

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..b7bb615 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -79,7 +79,7 @@ __init int create_simplefb(const struct screen_info *si,

        /* setup IORESOURCE_MEM as framebuffer memory */
        memset(&res, 0, sizeof(res));
-       res.flags = IORESOURCE_MEM;
+       res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
        res.name = simplefb_resname;
        res.start = si->lfb_base;
        res.end = si->lfb_base + len - 1;
