Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3GINK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:10:58 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48527 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GINK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:10:56 -0400
Message-ID: <51DC0B0D.9070201@linux.vnet.ibm.com>
Date: Tue, 09 Jul 2013 18:37:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
References: <1443144.WnBWEpaopK@amdc1032> <51DB724F.9050708@linux.vnet.ibm.com> <1754044.EVIH1UZj6p@amdc1032>
In-Reply-To: <1754044.EVIH1UZj6p@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070913-5816-0000-0000-000008D49101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 05:21 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday, July 09, 2013 10:15:43 AM Michael Wang wrote:
>> Hi, Bartlomiej
>>
>> On 07/08/2013 11:26 PM, Bartlomiej Zolnierkiewicz wrote:
>> [snip]
>>>
>>> # echo 0 > /sys/devices/system/cpu/cpu3/online
>>> # echo 0 > /sys/devices/system/cpu/cpu2/online
>>> # echo 0 > /sys/devices/system/cpu/cpu1/online
>>> # while true;do echo 1 > /sys/devices/system/cpu/cpu1/online;echo 0 > /sys/devices/system/cpu/cpu1/online;done
>>>
>>> The commit in question (2f7021a8) was merged in v3.10-rc5 as a fix for
>>> commit 031299b ("cpufreq: governors: Avoid unnecessary per cpu timer
>>> interrupts") which was causing a kernel warning to show up.
>>>
>>> Michael/Viresh: do you have some idea how to fix the issue?
>>
>> Thanks for the report :) would you like to take a try
>> on below patch and see whether it solve the issue?
> 
> It doesn't help and unfortunately it just can't help as it only
> addresses lockdep functionality while the issue is not a lockdep
> problem but a genuine locking problem. CPU hot-unplug invokes
> _cpu_down() which calls cpu_hotplug_begin() which in turn takes
> &cpu_hotplug.lock. The lock is then hold during __cpu_notify()
> call. Notifier chain goes up to cpufreq_governor_dbs() which for
> CPUFREQ_GOV_STOP event does gov_cancel_work(). This function
> flushes pending work and waits for it to finish. The all above
> happens in one kernel thread. At the same time the other kernel
> thread is doing the work we are waiting to complete and it also
> happens to do gov_queue_work() which calls get_online_cpus().
> Then the code tries to take &cpu_hotplug.lock which is already
> held by the first thread and deadlocks.
> 

Yeah, exactly!

So I had proposed doing an asynchronous cancel-work or doing the
synchronous cancel-work in the CPU_POST_DEAD phase, where the
cpu_hotplug.lock is not held. See this thread:

http://marc.info/?l=linux-kernel&m=137241212616799&w=2
http://marc.info/?l=linux-pm&m=137242906622537&w=2

But now that I look at commit 2f7021a8 again, I still think we should
revert it and fix the _actual_ root-cause of the bug.

Cpufreq subsystem has enough synchronization to ensure that policy->cpus
always contains online CPUs. And it also has the concept of cancelling
queued work items, *before* that CPU is taken offline.
So, where is the chance that we try to queue work items on offline CPUs?

To answer that question, I was looking at the cpufreq code yesterday
and found something very interesting: the gov_cancel_work() that is
invoked before a CPU goes offline, can actually end up effectively
*NOT* cancelling the queued work item!

The reason is, the per-cpu work items are not just self-queueing (if
that was the case, gov_cancel_work would have been successful without
any doubt), but instead, they can also queue work items on *other* CPUs!

Example from ondemand governor's per-cpu work item:

static void od_dbs_timer(struct work_struct *work)
{
  ...
  bool modify_all = true;
  ...
  gov_queue_work(dbs_data, dbs_info->cdbs.cur_policy, delay, modify_all);
}

So, every per-cpu work item can re-queue the work item on *many other*
CPUs, and not just itself!

So that leads to a race which makes gov_cancel_work() ineffective.
The call to cancel_delayed_work_sync() will cancel all pending work items
on say CPU 3 (which is going down), but immediately after that, say CPU4's
work item fires and queues the work item on CPU4 as well as CPU3. Thus,
gov_cancel_work() _effectively_ didn't do anything useful.

But this still doesn't immediately explain how we can end up trying to
queue work items on offline CPUs (since policy->cpus is supposed to always
contain online cpus only, and this does look correct in the code as well,
at a first glance). But I just wanted to share this finding, in case it
helps us find out the real root-cause.

Also, you might perhaps want to try the (untested) patch shown below, and
see if it resolves your problem. It basically makes work-items requeue
themselves on only their respective CPUs and not others, so that
gov_cancel_work succeeds in its mission. However, I guess the patch is
wrong from a cpufreq perspective, in case cpufreq really depends on the
"requeue-work-on-everybody" model.

Regards,
Srivatsa S. Bhat

------------------------------------------------------------------------

 drivers/cpufreq/cpufreq_conservative.c |    2 +-
 drivers/cpufreq/cpufreq_governor.c     |    2 --
 drivers/cpufreq/cpufreq_ondemand.c     |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 0ceb2ef..bbfc1dd 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -120,7 +120,7 @@ static void cs_dbs_timer(struct work_struct *work)
 	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	int delay = delay_for_sampling_rate(cs_tuners->sampling_rate);
-	bool modify_all = true;
+	bool modify_all = false;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
 	if (!need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 4645876..ec4baeb 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -137,10 +137,8 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
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
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 93eb5cb..241ebc0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -230,7 +230,7 @@ static void od_dbs_timer(struct work_struct *work)
 	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	int delay = 0, sample_type = core_dbs_info->sample_type;
-	bool modify_all = true;
+	bool modify_all = false;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
 	if (!need_load_eval(&core_dbs_info->cdbs, od_tuners->sampling_rate)) {




