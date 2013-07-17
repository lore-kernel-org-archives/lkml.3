Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3GQOpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:45:08 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:36079 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab3GQOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:45:06 -0400
Date: Wed, 17 Jul 2013 16:43:55 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sudeep.KarkadaNagesha@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC PATCH v2 11/15] cpufreq: kirkwood-cpufreq: remove device
 tree parsing for cpu nodes
Message-ID: <20130717144355.GE1026@lunn.ch>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374069984-20567-12-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374069984-20567-12-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 03:06:20PM +0100, Sudeep.KarkadaNagesha@arm.com wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Now that the cpu device registration initialises the of_node(if available)
> appropriately for all the cpus, parsing here is redundant.
> 
> This patch removes all DT parsing and uses cpu->of_node instead.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/cpufreq/kirkwood-cpufreq.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index c233ea6..18aa3eb 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
> +#include <linux/cpu.h>
>  #include <linux/cpufreq.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -165,6 +166,7 @@ static struct cpufreq_driver kirkwood_cpufreq_driver = {
>  static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np;
> +	struct device *cpu_dev;
>  	struct resource *res;
>  	int err;
>  
> @@ -175,9 +177,17 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv.base))
>  		return PTR_ERR(priv.base);
>  
> -	np = of_find_node_by_path("/cpus/cpu@0");
> -	if (!np)
> +	cpu_dev = get_cpu_device(0);
> +	if (!cpu_dev) {
> +		dev_err(&pdev->dev, "failed to get cpu device\n");
>  		return -ENODEV;
> +	}
> +
> +	np = of_node_get(cpu_dev->of_node);
> +	if (!np) {
> +		dev_err(&pdev->dev, "failed to get cpu device node\n");
> +		return -ENODEV;
> +	}

Hi Sudeep

Are we not going a bit backwards here? You are replacing two lines
with 10 lines.

How about putting these 10 lines into some helper,
of_get_cpu_device()?  It would be useful for spear, kirkwood and
imx6q, and maybe others.

    Thanks
	Andrew
