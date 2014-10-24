Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbaJXQoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:44:38 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33196 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaJXQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:44:36 -0400
Date: Fri, 24 Oct 2014 09:44:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v7 1/3] power-domain: add power domain drivers for
 Rockchip platform
Message-ID: <20141024164431.GE19933@dtor-ws>
References: <1414135761-3406-1-git-send-email-jinkun.hong@rock-chips.com>
 <1414135761-3406-2-git-send-email-jinkun.hong@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414135761-3406-2-git-send-email-jinkun.hong@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jinkun,

On Fri, Oct 24, 2014 at 12:29:19AM -0700, jinkun.hong wrote:
> +static int rockchip_pd_power(struct rockchip_domain *pd, bool power_on)
> +{
> +	int ret = 0;
> +	struct rockchip_dev_entry *de;
> +
> +	mutex_lock(&pd->dev_lock);
> +	/* no clk, set power domain will fail */
> +	if (list_empty(&pd->dev_list)) {
> +		pr_err("%s: no devices in %s power domain\n", __func__,
> +			pd->base.name);
> +		goto out;
> +	}
> +
> +	list_for_each_entry(de, &pd->dev_list, node) {
> +		pm_clk_resume(de->dev);
> +	}
> +
> +	ret = rockchip_pmu_set_power_domain(pd, power_on);
> +
> +	list_for_each_entry(de, &pd->dev_list, node) {
> +		pm_clk_suspend(de->dev);
> +	}
> +out:
> +	mutex_unlock(&pd->dev_lock);
> +	return ret;
> +}

For my education, could you please tell me why we need to enable all
clocks of all devices in a power domain when we are talking to the PMU
and then turn them immediately off? Would not we want to enable clocks
in start()) callbacks, like Ulf mentioned?

Thanks.

-- 
Dmitry
