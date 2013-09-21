Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3IUMu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:50:59 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41541 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IUMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:50:57 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] clk: exynos-audss: convert to platform device
Date: Sat, 21 Sep 2013 14:50:51 +0200
Message-ID: <1530327.jvk44KuFQA@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This patch looks good overall, but I have some minor comments inline.

On Friday 20 of September 2013 14:13:52 Andrew Bresticker wrote:
> The Exynos AudioSS clock controller will later be modified to allow
> input clocks to be specified via device-tree in order to support
> multiple Exynos SoCs.  This will introduce a dependency on the core
> SoC clock controller being initialized first so that the AudioSS driver
> can look up its input clocks, but the order in which clock providers
> are probed in of_clk_init() is not guaranteed.  Since deferred probing
> is not supported in of_clk_init() and the AudioSS block is not the core
> controller, we can initialize it later as a platform device.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 71
> +++++++++++++++++++++++++++------- 1 file changed, 58 insertions(+), 13
> deletions(-)
[snip]
> +static int exynos_audss_clk_remove(struct platform_device *pdev)
> +{
> +	of_clk_del_provider(pdev->dev.of_node);
> +
> +	return 0;
>  }

Don't we need to unregister all the registered clocks in remove? This also 
leads to another question: Do we even need removal support for this 
driver?

> -CLK_OF_DECLARE(exynos4210_audss_clk, "samsung,exynos4210-audss-clock",
> -		exynos_audss_clk_init);
> -CLK_OF_DECLARE(exynos5250_audss_clk, "samsung,exynos5250-audss-clock",
> -		exynos_audss_clk_init);
> +
> +static const struct of_device_id exynos_audss_clk_of_match[] = {
> +	{ .compatible = "samsung,exynos4210-audss-clock", },
> +	{ .compatible = "samsung,exynos5250-audss-clock", },
> +	{},
> +};
> +
> +static struct platform_driver exynos_audss_clk_driver = {
> +	.driver	= {
> +		.name = "exynos-audss-clk",
> +		.owner = THIS_MODULE,
> +		.of_match_table = exynos_audss_clk_of_match,
> +	},
> +	.probe = exynos_audss_clk_probe,
> +	.remove = exynos_audss_clk_remove,
> +};
> +
> +static int __init exynos_audss_clk_init(void)
> +{
> +	return platform_driver_register(&exynos_audss_clk_driver);
> +}
> +core_initcall(exynos_audss_clk_init);

Does it need to be core_initcall? Drivers depending on clocks provided by 
this driver should be able to defer probing if they are probed before this 
driver.

Then you would be able to simply use module_platform_driver() below.

> +static void __init exynos_audss_clk_exit(void)
> +{
> +	platform_driver_unregister(&exynos_audss_clk_driver);
> +}
> +module_exit(exynos_audss_clk_exit);
> +
> +MODULE_AUTHOR("Padmavathi Venna <padma.v@samsung.com>");
> +MODULE_DESCRIPTION("Exynos AudioSS Clock Controller");

nit: IMHO Audio Subsystem instead of AudioSS would be more meaningful.

> +MODULE_LICENSE("GPL");

This should be GPL v2.

Best regards,
Tomasz

