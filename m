Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403Ab3EAOln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:41:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39446 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab3EAOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:41:36 -0400
Date: Wed, 1 May 2013 09:41:20 -0500
From: Nishanth Menon <nm@ti.com>
To: <Sudeep.KarkadaNagesha@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / OPP: add support to specify phandle of another
 node for OPP
Message-ID: <20130501144120.GA17385@kahuna>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1367406679-21603-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367406679-21603-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> If more than one similar devices share the same OPPs, currently we
> need to replicate the OPP entries in all the nodes.
Nice, thanks.
> 
> Few drivers like cpufreq depend on physical cpu0 node to specify the
cpufreq-cpu0?
> OPPs and only that node is referred irrespective of the logical cpu
> accessing it. Alternatively to support cpuhotplug path, few drivers
> parse all the cpu nodes for OPPs. Instead we can specify the phandle
> of the node with which the current node shares the operating points.
> 
> This patch adds support to specify the phandle in the operating points
> of any device node, where the node specified by the phandle holds the
> actual OPPs.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  Documentation/devicetree/bindings/power/opp.txt |   41 +++++++++++++++++++++++
>  drivers/base/power/opp.c                        |   30 ++++++++++++-----
>  2 files changed, 63 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/power/opp.txt b/Documentation/devicetree/bindings/power/opp.txt
> index 74499e5..a659da4 100644
> --- a/Documentation/devicetree/bindings/power/opp.txt
> +++ b/Documentation/devicetree/bindings/power/opp.txt
> @@ -23,3 +23,44 @@ cpu@0 {
>  		198000  850000
>  	>;
>  };
> +
Definition of operating-points is now a little different in the
original description - it still indicates tuple {freq,voltage}, where
as, this patch allows phandle to a different device's operating-points
to be used. - we might want to rephrase the description.

btw, to device-tree folks, I am not sure if it is OK to have different formats
for the same property like operating-points. At least I don't seem to
quickly be able to find any precedence.

> +If more than one device of same type share the same OPPs, e.g. all the CPUs on
s/e.g/example?
> +a SoC or in a single cluster on a SoC, then we need to avoid replicating the
> +OPPs in all the nodes. We can specify the phandle of the node with which the
> +current node shares the operating points instead.
> +
> +Examples:
> +Consider an SMP with 4 CPUs all sharing the same OPPs.
We might want to descr
> +
> +cpu0: cpu@0 {
> +	compatible = "arm,cortex-a9";
> +	reg = <0>;
> +	next-level-cache = <&L2>;
> +	operating-points = <
> +		/* kHz    uV */
> +		792000  1100000
> +		396000  950000
> +		198000  850000
> +	>;
> +};
> +
> +cpu1: cpu@1 {
> +	compatible = "arm,cortex-a9";
> +	reg = <1>;
> +	next-level-cache = <&L2>;
> +	operating-points = <&cpu0>;
> +};
> +
> +cpu2: cpu@2 {
> +	compatible = "arm,cortex-a9";
> +	reg = <2>;
> +	next-level-cache = <&L2>;
> +	operating-points = <&cpu0>;
> +};
> +
> +cpu3: cpu@3 {
> +	compatible = "arm,cortex-a9";
> +	reg = <3>;
> +	next-level-cache = <&L2>;
> +	operating-points = <&cpu0>;
> +};
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index f0077cb..4dfdc01 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -698,19 +698,15 @@ struct srcu_notifier_head *opp_get_notifier(struct device *dev)
>  }
>  
>  #ifdef CONFIG_OF
> -/**
> - * of_init_opp_table() - Initialize opp table from device tree
> - * @dev:	device pointer used to lookup device OPPs.
> - *
> - * Register the initial OPP table with the OPP library for given device.
> - */
> -int of_init_opp_table(struct device *dev)
> +static int of_init_opp_table_from_ofnode(struct device *dev,
> +					struct device_node *of_node)
please provide kernel-doc documentation for static function as well -
this is inline with the rest of the file.
>  {
> +	struct device_opp *dev_opp = NULL;
dev_opp is not used until patch #2 - please introduce it in that patch.
>  	const struct property *prop;
>  	const __be32 *val;
>  	int nr;
>  
> -	prop = of_find_property(dev->of_node, "operating-points", NULL);
> +	prop = of_find_property(of_node, "operating-points", NULL);
>  	if (!prop)
>  		return -ENODEV;
>  	if (!prop->value)
> @@ -722,6 +718,14 @@ int of_init_opp_table(struct device *dev)
>  	 */
>  	nr = prop->length / sizeof(u32);
>  	if (nr % 2) {
> +		if (nr == 1) {
> +			struct device_node *opp_node;
> +			opp_node = of_parse_phandle(dev->of_node,
> +						"operating-points", 0);
> +			if (opp_node)
> +				return of_init_opp_table_from_ofnode(dev,
> +								opp_node);
> +		}
if operating-points=<100000>, then we return Invalid OPP list
if operating-points=<&uart3>; (some phandle that does not have
operating-points), there is no helpful warning in log except -ENODEV is
returned - we might want to add some info here?
>  		dev_err(dev, "%s: Invalid OPP list\n", __func__);
>  		return -EINVAL;
>  	}
> @@ -741,5 +745,15 @@ int of_init_opp_table(struct device *dev)
>  
>  	return 0;
>  }
missing EOL?
> +/**
> + * of_init_opp_table() - Initialize opp table from device tree
> + * @dev:	device pointer used to lookup device OPPs.
> + *
> + * Register the initial OPP table with the OPP library for given device.
> + */
> +int of_init_opp_table(struct device *dev)
> +{
> +	return of_init_opp_table_from_ofnode(dev, dev->of_node);
> +}
>  EXPORT_SYMBOL_GPL(of_init_opp_table);
>  #endif
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Nishanth Menon
