Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3GNLsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 07:48:32 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59528 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3GNLs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 07:48:29 -0400
Date: Sun, 14 Jul 2013 14:47:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
Message-ID: <20130714114721.GB2178@swordfish>
References: <20130625211544.GA2270@swordfish>
 <51D10899.1080501@linux.vnet.ibm.com>
 <20130710231305.GA4046@swordfish>
 <51DE1BE1.3090707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE1BE1.3090707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/11/13 10:43), Michael Wang wrote:
> [..]
> Nice to know you have some idea on solving the issue ;-)
> 
> I'm not sure whether I catch the idea, but seems like you are trying
> to re-organize the timing of add/remove device.
> 
> I'm sure that we have more than one way to solve the issues, but what
> we need is the cure of root...
> 
> As Srivatsa discovered, the root issue may be:
> 	gov_cancel_work() failed to stop all the work after it's return.
> 
> And Viresh also confirmed that this is not by-designed.
> 
> Which means gov_queue_work() invoked by od_dbs_timer() is supposed to
> never happen after CPUFREQ_GOV_STOP notify, the whole policy should
> stop working at that time.
> 
> But it failed to, and the work concurrent with cpu dying caused the
> first problem.
> 
> Thus I think we should focus on this and suggested below fix, I'd like
> to know your opinions :)
>

Hello,

I just realized that lockdep was disabling itself at startup (after recent AMD
radeon patch set) due to radeon kms error:

[    4.790019] [drm] Loading CEDAR Microcode
[    4.790943] r600_cp: Failed to load firmware "radeon/CEDAR_smc.bin"
[    4.791152] [drm:evergreen_startup] *ERROR* Failed to load firmware!
[    4.791330] radeon 0000:01:00.0: disabling GPU acceleration
[    4.792633] INFO: trying to register non-static key.
[    4.792792] the code is fine but needs lockdep annotation.
[    4.792953] turning off the locking correctness validator.


Now, as I fixed radeon kms, I can see:

[  806.660530] ------------[ cut here ]------------
[  806.660539] WARNING: CPU: 0 PID: 2389 at arch/x86/kernel/smp.c:124
native_smp_send_reschedule+0x57/0x60()

[  806.660572] Workqueue: events od_dbs_timer
[  806.660575]  0000000000000009 ffff8801531cfbd8 ffffffff816044ee
0000000000000000
[  806.660577]  ffff8801531cfc10 ffffffff8104995d 0000000000000003
ffff8801531f8000
[  806.660579]  000000010001ee39 0000000000000003 0000000000000003
ffff8801531cfc20
[  806.660580] Call Trace:
[  806.660587]  [<ffffffff816044ee>] dump_stack+0x4e/0x82
[  806.660591]  [<ffffffff8104995d>] warn_slowpath_common+0x7d/0xa0
[  806.660593]  [<ffffffff81049a3a>] warn_slowpath_null+0x1a/0x20
[  806.660595]  [<ffffffff8102ca07>] native_smp_send_reschedule+0x57/0x60
[  806.660599]  [<ffffffff81085211>] wake_up_nohz_cpu+0x61/0xb0
[  806.660603]  [<ffffffff8105cb6d>] add_timer_on+0x8d/0x1e0
[  806.660607]  [<ffffffff8106cc66>] __queue_delayed_work+0x166/0x1a0
[  806.660609]  [<ffffffff8106d6a9>] ? try_to_grab_pending+0xd9/0x1a0
[  806.660611]  [<ffffffff8106d7bf>] mod_delayed_work_on+0x4f/0x90
[  806.660613]  [<ffffffff8150f436>] gov_queue_work+0x56/0xd0
[  806.660615]  [<ffffffff8150e740>] od_dbs_timer+0xc0/0x160
[  806.660617]  [<ffffffff8106dbcd>] process_one_work+0x1cd/0x6a0
[  806.660619]  [<ffffffff8106db63>] ? process_one_work+0x163/0x6a0
[  806.660622]  [<ffffffff8106e8d1>] worker_thread+0x121/0x3a0
[  806.660627]  [<ffffffff810b668d>] ? trace_hardirqs_on+0xd/0x10
[  806.660629]  [<ffffffff8106e7b0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  806.660633]  [<ffffffff810760cb>] kthread+0xdb/0xe0
[  806.660635]  [<ffffffff81075ff0>] ? insert_kthread_work+0x70/0x70
[  806.660639]  [<ffffffff8160de6c>] ret_from_fork+0x7c/0xb0
[  806.660640]  [<ffffffff81075ff0>] ? insert_kthread_work+0x70/0x70
[  806.660642] ---[ end trace 01ae278488a0ad6d ]---


The same problem why get/put_online_cpus() has been added to  __gov_queue_work()

