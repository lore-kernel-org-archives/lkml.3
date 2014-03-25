Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaCYJOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:14:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:59076 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaCYJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:13:50 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140324231130.GA1386@rhlx01.hs-esslingen.de>
References: <20140322234317.GA10483@rhlx01.hs-esslingen.de>
	<20140323121541.GA20971@rhlx01.hs-esslingen.de>
	<CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
	<20140323212715.GA22767@rhlx01.hs-esslingen.de>
	<CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com>
	<20140324085449.GA26878@phenom.ffwll.local>
	<alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
	<20140324202606.GJ26878@phenom.ffwll.local>
	<alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
	<CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
	<20140324231130.GA1386@rhlx01.hs-esslingen.de>
Date: Tue, 25 Mar 2014 10:13:27 +0100
X-Google-Sender-Auth: xOnQHHdHBGOtFHwmEV5btbXMsOI
Message-ID: <CAKMK7uHktVQXZYCqoQwPsfbcLAxRoqMWtXLgnUie2D=X4nVcVQ@mail.gmail.com>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in mga_driver_irq_uninstall)
From: Daniel Vetter <daniel@ffwll.ch>
To: Andreas Mohr <andi@lisas.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 12:11 AM, Andreas Mohr <andi@lisas.de> wrote:
> On Mon, Mar 24, 2014 at 10:46:49PM +0100, Daniel Vetter wrote:
>> On Mon, Mar 24, 2014 at 9:40 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > If someone understands the locking issues I pointed out above, it could be
>> > easy to fix.
>>
>> The locking issue isn't your problem, the real issue is that putting a
>> irq_uninstall into core code will break all the new (properly working)
>> drivers. And you can't really fix this in mga itself since the
>> lifetime rules of the register mappings are totally broken. It's a
>> fundamental misdesign of the legacy drm driver architecture and the
>> _only_ way to fix this bug for real is to rewrite this all. Which was
>> done for all the still used drivers like i915, radeon, nouveau, ...
>
> That sounds plausible - yet with meatballs (ok, maybe I should omit
> such quite possibly unjustified qualification) such as this:
>
> git show --stat 771fe6b912fca54f03
>
> how is a bunch of marginally-trained hobbyists ever supposed to be implementing
> a working practical (i.e., "base") driver for *various* currently unsupported
> (booted would perhaps even be a more fitting word?) hardware?
>
> While the result of a wc -l check of the drivers/gpu/drm/r128 dir itself
> seems quite positive, that still might be not much of help
> when eyeing the large KMS changes that had to be done elsewhere.
>
> I guess we can make use of all the practical advice/links that we can get...
> (such as hints at good candidates of existing KMSified drivers
> which don't come with the full bells and whistles package,
> hints at suitably sized KMS support commits, grandma tutorials, ...).
> Some semi-short search wasn't overly successful, with links such as
> http://www.x.org/wiki/ModeSetting/
> https://en.wikipedia.org/wiki/KMS_%28Linux_kernel%29#Linux
> "New, Generic X.Org KMS Driver Work" http://www.phoronix.com/scan.php?page=news_item&px=OTk1OA
>
> Or perhaps I should just state outright that I seem to be in need
> of a working solution for my kernel upgrade pain
> which I would be deemed to want semi-soonish
> (the i810, MGA users and some others might be sharing my thoughts).
> IOW, my r128 driver is somewhat of a "still used driver", thank you very much.
>
> Thanks for having managed to survive my posting in an asbestos-lined
> garment (apologies if it came across in harsh terms :),
>
> Andreas Mohr
> (not necessarily a member of the forced-monopoly hardware upgrade treadmill cult)

Well I have a i810 here personally and since about 3 years haven't
gotten around to implement a kms stack for it (just for fun
essentially). And that's on a platform which can steal a lot of the
kms infrastructure from the i915 driver.

For simple devices getting a basic kms driver off the ground (that
means no accelaration support in the kernel with GEM, and obviously
userspace not ported) seems to be doable in one gsoc term, at least
someone managed it. Which means 3 months full-time work.

So yeah, writing real gpu drivers is fairly non-trivial task. And all
the people who can do it are fully busy getting the new shit to work.

Wrt stealing code: It's better to look at the legacy fbdev drivers,
since they have modeset support. And meanwhile we have fairly decent
drm DocBook in the kernel, the latest updates are in drm-next.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
