Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaIXV2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:28:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41404 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751568AbaIXV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:28:15 -0400
Date: Wed, 24 Sep 2014 22:28:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
Message-ID: <20140924212803.GD5182@n2100.arm.linux.org.uk>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:27:28PM -0500, atull@opensource.altera.com wrote:
> diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
> index 5356a72..1d5f8ad 100644
> --- a/arch/arm/mach-socfpga/platsmp.c
> +++ b/arch/arm/mach-socfpga/platsmp.c
> @@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
>  
>  	if (cpu1start_addr) {
> +		/* This will put CPU #1 into reset.*/
> +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> +			     rst_manager_base_addr + 0x10);

If you can place CPU1 into reset, then why not place it into reset during
hot unplug?

> @@ -86,10 +90,12 @@ static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
>   */
>  static void socfpga_cpu_die(unsigned int cpu)
>  {
> -	cpu_do_idle();
> +	/* Flush the L1 data cache. */
> +	flush_cache_all();

Why do you think that's necessary?

This potentially flushes *all* levels of the cache, including L2, which
is not a nice thing to do if you have another CPU running.  Secondly,
the core code has already called flush_cache_louis() _twice_ for you
immediately prior to calling your cpu_die() function explicitly to
remove any L1 data.

The only data which should remain are speculative prefetches and stack
data specific to _this_ CPU (which could include dirty cache lines
associated with the stack frame to enter your cpu_die function.)
None of these cache lines are of any interest to other CPUs in the
system, so there's no need for them to be written back prior to the
CPU being reset or powered down for hot unplug.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
