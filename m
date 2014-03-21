Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaCUHtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:49:09 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46812 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaCUHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:49:05 -0400
Message-ID: <532BEEDC.9000106@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 13:18:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 2/3] cpufreq: Convert existing drivers to use cpufreq_freq_transition_{begin|end}
References: <cover.1395379422.git.viresh.kumar@linaro.org> <6c531c2fb48c3092bba1098459ef0862a6179375.1395379422.git.viresh.kumar@linaro.org>
In-Reply-To: <6c531c2fb48c3092bba1098459ef0862a6179375.1395379422.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032107-0260-0000-0000-00000492C986
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:04 AM, Viresh Kumar wrote:
> CPUFreq core has new infrastructure that would guarantee serialized calls to
> target() or target_index() callbacks. These are called
> cpufreq_freq_transition_begin() and cpufreq_freq_transition_end().
> 
> This patch converts existing drivers to use these new set of routines.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Nitpick: Instead of using 'false' as an argument to _post_transition(),
you could use '0', since the argument is supposed to be an int. But that's
minor, I won't insist.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq-nforce2.c    | 4 ++--
>  drivers/cpufreq/cpufreq.c            | 9 ++++-----
>  drivers/cpufreq/exynos5440-cpufreq.c | 4 ++--
>  drivers/cpufreq/gx-suspmod.c         | 4 ++--
>  drivers/cpufreq/integrator-cpufreq.c | 4 ++--
>  drivers/cpufreq/longhaul.c           | 4 ++--
>  drivers/cpufreq/pcc-cpufreq.c        | 4 ++--
>  drivers/cpufreq/powernow-k6.c        | 4 ++--
>  drivers/cpufreq/powernow-k7.c        | 4 ++--
>  drivers/cpufreq/powernow-k8.c        | 4 ++--
>  drivers/cpufreq/s3c24xx-cpufreq.c    | 4 ++--
>  drivers/cpufreq/sh-cpufreq.c         | 4 ++--
>  drivers/cpufreq/unicore2-cpufreq.c   | 4 ++--
>  13 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
> index a05b876..379cc2c 100644
> --- a/drivers/cpufreq/cpufreq-nforce2.c
> +++ b/drivers/cpufreq/cpufreq-nforce2.c
> @@ -270,7 +270,7 @@ static int nforce2_target(struct cpufreq_policy *policy,
>  	pr_debug("Old CPU frequency %d kHz, new %d kHz\n",
>  	       freqs.old, freqs.new);
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	/* Disable IRQs */
>  	/* local_irq_save(flags); */
> @@ -285,7 +285,7 @@ static int nforce2_target(struct cpufreq_policy *policy,
>  	/* Enable IRQs */
>  	/* local_irq_restore(flags); */
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 4279cc9..b63e7e4 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1503,8 +1503,8 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
>  	policy = per_cpu(cpufreq_cpu_data, cpu);
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
>  }
> 
>  /**
> @@ -1864,8 +1864,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
>  				 __func__, policy->cpu, freqs.old, freqs.new);
> 
> -			cpufreq_notify_transition(policy, &freqs,
> -					CPUFREQ_PRECHANGE);
> +			cpufreq_freq_transition_begin(policy, &freqs);
>  		}
> 
>  		retval = cpufreq_driver->target_index(policy, index);
> @@ -1874,7 +1873,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  			       __func__, retval);
> 
>  		if (notify)
> -			cpufreq_notify_post_transition(policy, &freqs, retval);
> +			cpufreq_freq_transition_end(policy, &freqs, retval);
>  	}
> 
>  out:
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> index 7f776aa..3655e7d 100644
> --- a/drivers/cpufreq/exynos5440-cpufreq.c
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -219,7 +219,7 @@ static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
>  	freqs.old = policy->cur;
>  	freqs.new = freq_table[index].frequency;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	/* Set the target frequency in all C0_3_PSTATE register */
>  	for_each_cpu(i, policy->cpus) {
> @@ -258,7 +258,7 @@ static void exynos_cpufreq_work(struct work_struct *work)
>  		dev_crit(dvfs_info->dev, "New frequency out of range\n");
>  		freqs.new = freqs.old;
>  	}
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	cpufreq_cpu_put(policy);
>  	mutex_unlock(&cpufreq_lock);
> diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
> index d83e826..fe85673 100644
> --- a/drivers/cpufreq/gx-suspmod.c
> +++ b/drivers/cpufreq/gx-suspmod.c
> @@ -265,7 +265,7 @@ static void gx_set_cpuspeed(struct cpufreq_policy *policy, unsigned int khz)
> 
>  	freqs.new = new_khz;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
>  	local_irq_save(flags);
> 
>  	if (new_khz != stock_freq) {
> @@ -314,7 +314,7 @@ static void gx_set_cpuspeed(struct cpufreq_policy *policy, unsigned int khz)
> 
>  	gx_params->pci_suscfg = suscfg;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	pr_debug("suspend modulation w/ duration of ON:%d us, OFF:%d us\n",
>  		gx_params->on_duration * 32, gx_params->off_duration * 32);
> diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
> index 0e27844..771f422 100644
> --- a/drivers/cpufreq/integrator-cpufreq.c
> +++ b/drivers/cpufreq/integrator-cpufreq.c
> @@ -122,7 +122,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
>  		return 0;
>  	}
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	cm_osc = __raw_readl(cm_base + INTEGRATOR_HDR_OSC_OFFSET);
> 
> @@ -143,7 +143,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
>  	 */
>  	set_cpus_allowed(current, cpus_allowed);
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
> index 7b94da3..c599af9 100644
> --- a/drivers/cpufreq/longhaul.c
> +++ b/drivers/cpufreq/longhaul.c
> @@ -269,7 +269,7 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
>  	freqs.old = calc_speed(longhaul_get_cpu_mult());
>  	freqs.new = speed;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	pr_debug("Setting to FSB:%dMHz Mult:%d.%dx (%s)\n",
>  			fsb, mult/10, mult%10, print_speed(speed/1000));
> @@ -386,7 +386,7 @@ retry_loop:
>  		}
>  	}
>  	/* Report true CPU frequency */
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	if (!bm_timeout)
>  		printk(KERN_INFO PFX "Warning: Timeout while waiting for "
> diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
> index 1c0f106..728a2d8 100644
> --- a/drivers/cpufreq/pcc-cpufreq.c
> +++ b/drivers/cpufreq/pcc-cpufreq.c
> @@ -215,7 +215,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
> 
>  	freqs.old = policy->cur;
>  	freqs.new = target_freq;
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	input_buffer = 0x1 | (((target_freq * 100)
>  			       / (ioread32(&pcch_hdr->nominal) * 1000)) << 8);
> @@ -231,7 +231,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
>  	status = ioread16(&pcch_hdr->status);
>  	iowrite16(0, &pcch_hdr->status);
> 
> -	cpufreq_notify_post_transition(policy, &freqs, status != CMD_COMPLETE);
> +	cpufreq_freq_transition_end(policy, &freqs, status != CMD_COMPLETE);
>  	spin_unlock(&pcc_lock);
> 
>  	if (status != CMD_COMPLETE) {
> diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
> index ce27e6c..882d673 100644
> --- a/drivers/cpufreq/powernow-k6.c
> +++ b/drivers/cpufreq/powernow-k6.c
> @@ -148,11 +148,11 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
>  	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
>  	freqs.new = busfreq * clock_ratio[best_i].driver_data;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	powernow_k6_set_cpu_multiplier(best_i);
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
> index 0e68e02..30a6c48 100644
> --- a/drivers/cpufreq/powernow-k7.c
> +++ b/drivers/cpufreq/powernow-k7.c
> @@ -269,7 +269,7 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
> 
>  	freqs.new = powernow_table[index].frequency;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
> 
>  	/* Now do the magic poking into the MSRs.  */
> 
> @@ -290,7 +290,7 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
>  	if (have_a0 == 1)
>  		local_irq_enable();
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index 27eb2be..770a9e1 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -963,9 +963,9 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
>  	policy = cpufreq_cpu_get(smp_processor_id());
>  	cpufreq_cpu_put(policy);
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
>  	res = transition_fid_vid(data, fid, vid);
> -	cpufreq_notify_post_transition(policy, &freqs, res);
> +	cpufreq_freq_transition_end(policy, &freqs, res);
> 
>  	return res;
>  }
> diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
> index 2506974..d5ef905 100644
> --- a/drivers/cpufreq/s3c24xx-cpufreq.c
> +++ b/drivers/cpufreq/s3c24xx-cpufreq.c
> @@ -217,7 +217,7 @@ static int s3c_cpufreq_settarget(struct cpufreq_policy *policy,
>  	s3c_cpufreq_updateclk(clk_pclk, cpu_new.freq.pclk);
> 
>  	/* start the frequency change */
> -	cpufreq_notify_transition(policy, &freqs.freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs.freqs);
> 
>  	/* If hclk is staying the same, then we do not need to
>  	 * re-write the IO or the refresh timings whilst we are changing
> @@ -261,7 +261,7 @@ static int s3c_cpufreq_settarget(struct cpufreq_policy *policy,
>  	local_irq_restore(flags);
> 
>  	/* notify everyone we've done this */
> -	cpufreq_notify_transition(policy, &freqs.freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs.freqs, false);
> 
>  	s3c_freq_dbg("%s: finished\n", __func__);
>  	return 0;
> diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
> index 696170e..f63abf3 100644
> --- a/drivers/cpufreq/sh-cpufreq.c
> +++ b/drivers/cpufreq/sh-cpufreq.c
> @@ -68,10 +68,10 @@ static int sh_cpufreq_target(struct cpufreq_policy *policy,
>  	freqs.new	= (freq + 500) / 1000;
>  	freqs.flags	= 0;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
>  	set_cpus_allowed_ptr(current, &cpus_allowed);
>  	clk_set_rate(cpuclk, freq);
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +	cpufreq_freq_transition_end(policy, &freqs, false);
> 
>  	dev_dbg(dev, "set frequency %lu Hz\n", freq);
> 
> diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
> index 36cc330..13be802 100644
> --- a/drivers/cpufreq/unicore2-cpufreq.c
> +++ b/drivers/cpufreq/unicore2-cpufreq.c
> @@ -44,9 +44,9 @@ static int ucv2_target(struct cpufreq_policy *policy,
>  	freqs.old = policy->cur;
>  	freqs.new = target_freq;
> 
> -	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> +	cpufreq_freq_transition_begin(policy, &freqs);
>  	ret = clk_set_rate(policy->mclk, target_freq * 1000);
> -	cpufreq_notify_post_transition(policy, &freqs, ret);
> +	cpufreq_freq_transition_end(policy, &freqs, ret);
> 
>  	return ret;
>  }
> 

