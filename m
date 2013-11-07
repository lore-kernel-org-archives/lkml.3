Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3KGBvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:51:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3KGBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:51:15 -0500
Date: Wed, 6 Nov 2013 19:50:05 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 05/11] ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu
 hotplug/smp
Message-ID: <20131107015005.GE22684@joshc.qualcomm.com>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
 <1383343739-23080-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383343739-23080-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen-

Nit/suggestion below:

On Fri, Nov 01, 2013 at 03:08:53PM -0700, Stephen Boyd wrote:
[..]
> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
> index a8cae71c..c27ec55 100644
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -112,6 +112,15 @@ struct smp_operations {
>  #endif
>  };
>  
> +struct of_cpu_method {
> +	const char *method;
> +	struct smp_operations *ops;
> +};
> +
> +#define CPU_METHOD_OF_DECLARE(name, _method, _ops)			\
> +	static const struct of_cpu_method __cpu_method_of_table_##name	\
> +		__used __section(__cpu_method_of_table)			\
> +		= { .method = _method, .ops = _ops }
>  /*
>   * set platform specific SMP operations
>   */
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index f35906b..71a8592 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -25,6 +25,7 @@
>  #include <asm/smp_plat.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach-types.h>
> +#include <asm/smp.h>
>  
>  void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
> @@ -63,6 +64,36 @@ void __init arm_dt_memblock_reserve(void)
>  	}
>  }
>  
> +#ifdef CONFIG_SMP
> +extern struct of_cpu_method __cpu_method_of_table[];
> +
> +static const struct of_cpu_method __cpu_method_of_table_sentinel
> +	__used __section(__cpu_method_of_table_end);

Having a sentinel allocated into the linked image makes a lot of sense
in other cases (IRQCHIP/CLOCKSOURCE_OF_DECLARE, etc), where it's used to
terminate an of_device_id table (as is expected by of_match_table and
friends).

In this case, however, you aren't building a match table, so having a
sentinel allocated isn't necessary.  I'd suggest bookending the table
with a VMLINUX_SYMBOL(__cpu_method_of_table_end) instead.

A whole 2 pointers worth of savings!

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
