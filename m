Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3FFKYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:24:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7415 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3FFKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:24:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Jun 2013 03:22:57 -0700
Message-ID: <51B06327.5030508@nvidia.com>
Date: Thu, 6 Jun 2013 19:23:35 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <20130606093524.GM18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130606093524.GM18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:35 PM, Russell King - ARM Linux wrote:
> On Thu, Jun 06, 2013 at 04:28:07PM +0900, Alexandre Courbot wrote:
>> +static int __attribute__((used)) __tegra_smc_stack[10];
>> +
>> +/*
>> + * With EABI, subtype and arg already end up in r0, r1 and r2 as they are
>> + * function arguments, but we prefer to play safe here and explicitly move
>> + * these values into the expected registers anyway. mov instructions without
>> + * any side-effect are turned into nops by the assembler, which limits
>> + * overhead.
>
> No they aren't.  They will be preserved as:
> 	mov r0, r0
> 	mov r1, r1
> 	mov r2, r2

I'm pretty sure I checked with objdump and saw these replaced by nops at 
some point, but for some reason I cannot get that behavior again. So 
simply put, my statement is wrong indeed.

> Moreover, things will go wrong if the compiler decides for whatever reason
> to move 'arg' into r0 before calling your code sequence.  So really this
> is quite fragile.
>
> There's also no point in mentioning EABI in the above paragraph; all ARM
> ABIs under Linux have always placed the arguments in r0..r3 and then on
> the stack.  You can assert that this is always true by using the __asmeq()
> macro.

Good to know, thanks.

> Also...
>
>> + */
>> +static void tegra_generic_smc(u32 type, u32 subtype, u32 arg)
>> +{
>> +	asm volatile(
>> +		".arch_extension	sec\n\t"
>> +		"ldr	r3, =__tegra_smc_stack\n\t"
>> +		"stmia	r3, {r4-r12, lr}\n\t"
>
> using a statically allocated area to save the registers in this way is
> probably a bad move; although the hotplug code guarantees that there
> will be no concurrency between CPU hotplug operations, this sets a
> precident for it being used in places where no such protection exists.

Indeed. This function will be called from other places in the future, 
and for these we cannot assume there will be no concurrency.

> What is wrong with stacking r4-r12, lr onto the SVC stack?

Nothing, actually. /o\

> You don't
> save the SVC stack pointer, so one can only assume that your SMC
> implmentation preserves this (if it doesn't, that's yet another bug
> with this assembly code.)

SVC stack pointer is ok AFAICT.

> Combining these two issues, you're probably far better off using an
> __attribute__((naked)) function for this - which means you get to
> write the entire function in assembly code without any compiler
> interference:
 >
> static void __attribute__((naked)) tegra_generic_smc(u32 type, u32 subtype, u32 arg)
> {
> 	asm volatile(
> 		".arch_extension	sec\n\t"
> 		"stmfd	sp!, {r4 - r12, lr}\n\t"
> 		__asmeq("%0", "r0")
> 		__asmeq("%1", "r1")
> 		__asmeq("%2", "r2")
> 		"mov	r3, #0\n\t"
> 		"mov	r4, #0\n\t"
> 		"dsb\n\t"
> 		"smc	#0\n\t"
> 		"ldmfd	sp!, {r4 - r12, pc}"
> 		:
> 		: "r" (type), "r" (subtype), "r" (arg)
> 		: "memory");
> }

Well, that works beautifully indeed, and results in a much smaller 
function that does nothing more beyond what's needed. On top of that, I 
feel enlightened.

Thanks, I will resubmit a fixed version soon.
Alex.

