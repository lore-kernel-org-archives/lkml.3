Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaLBRgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:36:05 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34426 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaLBRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:36:01 -0500
MIME-Version: 1.0
In-Reply-To: <25485084.A6ydfR9Xle@wuerfel>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<20141201225057.GA11285@n2100.arm.linux.org.uk>
	<CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
	<25485084.A6ydfR9Xle@wuerfel>
Date: Tue, 2 Dec 2014 09:36:00 -0800
X-Google-Sender-Auth: gtKgjHCb-hmeCOXxfo2zSoL9NNk
Message-ID: <CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Doug Anderson <dianders@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        russ.dill@gmail.com, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 2, 2014 at 1:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 01 December 2014 15:04:59 Doug Anderson wrote:
>> Russel,
>>
>> On Mon, Dec 1, 2014 at 2:50 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > What I see here is a load of complexity which achieves very little.
>> > The result doesn't get rid of much assembly, but it does make stuff
>> > more complicated.  And the diffstat speaks volumes about this:
>> >
>> >  10 files changed, 275 insertions(+), 94 deletions(-)
>> >
>> > There's a lot of words in the description, but it's missing the most
>> > important bit: why do we want to take this approach - what benefits
>> > does it bring?
>>
>> Sure.  I guess the most important words in the description are:
>>
>> > We convert the existing assembly resume code into C as proof that this
>> > works and to prepare for linking in SDRAM reinit code.
>>
>> I can't say that the SDRAM reinit code is ready for prime time yet,
>> but you can get a preview of what it could look like at:
>>
>> https://chromium-review.googlesource.com/#/c/227366/25/arch/arm/mach-rockchip/embedded/rk3288_ddr_resume.c
>>
>> Adding that code in assembly seems like a very, very bad idea.
>> Certainly my patch could wait until the DDR code is ready to be posted
>> upstream if that made sense.  One advantage of waiting is that it's
>> possible that the DDR code might end up moving elsewhere if it made
>> sense to have it part of a memory controller driver or something like
>> that.
>
> I recently looked at another vendor tree (quantenna wifi access point,
> based on arch/arc), which was putting arbitrary functions into SRAM
> for performance reasons, in their case the entire hot path for network
> switching. Having at least the infrastructure to do this seems like
> a great idea, even though it's very hard to do in a general-purpose
> kernel, as you'd have a hard time squeezing as much code as possible
> into the available SRAM.

I'm always a fan of seeing general infrastructure introduced, though
we always need to make sure that the general infrastructure makes
things easier and not harder.  There's always the danger of adding so
much abstraction for a small thing that using it is like pulling
teeth.  I'm not saying that's the case here, but it is always a
danger.

Note: I will point out a critical differences between the "hotpath"
problem and the one I'm solving here.  When you're just trying to
speed up a hotpath, it's not the end of the world if there's a stray
access to SDRAM.  If you happen to access a global variable in SDRAM,
or use a libc function to do division, or have a WARN_ON, those things
are OK.  It might also be OK if the stack was still in SDRAM.  When
you're compiling code that has to run with no other kernel function
present it's really nice to link them into a separate executable.


> Unfortunately you already said that you're not that interested in
> making it completely generic,

Yes.  I felt like a jerk with my list of caveats, but at the same time
I know that realistically I just don't have time.  It was either send
it upstream with the caveats or don't send it.  To me it seemed better
to send it.

Thank you for providing a constructive review despite my caveats!  :)


> and I also don't think I want to have
> the infrastructure for it in mach-rockchip and would want to see that
> at least shared across arch/arm if it's too hard to do
> cross-architecture. If you were to include code from drivers/memory/
> in the blob, you couldn't keep it in mach-rockchip anyway.

I guess I was envisioning that if other places need similar
functionality that they would copy the ideas here.  Some of the
Makefile bits could possibly be shared through some type of Makefile
library.  I know copying code / Makefiles is bad, but sometimes it's
the cleanest way to do something.  If we start seeing a lot of
duplication then we can make things common and we can truly evaluate
whether the common solution is better than the duplication.


> AFAICT, the quantenna implementation is similar to the itcm/dtcm
> stuff we already have (but are not using upstream), so I wonder
> why we can't use that here too, see Documentation/arm/tcm.txt

I wasn't aware of the TCM stuff.  Thanks for the pointer!  It looks
pretty neat...

Ah, but the TCM stuff has a critical difference from my problem.  By
the very definition of TCM you don't need to do relocation.

TCM has the magical property that you can assign the physical address.
That means that you instantly sidestep multiplatform problems of
having SRAM at different physical addresses.  You can compile the code
to assume it's at 0xfffe0000 and it will work on every single machine
out there that needs TCM.  So if you've got a generic "udelay"
function you could just mark it as a "tcmfunc" and it will work
everywhere.  No relocation needed and the compiler knows exactly where
things will be.

Unfortunately, the rk3288 doesn't have TCM.  I tried enabling it and
got these nice printouts at boot:

    DTCM    : 0xfffe8000 - 0xfffe8000   (   0 kB)
    ITCM    : 0xfffe0000 - 0xfffe0000   (   0 kB)

Instead of TCM I'm using the "PMU SRAM" on the rk3288 which is
designed to keep code and data across deep sleep.  Adding relocation
to the existing TCM support gets back into the rats nest of issues
that I was trying to avoid tackling.

A few other TCM thoughts:

1. It sure seems unlikely that the current TCM solution would scale to
multiplatform.  Oh right, Linus W said this in his reply, too.  If
you've got SoC_A, SoC_B, and SoC_C all marking their functions
"tcmfunc" then they'll all be placed in the TCM section, right?
There's no way to detect that you're on SoC_A and that you only need
the SoC_A code.  Given the marching orders of multiplatform,
multiplatform, multiplatform then I _think_ that means we shouldn't
let anyone merge any code to mainline that uses TCM (unless TCM gets
revamped).

2. I haven't tried it, but it seems like the compiler still might not
catch stray (accidental) accesses from the TCM section to the non-TCM
section.  Again, this isn't a showstopper because you'd just track
each one down, but it is a nice feature of adding a separate
executable.


As always, please correct me where I'm misunderstanding things.


Unless any of the above has changed your minds, feel free to consider
this patch abandoned and thus we part ways amicably.  :)  At least
rk3288 looks like it can get _basic_ suspend/resume (without shutting
off SDRAM) working without this...

-Doug
