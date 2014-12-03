Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLCQ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:57:43 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58152 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaLCQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:57:41 -0500
MIME-Version: 1.0
In-Reply-To: <6779994.zYRbhBjLnB@wuerfel>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<25485084.A6ydfR9Xle@wuerfel>
	<CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
	<6779994.zYRbhBjLnB@wuerfel>
Date: Wed, 3 Dec 2014 08:57:40 -0800
X-Google-Sender-Auth: kurKHlurr_G6f40K2zhdYIWuQvs
Message-ID: <CAD=FV=WbdEQ1qS3h=7ybQavuiKzPjc0Ys1oNkcuXkv4CEcJgdQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Doug Anderson <dianders@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Russ Dill <russ.dill@gmail.com>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Wed, Dec 3, 2014 at 6:42 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 02 December 2014 09:36:00 Doug Anderson wrote:
>> On Tue, Dec 2, 2014 at 1:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 01 December 2014 15:04:59 Doug Anderson wrote:
>> >> On Mon, Dec 1, 2014 at 2:50 PM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> > I recently looked at another vendor tree (quantenna wifi access point,
>> > based on arch/arc), which was putting arbitrary functions into SRAM
>> > for performance reasons, in their case the entire hot path for network
>> > switching. Having at least the infrastructure to do this seems like
>> > a great idea, even though it's very hard to do in a general-purpose
>> > kernel, as you'd have a hard time squeezing as much code as possible
>> > into the available SRAM.
>>
>> I'm always a fan of seeing general infrastructure introduced, though
>> we always need to make sure that the general infrastructure makes
>> things easier and not harder.  There's always the danger of adding so
>> much abstraction for a small thing that using it is like pulling
>> teeth.  I'm not saying that's the case here, but it is always a
>> danger.
>>
>> Note: I will point out a critical differences between the "hotpath"
>> problem and the one I'm solving here.  When you're just trying to
>> speed up a hotpath, it's not the end of the world if there's a stray
>> access to SDRAM.  If you happen to access a global variable in SDRAM,
>> or use a libc function to do division, or have a WARN_ON, those things
>> are OK.  It might also be OK if the stack was still in SDRAM.  When
>> you're compiling code that has to run with no other kernel function
>> present it's really nice to link them into a separate executable.
>
> Yes, makes sense. We might be able to use the same trick that we have
> for verifying __init sections though: During the final link of the
> vmlinux or module, check that an SRAM function only calls other
> functions that are in SRAM and accesses global variables that way
> too.

Yup, I thought about this.  You might want some way to make decisions
about whether accesses are OK.  If you're optimizing a hotpath maybe
all accesses are OK (but deserve a warning?).  If you're running code
where SDRAM is not available then no accesses are OK.


> It wouldn't cover any pointers you pass using function arguments
> though, and I don't yet understand the requirements for stack accesses.
> How do you currently deal with local variables that are put on the
> stack by a blob?

The blob sets up its own stack in assembly code.


>> > and I also don't think I want to have
>> > the infrastructure for it in mach-rockchip and would want to see that
>> > at least shared across arch/arm if it's too hard to do
>> > cross-architecture. If you were to include code from drivers/memory/
>> > in the blob, you couldn't keep it in mach-rockchip anyway.
>>
>> I guess I was envisioning that if other places need similar
>> functionality that they would copy the ideas here.  Some of the
>> Makefile bits could possibly be shared through some type of Makefile
>> library.  I know copying code / Makefiles is bad, but sometimes it's
>> the cleanest way to do something.  If we start seeing a lot of
>> duplication then we can make things common and we can truly evaluate
>> whether the common solution is better than the duplication.
>
> The makefile parts should be really easy to share by putting them
> into scripts/Makefile.lib.

Agreed.


>> > AFAICT, the quantenna implementation is similar to the itcm/dtcm
>> > stuff we already have (but are not using upstream), so I wonder
>> > why we can't use that here too, see Documentation/arm/tcm.txt
>>
>> I wasn't aware of the TCM stuff.  Thanks for the pointer!  It looks
>> pretty neat...
>>
>> Ah, but the TCM stuff has a critical difference from my problem.  By
>> the very definition of TCM you don't need to do relocation.
>>
>> TCM has the magical property that you can assign the physical address.
>> That means that you instantly sidestep multiplatform problems of
>> having SRAM at different physical addresses.  You can compile the code
>> to assume it's at 0xfffe0000 and it will work on every single machine
>> out there that needs TCM.  So if you've got a generic "udelay"
>> function you could just mark it as a "tcmfunc" and it will work
>> everywhere.  No relocation needed and the compiler knows exactly where
>> things will be.
>
> Ok, I have to admit that I don't actually understand the differences
> myself. Why does the physical address of the TCM matter? Can't we
> just map the SRAM to a sufficiently large well-known virtual address?

Linus W. got it right when he said I was implicitly alluding to the
fact that I needed to be running with the MMU off.  I'm running resume
code which runs with everything off and all addresses are physical.

In my case I could compile the code PIC/PID if needed, but I don't
think it's so easy with the TCM approach.


>> Unfortunately, the rk3288 doesn't have TCM.  I tried enabling it and
>> got these nice printouts at boot:
>>
>>     DTCM    : 0xfffe8000 - 0xfffe8000   (   0 kB)
>>     ITCM    : 0xfffe0000 - 0xfffe0000   (   0 kB)
>>
>> Instead of TCM I'm using the "PMU SRAM" on the rk3288 which is
>> designed to keep code and data across deep sleep.  Adding relocation
>> to the existing TCM support gets back into the rats nest of issues
>> that I was trying to avoid tackling.
>>
>> A few other TCM thoughts:
>>
>> 1. It sure seems unlikely that the current TCM solution would scale to
>> multiplatform.  Oh right, Linus W said this in his reply, too.  If
>> you've got SoC_A, SoC_B, and SoC_C all marking their functions
>> "tcmfunc" then they'll all be placed in the TCM section, right?
>
> Correct, that would be a problem, at least if the total size grows
> to more than the minimum of any of the chips' physical SRAM.

See below.  I have 4K, which means that the total size of all SoC's
TCM code has to be less than 4K.


>> There's no way to detect that you're on SoC_A and that you only need
>> the SoC_A code.  Given the marching orders of multiplatform,
>> multiplatform, multiplatform then I _think_ that means we shouldn't
>> let anyone merge any code to mainline that uses TCM (unless TCM gets
>> revamped).
>
> Just out of curiosity, what sizes are we looking at here, for the
> code you currently have and the available SRAM on rk3288?

I'm running in 4K of SRAM.  I think my current code is just over 2K.
It's unlikely any other platform would fit.


>> 2. I haven't tried it, but it seems like the compiler still might not
>> catch stray (accidental) accesses from the TCM section to the non-TCM
>> section.  Again, this isn't a showstopper because you'd just track
>> each one down, but it is a nice feature of adding a separate
>> executable.
>
> No, the compiler won't care about this, but as mentioned above we
> can have the kernel linker scripts help us a bit here.

Yup, true.

-Doug
