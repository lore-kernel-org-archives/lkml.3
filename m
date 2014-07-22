Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaGVQ51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:57:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45456 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaGVQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:57:25 -0400
Message-ID: <53CE97F2.80300@wwwdotorg.org>
Date: Tue, 22 Jul 2014 10:57:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, pdeschrijver@nvidia.com,
        pgaikwad@nvidia.com, mturquette@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 8/8] clk: tegra: Add EMC clock driver
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-9-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405088313-20048-9-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> The driver is currently only tested on Tegra124 Jetson TK1, but should
> work with other Tegra124 boards, provided that correct EMC tables are
> provided through the device tree. Older chip models have differing
> timing change sequences, so they are not currently supported.

> diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c

> +struct emc_timing {
> +	unsigned long rate, parent_rate;
> +	u8 parent_index;
> +	struct clk *parent;
> +
> +	/* Store EMC burst data in a union to minimize mistakes. This allows
> +	 * us to use the same burst data lists as used by the downstream and
> +	 * ChromeOS kernels. */

Nit: */ should be on its own line. This applies to many comments in the
file.

> +/* * * * * * * * * * * * * * * * * * * * * * * * * *
> + * Timing change sequence functions                *
> + * * * * * * * * * * * * * * * * * * * * * * * * * */

Nit: This kind of banner comment is unusual, but I guess it's fine.

> +static void emc_seq_update_timing(struct tegra_emc *tegra)
...
> +	dev_err(&tegra->pdev->dev, "timing update failed\n");
> +	BUG();
> +}

Is there any way to avoid all these BUGs? Can we just continue on and
retry the next time, or disallow any further clock rate changes or
something?

> +/* * * * * * * * * * * * * * * * * * * * * * * * * *
> + * Debugfs entry                                   *
> + * * * * * * * * * * * * * * * * * * * * * * * * * */
> +
> +static int emc_debug_rate_get(void *data, u64 *rate)
> +{
> +	struct tegra_emc *tegra = data;
> +
> +	*rate = clk_get_rate(tegra->hw.clk);
> +
> +	return 0;
> +}
> +
> +static int emc_debug_rate_set(void *data, u64 rate)
> +{
> +	struct tegra_emc *tegra = data;
> +
> +	return clk_set_rate(tegra->hw.clk, rate);
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(emc_debug_rate_fops, emc_debug_rate_get,
> +			emc_debug_rate_set, "%lld\n");

I think the rate can already be obtained through
...debug/clock/clock_summary. I'm not sure about changing the rate, but
shouldn't that be a feature of the common clock core, not individual
drivers?

> +static int load_timings_from_dt(struct tegra_emc *tegra,
> +				struct device_node *node)
> +{
...
> +	for_each_child_of_node(node, child) {
...
> +		if (timing->rate <= prev_rate) {
> +			dev_err(&tegra->pdev->dev,
> +				"timing %s: rate not increasing\n",
> +				child->name);

I don't believe there's any guaranteed node enumeration order. If the
driver needs the child nodes sorted, it should sort them itself.

> +static const struct of_device_id tegra_car_of_match[] = {
> +	{ .compatible = "nvidia,tegra124-car" },
> +	{}
> +};
> +
> +static const struct of_device_id tegra_mc_of_match[] = {
> +	{ .compatible = "nvidia,tegra124-mc" },
> +	{}
> +};

It would be better if this driver explicitly called into the driver for
other modules, rather than directly touching their registers.
