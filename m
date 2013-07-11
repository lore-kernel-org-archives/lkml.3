Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3GKCn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:43:57 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47219 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3GKCnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:43:55 -0400
Message-ID: <51DE1BE1.3090707@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 10:43:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <51D10899.1080501@linux.vnet.ibm.com> <20130710231305.GA4046@swordfish>
In-Reply-To: <20130710231305.GA4046@swordfish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071102-8878-0000-0000-000007E6F65F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sergey

On 07/11/2013 07:13 AM, Sergey Senozhatsky wrote:
[snip]
> 
> 
> Please kindly review the following patch.
> 
> 
> 
> Remove cpu device only upon succesful cpu down on CPU_POST_DEAD event,
> so we can kill off CPU_DOWN_FAILED case and eliminate potential extra
> remove/add path:
> 	
> 	hotplug lock
> 		CPU_DOWN_PREPARE: __cpufreq_remove_dev
> 		CPU_DOWN_FAILED: cpufreq_add_dev
> 	hotplug unlock
> 
> Since cpu still present on CPU_DEAD event, cpu stats table should be
> kept longer and removed later on CPU_POST_DEAD as well.
> 
> Because CPU_POST_DEAD action performed with hotplug lock released, CPU_DOWN
> might block existing gov_queue_work() user (blocked on get_online_cpus())
> and unblock it with one of policy->cpus offlined, thus cpu_is_offline()
> check is performed in __gov_queue_work().
> 
> Besides, existing gov_queue_work() hotplug guard extended to protect all
> __gov_queue_work() calls: for both all_cpus and !all_cpus cases.
> 
> CPUFREQ_GOV_START performs direct __gov_queue_work() call because hotplug
> lock already held there, opposing to previous gov_queue_work() and nested
> get/put_online_cpus().

Nice to know you have some idea on solving the issue ;-)

I'm not sure whether I catch the idea, but seems like you are trying
to re-organize the timing of add/remove device.

I'm sure that we have more than one way to solve the issues, but what
we need is the cure of root...

As Srivatsa discovered, the root issue may be:
	gov_cancel_work() failed to stop all the work after it's return.

And Viresh also confirmed that this is not by-designed.

Which means gov_queue_work() invoked by od_dbs_timer() is supposed to
never happen after CPUFREQ_GOV_STOP notify, the whole policy should
stop working at that time.

But it failed to, and the work concurrent with cpu dying caused the
first problem.

Thus I think we should focus on this and suggested below fix, I'd like
to know your opinions :)

Regards,
Michael Wang

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index dc9b72e..a64b544 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 {
 	int i;
 
+	if (dbs_data->queue_stop)
+		return;
+
 	if (!all_cpus) {
 		__gov_queue_work(smp_processor_id(), dbs_data, delay);
 	} else {
-		get_online_cpus();
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
-		put_online_cpus();
 	}
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);
@@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy)
 {
 	struct cpu_dbs_common_info *cdbs;
-	int i;
+	int i, round = 2;
 
+	dbs_data->queue_stop = 1;
+redo:
+	round--;
 	for_each_cpu(i, policy->cpus) {
 		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
 		cancel_delayed_work_sync(&cdbs->work);
 	}
+
+	/*
+	 * Since there is no lock to prvent re-queue the
+	 * cancelled work, some early cancelled work might
+	 * have been queued again by later cancelled work.
+	 *
+	 * Flush the work again with dbs_data->queue_stop
+	 * enabled, this time there will be no survivors.
+	 */
+	if (round)
+		goto redo;
+	dbs_data->queue_stop = 0;
 }
 
 /* Will return if we need to evaluate cpu load again or not */
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..9116135 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -213,6 +213,7 @@ struct dbs_data {
 	unsigned int min_sampling_rate;
 	int usage_count;
 	void *tuners;
+	int queue_stop;
 
 	/* dbs_mutex protects dbs_enable in governor start/stop */
 	struct mutex mutex;

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/cpufreq/cpufreq.c          |  5 +----
>  drivers/cpufreq/cpufreq_governor.c | 17 +++++++++++------
>  drivers/cpufreq/cpufreq_stats.c    |  2 +-
>  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6a015ad..f8aacf1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1943,13 +1943,10 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>  		case CPU_ONLINE:
>  			cpufreq_add_dev(dev, NULL);
>  			break;
> -		case CPU_DOWN_PREPARE:
> +		case CPU_POST_DEAD:
>  		case CPU_UP_CANCELED_FROZEN:
>  			__cpufreq_remove_dev(dev, NULL);
>  			break;
> -		case CPU_DOWN_FAILED:
> -			cpufreq_add_dev(dev, NULL);
> -			break;
>  		}
>  	}
>  	return NOTIFY_OK;
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 4645876..681d5d6 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -125,7 +125,11 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>  		unsigned int delay)
>  {
>  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
> -
> +	/* cpu offline might block existing gov_queue_work() user,
> +	 * unblocking it after CPU_DEAD and before CPU_POST_DEAD.
> +	 * thus potentially we can hit offlined CPU */
> +	if (unlikely(cpu_is_offline(cpu)))
> +		return;
>  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
>  }
> 
> @@ -133,15 +137,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  		unsigned int delay, bool all_cpus)
>  {
>  	int i;
> -
> +	get_online_cpus();
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
> +	put_online_cpus();
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> 
> @@ -354,8 +357,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		/* Initiate timer time stamp */
>  		cpu_cdbs->time_stamp = ktime_get();
> 
> -		gov_queue_work(dbs_data, policy,
> -				delay_for_sampling_rate(sampling_rate), true);
> +		/* hotplug lock already held */
> +		for_each_cpu(j, policy->cpus)
> +			__gov_queue_work(j, dbs_data,
> +				delay_for_sampling_rate(sampling_rate));
>  		break;
> 
>  	case CPUFREQ_GOV_STOP:
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index cd9e817..833816e 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -355,7 +355,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>  	case CPU_DOWN_PREPARE:
>  		cpufreq_stats_free_sysfs(cpu);
>  		break;
> -	case CPU_DEAD:
> +	case CPU_POST_DEAD:
>  		cpufreq_stats_free_table(cpu);
>  		break;
>  	case CPU_UP_CANCELED_FROZEN:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

