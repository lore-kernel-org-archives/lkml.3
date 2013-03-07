Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3CGV5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:57:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab3CGV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:57:11 -0500
Date: Thu, 7 Mar 2013 22:56:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux@arm.linux.org.uk,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        robin.randhawa@arm.com, linux-arm-kernel@lists.infradead.org,
        mark.hambleton@broadcom.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
In-Reply-To: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
Message-ID: <Pine.LNX.4.64.1303072248560.20470@axis700.grange>
References: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ahLa0K2jBpAvAjjnX8qAfXNdu9/QvJggGli/WBm0vyO
 cp8+of/nJeEOjXl+cX6GDnXGroJNBWkRkVZm3GPhkZXD0qqR1Q
 UpP8qDwryxL8MwnRj52wheMDQPfvYDxdt7yfqsePSiyiXXIkMh
 DBGRqWyQeLYhs6tFH/JPW4ysPD9TuZT51ZuZtWiqJgw2puYklj
 RyMYVi2yoGbcMzz+Wv0gL+YW2e8U2GvXHDUYmLeddaAuIwxmNQ
 ULL0UFkNtv3ZLD/TBl5NplGVRjPM63H7t4xGGCoOFL+coM5S7Y
 8Wt7HvsFFlDxg1ISGV7Th1TwJGfmtBAqHTmZRru4eN2kDEsDiP
 r/OV4uSbvy1NWyfVPELL0FZzTdlKVdOMba9KT2Zb4KS66i1CZl
 k7daGjqmmH6wA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh

On Fri, 8 Mar 2013, Viresh Kumar wrote:

> big LITTLE is ARM's new Architecture focussing power/performance needs of modern
> world. More information about big LITTLE can be found here:
> 
> http://www.arm.com/products/processors/technologies/biglittleprocessing.php
> http://lwn.net/Articles/481055/
> 
> In order to keep cpufreq support for all big LITTLE platforms simple/generic,
> this patch tries to add a generic cpufreq driver layer for all big LITTLE
> platforms.

I like generic drivers :) cpufreq-cpu0 is yet another such generic 
(cpufreq) driver. Now, comparing the functionality of the two:

[snip]

> +/* Set clock frequency */
> +static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
> +		unsigned int target_freq, unsigned int relation)
> +{
> +	struct cpufreq_freqs freqs;
> +	u32 cpu = policy->cpu, freq_tab_idx, cur_cluster;
> +	int ret = 0;
> +
> +	cur_cluster = cpu_to_cluster(policy->cpu);
> +
> +	freqs.old = bL_cpufreq_get(policy->cpu);
> +
> +	/* Determine valid target frequency using freq_table */
> +	cpufreq_frequency_table_target(policy, freq_table[cur_cluster],
> +			target_freq, relation, &freq_tab_idx);
> +	freqs.new = freq_table[cur_cluster][freq_tab_idx].frequency;
> +
> +	freqs.cpu = policy->cpu;
> +
> +	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
> +			__func__, cpu, cur_cluster, freqs.old, target_freq,
> +			freqs.new);
> +
> +	if (freqs.old == freqs.new)
> +		return 0;
> +
> +	for_each_cpu(freqs.cpu, policy->cpus)
> +		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
> +
> +	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);

we see, that this driver "only" switches CPU clock frequencies. Whereas 
the cpufreq-cpu0 driver also manipulates a regulator (if available) 
directly. I understand, power-saving is also an important consideration 
for big.LITTLE systems. So, I presume, you plan to implement voltage 
switching in cpufreq notifiers? Now, my question is: is this (notifier) 
actually the preferred method and the cpufreq-cpu0 driver is doing it 
"wrongly?"

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
