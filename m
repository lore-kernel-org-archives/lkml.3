Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3CRPHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:07:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65142 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab3CRPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:07:40 -0400
Date: Mon, 18 Mar 2013 15:07:24 +0000
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if
 system supports 'has_ossr'
Message-ID: <20130318150724.GC28585@mudshark.cambridge.arm.com>
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
 <51406BA7.8010306@arm.com>
 <51407120.7030709@ti.com>
 <51417E58.5050501@ti.com>
 <20130315050014.GA15706@tiny-lites>
 <5146B972.1010002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5146B972.1010002@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Mon, Mar 18, 2013 at 06:51:30AM +0000, Santosh Shilimkar wrote:
> On Friday 15 March 2013 10:30 AM, Will Deacon wrote:
> > Furthermore, I was under the impression that hw_breakpoint did actually
> > work on panda, which implies that a cold boot *does* manage to reset the
> > registers (can you please confirm this by looking in your dmesg during
> > boot?). In that case, it seems as though a PM cycle is powering down a
> > bunch of debug logic that was powered up during boot, and then we trip over
> > because we can't access the register bank.
> > 
> Actually it seems to be without PM. Thanks to analysis from Lokesh, the issue
> can be seen even with just suspend or cpu hotplug. So cold boot as such is
> fine.

Right, so what you're saying is that monitor-mode hardware debug only works
until the first pm/suspend/hotplug operation, then it's dead in the water?

> > The proper solution to this problem requires us to establish exactly what is
> > turning off the debug registers, and then having an OMAP PM notifier to
> > enable it again. Assuming this has always been the case, I expect hardware
> > debug across PM fails silently with older kernels.
> > 
> This has been always the case it seems with CPU power cycle.
> After the CPU is power cycled, 'DBGAUTHSTATUS' reads '0xaa' rather
> than '0xaf' which means 'DBGEN = 0' and hence code fails to enable
> monitor mode. This happens on both secure and GP devices and it can not
> be patched since the secure code is ROM'ed. We didn't notice so far
> because hw_breakpoint support was not default enabled on OMAP till the
> multi-platform build.

That really sucks :( Does this affect all OMAP-based boards?

> >> I was also wondering whether we should just warn once rather
> >> than continuous warnings in the notifier. Patch is end of the
> >> email.
> > 
> > Could do, but I'd like to see a fix for the real issue before we simply hide
> > the warnings :)
> > 
> Agree here too. As evident above, the feature won't work on OMAP4
> devices with PM and hence some solution is needed.
> 
> What you think of below ?

Comments inline...

> 
> From d74b4264f6a5967b0f7ada96aad77ab0ac30dbed Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Mon, 18 Mar 2013 11:59:04 +0530
> Subject: [PATCH] ARM: hw_breakpoints: Check for CPU debug availability before
>  enabling it
> 
> CPU debug features like hardware break, watchpoints can be used only when
> the debug mode is enabled and available for non-secure mode.
> 
> Hence check 'DBGAUTHSTATUS.DBGEN' before proceeding to enable the
> features.
> 
> Thanks to Will for pointers and Lokesh for the analysis of the issue on
> OMAP4 where after a CPU power cycle, debug mode gets disabled.
> 
> Cc: Will Deacon <Will.Deacon@arm.com>
> 
> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  arch/arm/kernel/hw_breakpoint.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index 96093b7..683a7cf 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -930,6 +930,14 @@ static void reset_ctrl_regs(void *unused)
>  	int i, raw_num_brps, err = 0, cpu = smp_processor_id();
>  	u32 val;
>  
> +	/* Check if we have access to CPU debug features */
> +	ARM_DBG_READ(c7, c14, 6, val);
> +	if ((val & 0x1) == 0) {
> +		pr_warn_once("CPU %d debug is unavailable\n", cpu);
> +		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
> +		return;
> +	}

There are a few of problems here:

	1. That is only checking for non-secure access, which precludes
	   running Linux in secure mode.

	2. DBGAUTHSTATUS accesses are UNPREDICTABLE when the double-lock is
	   set for v7.1 processors.

	3. DBGAUTHSTATUS doesn't exist in ARMv6.

	4. CPUs without the security extensions have DBGAUTHSTATUS.NSE == 0

	5. Accessing DBGAUTHSTATUS requires DBGEN to be driven high.
	   Assuming that your pr_warn_once is emitted, this implies that
	   DBGEN is driven high from cold boot, yet the NSE bit is low,
	   implying that DBGEN is also low. That's contradictory, so I have
	   no idea what's going on...

Apart from that, it's fine!

Will
