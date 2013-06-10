Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3FJHro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:47:44 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39555 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3FJHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130607173004.GA29344@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <20130606110240.GA3320@localhost.localdomain> <CAAVeFu+o7oc4Rrn67xxzsgeZ9xrTBkaLd_E4amaVgcNBRsKC_g@mail.gmail.com>
 <20130607173004.GA29344@localhost.localdomain>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 10 Jun 2013 16:47:22 +0900
Message-ID: <CAAVeFuJuf2hrMaM5keoai65vAAg6JLrjDUvYm4e2zQvsw64_8A@mail.gmail.com>
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

On Sat, Jun 8, 2013 at 2:30 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> Most likely it's either unnecessary, or insufficient.
>
> Just for entering call SMC properly, it's not needed.  If the Secure
> World has its MMU on and maps Normal World memory using the same memory
> types as Linux, then the Normal World and Secure World access the memory
> coherently with no extra barrier needed.
>
> It the Secure World's MMU is off, or if it maps Normal World memory
> as Secure (pagetable NS bit = 0), or if it maps Normal World memory with
> memory types incompatible with the ones Linux is using then you will get
> coherency problems: the Secure and Normal Worlds won't necessarily see
> the same data.
>
> In the latter case, you must do explicit cache maintenance around SMC
> for the data you want to exchange.  This might also be needed in the
> Secure World if caches are enabled over there.  DSB isn't enough by
> itself.
>
>
> If the Secure World doesn't access Normal World memory at all, you
> don't need to do anything special and can remove the DSB.
>
> Otherwise, for performance reasons, it is definitely preferable to have
> the Secure World MMU on if possible, though it's a bit more complex to
> set up.

Thanks for the information. I will try to understand why we put it
here in the first place.

>> >> +             "smc    #0\n\t"
>> >> +             "ldr    r3, =__tegra_smc_stack\n\t"
>> >> +             "ldmia  r3, {r4-r12, lr}"
>> >> +                     :
>> >> +                     : [type]    "r" (type),
>> >> +                       [subtype] "r" (subtype),
>> >> +                       [arg]     "r" (arg)
>> >> +                     : "r0", "r1", "r2", "r3", "r4", "memory");
>> >
>> > If r5-r12 are not clobbered, why do you save and restore them?
>>
>> The secure monitor might change them.
>
> Sure, but you could just add all the registers to the clobber list,
> and then the compiler would save and restore them for you in the
> function entry/exit sequences, which may be a bit more efficient.
>
> Since you are going to replace this code anyway, it's academic
> though.

Right. I suppose you mentioned this in the context of my initial code
- however if I understand how inline asm works (in case it wasn't
clear already, I probably don't), turning this function into a naked
function will make it impossible for the compiler to generate the
entry/exit sequences since the assembler code will be responsible for
returning from the function.

One could remove the naked attribute and put there registers into the
clobber list, but then the function will be inlined and we will have
to ensure the parameters end up in the right register (and having a
function that cannot be inlined is convenient in that respect). So as
far as I can tell, having the function naked and saving the registers
ourselves seems to be the most convenient way around this.

Thanks,
Alex.
