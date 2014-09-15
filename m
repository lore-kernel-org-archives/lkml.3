Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaIOJEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:04:07 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56910 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753252AbaIOJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:04:05 -0400
Date: Mon, 15 Sep 2014 10:03:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com
Subject: Re: [PATCH v4 6/7] ARM: EXYNOS: Add support for non-secure L2X0
	resume
Message-ID: <20140915090353.GD12379@n2100.arm.linux.org.uk>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com> <1409062680-15906-7-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409062680-15906-7-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:17:59PM +0200, Tomasz Figa wrote:
> On Exynos SoCs it is necessary to resume operation of L2C early in
> assembly code, because otherwise certain systems will crash. This patch
> adds necessary code to non-secure resume handler.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h   |  1 +
>  arch/arm/mach-exynos/firmware.c |  4 +++-
>  arch/arm/mach-exynos/sleep.S    | 41 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index c218200..e88c0f9 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -113,6 +113,7 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
>  
>  extern u32 cp15_save_diag;
>  extern u32 cp15_save_power;
> +extern unsigned long l2x0_regs_phys;
>  
>  extern void __iomem *sysram_ns_base_addr;
>  extern void __iomem *sysram_base_addr;
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index 554b350..71bcfbd 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -102,7 +102,9 @@ static int exynos_suspend(void)
>  	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
>  	writel(virt_to_phys(exynos_cpu_resume_ns),
>  		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
> -
> +#ifdef CONFIG_CACHE_L2X0
> +	l2x0_regs_phys = virt_to_phys(&l2x0_saved_regs);
> +#endif

NAK.  Please look at how arch/arm/mm/l2c-l2x0-resume.S gets the address
of this structure in assembly code.  The name of this variable is crap
in any case.  It's not the registers, it's the saved registers.  So even
more reason to kill this abomination, which incidentally, I've already
killed off once before in the exynos code.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
