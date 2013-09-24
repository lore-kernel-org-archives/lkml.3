Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3IXVPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:15:54 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45375 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3IXVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:15:51 -0400
Message-ID: <524200FB.8010004@gmail.com>
Date: Tue, 24 Sep 2013 23:15:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/6] clk: exynos-audss: convert to platform device
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org> <1380046016-5811-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 08:06 PM, Andrew Bresticker wrote:
> +static int exynos_audss_clk_probe(struct platform_device *pdev)
>   {
[...]
>   	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
>   				mout_audss_p, ARRAY_SIZE(mout_audss_p),
> @@ -123,13 +124,83 @@ static void __init exynos_audss_clk_init(struct device_node *np)
>   				"div_pcm0", CLK_SET_RATE_PARENT,
>   				reg_base + ASS_CLK_GATE, 5, 0,&lock);
>
> +	for (i = 0; i<  EXYNOS_AUDSS_MAX_CLKS; i++) {
> +		if (IS_ERR(clk_table[i])) {
> +			dev_err(&pdev->dev, "failed to regsiter clock %d\n", i);

typo: regsiter -> register

> +			ret = PTR_ERR(clk_table[i]);
> +			goto unregister;
> +		}
> +	}
> +
> +	clk_data.clks = clk_table;
> +	clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS;
> +	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
> +					&clk_data);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to add clock provider\n");
> +		goto unregister;
> +	}
> +
[...]
> +	return 0;
> +
> +unregister:
> +	for (i = 0; i<  EXYNOS_AUDSS_MAX_CLKS; i++) {
> +		if (!IS_ERR_OR_NULL(clk_table[i]))
> +			clk_unregister(clk_table[i]);
> +	}

Couldn't this instead be:

	while (--i >= 0)
		clk_unregister(clk_table[i]);

?
> +static int exynos_audss_clk_remove(struct platform_device *pdev)
> +{
> +	int i;
> +
> +	of_clk_del_provider(pdev->dev.of_node);
> +
> +	for (i = 0; i<  EXYNOS_AUDSS_MAX_CLKS; i++) {
> +		if (!IS_ERR_OR_NULL(clk_table[i]))
> +			clk_unregister(clk_table[i]);
> +	}

Since we only get here if all the clocks are registered properly and we
always register EXYNOS_AUDSS_MAX_CLKS clocks, couldn't this simply be:

	for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++)
		clk_unregister(clk_table[i]);

?
> +	return 0;
> +}

Otherwise the whole series looks good to me. Feel free to add:

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


--
Thanks,
Sylwester
