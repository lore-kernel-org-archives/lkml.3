Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946488Ab3BHM30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:29:26 -0500
Received: from mout.gmx.net ([212.227.17.20]:51574 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946433Ab3BHM3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:29:22 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/rY8NK/xPrW1Web1x+EMT0zBflZ0PE7ZwxQDU4+q
	ihMB09hP9zyytZ
From: Marc Dietrich <marvin24@gmx.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, arnd@arndb.de,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Date: Fri, 08 Feb 2013 13:29:14 +0100
Message-ID: <340098510.UosBEPkrGv@fb07-iapwap2>
User-Agent: KMail/4.9.5 (Linux/3.7.6-22-desktop; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360308574-19658-2-git-send-email-hdoyu@nvidia.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <1360308574-19658-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi,

Am Freitag, 8. Februar 2013, 09:29:31 schrieb Hiroshi Doyu:
> Refactored tegra{20,30,114}_init_early() so that we have the unified
> tegra_init_early().
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>

[...]

> diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
> index a599f6e..9bcecb8 100644
> --- a/arch/arm/mach-tegra/hotplug.c
> +++ b/arch/arm/mach-tegra/hotplug.c
> @@ -1,8 +1,7 @@
>  /*
> - *
>   *  Copyright (C) 2002 ARM Ltd.
>   *  All Rights Reserved
> - *  Copyright (c) 2010, 2012 NVIDIA Corporation. All rights reserved.
> + *  Copyright (c) 2010, 2012-2013, NVIDIA Corporation. All rights reserved.
> *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -15,6 +14,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/smp_plat.h>
> 
> +#include "fuse.h"
>  #include "sleep.h"
> 
>  static void (*tegra_hotplug_shutdown)(void);
> @@ -56,18 +56,21 @@ int tegra_cpu_disable(unsigned int cpu)
>  	return cpu == 0 ? -EPERM : 0;
>  }
> 
> -#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> -extern void tegra20_hotplug_shutdown(void);
> -void __init tegra20_hotplug_init(void)
> +void __init tegra_hotplug_init(void)
>  {
> -	tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
> -}
> +	switch (tegra_chip_id) {
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> +	case TEGRA20:
> +		tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
> +		break;
>  #endif
> -
> -#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> -extern void tegra30_hotplug_shutdown(void);
> -void __init tegra30_hotplug_init(void)
> -{
> -	tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
> -}
> +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
> +	case TEGRA30:
> +		tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
> +		break;
>  #endif
> +	default:
> +		BUG_ON(IS_ENABLED(CONFIG_HOTPLUG_CPU));
> +		break;
> +	}
> +}

are these ifdefs really needed? Multisoc kernels will enable them all anyway 
and there is a case structure which protects the assignments. Also the hotplug 
functions are very tiny, so there shouldn't be a big loss.

Marc



