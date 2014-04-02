Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbaDBLsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:48:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56281 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbaDBLsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:48:30 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-8d-533bf90c6758
Message-id: <533BF905.6070701@samsung.com>
Date: Wed, 02 Apr 2014 13:48:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7o8P62DDZ7f1bBYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vFjpbVLA4cHi3NPWwem5fUe/RtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGuWlsBVNFKh5taWBtYNwp0MXIySEhYCJx7Ph/NghbTOLCvfVANheH
	kMBSRomZU1+yQjifGCXere4Aq+IV0JJ4ufIGK4jNIqAq0blvOZjNJmAo0Xu0jxHEFhWIkLjX
	eJgVol5Q4sfkeywgtohAnsSeRzPANjALzGaUWPJ4FthQYYFIidmnX7BDbGtllJhysRVsEqeA
	h8TVXW+YQGxmAR2J/a3T2CBseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERLkX3YwLj5mdYhRgINRiYdX4pJVsBBrYllxZe4hRgkOZiUR3kmfrIOF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MEp93Kp5pJzxkcCL0wkZic3aH363zrynv+mqk6NXH9fO
	I2HmzjmWE2Q165nKEqbIXJ3bGLXLu1VFfppT6q3ssy++L+H5FznB8SVPnKn/pfZUkYTjHmnh
	HQt/x/9prfZtPcCY78XGcPlyNCvzgSPuwYEOn76dtRLcpuX+ckUZh/G8B5OjbA4WKLEUZyQa
	ajEXFScCAHGnVIlQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/14 09:50, Pankaj Dubey wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
> 
> Add support for mapping Exynos Power Management Unit (PMU) base address
> from device tree. Code will use existing samsung pmu binding information.
> This patch also adds "get_exynos_pmubase" a helper function to return mapped base
> address to various other files under "mach-exynos".
> 
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h |    2 ++
>  arch/arm/mach-exynos/exynos.c |   44 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
[...]
>  #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index a5e1349..a5127fb 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -35,6 +35,8 @@
>  #define L2_AUX_VAL 0x7C470001
>  #define L2_AUX_MASK 0xC200ffff
>  
> +static void __iomem *exynos_pmu_base __initdata;
> +
>  static struct map_desc exynos4_iodesc[] __initdata = {
>  	{
>  		.virtual	= (unsigned long)S3C_VA_SYS,
> @@ -245,6 +247,47 @@ void __init exynos_init_late(void)
>  	exynos_pm_init();
>  }
>  
> +static char const *exynos_dt_pmu_match[] __initconst = {
> +	"samsung,exynos4210-pmu",
> +	"samsung,exynos4212-pmu",
> +	"samsung,exynos4412-pmu",
> +	"samsung,exynos5250-pmu",
> +	NULL
> +};
> +
> +static int __init exynos_fdt_map_pmu(unsigned long node,
> +		const char *uname, int depth, void *data)
> +{
> +	struct map_desc iodesc;
> +	__be32 *reg;
> +	unsigned long len;
> +
> +	if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
> +		phys_addr_t phys_addr;
> +		reg = of_get_flat_dt_prop(node, "reg", &len);
> +		if (reg == NULL || len != (sizeof(unsigned long) * 2))
> +			return 0;
> +
> +		phys_addr = be32_to_cpu(reg[0]);
> +		iodesc.pfn = __phys_to_pfn(phys_addr);
> +		iodesc.length = be32_to_cpu(reg[1]) - 1;
> +		iodesc.virtual = (unsigned long)S5P_VA_PMU;
> +		iodesc.type = MT_DEVICE;
> +		iotable_init(&iodesc, 1);

Are you sure...you need this in addition to ioremap() below ?
Can't you just use the Linux syscon API ?
There were some patches posted for syscon to make it available in earlier
system initialization stage: https://lkml.org/lkml/2014/2/19/218

> +		exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
> +		if (WARN_ON(!exynos_pmu_base))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}

--
Thanks,
Sylwester
