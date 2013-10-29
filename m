Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3J2ATK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:19:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62009 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632Ab3J2ATI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:19:08 -0400
Date: Tue, 29 Oct 2013 00:18:59 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Dave P Martin <Dave.Martin@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 3/5] ARM: tegra: split setting of CPU reset handler
Message-ID: <20131029001858.GE4763@kartoffel>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
 <1382956118-12495-4-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382956118-12495-4-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:28:36AM +0000, Alexandre Courbot wrote:
> Not all Tegra devices can set the CPU reset handler in the same way.
> In particular, devices using a TrustZone secure monitor cannot set the
> reset handler directly and need to do it through a firmware operation.
> 
> This patch separates the act of setting the reset handler from its
> preparation, so the former can be implemented in a different way.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/mach-tegra/reset.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
> index fd0bbf8..e282395 100644
> --- a/arch/arm/mach-tegra/reset.c
> +++ b/arch/arm/mach-tegra/reset.c
> @@ -33,26 +33,18 @@
>  
>  static bool is_enabled;
>  
> -static void __init tegra_cpu_reset_handler_enable(void)
> +static void __init tegra_cpu_reset_handler_set(const u32 reset_address)
>  {
> -	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
>  	void __iomem *evp_cpu_reset =
>  		IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE + 0x100);
>  	void __iomem *sb_ctrl = IO_ADDRESS(TEGRA_SB_BASE);
>  	u32 reg;
>  
> -	BUG_ON(is_enabled);
> -	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
> -
> -	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
> -			tegra_cpu_reset_handler_size);
> -
>  	/*
>  	 * NOTE: This must be the one and only write to the EVP CPU reset
>  	 *       vector in the entire system.
>  	 */
> -	writel(TEGRA_IRAM_RESET_BASE + tegra_cpu_reset_handler_offset,
> -			evp_cpu_reset);
> +	writel(reset_address, evp_cpu_reset);
>  	wmb();
>  	reg = readl(evp_cpu_reset);
>  
> @@ -66,6 +58,21 @@ static void __init tegra_cpu_reset_handler_enable(void)
>  		writel(reg, sb_ctrl);
>  		wmb();
>  	}
> +}
> +
> +static void __init tegra_cpu_reset_handler_enable(void)
> +{
> +	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
> +	const u32 reset_address = TEGRA_IRAM_RESET_BASE +
> +						tegra_cpu_reset_handler_offset;
> +
> +	BUG_ON(is_enabled);
> +	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
> +
> +	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
> +			tegra_cpu_reset_handler_size);

A memcpy to iomem seems suspect. Should this be memcpy_toio, or is the __iomem
annotation misleading?

Thanks,
Mark.
