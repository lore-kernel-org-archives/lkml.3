Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbaCNXHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:07:15 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59500 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbaCNXHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Len Brown <len.brown@intel.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Tomasz Figa <t.figa@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 01/11] base: power: Add generic OF-based power domain look-up
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
	<1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
Date: Fri, 14 Mar 2014 16:07:05 -0700
In-Reply-To: <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com> (Tomasz
	Figa's message of "Mon, 3 Mar 2014 17:02:06 +0100")
Message-ID: <7h38ikgz1i.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa <tomasz.figa@gmail.com> writes:

> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
>
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.
>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>

Reviewed-by: Kevin Hilman <khilman@linaro.org>

The approach and binding both look good to me, other than a few minor
nits on comments and question on the locking below...

[...]

> @@ -2177,3 +2181,297 @@ void pm_genpd_init(struct generic_pm_domain *genpd,
>  	list_add(&genpd->gpd_list_node, &gpd_list);
>  	mutex_unlock(&gpd_list_lock);
>  }
> +
> +#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
> +/*
> + * DEVICE TREE BASED POWER DOMAIN PROVIDERS

why all caps?

[...]

> +/* See of_genpd_get_from_provider(). */
> +static struct generic_pm_domain *__of_genpd_get_from_provider(
> +					struct of_phandle_args *genpdspec)
> +{
> +	struct of_genpd_provider *provider;
> +	struct generic_pm_domain *genpd = ERR_PTR(-EPROBE_DEFER);
> +
> +	/* Check if we have such a provider in our array */

I think you want to take the mutex here...

> +	list_for_each_entry(provider, &of_genpd_providers, link) {
> +		if (provider->node == genpdspec->np)
> +			genpd = provider->xlate(genpdspec, provider->data);
> +		if (!IS_ERR(genpd))
> +			break;
> +	}

...and release it here, right?

[...]

> +/*
> + * DEVICE<->DOMAIN BINDING USING DEVICE TREE LOOK-UP

hmm, more yelling?


Otherwise, looks good to me.

Kevin
