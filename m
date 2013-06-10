Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3FJIF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:05:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61025 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3FJIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130607181318.GC29344@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <51B0BC80.9040007@wwwdotorg.org> <20130606180824.GC3320@localhost.localdomain>
 <CAAVeFuJkV3VVfeinLrjCCef9ZqJNvKurQwVWnJsW-bZqniTQ1w@mail.gmail.com> <20130607181318.GC29344@localhost.localdomain>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 10 Jun 2013 17:05:04 +0900
Message-ID: <CAAVeFuKsa=GsxexQOSOYPYvkAXaEZXfW1+zRmv25CtFEY=T_GQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
To: Dave Martin <Dave.Martin@arm.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 3:13 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> One way to make the backend generic would be to have something like
> one of the following (some syntax omitted due to laziness):
>
>         u32 __naked __call_smc(u32 r0, ...)
>         {
>                 asm volatile (
>                         stmfd   sp!, {r4-r11,lr}
>                         smc     #0
>                         ldmfd   sp!, {r4-r11,pc}
>                         ::: "memory"
>                 );
>         }
>
>         /* The above works for up to 4 u32 arguments */
>
>         u32 __naked __call_smc(u32 r0, ...)
>         {
>                 asm volatile (
>                         mov     ip, sp
>                         stmfd   sp!, {r4-r11,lr}
>                         ldmia   ip, {r4-r11}
>                         smc     #0
>                         ldmfd   sp!, {r4-r11,pc}
>                         ::: "memory"
>                 );
>         }
>
>         /*
>          * Works for up to 13 u32 arguments, provided the stack is deep
>          * enough to provide suitable garbage data to fill the registers
>          * if the caller supplied fewer arguments (a bit of a hack)
>          */
>
>         u32 __naked __call_smc(struct pt_regs *regs) {
>
>                 asm(
>                         stmfd   sp!, {r4-r11,lr}
>                         /* load regs from <regs> */
>                         smc #0
>                         /* save regs back to <regs> */
>                         ldmfd   sp!, {r4-r11,pc}
>                 );
>         }
>
>         /*
>          * Most generic,  least-efficient version.
>          * Can return up to 13 u32 results instead of just one.
>          * For convenience, the r0 value returned by the SMC could be
>          * left in r0 so that it also determines the return value of the
>          * function.
>          *
>          * Most of the time, SMC shouldn't be called on any hot path,
>          * otherwise the performance battle is already lost -- so it may
>          * not be crucial to reach the maximum possible efficiency for
>          * these calls.
>          */
>
>
> A particular firmware's Linux glue code might have to put extra stuff
> around calls to generic_smc, but at least generic_smc itself wouldn't
> need to be reinvented, and the firmware-specific glue code could usually
> avoid asm.
>
>> Another example is the function that Tomasz shown
>> (https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/mach-exynos/exynos-smc.S?id=refs/tags/next-20130606
>> ), which preserves r4-r11 but also assumes r3 is an argument - that's
>> again another slightly different convention.
>
> ... for which the above implementations of __call_smc() should work too.
>
>> All in all the needs of the various firmwares might end up being just
>> different enough that we need to have a different backend for each of
>> them. The firmware_ops defined in arch/arm/include/asm/firmware.h
>> perform the abstraction at a higher level, which seems more fit here
>> IMHO.
>>
>> Alex.
>
> Indeed.  If you think you could work with one of the above generics, we
> could try it and see what it looks like though.
>
> If it's an awkward fit, I might be being too optimistic.

I agree that your versions would most likely work in our (and probably
many others) case. But I wonder if individual platforms will not
prefer to sacrifice the ease of use of a generic version for the
ability to write faster code that will just preserve what is needed
(whether that performance gain is justified or not is of course
subject to debate). I don't have enough hindsight to decide which
approach is the best, but until we have more examples of firmwares
that would justify such a factorization, I think I'd like to go with
our own version first - for there is already more than enough to fix
in this patch. :)

Thanks,
Alex.
