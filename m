Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3FCDvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:51:31 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:46059 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3FCDvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <1369993517-24735-1-git-send-email-srinivas.kandagatla@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993517-24735-1-git-send-email-srinivas.kandagatla@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 3 Jun 2013 11:51:02 +0800
Message-ID: <CAGsJ_4yu2MT5o7hbX67KPhrejS9D1BbPcship4zxtXs3G9tE-Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] ARM:prima2:move postcore_initcalls to init_machine.
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Barry Song <baohua.song@csr.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Srinivas,

2013/5/31 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch moves all  postcore_initcalls to very first calls in
> init_machine. This should achieve the same sequencing as done via
> postcore_initcalls.
> Without this patch a multi_v7 kernel panics if we boot it on any
> non prima2 parts with below log:
>
> Kernel panic - not syncing: unable to find compatible pwrc node in dtb
>
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00536-ge2f1bc1 #63
> [<c001387c>] (unwind_backtrace+0x0/0xf8) from [<c00111cc>]
> (show_stack+0x10/0x14)
> [<c00111cc>] (show_stack+0x10/0x14) from [<c0341834>] (panic+0x90/0x1e4)
> [<c0341834>] (panic+0x90/0x1e4) from [<c0425784>]
> (sirfsoc_of_pwrc_init+0x24/0x58)
> [<c0425784>] (sirfsoc_of_pwrc_init+0x24/0x58) from [<c041f854>]
> (do_one_initcall+0x90/0x150)
> [<c041f854>] (do_one_initcall+0x90/0x150) from [<c041fa10>]
> (kernel_init_freeable+0xfc/0x1c4)
> [<c041fa10>] (kernel_init_freeable+0xfc/0x1c4) from [<c033d384>]
> (kernel_init+0x8/0xe4)
> [<c033d384>] (kernel_init+0x8/0xe4) from [<c000ded8>]
> (ret_from_fork+0x14/0x3c)
> CPU1: stopping
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.0-rc3-00536-ge2f1bc1 #63
> [<c001387c>] (unwind_backtrace+0x0/0xf8) from [<c00111cc>]
> (show_stack+0x10/0x14)
> [<c00111cc>] (show_stack+0x10/0x14) from [<c0012030>]
> (handle_IPI+0xf8/0x12c)
> [<c0012030>] (handle_IPI+0xf8/0x12c) from [<c0008600>]
> (gic_handle_irq+0x54/0x5c)
> [<c0008600>] (gic_handle_irq+0x54/0x5c) from [<c000da80>]
> (__irq_svc+0x40/0x50)
> Exception stack(0xef079fa0 to 0xef079fe8)
> 9fa0: c0ddd6d8 00000000 000002d2 00000000 ef078000 c04888f5 00000001
> c04888f5
> 9fc0: c045c490 c045c42c c0348f38 00000000 01000000 ef079fe8 c000f018
> c000f01c
> 9fe0: 60000113 ffffffff
> [<c000da80>] (__irq_svc+0x40/0x50) from [<c000f01c>]
> (arch_cpu_idle+0x28/0x30)
> [<c000f01c>] (arch_cpu_idle+0x28/0x30) from [<c0051080>]
> (cpu_startup_entry+0x60/0x130)
> [<c0051080>] (cpu_startup_entry+0x60/0x130) from [<6033dfc4>]
> (0x6033dfc4)
>
> Initially detected when booting Stih415 SOC with multi_v7_defconfig.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

did you see this one?

[PATCH v2] arm: prima2: use of_platform_populate instead of
of_platform_bus_probe
http://www.spinics.net/lists/arm-kernel/msg243710.html


> ---
>  arch/arm/mach-prima2/common.c |    3 +++
>  arch/arm/mach-prima2/pm.c     |    6 ++----
>  arch/arm/mach-prima2/pm.h     |    2 ++
>  3 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
> index 9aefcd6..8e27cb7 100644
> --- a/arch/arm/mach-prima2/common.c
> +++ b/arch/arm/mach-prima2/common.c
> @@ -16,6 +16,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include "common.h"
> +#include "pm.h"
>
>  static struct of_device_id sirfsoc_of_bus_ids[] __initdata = {
>         { .compatible = "simple-bus", },
> @@ -24,6 +25,8 @@ static struct of_device_id sirfsoc_of_bus_ids[] __initdata = {
>
>  void __init sirfsoc_mach_init(void)
>  {
> +       sirfsoc_of_pwrc_init();
> +       sirfsoc_memc_init();
>         of_platform_bus_probe(NULL, sirfsoc_of_bus_ids, NULL);
>  }
>
> diff --git a/arch/arm/mach-prima2/pm.c b/arch/arm/mach-prima2/pm.c
> index 9936c18..8850e3b 100644
> --- a/arch/arm/mach-prima2/pm.c
> +++ b/arch/arm/mach-prima2/pm.c
> @@ -96,7 +96,7 @@ static const struct of_device_id pwrc_ids[] = {
>         {}
>  };
>
> -static int __init sirfsoc_of_pwrc_init(void)
> +int __init sirfsoc_of_pwrc_init(void)
>  {
>         struct device_node *np;
>
> @@ -116,7 +116,6 @@ static int __init sirfsoc_of_pwrc_init(void)
>
>         return 0;
>  }
> -postcore_initcall(sirfsoc_of_pwrc_init);
>
>  static const struct of_device_id memc_ids[] = {
>         { .compatible = "sirf,prima2-memc" },
> @@ -143,8 +142,7 @@ static struct platform_driver sirfsoc_memc_driver = {
>         },
>  };
>
> -static int __init sirfsoc_memc_init(void)
> +int __init sirfsoc_memc_init(void)
>  {
>         return platform_driver_register(&sirfsoc_memc_driver);
>  }
> -postcore_initcall(sirfsoc_memc_init);
> diff --git a/arch/arm/mach-prima2/pm.h b/arch/arm/mach-prima2/pm.h
> index bae6d77..b658d66 100644
> --- a/arch/arm/mach-prima2/pm.h
> +++ b/arch/arm/mach-prima2/pm.h
> @@ -23,6 +23,8 @@
>
>  #ifndef __ASSEMBLY__
>  extern int sirfsoc_finish_suspend(unsigned long);
> +extern int __init sirfsoc_of_pwrc_init(void);
> +extern int __init sirfsoc_memc_init(void);
>  #endif
>
>  #endif
> --
> 1.7.6.5

-barry
