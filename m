Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaIPURr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:17:47 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36201 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaIPURq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <1410864271-9277-3-git-send-email-kever.yang@rock-chips.com>
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com> <1410864271-9277-3-git-send-email-kever.yang@rock-chips.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 16 Sep 2014 13:17:25 -0700
X-Google-Sender-Auth: Htjxc4PIJEzrNnwpQ3HboFtn2U4
Message-ID: <CAPz6YkVqhO6kJtySB7MrCYzVLgjViKLO3c_HgS_NVxt3-=SJew@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: rockchip: add basic smp support for rk3288
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, hj@rock-chips.com,
        huangtao@rock-chips.com, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 3:44 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add basic rk3288 smp support, cpu 1~3 are in wfe state
> when get into kernel.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - use rk3288_boot_secondary instead ofsmp_boot_secondary
> - discards the power domain operation
> - handle the per cpu starup when actived by 'sev'
>
>  arch/arm/mach-rockchip/core.h    |  1 +
>  arch/arm/mach-rockchip/headsmp.S | 14 +++++++++
>  arch/arm/mach-rockchip/platsmp.c | 63 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 72 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-rockchip/core.h b/arch/arm/mach-rockchip/core.h
> index 39bca96..13de05a 100644
> --- a/arch/arm/mach-rockchip/core.h
> +++ b/arch/arm/mach-rockchip/core.h
> @@ -18,3 +18,4 @@ extern char rockchip_secondary_trampoline_end;
>
>  extern unsigned long rockchip_boot_fn;
>  extern void rockchip_secondary_startup(void);
> +extern void rk3288_secondary_startup(void);
> diff --git a/arch/arm/mach-rockchip/headsmp.S b/arch/arm/mach-rockchip/headsmp.S
> index 73206e3..bacdb56 100644
> --- a/arch/arm/mach-rockchip/headsmp.S
> +++ b/arch/arm/mach-rockchip/headsmp.S
> @@ -20,6 +20,20 @@ ENTRY(rockchip_secondary_startup)
>         b       secondary_startup
>  ENDPROC(rockchip_secondary_startup)
>
> +ENTRY(rk3288_secondary_startup)
> +       mrc p15, 0, r0, c0, c0, 5
> +       mov r2, #3
> +       and r0, r0, r2
> +       ldr r1, =0xff700000
> +       ldr r1, [r1]
> +       cmp r0, r1
> +       beq 2f
> +       ldr r2, =0xfffd0000
> +       mov pc, r2
> +2:
> +       b       secondary_startup
> +ENDPROC(rk3288_secondary_startup)

Comments on what's going on here would be nice.
It looks like what you're doing is checking to see whether this CPU is
the one that is supposed to wake up or not, but looking at sram
(written by the C code below), and this isn't the correct CPU then go
back to boot rom?  Since we read in int-mem from the device-tree it
would also probably be good to make that ldr r1, 0xff700000 reference
the sram_base_addr variable rather than hard coding here.

> +
>  ENTRY(rockchip_secondary_trampoline)
>         ldr     pc, 1f
>  ENDPROC(rockchip_secondary_trampoline)
> diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
> index 189684f..022a01d 100644
> --- a/arch/arm/mach-rockchip/platsmp.c
> +++ b/arch/arm/mach-rockchip/platsmp.c
> @@ -60,7 +60,7 @@ static void pmu_set_power_domain(int pd, bool on)
>   * Handling of CPU cores
>   */
>
> -static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
> +static int __cpuinit rk3066_boot_secondary(unsigned int cpu,
>                                              struct task_struct *idle)
>  {
>         if (!sram_base_addr || !pmu_base_addr) {
> @@ -80,6 +80,28 @@ static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
>         return 0;
>  }
>
> +static int __cpuinit rk3288_boot_secondary(unsigned int cpu,
> +                                            struct task_struct *idle)
> +{
> +       if (!sram_base_addr) {
> +               pr_err("%s: sram missing for cpu boot\n", __func__);
> +               return -ENXIO;
> +       }
> +
> +       if (cpu >= ncores) {
> +               pr_err("%s: cpu %d outside maximum number of cpus %d\n",
> +                                                       __func__, cpu, ncores);
> +               return -ENXIO;
> +       }
> +       /* start the core */
> +       writel(virt_to_phys(rk3288_secondary_startup), sram_base_addr + 8);
> +       writel(0xDEADBEAF, sram_base_addr + 4);
> +       writel(cpu, sram_base_addr + 0);

I guess the boot rom is looking for 0xDEADBEEF here at sram_base_addr
+ 4, but the cpu itself will be looking at sram_base_addr + 0.
Again, might be good to somehow document what the protocol is.

> +       dsb_sev();
> +
> +       return 0;
> +}
> +
>  /**
>   * rockchip_smp_prepare_sram - populate necessary sram block
>   * Starting cores execute the code residing at the start of the on-chip sram
> @@ -125,7 +147,7 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
>         return 0;
>  }
>
> -static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
> +static void __init rk3066_smp_prepare_cpus(unsigned int max_cpus)
>  {
>         struct device_node *node;
>         unsigned int i;
> @@ -194,12 +216,41 @@ static void rockchip_cpu_die(unsigned int cpu)
>  }
>  #endif
>
> -static struct smp_operations rockchip_smp_ops __initdata = {
> -       .smp_prepare_cpus       = rockchip_smp_prepare_cpus,
> -       .smp_boot_secondary     = rockchip_boot_secondary,
> +static void __init rk3288_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +       struct device_node *node;
> +
> +       node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-smp-sram");
> +       if (!node) {
> +               pr_err("%s: could not find sram dt node\n", __func__);
> +               return;
> +       }
> +
> +       sram_base_addr = of_iomap(node, 0);
> +       if (!sram_base_addr) {
> +               pr_err("%s: could not map pmu registers\n", __func__);
> +               return;
> +       }
> +
> +       ncores = 4;
> +}
> +
> +static struct smp_operations rockchip3066_smp_ops __initdata = {
> +       .smp_prepare_cpus       = rk3066_smp_prepare_cpus,
> +       .smp_boot_secondary     = rk3066_boot_secondary,
> +#ifdef CONFIG_HOTPLUG_CPU
> +       .cpu_kill               = rockchip_cpu_kill,
> +       .cpu_die                = rockchip_cpu_die,
> +#endif
> +};
> +CPU_METHOD_OF_DECLARE(rk3066_smp, "rockchip,rk3066-smp", &rockchip3066_smp_ops);
> +
> +static struct smp_operations rockchip3288_smp_ops __initdata = {
> +       .smp_prepare_cpus       = rk3288_smp_prepare_cpus,
> +       .smp_boot_secondary     = rk3288_boot_secondary,
>  #ifdef CONFIG_HOTPLUG_CPU
>         .cpu_kill               = rockchip_cpu_kill,
>         .cpu_die                = rockchip_cpu_die,
>  #endif
>  };
> -CPU_METHOD_OF_DECLARE(rk3066_smp, "rockchip,rk3066-smp", &rockchip_smp_ops);
> +CPU_METHOD_OF_DECLARE(rk3288_smp, "rockchip,rk3288-smp", &rockchip3288_smp_ops);
> --
> 1.9.1
>
