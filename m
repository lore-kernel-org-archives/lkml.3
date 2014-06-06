Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFFODn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:03:43 -0400
Received: from mail.tpi.com ([74.45.170.26]:46255 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaFFODm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:03:42 -0400
Message-ID: <5391CA3C.9060907@canonical.com>
Date: Fri, 06 Jun 2014 08:03:40 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ed Swarthout <Ed.Swarthout@freescale.com>, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ppc-corenet-cpu-freq: do_div use quotient
References: <1398701898-68201-1-git-send-email-tim.gardner@canonical.com> <1401913973-22536-1-git-send-email-Ed.Swarthout@freescale.com>
In-Reply-To: <1401913973-22536-1-git-send-email-Ed.Swarthout@freescale.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 02:32 PM, Ed Swarthout wrote:
> 6712d2931933ada259b82f06c03a855b19937074 (cpufreq:
> ppc-corenet-cpufreq: Fix __udivdi3 modpost error) used the remainder
> from do_div instead of the quotient. Fix that and add one to ensure
> minimum is met.
> 
> Signed-off-by: Ed Swarthout <Ed.Swarthout@freescale.com>
> ---
>  drivers/cpufreq/ppc-corenet-cpufreq.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
> index 0af618a..3607070 100644
> --- a/drivers/cpufreq/ppc-corenet-cpufreq.c
> +++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
> @@ -138,7 +138,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  	struct cpufreq_frequency_table *table;
>  	struct cpu_data *data;
>  	unsigned int cpu = policy->cpu;
> -	u64 transition_latency_hz;
> +	u64 u64temp;
>  
>  	np = of_get_cpu_node(cpu, NULL);
>  	if (!np)
> @@ -206,9 +206,10 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  	for_each_cpu(i, per_cpu(cpu_mask, cpu))
>  		per_cpu(cpu_data, i) = data;
>  
> -	transition_latency_hz = 12ULL * NSEC_PER_SEC;
> -	policy->cpuinfo.transition_latency =
> -		do_div(transition_latency_hz, fsl_get_sys_freq());
> +	/* Minimum transition latency is 12 platform clocks */
> +	u64temp = 12ULL * NSEC_PER_SEC;
> +	do_div(u64temp, fsl_get_sys_freq());
> +	policy->cpuinfo.transition_latency = u64temp + 1;
>  
>  	of_node_put(np);
>  
> 

Whoops, what was I thinking ? You should also add "Cc:
stable@vger.kernel.org # 3.15+" since this patch will likely miss 3.15
final.

Acked-by: Tim Gardner <tim.gardner@canonical.com>

-- 
Tim Gardner tim.gardner@canonical.com
