Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaF3RGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:06:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38449 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaF3RGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:06:17 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a7-53b19906f8fb
Message-id: <53B198EB.80502@samsung.com>
Date: Mon, 30 Jun 2014 19:05:47 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 4/5] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-5-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1403705032-14835-5-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7psMzcGG8yYLWuxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV0bH3MlMBcccKg7MPsjUwPjOuIuRk0NCwESi
	b9p+JghbTOLCvfVsILaQwFJGiX3L0yHsz4wSO7dxgti8AhoSK/41soDYLAKqEjP2HWIFsdkE
	1CQ+NzwC6+UX0JJY03QdqIaDQ1QgQuLxBSGIVkGJH5PvAYW5OEQEpjFKXLx0mx3EYRZYwiix
	Z8YpRpAqYYFQiQ0r34JVCQm0M0o8+HEOLMEp4Cmxdf8/sM3MAjoS+1unsUHY8hKb17xlnsAo
	OAvJlllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQuvuxgXHzM6hCjAAej
	Eg9v44oNwUKsiWXFlbmHGCU4mJVEeG/6bAwW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMiwcNrt
	258FXY7EhaonTjx7Vuqh5APH+KbdNQ3y/v8PLTxyX7Ls6YVSsZtft3ImRbE0PMzslO+QlPH7
	qz1h8xW9lNpg5sPxQRsvH8rd1vt0XwfnffeFq89KS8ZkMp7tn5X3uuHu8z6hZ21bO4tjJiS9
	TLObx7Lq1Md1mSGG9l8/aLVLlmhNuqnEUpyRaKjFXFScCAAt5Q9JaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Please see my comments inline.

On 25.06.2014 16:03, Pankaj Dubey wrote:
> This patch modifies Exynos Power Management Unit (PMU) initialization
> implementation in following way:
> 
> - Added platform driver support and probe function where Exynos PMU
>   driver will register itself as syscon provider with syscon framework.
> - Added platform struct exynos_pmu_data to hold platform specific data.
> - For each SoC's PMU support now we can add platform data and statically
>   bind PMU configuration and SoC specific initialization function.
> - Separate each SoC's PMU initialization function and make it as part of
>   platform data.
> - It also removes uses of soc_is_exynosXYZ().

[snip]

