Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3KGRzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:55:41 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53090 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180Ab3KGRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:55:38 -0500
Message-ID: <527BD418.8000306@free-electrons.com>
Date: Thu, 07 Nov 2013 18:55:36 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, rob.herring@calxeda.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, baohua@kernel.org,
        dinguyen@altera.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/3] arm: mvebu: add missing of_node_put() to fix reference
 leak
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com> <1383793720-4643-3-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383793720-4643-3-git-send-email-jszhang@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:08, Jisheng Zhang wrote:
> Add of_node_put to properly decrement the refcount when we are
> done using a given node.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Seems ok for me too


Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory


> ---
>  arch/arm/mach-mvebu/armada-370-xp.c     | 1 +
>  arch/arm/mach-mvebu/coherency.c         | 8 +++++++-
>  arch/arm/mach-mvebu/platsmp.c           | 1 +
>  arch/arm/mach-mvebu/pmsu.c              | 1 +
>  arch/arm/mach-mvebu/system-controller.c | 1 +
>  5 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
> index 97cbb80..8a1ae83 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -64,6 +64,7 @@ static void __init armada_370_xp_mbus_init(void)
>  			ARMADA_370_XP_MBUS_WINS_SIZE,
>  			of_translate_address(dn, &sdram_wins_offs),
>  			ARMADA_370_XP_SDRAM_WINS_SIZE);
> +	of_node_put(dn);
>  }
>  
>  static void __init armada_370_xp_timer_and_clk_init(void)
> diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
> index 4c24303..58adf2f 100644
> --- a/arch/arm/mach-mvebu/coherency.c
> +++ b/arch/arm/mach-mvebu/coherency.c
> @@ -140,6 +140,7 @@ int __init coherency_init(void)
>  		coherency_base = of_iomap(np, 0);
>  		coherency_cpu_base = of_iomap(np, 1);
>  		set_cpu_coherent(cpu_logical_map(smp_processor_id()), 0);
> +		of_node_put(np);
>  	}
>  
>  	return 0;
> @@ -147,9 +148,14 @@ int __init coherency_init(void)
>  
>  static int __init coherency_late_init(void)
>  {
> -	if (of_find_matching_node(NULL, of_coherency_table))
> +	struct device_node *np;
> +
> +	np = of_find_matching_node(NULL, of_coherency_table);
> +	if (np) {
>  		bus_register_notifier(&platform_bus_type,
>  				      &mvebu_hwcc_platform_nb);
> +		of_node_put(np);
> +	}
>  	return 0;
>  }
>  
> diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
> index ce81d30..e7edb82 100644
> --- a/arch/arm/mach-mvebu/platsmp.c
> +++ b/arch/arm/mach-mvebu/platsmp.c
> @@ -95,6 +95,7 @@ static void __init armada_xp_smp_init_cpus(void)
>  		panic("No 'cpus' node found\n");
>  
>  	ncores = of_get_child_count(np);
> +	of_node_put(np);
>  	if (ncores == 0 || ncores > ARMADA_XP_MAX_CPUS)
>  		panic("Invalid number of CPUs in DT\n");
>  
> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
> index 3cc4bef..27fc4f0 100644
> --- a/arch/arm/mach-mvebu/pmsu.c
> +++ b/arch/arm/mach-mvebu/pmsu.c
> @@ -67,6 +67,7 @@ int __init armada_370_xp_pmsu_init(void)
>  		pr_info("Initializing Power Management Service Unit\n");
>  		pmsu_mp_base = of_iomap(np, 0);
>  		pmsu_reset_base = of_iomap(np, 1);
> +		of_node_put(np);
>  	}
>  
>  	return 0;
> diff --git a/arch/arm/mach-mvebu/system-controller.c b/arch/arm/mach-mvebu/system-controller.c
> index f875124..5175083c 100644
> --- a/arch/arm/mach-mvebu/system-controller.c
> +++ b/arch/arm/mach-mvebu/system-controller.c
> @@ -98,6 +98,7 @@ static int __init mvebu_system_controller_init(void)
>  		BUG_ON(!match);
>  		system_controller_base = of_iomap(np, 0);
>  		mvebu_sc = (struct mvebu_system_controller *)match->data;
> +		of_node_put(np);
>  	}
>  
>  	return 0;
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
