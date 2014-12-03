Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaLCNV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:21:58 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61371 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaLCNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:21:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<20141201225057.GA11285@n2100.arm.linux.org.uk>
	<CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
	<25485084.A6ydfR9Xle@wuerfel>
	<CAD=FV=UFWZEcbO2ty0m+qEGv4Xgq0N=Rs30wBgw=6+OGd5gSpg@mail.gmail.com>
Date: Wed, 3 Dec 2014 14:21:55 +0100
Message-ID: <CACRpkdapVhrQe7n5wDzZbf3fYGGpB-jPzG8Z+A8X6j5ERLxAfg@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        russ.dill@gmail.com, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 6:36 PM, Doug Anderson <dianders@chromium.org> wrote:

> Ah, but the TCM stuff has a critical difference from my problem.  By
> the very definition of TCM you don't need to do relocation.
>
> TCM has the magical property that you can assign the physical address.
> That means that you instantly sidestep multiplatform problems of
> having SRAM at different physical addresses.

An SRAM behaves like an ITCM and no DTCM. So just
patch the code to believe it is an ITCM and test it out.

Then I guess you're implictly referring to the fact that the code
that you're running in your TCM/SRAM will turn of the MMU,
so it can't be used for remapping. This is correct, BUT if you're
just compiling for one single machine anyway it doesn't matter,
just use 0xBFEA0000 or wherever it is physically as the phys+virt
address.

They are just defined like so in arch/arm/include/asm/memory.h:

/*
 * We fix the TCM memories max 32 KiB ITCM resp DTCM at these
 * locations
 */
#ifdef CONFIG_HAVE_TCM
#define ITCM_OFFSET     UL(0xfffe0000)
#define DTCM_OFFSET     UL(0xfffe8000)
#endif

Patch it and see if it works.

>  You can compile the code
> to assume it's at 0xfffe0000 and it will work on every single machine
> out there that needs TCM.

Doesn't matter as long as we're not multiplatform! It's more like
ITCM_OFFSET would be a Kconfig constant and you could change
it per-platform that need this.

>  So if you've got a generic "udelay"
> function you could just mark it as a "tcmfunc" and it will work
> everywhere.  No relocation needed and the compiler knows exactly where
> things will be.

This would still work as long as you're not multiplatform.

But udelay is probably a bad idea. Maybe sched_clock() or others.

> 1. It sure seems unlikely that the current TCM solution would scale to
> multiplatform.  Oh right, Linus W said this in his reply, too.

Yes. But it is no less elegant than this patch AFAICT.

> you've got SoC_A, SoC_B, and SoC_C all marking their functions
> "tcmfunc" then they'll all be placed in the TCM section, right?
> There's no way to detect that you're on SoC_A and that you only need
> the SoC_A code.  Given the marching orders of multiplatform,
> multiplatform, multiplatform then I _think_ that means we shouldn't
> let anyone merge any code to mainline that uses TCM (unless TCM gets
> revamped).
>
> 2. I haven't tried it, but it seems like the compiler still might not
> catch stray (accidental) accesses from the TCM section to the non-TCM
> section.  Again, this isn't a showstopper because you'd just track
> each one down, but it is a nice feature of adding a separate
> executable.

This is correct I think.

I think something in the direction of Russ Dill's patch set is the right
way forward to fix the problem for multiplatform.

Yours,
Linus Walleij
