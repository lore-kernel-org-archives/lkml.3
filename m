Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaFXQW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:22:57 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49923 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaFXQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:22:53 -0400
Date: Tue, 24 Jun 2014 12:22:50 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v6 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
In-Reply-To: <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.LFD.2.11.1406241201180.16842@knanqh.ubzr>
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Daniel Thompson wrote:

> From: Anton Vorontsov <anton.vorontsov@linaro.org>
> 
> The FIQ debugger may be used to debug situations when the kernel stuck
> in uninterruptable sections, e.g. the kernel infinitely loops or
> deadlocked in an interrupt or with interrupts disabled.
> 
> By default KGDB FIQ is disabled in runtime, but can be enabled with
> kgdb_fiq.enable=1 kernel command line option.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
> Cc: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm/Kconfig                 |   2 +
>  arch/arm/Kconfig.debug           |  18 ++++++
>  arch/arm/include/asm/kgdb.h      |   7 +++
>  arch/arm/kernel/Makefile         |   1 +
>  arch/arm/kernel/kgdb_fiq.c       | 124 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/kgdb_fiq_entry.S |  87 +++++++++++++++++++++++++++
>  6 files changed, 239 insertions(+)
>  create mode 100644 arch/arm/kernel/kgdb_fiq.c
>  create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S

[...]

> +static long kgdb_fiq_setup_stack(void *info)
> +{
> +	struct pt_regs regs;
> +
> +	regs.ARM_sp = __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER) +
> +			THREAD_START_SP;
> +	WARN_ON(!regs.ARM_sp);

Isn't this rather fatal if you can't allocate any stack? Why not using 
BUG_ON(), or better yet propagate a proper error code back?

> +
> +	set_fiq_regs(&regs);
> +	return 0;
> +}
> +
> +/**
> + * kgdb_fiq_enable_nmi - Manage NMI-triggered entry to KGDB
> + * @on: Flag to either enable or disable an NMI
> + *
> + * This function manages NMIs that usually cause KGDB to enter. That is, not
> + * all NMIs should be enabled or disabled, but only those that issue
> + * kgdb_handle_exception().
> + *
> + * The call counts disable requests, and thus allows to nest disables. But
> + * trying to enable already enabled NMI is an error.
> + */
> +static void kgdb_fiq_enable_nmi(bool on)
> +{
> +	static atomic_t cnt;
> +	int ret;
> +
> +	ret = atomic_add_return(on ? 1 : -1, &cnt);
> +	if (ret > 1 && on) {
> +		/*
> +		 * There should be only one instance that calls this function
> +		 * in "enable, disable" order. All other users must call
> +		 * disable first, then enable. If not, something is wrong.
> +		 */
> +		WARN_ON(1);
> +		return;
> +	}

Minor style suggestion:

	/*
	 * There should be only one instance that calls this function
	 * in "enable, disable" order. All other users must call
	 * disable first, then enable. If not, something is wrong.
	 */
	if (WARN_ON(ret > 1 && on))
		return;

Other than that...

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
