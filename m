Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3FGHZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:25:30 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33108 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3FGHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130606110240.GA3320@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <20130606110240.GA3320@localhost.localdomain>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Jun 2013 16:25:07 +0900
Message-ID: <CAAVeFu+o7oc4Rrn67xxzsgeZ9xrTBkaLd_E4amaVgcNBRsKC_g@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
To: Dave Martin <Dave.Martin@arm.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 8:02 PM, Dave Martin <Dave.Martin@arm.com> wrote:

>> +static int __attribute__((used)) __tegra_smc_stack[10];
>
> Use __used instead of using GCC attributes directly.
>
>> +
>> +/*
>> + * With EABI, subtype and arg already end up in r0, r1 and r2 as they are
>> + * function arguments, but we prefer to play safe here and explicitly move
>> + * these values into the expected registers anyway. mov instructions without
>> + * any side-effect are turned into nops by the assembler, which limits
>> + * overhead.
>> + */
>> +static void tegra_generic_smc(u32 type, u32 subtype, u32 arg)
>> +{
>> +     asm volatile(
>> +             ".arch_extension        sec\n\t"
>> +             "ldr    r3, =__tegra_smc_stack\n\t"
>
> ldr= should be avoided in inline asm, because GCC can't guess it's size,
> and can't guarantee that the literal pool word is close enough to be
> addressable (though for small compilation units it's unlikely to be a
> problem).

With Russel's suggested changes this will go away, but that's good to
know anyway.

>> +             "dsb\n\t"
>
> Can you explain what this DSB is for?

Just a safety measure to make sure all memory operations are done
before we enter the secure monitor. Is it unnecessary?

>> +             "smc    #0\n\t"
>> +             "ldr    r3, =__tegra_smc_stack\n\t"
>> +             "ldmia  r3, {r4-r12, lr}"
>> +                     :
>> +                     : [type]    "r" (type),
>> +                       [subtype] "r" (subtype),
>> +                       [arg]     "r" (arg)
>> +                     : "r0", "r1", "r2", "r3", "r4", "memory");
>
> If r5-r12 are not clobbered, why do you save and restore them?

The secure monitor might change them.

> In the ARM ABI, r12 is a caller-save register, so you probably
> don't need to save/restore that even if it is clobbered.

Right, thanks. Didn't know r12 could be used as a scratch register.

Alex.
