Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3GJXNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:13:41 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49431 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3GJXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:13:39 -0400
Date: Thu, 11 Jul 2013 02:13:05 +0300
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
Message-ID: <20130710231305.GA4046@swordfish>
References: <20130625211544.GA2270@swordfish>
 <51D10899.1080501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D10899.1080501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/01/13 12:42), Michael Wang wrote:
> On 06/26/2013 05:15 AM, Sergey Senozhatsky wrote:
> [snip]
> > 
> > [   60.277848] Chain exists of:
> >   (&(&j_cdbs->work)->work) --> &j_cdbs->timer_mutex --> cpu_hotplug.lock
> > 
> > [   60.277864]  Possible unsafe locking scenario:
> > 
> > [   60.277869]        CPU0                    CPU1
> > [   60.277873]        ----                    ----
> > [   60.277877]   lock(cpu_hotplug.lock);
> > [   60.277885]                                lock(&j_cdbs->timer_mutex);
> > [   60.277892]                                lock(cpu_hotplug.lock);
> > [   60.277900]   lock((&(&j_cdbs->work)->work));
> > [   60.277907] 
> >  *** DEADLOCK ***
> 
> It may caused by that 'j_cdbs->work.work' and 'j_cdbs->timer_mutex'
> has the same lock class, although they are different lock...
> 
> This may help fix the issue:
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 5af40ad..aa05eaa 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -229,6 +229,8 @@ static void set_sampling_rate(struct dbs_data *dbs_data,
>         }
>  }
>  
> +static struct lock_class_key j_cdbs_key;
> +
>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                 struct common_dbs_data *cdata, unsigned int event)
>  {
> @@ -366,6 +368,8 @@ int (struct cpufreq_policy *policy,
>                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>  
>                         mutex_init(&j_cdbs->timer_mutex);
> +                       lockdep_set_class(&j_cdbs->timer_mutex, &j_cdbs_key);
> +
>                         INIT_DEFERRABLE_WORK(&j_cdbs->work,
>                                              dbs_data->cdata->gov_dbs_timer);
>                 }
> 
> Would you like to take a try?
>

Hello,
sorry for long reply. unfortunately it seems it doesn't.


Please kindly review the following patch.



Remove cpu device only upon succesful cpu down on CPU_POST_DEAD event,
so we can kill off CPU_DOWN_FAILED case and eliminate potential extra
remove/add path:
	
	hotplug lock
		CPU_DOWN_PREPARE: __cpufreq_remove_dev
		CPU_DOWN_FAILED: cpufreq_add_dev
	hotplug unlock

Since cpu still present on CPU_DEAD event, cpu stats table should be
kept longer and removed later on CPU_POST_DEAD as well.

Because CPU_POST_DEAD action performed with hotplug lock released, CPU_DOWN
might block existing gov_queue_work() user (blocked on get_online_cpus())
and unblock it with one of policy->cpus offlined, thus cpu_is_offline()
check is performed in __gov_queue_work().

Besides, existing gov_queue_work() hotplug guard extended to protect all
__gov_queue_work() calls: for both all_cpus and !all_cpus cases.

CPUFREQ_GOV_START performs direct __gov_queue_work() call because hotplug
lock already held there, opposing to previous gov_queue_work() and nested
get/put_online_cpus().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/cpufreq/cpufreq.c          |  5 +----
 drivers/cpufreq/cpufreq_governor.c | 17 +++++++++++------
 drivers/cpufreq/cpufreq_stats.c    |  2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6a015ad..f8aacf1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1943,13 +1943,10 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 		case CPU_ONLINE:
 			cpufreq_add_dev(dev, NULL);
 			break;
-		case CPU_DOWN_PREPARE:
+		case CPU_POST_DEAD:
 		case CPU_UP_CANCELED_FROZEN:
 			__cpufreq_remove_dev(dev, NULL);
 			break;
-		case CPU_DOWN_FAILED:
-			cpufreq_add_dev(dev, NULL);
-			break;
 		}
 	}
 	return NOTIFY_OK;
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 4645876..681d5d6 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -125,7 +125,11 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
 		unsigned int delay)
 {
 	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
-
+	/* cpu offline might block existing gov_queue_work() user,
+	 * unblocking it after CPU_DEAD and before CPU_POST_DEAD.
+	 * thus potentially we can hit offlined CPU */
+	if (unlikely(cpu_is_offline(cpu)))
+		return;
 	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
 }
 
@@ -133,15 +137,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		unsigned int delay, bool all_cpus)
 {
 	int i;
-
+	get_online_cpus();
 	if (!all_cpus) {
 		__gov_queue_work(smp_processor_id(), dbs_data, delay);
 	} else {
-		get_online_cpus();
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
-		put_online_cpus();
 	}
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);
 
@@ -354,8 +357,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		/* Initiate timer time stamp */
 		cpu_cdbs->time_stamp = ktime_get();
 
-		gov_queue_work(dbs_data, policy,
-				delay_for_sampling_rate(sampling_rate), true);
+		/* hotplug lock already held */
+		for_each_cpu(j, policy->cpus)
+			__gov_queue_work(j, dbs_data,
+				delay_for_sampling_rate(sampling_rate));
 		break;
 
 	case CPUFREQ_GOV_STOP:
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cd9e817..833816e 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -355,7 +355,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 		cpufreq_stats_free_table(cpu);
 		break;
 	case CPU_UP_CANCELED_FROZEN:
