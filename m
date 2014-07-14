Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaGNPey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:34:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37594 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGNPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:34:46 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-47-53c3f88b9f90
Message-id: <53C3F88A.8080005@samsung.com>
Date: Mon, 14 Jul 2014 17:34:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        mturquette@linaro.org, t.figa@samsung.com, trblinux@gmail.com
Subject: Re: [PATCH V2 3/3] clk: exynos-audss: Use samsung clock APIs to
 register/unregister clocks
References: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
 <1405080036-6651-4-git-send-email-tushar.b@samsung.com>
In-reply-to: <1405080036-6651-4-git-send-email-tushar.b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7rdPw4HGxxeZGPRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLpxMuslmsn/GaxWLD5N3sFje2f2Vx4PDYOesuu8eda3vYPDYvqffo27KK
	0ePzJrkA1igum5TUnMyy1CJ9uwSujB9Hl7AVHOCq6O5bx97A+ICji5GDQ0LAROLhHMYuRk4g
	U0ziwr31bF2MXBxCAksZJc6fWcgO4XxilDjWuoMJpIFXQEvi3T1zkAYWAVWJljuf2EFsNgFD
	id6jfWCDRAUiJA70PWMFsXkFBCV+TL7HAmKLCGhIXF2wH8xmFjjMKLFnTQWILSyQKrH79g02
	EFtIoFZi6qTzYDWcAi4SU47fY4ao15HY3zqNDcKWl9i85i3zBEaBWUhWzEJSNgtJ2QJG5lWM
	oqmlyQXFSem5RnrFibnFpXnpesn5uZsYIaH+dQfj0mNWhxgFOBiVeHgL+A8HC7EmlhVX5h5i
	lOBgVhLhPfoBKMSbklhZlVqUH19UmpNafIiRiYNTqoExWIivPst2ddWZ3LelKlPX8m+WLZY8
	1ruJqejSDAuz6LIFCxcL+2ktO1QZWTBTLunT+eeMSy88XdO6ZN/y3e1/AvO/f7kpfK5M1aH4
	qJSfXt7H8wFGrZqf6pILuW6eE5t/TL37n/e/wLnRk1i/9B9xPsi56liwB0P1G+nHs1Vv/ZuX
	ZH21I6JGiaU4I9FQi7moOBEANQJ+/1MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 14:00, Tushar Behera wrote:
> @@ -103,17 +140,11 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  		return PTR_ERR(reg_base);
>  	}
>  
> -	clk_table = devm_kzalloc(&pdev->dev,
> -				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
> -				GFP_KERNEL);
> -	if (!clk_table)
> +	ctx = samsung_clk_init(pdev->dev.of_node, reg_base, nr_clks);

There is an issue here that this registers the clk provider before all
its clocks are registered with the clk core. Therefore it introduces
a race condition.

Please have a look at patch [1], you may want to rebase this series
onto that patch.

> +	samsung_clk_register_div(ctx, exynos_audss_div_clks,
> +				ARRAY_SIZE(exynos_audss_div_clks));
[...]
> +	samsung_clk_register_gate(ctx, exynos_audss_gate_clks,
> +				ARRAY_SIZE(exynos_audss_gate_clks));
[...]
> -	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
> -					&clk_data);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to add clock provider\n");
> -		goto unregister;
> +		samsung_clk_register_gate(ctx, exynos5420_audss_gate_clks,
> +					ARRAY_SIZE(exynos5420_audss_gate_clks));
>  	}

[1]
https://git.kernel.org/cgit/linux/kernel/git/tfiga/samsung-clk.git/commit/?h=samsung-clk-next&id=d5e136a21b2028fb1f45143ea7112d5869bfc6c7

--
Regards,
Sylwester