> @@ -93,7 +112,7 @@ static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>  	{ PMU_TABLE_END,},
>  };
>  
> -static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
> +static const struct exynos_pmu_conf exynos4212_pmu_config[] = {

Why the name change?

>  	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
>  	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
>  	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
> @@ -335,7 +354,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>  	EXYNOS5_ISP_ARM_OPTION,
>  };
>  
> -static void exynos5_init_pmu(void)
> +static void exynos5_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
>  	unsigned int tmp;
> @@ -372,51 +391,151 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
>  
> -	if (soc_is_exynos5250())
> -		exynos5_init_pmu();
> +	struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> +
> +	if (!pmu_data)
> +		return;
>  
> -	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> -		__raw_writel(exynos_pmu_config[i].val[mode],
> -				pmu_base_addr + exynos_pmu_config[i].offset);
> +	if (pmu_data->powerdown_conf)
> +		pmu_data->powerdown_conf(mode);
>  
> -	if (soc_is_exynos4412()) {
> -		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END ; i++)
> -			__raw_writel(exynos4412_pmu_config[i].val[mode],
> -				pmu_base_addr + exynos4412_pmu_config[i].offset);
> +	if (pmu_data->pmu_config) {
> +		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
> +			__raw_writel(pmu_data->pmu_config[i].val[mode],
> +					pmu_base_addr + pmu_data->pmu_config[i].offset);

Analogically to patch 2/5, you could add static inline accessors and use
them instead of adding pmu_base_addr every time.

> +	}
> +
> +	if (pmu_data->pmu_config_extra) {
> +		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
> +			__raw_writel(pmu_data->pmu_config_extra[i].val[mode],
> +					pmu_base_addr + pmu_data->pmu_config_extra[i].offset);
>  	}
>  }
>  
> -static int __init exynos_pmu_init(void)
> +static void exynos5250_pmu_init(void)
>  {
>  	unsigned int value;
> +	/*
> +	 * When SYS_WDTRESET is set, watchdog timer reset request
> +	 * is ignored by power management unit.
> +	 */
> +	value = __raw_readl(pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	__raw_writel(value, pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
> +
> +	value = __raw_readl(pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	__raw_writel(value, pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
> +}
> +
> +static struct exynos_pmu_data exynos4210_pmu_data = {

static const struct

> +	.pmu_config	= exynos4210_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos4212_pmu_data = {

static const struct

> +	.pmu_config	= exynos4212_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos4412_pmu_data = {

static const struct

> +	.pmu_config		= exynos4212_pmu_config,
> +	.pmu_config_extra	= exynos4412_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos5250_pmu_data = {

static const struct

> +	.pmu_config	= exynos5250_pmu_config,
> +	.pmu_init	= exynos5250_pmu_init,
> +	.powerdown_conf	= exynos5_powerdown_conf,
> +};
>  
> -	exynos_pmu_config = exynos4210_pmu_config;
> -
> -	if (soc_is_exynos4210()) {
> -		exynos_pmu_config = exynos4210_pmu_config;
> -		pr_info("EXYNOS4210 PMU Initialize\n");
> -	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> -		exynos_pmu_config = exynos4x12_pmu_config;
> -		pr_info("EXYNOS4x12 PMU Initialize\n");
> -	} else if (soc_is_exynos5250()) {
> -		/*
> -		 * When SYS_WDTRESET is set, watchdog timer reset request
> -		 * is ignored by power management unit.
> -		 */
> -		value = __raw_readl(pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
> -		value &= ~EXYNOS5_SYS_WDTRESET;
> -		__raw_writel(value, pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
> -
> -		value = __raw_readl(pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
> -		value &= ~EXYNOS5_SYS_WDTRESET;
> -		__raw_writel(value, pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
> -
> -		exynos_pmu_config = exynos5250_pmu_config;
> -		pr_info("EXYNOS5250 PMU Initialize\n");
> -	} else {
> -		pr_info("EXYNOS: PMU not supported\n");
> +static struct regmap_config pmu_regmap_config = {

static const struct

> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +};
> +
> +/*
> + * PMU platform driver and devicetree bindings.
> + */
> +static struct of_device_id exynos_pmu_of_device_ids[] = {

static const struct

> +	{
> +		.compatible = "samsung,exynos4210-pmu",
> +		.data = (void *)&exynos4210_pmu_data,

No need for the cast.

> +	},
> +	{

nit: You could place both parentheses in the same line, i.e.

	}, {

> +		.compatible = "samsung,exynos4212-pmu",
> +		.data = (void *)&exynos4212_pmu_data,

Ditto.

> +	},
> +	{
> +		.compatible = "samsung,exynos4412-pmu",
> +		.data = (void *)&exynos4412_pmu_data,

Ditto.

> +	},
> +	{
> +		.compatible = "samsung,exynos5250-pmu",
> +		.data = (void *)&exynos5250_pmu_data,

Ditto.

> +	},
> +	{},

It is a good practice to put a comment inside the sentinel, e.g.

	{ /* sentinel */ }

> +};
> +
> +static int exynos_pmu_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct device *dev = &pdev->dev;
> +	struct regmap *regmap;
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;

No need to check this here, if you use devm_ioremap_resource() instead.

> +
> +	pmu_base_addr = devm_ioremap(dev, res->start, resource_size(res));

You could use devm_ioremap_resource() instead. In addition to handling
the resource directly without the need to access its internals here, it
also checks the validity of the resource pointer.

> +	if (IS_ERR(pmu_base_addr))
> +		return PTR_ERR(pmu_base_addr);
> +
> +	pmu_context = devm_kzalloc(&pdev->dev,
> +			sizeof(struct exynos_pmu_context),
> +			GFP_KERNEL);
> +
> +	if (pmu_context == NULL) {

nit: Extraneous blank line.
nit: Inconsistent pointer check (!res above, but == NULL here), just use
!ptr everywhere, please.

> +		dev_err(dev, "Cannot allocate memory.\n");
> +		return -ENOMEM;
> +	}
> +
> +	regmap = devm_regmap_init_mmio(dev, pmu_base_addr,
> +					&pmu_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_err(dev, "regmap init failed\n");
> +		return PTR_ERR(regmap);
>  	}
>  
> +	devm_syscon_register(dev, regmap);
> +
> +	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
> +
> +	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;

No need to cast if you change all affected pointers to const.

> +
> +	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_init)

In what conditions pmu_data will be NULL?

> +		pmu_context->pmu_data->pmu_init();
> +
> +	pmu_context->dev = dev;

I believe this should be set before calling pmu_init().

> +
> +	platform_set_drvdata(pdev, pmu_context);
> +
> +	pr_info("Exynos PMU Driver probe done!!!\n");

Hurrah, the driver probed! The users won't care, though, and they might
find those exclamation marks scary. ;)

dev_dbg() without those exclamation marks would be more appropriate.

Best regards,
Tomasz
