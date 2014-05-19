Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaESGww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:52:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10251 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaESGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:52:51 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5e-5379aa3b80d6
Message-id: <1400482362.4382.0.camel@AMDC1943>
Subject: Re: [PATCH] clk: s2mps11: Simplify s2mps11_clk_probe unwind paths
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 08:52:42 +0200
In-reply-to: <1400428295.15403.3.camel@phoenix>
References: <1400428295.15403.3.camel@phoenix>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xy7rWqyqDDV79tLA4Mucrs8XlXXPY
	LJ5OuMhmMWf6OyYHFo+2n2Ued67tYfPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujItHHzEW
	bOauOLXoPWsD4wzOLkZODgkBE4mjx9pYIWwxiQv31rN1MXJxCAksZZQ48GwNC4TzmVHieucW
	IIeDg1dAT2JzlzZIg7CAl8Se7QuZQWw2AWOJzcuXsIHYIgJKEqvuX2YBsZkFKiTenHgDZrMI
	qEqcmrkbrJ5TQF9i44wOsMVCQCO3989nhqhXl5g0bxEzxEHKEvP2H2MCsXkFBCV+TL4HNVNe
	YvOat8wTGAVmIWmZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCQvfLDsbF
	x6wOMQpwMCrx8H5IqAwWYk0sK67MPcQowcGsJML7yRsoxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gbE+4Bf7Ql2OU9d59ruJTozavevt9BIXpuWq+up/LF5fVPv48G07v7Pzi5XCIZNOlDuaFR3U
	PmO5N+iS+XynqLM8U9dwz7B3iPFg95hTkMIRdmHFtsVLpRqU1q386uN0dZ3opKfONoab1ZaX
	TjqprNYp/r8vX/3BxJyVHjcdTQ3k7pQHF7+y1lBiKc5INNRiLipOBADbRPEGOwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On nie, 2014-05-18 at 23:51 +0800, Axel Lin wrote:
> The devm_clk_unregister() in probe error paths are not necessary as it will be
> automatically called when probe fails.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/clk/clk-s2mps11.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof



> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
> index f2f62a1b..aeaa61c 100644
> --- a/drivers/clk/clk-s2mps11.c
> +++ b/drivers/clk/clk-s2mps11.c
> @@ -210,7 +210,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>  					sizeof(struct clk_lookup), GFP_KERNEL);
>  		if (!s2mps11_clk->lookup) {
>  			ret = -ENOMEM;
> -			goto err_lup;
> +			goto err_reg;
>  		}
>  
>  		s2mps11_clk->lookup->con_id = s2mps11_name(s2mps11_clk);
> @@ -231,16 +231,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, s2mps11_clks);
>  
>  	return ret;
> -err_lup:
> -	devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
> +
>  err_reg:
> -	while (s2mps11_clk > s2mps11_clks) {
> -		if (s2mps11_clk->lookup) {
> -			clkdev_drop(s2mps11_clk->lookup);
> -			devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
> -		}
> -		s2mps11_clk--;
> -	}
> +	while (--i >= 0)
> +		clkdev_drop(s2mps11_clks[i].lookup);
>  
>  	return ret;
>  }

