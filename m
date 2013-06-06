Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3FFJhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:37:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37248 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3FFJhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:37:06 -0400
Date: Thu, 6 Jun 2013 10:35:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
Message-ID: <20130606093524.GM18614@n2100.arm.linux.org.uk>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 04:28:07PM +0900, Alexandre Courbot wrote:
> +static int __attribute__((used)) __tegra_smc_stack[10];
> +
> +/*
> + * With EABI, subtype and arg already end up in r0, r1 and r2 as they are
> + * function arguments, but we prefer to play safe here and explicitly move
> + * these values into the expected registers anyway. mov instructions without
> + * any side-effect are turned into nops by the assembler, which limits
> + * overhead.

No they aren't.  They will be preserved as:
	mov r0, r0
	mov r1, r1
	mov r2, r2

Moreover, things will go wrong if the compiler decides for whatever reason
to move 'arg' into r0 before calling your code sequence.  So really this
is quite fragile.

There's also no point in mentioning EABI in the above paragraph; all ARM
ABIs under Linux have always placed the arguments in r0..r3 and then on
the stack.  You can assert that this is always true by using the __asmeq()
macro.

Also...

> + */
> +static void tegra_generic_smc(u32 type, u32 subtype, u32 arg)
> +{
> +	asm volatile(
> +		".arch_extension	sec\n\t"
> +		"ldr	r3, =__tegra_smc_stack\n\t"
> +		"stmia	r3, {r4-r12, lr}\n\t"

using a statically allocated area to save the registers in this way is
probably a bad move; although the hotplug code guarantees that there
will be no concurrency between CPU hotplug operations, this sets a
precident for it being used in places where no such protection exists.

What is wrong with stacking r4-r12, lr onto the SVC stack?  You don't
save the SVC stack pointer, so one can only assume that your SMC
implmentation preserves this (if it doesn't, that's yet another bug
with this assembly code.)

Combining these two issues, you're probably far better off using an
__attribute__((naked)) function for this - which means you get to
write the entire function in assembly code without any compiler
interference:

static void __attribute__((naked)) tegra_generic_smc(u32 type, u32 subtype, u32 arg)
{
	asm volatile(
		".arch_extension	sec\n\t"
		"stmfd	sp!, {r4 - r12, lr}\n\t"
		__asmeq("%0", "r0")
		__asmeq("%1", "r1")
		__asmeq("%2", "r2")
		"mov	r3, #0\n\t"
		"mov	r4, #0\n\t"
		"dsb\n\t"
		"smc	#0\n\t"
		"ldmfd	sp!, {r4 - r12, pc}"
		:
		: "r" (type), "r" (subtype), "r" (arg)
		: "memory");
}
