Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaIYWXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:23:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:45192 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaIYWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:23:12 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] ARM: keystone: pm: switch to use generic pm domains
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
	<1411657537-25238-3-git-send-email-grygorii.strashko@ti.com>
Date: Thu, 25 Sep 2014 15:23:10 -0700
In-Reply-To: <1411657537-25238-3-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Thu, 25 Sep 2014 18:05:35 +0300")
Message-ID: <7hlhp79w6p.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> This patch switches Keystone 2 PM code to use Generic PM domains
> instead of PM  clock domains because of the lack of DT support
> for the last.
>
> Keystone 2 PM domain should be specified per device for which
> Runtime PM has to be enabled and handles the list of functional clocks
> to enable/disable device.
>
> Example:
>  qmss_domain: qmss_pm_controller {
> 	compatible = "ti,keystone-pm-controller";
> 	clocks = <&chipclk13>;
> 	#power-domain-cells = <0>;
>  };
>
>  qmss: qmss@2a40000 {
> 	compatible = "ti,keystone-navigator-qmss";
> 	...
> 	power-domains = <&qmss_domain>;
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

[...]

> +static int keystone_pm_domain_power_off(struct generic_pm_domain *genpd)
> +{
> +	int ret;
> +	struct keystone_domain *dm = container_of(genpd,
> +						  struct keystone_domain,
> +						  base);
> +
> +	/* Enable reset clocks for all devices in the PU domain */

This says enable clocks...

> +	ret = pm_clk_suspend(dm->dev);

...but this calls clk_disable().

> +	if (ret)
> +		dev_err(dm->dev, "can't turn off clocks %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int keystone_pm_domain_power_on(struct generic_pm_domain *genpd)
> +{
> +	int ret;
> +	struct keystone_domain *dm = container_of(genpd,
> +						  struct keystone_domain,
> +						  base);
> +
> +	/* Disable reset clocks for all devices in the PU domain */

And this says disable clocks...

> +	ret = pm_clk_resume(dm->dev);

...but this calls clk_enable().

-ECONFUSED.

Kevin
