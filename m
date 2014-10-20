Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaJTJMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:12:47 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41168 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaJTJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:12:44 -0400
Message-ID: <5444D15C.4030308@gmail.com>
Date: Mon, 20 Oct 2014 14:39:48 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "jinkun.hong" <jinkun.hong@rock-chips.com>, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org
CC: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v4 1/3] power-domain: add power domain drivers for Rockchip
 platform
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com> <1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com>
In-Reply-To: <1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 02:33 PM, jinkun.hong wrote:
> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>
> Add power domain drivers based on generic power domain for Rockchip platform,
> and support RK3288.
>
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
>
> ---
>
(...)

> +static int rockchip_pd_power(struct rockchip_domain *pd, bool power_on)
> +{
> +	int i = 0;
> +	int ret = 0;
> +	struct rockchip_dev_entry *de;
> +
> +	spin_lock_irq(&pd->dev_lock);
> +
> +	list_for_each_entry(de, &pd->dev_list, node) {
> +		i += 1;
> +		pm_clk_resume(pd->dev);
> +	}
> +
> +	/* no clk, set power domain will fail */
> +	if (i == 0) {
> +		pr_err("%s: failed to on/off power domain!", __func__);

Missed terminating new line  :-)

> +		spin_unlock_irq(&pd->dev_lock);
> +		return ret;
> +	}
> +
> +	ret = rockchip_pmu_set_power_domain(pd, power_on);
> +
> +	list_for_each_entry(de, &pd->dev_list, node) {
> +		pm_clk_suspend(pd->dev);
> +	}
> +
> +	spin_unlock_irq(&pd->dev_lock);
> +
> +	return ret;
> +}
> +

(...)

> +static int rockchip_pm_domain_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node;
> +	struct regmap *regmap_pmu;
> +	struct rockchip_domain *pd;
> +	const struct of_device_id *match;
> +
> +	match = of_match_node(rockchip_pm_domain_dt_match, pdev->dev.of_node);
> +	pd = (struct rockchip_domain *)match->data;
> +

Unnecessary one line space..

> +	if (!pd)
> +		return -ENOMEM;
> +
> +	node = of_parse_phandle(pdev->dev.of_node, "rockchip,pmu", 0);
> +	regmap_pmu = syscon_node_to_regmap(node);
> +	of_node_put(node);
> +	if (IS_ERR(regmap_pmu)) {
> +		pr_err("%s: failed to get regmap_pmu", __func__);

Terminating new line missed...  :-)

> +		return PTR_ERR(regmap_pmu);
> +	}
> +
> +	pd->regmap_pmu = regmap_pmu;
> +	pd->dev = &pdev->dev;
> +
> +	INIT_LIST_HEAD(&pd->dev_list);
> +
> +	spin_lock_init(&pd->idle_lock);
> +	spin_lock_init(&pd->pmu_lock);
> +	spin_lock_init(&pd->dev_lock);
> +
> +	pm_genpd_init(&pd->base, NULL, false);
> +
> +	return of_genpd_add_provider_simple(pdev->dev.of_node, &pd->base);
> +}
> +
>
-- 
Thanks and Regards,
Varka Bhadram.

