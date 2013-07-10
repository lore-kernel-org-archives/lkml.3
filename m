Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3GJEMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:12:23 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39107 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3GJEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:12:21 -0400
Message-ID: <51DCDF1C.1000208@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 12:12:12 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
References: <1443144.WnBWEpaopK@amdc1032> <51DB724F.9050708@linux.vnet.ibm.com> <1754044.EVIH1UZj6p@amdc1032> <51DC0B0D.9070201@linux.vnet.ibm.com>
In-Reply-To: <51DC0B0D.9070201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071004-8256-0000-0000-00000847210B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 09:07 PM, Srivatsa S. Bhat wrote:
[snip]
> 
> But this still doesn't immediately explain how we can end up trying to
> queue work items on offline CPUs (since policy->cpus is supposed to always
> contain online cpus only, and this does look correct in the code as well,
> at a first glance). But I just wanted to share this finding, in case it
> helps us find out the real root-cause.

The prev info show the policy->cpus won't contain offline cpu, but after
you get one cpu id from it, that cpu will go offline at any time.

I'm not sure what is supposed after notify CPUFREQ_GOV_STOP event, if it
is in order to stop queued work and prevent follow work happen again,
then it failed to, and we need some method to stop queue work again when
CPUFREQ_GOV_STOP notified, like some flag in policy which will be
checked before re-queue work in work.

But if the event is just to sync the queued work but not prevent follow
work happen, then things will become tough...we need confirm.

What's your opinion?

Regards,
Michael Wang

> 
> Also, you might perhaps want to try the (untested) patch shown below, and
> see if it resolves your problem. It basically makes work-items requeue
> themselves on only their respective CPUs and not others, so that
> gov_cancel_work succeeds in its mission. However, I guess the patch is
> wrong from a cpufreq perspective, in case cpufreq really depends on the
> "requeue-work-on-everybody" model.
> 
> Regards,
> Srivatsa S. Bhat
> 
> ------------------------------------------------------------------------
> 
>  drivers/cpufreq/cpufreq_conservative.c |    2 +-
>  drivers/cpufreq/cpufreq_governor.c     |    2 --
>  drivers/cpufreq/cpufreq_ondemand.c     |    2 +-
>  3 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 0ceb2ef..bbfc1dd 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -120,7 +120,7 @@ static void cs_dbs_timer(struct work_struct *work)
>  	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
>  	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
>  	int delay = delay_for_sampling_rate(cs_tuners->sampling_rate);
> -	bool modify_all = true;
> +	bool modify_all = false;
> 
>  	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
>  	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 4645876..ec4baeb 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -137,10 +137,8 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 93eb5cb..241ebc0 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -230,7 +230,7 @@ static void od_dbs_timer(struct work_struct *work)
>  	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
>  	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>  	int delay = 0, sample_type = core_dbs_info->sample_type;
> -	bool modify_all = true;
> +	bool modify_all = false;
> 
>  	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
>  	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners->sampling_rate)) {
> 
> 
> 
> 

