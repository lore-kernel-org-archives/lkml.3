Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaCXVqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:46:51 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44546 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCXVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:46:49 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
	<20140322234317.GA10483@rhlx01.hs-esslingen.de>
	<20140323121541.GA20971@rhlx01.hs-esslingen.de>
	<CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
	<20140323212715.GA22767@rhlx01.hs-esslingen.de>
	<CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com>
	<20140324085449.GA26878@phenom.ffwll.local>
	<alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
	<20140324202606.GJ26878@phenom.ffwll.local>
	<alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
Date: Mon, 24 Mar 2014 22:46:49 +0100
X-Google-Sender-Auth: Ns3o5lM-2u9TlrYbxiHd90YjIro
Message-ID: <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in mga_driver_irq_uninstall)
From: Daniel Vetter <daniel@ffwll.ch>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 9:40 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > > -> All hell breaks loose if Xorg dies and takes all it's mappings with it
>> > > (in master_destroy, since the Xorg /dev fd is the master) and leaves the
>> > > driver hanging in the air if there's an interrupt still pending (or
>> > > anything else fwiw).
>> >
>> > For me that crash happened when xorg exited with a fatal error too.
>>
>> Is this fatal error itself a regression or have you seen that on older
>> kernels, too?
>
> In my case that Xorg error was not kernel-related at all. It happened
> because of unknown symbol because I used mga_dri.so from Debian 6 in
> Debian 7 (mga_dri.so isn't shipped in Debian 7 anymore). I can still play
> quake with that old mga_dri.so, although in some other scenario it causes
> failure because of unknown symbol. I should probably recompile mga_dri on
> my own.
>
>> Like I've said the entire teardown sequence for legacy drm drivers is
>> terminally busted, so the only hope we have is to reapply this missing
>> duct-tape which made your X crash. But if that itself isn't a regression
>> there's no way to fix the current drm/mga driver without a complete
>> rewrite as a new-style kernel modesetting driver.
>> -Daniel
>
> If someone understands the locking issues I pointed out above, it could be
> easy to fix.

The locking issue isn't your problem, the real issue is that putting a
irq_uninstall into core code will break all the new (properly working)
drivers. And you can't really fix this in mga itself since the
lifetime rules of the register mappings are totally broken. It's a
fundamental misdesign of the legacy drm driver architecture and the
_only_ way to fix this bug for real is to rewrite this all. Which was
done for all the still used drivers like i915, radeon, nouveau, ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
