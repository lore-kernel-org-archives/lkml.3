Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaFKQud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:50:33 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60000 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbaFKQub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:50:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1402464739-19044-2-git-send-email-tushar.b@samsung.com>
Cc: t.figa@samsung.com, linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, kgene.kim@samsung.com,
        khilman@linaro.org, dianders@google.com, trblinux@gmail.com,
        "Shaik Ameer Basha" <shaik.ameer@samsung.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
 <1402464739-19044-2-git-send-email-tushar.b@samsung.com>
Message-ID: <20140611165027.6562.64928@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss always
 enabled
Date: Wed, 11 Jun 2014 09:50:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tushar Behera (2014-06-10 22:32:17)
> When the output clock of AUDSS mux is disabled, we are getting kernel
> oops while doing a clk_get() on other clocks provided by AUDSS. Though
> user manual doesn't specify this dependency, we came across this issue
> while disabling the parent of AUDSS mux clocks.

Hi Tushar,

Can you help me understand better what the actual problem is? What is
the root cause of the kernel oops?

You mention calling clk_get on child clocks of the AUDSS mux fails, but
I cannot imagine why. How can the enable/disable state of a clock affect
the ability to clk_get other clocks?

Regards,
Mike

> 
> Keeping the parents of AUDSS mux always enabled fixes this issue.
> 
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos-audss.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
> index 13eae14c..1542f30 100644
> --- a/drivers/clk/samsung/clk-exynos-audss.c
> +++ b/drivers/clk/samsung/clk-exynos-audss.c
> @@ -30,6 +30,8 @@ static struct clk **clk_table;
>  static void __iomem *reg_base;
>  static struct clk_onecell_data clk_data;
>  
> +static struct clk *pll_ref, *pll_in;
> +
>  #define ASS_CLK_SRC 0x0
>  #define ASS_CLK_DIV 0x4
>  #define ASS_CLK_GATE 0x8
> @@ -83,7 +85,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>         const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
>         const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
>         const char *sclk_pcm_p = "sclk_pcm0";
> -       struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
> +       struct clk *cdclk, *sclk_audio, *sclk_pcm_in;
>         const struct of_device_id *match;
>         enum exynos_audss_clk_type variant;
>  
> @@ -113,10 +115,14 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  
>         pll_ref = devm_clk_get(&pdev->dev, "pll_ref");
>         pll_in = devm_clk_get(&pdev->dev, "pll_in");
> -       if (!IS_ERR(pll_ref))
> +       if (!IS_ERR(pll_ref)) {
>                 mout_audss_p[0] = __clk_get_name(pll_ref);
> -       if (!IS_ERR(pll_in))
> +               clk_prepare_enable(pll_ref);
> +       }
> +       if (!IS_ERR(pll_in)) {
>                 mout_audss_p[1] = __clk_get_name(pll_in);
> +               clk_prepare_enable(pll_in);
> +       }
>         clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
>                                 mout_audss_p, ARRAY_SIZE(mout_audss_p),
>                                 CLK_SET_RATE_NO_REPARENT,
> @@ -217,6 +223,11 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
>                         clk_unregister(clk_table[i]);
>         }
>  
> +       if (!IS_ERR(pll_in))
> +               clk_disable_unprepare(pll_in);
> +       if (!IS_ERR(pll_ref))
> +               clk_disable_unprepare(pll_ref);
> +
>         return 0;
>  }
>  
> -- 
> 1.7.9.5
> 