commit 2f7021a815f20f3481c10884fe9735ce2a56db35
Author: Michael Wang

    cpufreq: protect 'policy->cpus' from offlining during
    __gov_queue_work()

	-ss

> Regards,
> Michael Wang
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index dc9b72e..a64b544 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>  	int i;
>  
> +	if (dbs_data->queue_stop)
> +		return;
> +
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
> @@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
>  		struct cpufreq_policy *policy)
>  {
>  	struct cpu_dbs_common_info *cdbs;
> -	int i;
> +	int i, round = 2;
>  
> +	dbs_data->queue_stop = 1;
> +redo:
> +	round--;
>  	for_each_cpu(i, policy->cpus) {
>  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
>  		cancel_delayed_work_sync(&cdbs->work);
>  	}
> +
> +	/*
> +	 * Since there is no lock to prvent re-queue the
> +	 * cancelled work, some early cancelled work might
> +	 * have been queued again by later cancelled work.
> +	 *
> +	 * Flush the work again with dbs_data->queue_stop
> +	 * enabled, this time there will be no survivors.
> +	 */
> +	if (round)
> +		goto redo;
> +	dbs_data->queue_stop = 0;
>  }
>  
>  /* Will return if we need to evaluate cpu load again or not */
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index e16a961..9116135 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -213,6 +213,7 @@ struct dbs_data {
>  	unsigned int min_sampling_rate;
>  	int usage_count;
>  	void *tuners;
> +	int queue_stop;
>  
>  	/* dbs_mutex protects dbs_enable in governor start/stop */
>  	struct mutex mutex;
> 
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > ---
> > 
> >  drivers/cpufreq/cpufreq.c          |  5 +----
> >  drivers/cpufreq/cpufreq_governor.c | 17 +++++++++++------
> >  drivers/cpufreq/cpufreq_stats.c    |  2 +-
> >  3 files changed, 13 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 6a015ad..f8aacf1 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1943,13 +1943,10 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
> >  		case CPU_ONLINE:
> >  			cpufreq_add_dev(dev, NULL);
> >  			break;
> > -		case CPU_DOWN_PREPARE:
> > +		case CPU_POST_DEAD:
> >  		case CPU_UP_CANCELED_FROZEN:
> >  			__cpufreq_remove_dev(dev, NULL);
> >  			break;
> > -		case CPU_DOWN_FAILED:
> > -			cpufreq_add_dev(dev, NULL);
> > -			break;
> >  		}
> >  	}
> >  	return NOTIFY_OK;
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > index 4645876..681d5d6 100644
> > --- a/drivers/cpufreq/cpufreq_governor.c
> > +++ b/drivers/cpufreq/cpufreq_governor.c
> > @@ -125,7 +125,11 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
> >  		unsigned int delay)
> >  {
> >  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
> > -
> > +	/* cpu offline might block existing gov_queue_work() user,
> > +	 * unblocking it after CPU_DEAD and before CPU_POST_DEAD.
> > +	 * thus potentially we can hit offlined CPU */
> > +	if (unlikely(cpu_is_offline(cpu)))
> > +		return;
> >  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
> >  }
> > 
> > @@ -133,15 +137,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
> >  		unsigned int delay, bool all_cpus)
> >  {
> >  	int i;
> > -
> > +	get_online_cpus();
> >  	if (!all_cpus) {
> >  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
> >  	} else {
> > -		get_online_cpus();
> >  		for_each_cpu(i, policy->cpus)
> >  			__gov_queue_work(i, dbs_data, delay);
> > -		put_online_cpus();
> >  	}
> > +	put_online_cpus();
> >  }
> >  EXPORT_SYMBOL_GPL(gov_queue_work);
> > 
> > @@ -354,8 +357,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> >  		/* Initiate timer time stamp */
> >  		cpu_cdbs->time_stamp = ktime_get();
> > 
> > -		gov_queue_work(dbs_data, policy,
> > -				delay_for_sampling_rate(sampling_rate), true);
> > +		/* hotplug lock already held */
> > +		for_each_cpu(j, policy->cpus)
> > +			__gov_queue_work(j, dbs_data,
> > +				delay_for_sampling_rate(sampling_rate));
> >  		break;
> > 
> >  	case CPUFREQ_GOV_STOP:
> > diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> > index cd9e817..833816e 100644
> > --- a/drivers/cpufreq/cpufreq_stats.c
> > +++ b/drivers/cpufreq/cpufreq_stats.c
> > @@ -355,7 +355,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
> >  	case CPU_DOWN_PREPARE:
> >  		cpufreq_stats_free_sysfs(cpu);
> >  		break;
> > -	case CPU_DEAD:
> > +	case CPU_POST_DEAD:
> >  		cpufreq_stats_free_table(cpu);
> >  		break;
> >  	case CPU_UP_CANCELED_FROZEN:
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
