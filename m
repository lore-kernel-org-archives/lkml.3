Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaDOFJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:09:45 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52409 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDOFJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:09:42 -0400
MIME-Version: 1.0
In-Reply-To: <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
	<1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
Date: Tue, 15 Apr 2014 10:39:41 +0530
Message-ID: <CAHbNUh3m7n1OT9fc715vth=k6BdAvVZoYJjBvo8xT25TPji18w@mail.gmail.com>
Subject: Re: [PATCHv2 5/8] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
From: Tushar Behera <tushar.behera@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        =?UTF-8?B?67CV7LCs7Zi4?= <chanho61.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        marc.zyngier@arm.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 07:29, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch fix the offset of CPU boot address and don't operate smc call
> of SMC_CMD_CPU1BOOT command for Exynos3250.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/firmware.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index aa01c42..6205d4f 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -30,13 +30,16 @@ static int exynos_do_idle(void)
>
>  static int exynos_cpu_boot(int cpu)
>  {
> +       if (soc_is_exynos3250()) {
> +               return 0;
>         /*
>          * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>          * But, Exynos4212 has only one secondary CPU so second parameter
>          * isn't used for informing secure firmware about CPU id.
>          */
> -       if (soc_is_exynos4212())
> +       } else if (soc_is_exynos4212()) {
>                 cpu = 0;
> +       }
>

As you already return in case of Exynos3250, you need not change this.
First commit hunk without the opening brace should be sufficient.

>         exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>         return 0;
> @@ -46,7 +49,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>  {
>         void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
>
> -       if (!soc_is_exynos4212())
> +       if (!soc_is_exynos4212() && !soc_is_exynos3250())
>                 boot_reg += 4*cpu;
>
>         __raw_writel(boot_addr, boot_reg);
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Tushar Behera
