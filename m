Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3DUX1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:27:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40211 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3DUX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:27:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] cpufreq: ARM big LITTLE: put DT nodes after using them
Date: Mon, 22 Apr 2013 01:35:17 +0200
Message-ID: <2567042.4Wk0EiJ4ZT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
References: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 15, 2013 12:35:24 PM Viresh Kumar wrote:
> DT nodes should be put using of_node_put() to balance their usage counts. This
> is not done properly in ARM's big LITTLE driver. Fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,
> 
> These are fixes for 3.10

Both applied.

Thanks,
Rafael


>  drivers/cpufreq/arm_big_little_dt.c | 43 +++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
> index 452ff46..44be311 100644
> --- a/drivers/cpufreq/arm_big_little_dt.c
> +++ b/drivers/cpufreq/arm_big_little_dt.c
> @@ -31,22 +31,28 @@
>  
>  static int dt_init_opp_table(struct device *cpu_dev)
>  {
> -	struct device_node *np = NULL;
> +	struct device_node *np, *parent;
>  	int count = 0, ret;
>  
> -	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
> +	parent = of_find_node_by_path("/cpus");
> +	if (!parent) {
> +		pr_err("failed to find OF /cpus\n");
> +		return -ENOENT;
> +	}
> +
> +	for_each_child_of_node(parent, np) {
>  		if (count++ != cpu_dev->id)
>  			continue;
> -		if (!of_get_property(np, "operating-points", NULL))
> -			return -ENODATA;
> -
> -		cpu_dev->of_node = np;
> -
> -		ret = of_init_opp_table(cpu_dev);
> -		if (ret)
> -			return ret;
> -
> -		return 0;
> +		if (!of_get_property(np, "operating-points", NULL)) {
> +			ret = -ENODATA;
> +		} else {
> +			cpu_dev->of_node = np;
> +			ret = of_init_opp_table(cpu_dev);
> +		}
> +		of_node_put(np);
> +		of_node_put(parent);
> +
> +		return ret;
>  	}
>  
>  	return -ENODEV;
> @@ -54,15 +60,24 @@ static int dt_init_opp_table(struct device *cpu_dev)
>  
>  static int dt_get_transition_latency(struct device *cpu_dev)
>  {
> -	struct device_node *np = NULL;
> +	struct device_node *np, *parent;
>  	u32 transition_latency = CPUFREQ_ETERNAL;
>  	int count = 0;
>  
> -	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
> +	parent = of_find_node_by_path("/cpus");
> +	if (!parent) {
> +		pr_err("failed to find OF /cpus\n");
> +		return -ENOENT;
> +	}
> +
> +	for_each_child_of_node(parent, np) {
>  		if (count++ != cpu_dev->id)
>  			continue;
>  
>  		of_property_read_u32(np, "clock-latency", &transition_latency);
> +		of_node_put(np);
> +		of_node_put(parent);
> +
>  		return 0;
>  	}
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
