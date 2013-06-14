Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3FNOrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:47:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3FNOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:47:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: mach-moxart: add MOXA ART SoC files
Date: Fri, 14 Jun 2013 16:47:23 +0200
Message-ID: <2428901.voOA9oET8R@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com> <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Igz1NQSs6sToPxLuUyFgl8bZVvUc5CXwtSDildsGAvm
 y6M1OLE0HvhsV6nieVQ/rPM9c3lyDZY/r8ZYLxbJHeu/fUFacv
 JAKP5WVwREo6IVK90ZxjJuJHqzBtBqnGW8VgL6LBSqLB3YOZCu
 apHqIL4EjvvlstJvK3evdUbPUoOC1sXW/ck/PghpwBQAoC0Ymd
 do7iusHlwMWULzz3GlDLqyLq87Gxs+ZSPOix02N4Cb9DDMbzGo
 FRrRfuC2W9rro2hSZ86Wfxt9FfkEjZSPU0FMmmiGJfKXzxApXs
 KRikYthKvy+Jc1Be2gjgQ1+U74Je9r6BM8SnH28G/bBuI4CkAI
 ylduZgjoFw5ZEt9q6MsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013 14:34:06 Jonas Jensen wrote:

> diff --git a/arch/arm/mach-moxart/idle.c b/arch/arm/mach-moxart/idle.c
> new file mode 100644
> index 0000000..73ed844
> --- /dev/null
> +++ b/arch/arm/mach-moxart/idle.c
> @@ -0,0 +1,21 @@
> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version. */
> +
> +#include <linux/init.h>
> +#include <asm/system.h>
> +#include <asm/proc-fns.h>
> +
> +static void moxart_idle(void)
> +{
> +}
> +
> +static int __init moxart_idle_init(void)
> +{
> +	arm_pm_idle = moxart_idle;
> +	return 0;
> +}
> +
> +arch_initcall(moxart_idle_init);

IIRC Russell suggested changing cpu_fa526_do_idle() to not call WFI instead,
since the only other platform with fa526 has the same problem.

Your change above is actually wrong and breaks non-fa526 platforms in a
multiplatform kernel because it overrides arm_pm_idle without checking
what machine it currently runs on.

> diff --git a/arch/arm/mach-moxart/moxart.c b/arch/arm/mach-moxart/moxart.c
> new file mode 100644
> index 0000000..ab70386
> --- /dev/null
> +++ b/arch/arm/mach-moxart/moxart.c
> @@ -0,0 +1,23 @@
> +/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version. */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk-provider.h>

Most of these are probably unneeded now.

> +#include <asm/mach/arch.h>
> +
> +static const char * const moxart_dt_compat[] = {
> +	"moxa,moxart-uc-7112-lx",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
> +	.dt_compat		= moxart_dt_compat,
> +MACHINE_END

If the .dt_compat fields is the only field in the machine descriptor,
you can leave out the entire descriptor!

Olof, do you have a preference to how we want to handle this? The
only advantage of having this file at all is to have the
"MOXA UC-7112-LX" string in /proc/cpuinfo.
Should we just remove the entire directory or leave it as the trivial
file above?

	Arnd
