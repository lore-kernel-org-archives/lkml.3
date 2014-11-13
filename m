Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaKMKwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:52:09 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:65030 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbaKMKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:52:05 -0500
Date: Thu, 13 Nov 2014 11:51:43 +0100
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/13] clk: tegra: Add EMC clock driver
Message-ID: <20141113105143.GA26417@zorro.zusammrottung.local>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-12-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415779051-26410-12-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V02:K0:uVfG9wYtJtRsx+3ZvhXSxGLt6zdglsU5XUTIXmASl1/
 pXKtz5qTTmictXNg5tqPPlaYH2ghwK/1miz3Ht3noTFGq3lcWh
 46CLVdtHQqBIOdaZQA8MJl2Q3sqiTin2kNzMH54p1YdKDpdXDf
 /ebN7f2c3rT/nPJbBMfLf1KW5kEuLPyP0Ylbv6nwbs2rSgZiZ/
 +6sAcFpIS1c18gLWDMNDIg3/EHc09vYrFJ00kkeFuOsKxTfkS/
 eHj7OB1PRpeN63eLopuLyzelj85fx1jnJOLO4uSLv245YdD11y
 LEeclFiwTPgKsWYKNebNjkYJ64e3BfuU6m1hyhDa3BEdU4EDaU
 wpR2x6cf4Yo5re2NoJK6Kl0PGpt5aW6LYhexODFf66J6/YXbkN
 qKn38GGthvm5vMIK1SR4P11it5JZ9fpNvMzCxq/bhu15tDdxZH
 WwSc8
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 08:56:34AM +0100, Tomeu Vizoso wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> The driver is currently only tested on Tegra124 Jetson TK1, but should
> work with other Tegra124 boards, provided that correct EMC tables are
> provided through the device tree. Older chip models have differing
> timing change sequences, so they are not currently supported.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
[...]
> diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c
> new file mode 100644
> index 0000000..75beacd
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-emc.c
[...]
> +/*
> + * Rounds up unless no higher rate exists, in which case down. This way is
> + * safer since things have EMC rate floors. Also don't touch parent_rate
> + * since we don't want the CCF to play with our parent clocks.
> + */
> +static long emc_round_rate(struct clk_hw *hw, unsigned long rate,
> +		    unsigned long *parent_rate)
> +{
> +	struct tegra_emc *tegra = container_of(hw, struct tegra_emc, hw);
> +	u8 ram_code = tegra_read_ram_code();
> +	struct emc_timing *timing;
> +	int i;
> +
> +	/*
> +	 * Returning the original rate will lead to a more sensible error
> +	 * message when emc_set_rate fails.
> +	 */
> +	if (tegra->num_timings == 0)
> +		return rate;
> +
> +	for (i = 0; i < tegra->num_timings; ++i) {
> +		timing = tegra->timings + i;
> +		if (timing->ram_code != ram_code)
> +			continue;

Is timing->ram_code != ram_code really something that is allowed?

> +
> +		if (timing->rate >= rate)
> +			return timing->rate;
> +	}
> +
> +	return tegra->timings[tegra->num_timings - 1].rate;

If tegra->timings has timings for different ram_codes, the last timing
might not be for the requested ram_code.

> +}
