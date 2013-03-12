Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3CLHvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:51:25 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:43168
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab3CLHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:51:23 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 03:51:23 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 12 Mar 2013 15:36:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: cpufreq <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: cpufreq-cpu0: support for clock which are
 not in DT yet.
Message-ID: <20130312073630.GG18574@S2101-09.ap.freescale.net>
References: <1363043130-30270-1-git-send-email-nm@ti.com>
 <1363043130-30270-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363043130-30270-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:05:29PM -0500, Nishanth Menon wrote:
> On certain SoCs like variants of OMAP, the clock conversion to DT
> is not complete. In short, the ability to:
> cpus {
>     cpu@0 {
> 	clocks = <&cpuclk 0>;
>     };
>  };
> is not possible. However, the clock node is registered.
> Allow for clk names to be provided as string so as to be used when needed.
> Example (for OMAP3630):
> cpus {
>     cpu@0 {
> 	clock-name = "cpufreq_ck";
>     };
>  };
> 
I'm not sure why the patch is needed at all.  For platform that is
unable to look up clock from device tree yet, something like the
following in kernel will just help cpufreq-cpu0 find the clock, if
you instantiate cpufreq-cpu0 driver in the same way that
highbank-cpufreq does.

  clk_register_clkdev(cpuclk, NULL, "cpufreq-cpu0.0");

Shawn

> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |    3 +++
>  drivers/cpufreq/cpufreq-cpu0.c                     |    6 +++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index 4416ccc..f180963 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -12,6 +12,9 @@ Required properties:
>    for details
>  
>  Optional properties:
> +- clock-name: If the clock is not converted to device tree, then describe
> +  the clock name as a string. This may also be replaced with clocks=<&cpuclk>
> +  cpu clocks has already been converted to device tree.
>  - clock-latency: Specify the possible maximum transition latency for clock,
>    in unit of nanoseconds.
>  - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 4e5b7fb..28223c9 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -180,6 +180,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np;
>  	int ret;
> +	const char *clk_name = NULL;
>  
>  	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
>  		if (of_get_property(np, "operating-points", NULL))
> @@ -194,7 +195,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	cpu_dev = &pdev->dev;
>  	cpu_dev->of_node = np;
>  
> -	cpu_clk = devm_clk_get(cpu_dev, NULL);
> +	/* If clocks are not in DT yet, allow to define it part of CPU node */
> +	of_property_read_string(np, "clock-name", &clk_name);
> +
> +	cpu_clk = devm_clk_get(cpu_dev, clk_name);
>  	if (IS_ERR(cpu_clk)) {
>  		ret = PTR_ERR(cpu_clk);
>  		pr_err("failed to get cpu0 clock: %d\n", ret);
> -- 
> 1.7.9.5
> 

