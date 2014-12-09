Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaLIM7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:59:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60359 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaLIM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:59:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-88-5486f240dac9
Content-transfer-encoding: 8BIT
Message-id: <1418129982.19339.6.camel@AMDC1943>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock
 disable failure due to domain being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 09 Dec 2014 13:59:42 +0100
In-reply-to: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7oOn9pCDI73M1tsnLGe1eLo7wKL
	/sevmS2ebn7MZHG26Q27xabH11gtLu+aw2Yx4/w+Jou1R+6yWzydcJHN4vCbdlaLH2e6WSxW
	7frD6MDrcbmvl8nj7/PrLB47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXABHFJdNSmpO
	Zllqkb5dAlfGlCliBQdkKl7N5G9gvCrWxcjBISFgIrF1mUcXIyeQKSZx4d56ti5GLg4hgaWM
	Er0zlrOAJHgFBCV+TL7HAlLPLCAvceRSNkiYWUBdYtK8RcwQ9Z8ZJdbNO8wIUa8vsXfWDiaQ
	emGBMonNf8Dq2QSMJTYvX8IGYosAlSxZdRFsF7PAd2aJE2t+sIIkWARUJS4sPAq2l1PAQ2Ll
	2X9MILaQgLvEmmn3mSFuVpZo7HebwCgwC8l1sxCum4XkugWMzKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQiLmyw7GxcesDjEKcDAq8fCaK7aGCLEmlhVX5h5ilOBgVhLhnXK0LUSINyWx
	siq1KD++qDQntfgQIxMHp1QDY+fWF1Yee2x5Pl9yMTu1ab5+/a/Z/2//MGuKvCU499sMWeb0
	Y+/M5sgevPo6e+cWGV/d2NUKktuaPj2+eeSt1r947ydzGBpCC94/27G05O/UjIzVvyRr12jN
	O7/x+J01XLrTFubzbwjLtwm78aJNp4r3+uYXAbGbWVkWxvj7h6zTm3osVUK4rl2JpTgj0VCL
	uag4EQA3oDl9dgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-12-05 at 15:15 +0100, Krzysztof Kozlowski wrote:
> Audio subsystem clocks are located in separate block. On Exynos 5420 if
> clock for this block (from main clock domain) 'mau_epll' is gated then
> any read or write to audss registers will block.
> 
> This kind of boot hang was observed on Arndale Octa and Peach Pi/Pit
> after introducing runtime PM to pl330 DMA driver. After that commit the
> 'mau_epll' was gated, because the "amba" clock was disabled and there
> were no more users of mau_epll.
> 
> The system hang on one of steps:
> 1. Disabling unused clocks from audss block.
> 2. During audss GPIO setup (just before probing i2s0 because
>    samsung_pinmux_setup() tried to access memory from audss block which was
>    gated.
> 
> Add a workaround for this by enabling the 'mau_epll' clock in probe.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)

Sorry for pinging so quick but merge window is open and it looks like
booting Exynos542x boards will be broken (because pl330 will no longer
hold adma clock enabled so whole audss domain will be gated).

This is a non-intrusive workaround for that issue, as wanted by
Sylwester:
https://lkml.org/lkml/2014/12/5/223

Any comments on this?

Best regards,
Krzysztof


> diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
> index acce708ace18..0916a81fa932 100644
> --- a/drivers/clk/samsung/clk-exynos-audss.c
> +++ b/drivers/clk/samsung/clk-exynos-audss.c
> @@ -29,6 +29,13 @@ static DEFINE_SPINLOCK(lock);
>  static struct clk **clk_table;
>  static void __iomem *reg_base;
>  static struct clk_onecell_data clk_data;
> +/*
> + * On Exynos5420 this will be a clock which has to be enabled before any
> + * access to audss registers. Typically a child of EPLL.
> + *
> + * On other platforms this will be -ENODEV.
> + */
> +static struct clk *epll;
>  
>  #define ASS_CLK_SRC 0x0
>  #define ASS_CLK_DIV 0x4
> @@ -98,6 +105,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "failed to map audss registers\n");
>  		return PTR_ERR(reg_base);
>  	}
> +	/* EPLL don't have to be enabled for boards other than Exynos5420 */
> +	epll = ERR_PTR(-ENODEV);
>  
>  	clk_table = devm_kzalloc(&pdev->dev,
>  				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
> @@ -115,8 +124,20 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  	pll_in = devm_clk_get(&pdev->dev, "pll_in");
>  	if (!IS_ERR(pll_ref))
>  		mout_audss_p[0] = __clk_get_name(pll_ref);
> -	if (!IS_ERR(pll_in))
> +	if (!IS_ERR(pll_in)) {
>  		mout_audss_p[1] = __clk_get_name(pll_in);
> +
> +		if (variant == TYPE_EXYNOS5420) {
> +			epll = pll_in;
> +
> +			ret = clk_prepare_enable(epll);
> +			if (ret) {
> +				dev_err(&pdev->dev,
> +						"failed to prepare the epll clock\n");
> +				return ret;
> +			}
> +		}
> +	}
>  	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
>  				mout_audss_p, ARRAY_SIZE(mout_audss_p),
>  				CLK_SET_RATE_NO_REPARENT,
> @@ -203,6 +224,9 @@ unregister:
>  			clk_unregister(clk_table[i]);
>  	}
>  
> +	if (!IS_ERR(epll))
> +		clk_disable_unprepare(epll);
> +
>  	return ret;
>  }
>  
> @@ -217,6 +241,9 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
>  			clk_unregister(clk_table[i]);
>  	}
>  
> +	if (!IS_ERR(epll))
> +		clk_disable_unprepare(epll);
> +
>  	return 0;
>  }
>  

