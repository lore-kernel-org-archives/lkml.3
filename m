Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaFGMgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 08:36:41 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53496 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFGMgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 08:36:38 -0400
Message-ID: <539306FE.9090200@linux.vnet.ibm.com>
Date: Sat, 07 Jun 2014 18:05:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <20140607095559.GA23815@amd.pavel.ucw.cz>
In-Reply-To: <20140607095559.GA23815@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060712-1618-0000-0000-0000005D1E45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 03:25 PM, Pavel Machek wrote:
> Hi!
> 
>> We just want to avoid the stupidity of dropping down the frequency to a minimum
>> and then enduring a needless (and long) delay before ramping it up back again.
>> So, let us simply carry forward the previous load - that is, let us just pretend
>> that the 'load' for the current time-window is the same as the load for the
>> previous window. That way, the frequency and voltage will continue to be set
>> to whatever values they were set at previously. This means that bursty workloads
>> will get a chance to influence the CPU frequency at which they wake up from
>> cpu-idle, based on their past execution history. Thus, they might be able to
>> avoid suffering from slow wakeups and long response-times.
>>
>> [ The right way to solve this problem is to teach the CPU frequency governors
>> to track load on a per-task basis, not a per-CPU basis, and set the appropriate
>> frequency on whichever CPU the task executes. But that involves redesigning
>> the cpufreq subsystem, so this patch should make the situation bearable until
>> then. ]
> 
> Are you sure? For example "./configure" load consists of a lot of
> short-lived tasks. Per-task basis may not be option for that.
> 

True, but then there is no guarantee that all the tasks spawned by ./configure
run on a single CPU. So per-CPU tracking may or may not help, depending on the
scheduling pattern.

For very-short-lived tasks, per-task tracking won't give much benefit, but it
will for medium to long-lived tasks. So I guess we might need some sort of a
combination of both methods of tracking, to handle all the scenarios well.

>> A rudimentary and somewhat approximately latency-sensitive workload such as
>> sleeping-ebizzy itself showed a consistent, noticeable performance improvement
>> with this patch. Hence, workloads that are truly latency-sensitive will benefit
>> quite a bit from this change. Moreover, this is an overall win-win since this
>> patch does not hurt power-savings at all (because, this patch does not reduce
>> the idle time or idle residency; and the high frequency of the CPU when it goes
>> to cpu-idle does not affect/hurt the power-savings of deep idle
>> states).
> 
> Are you sure about win-win?
> 
> AFAICT, your patch helps
> 
> ##########.........#########.........###########...........##########............
> 
> case (not surprising, that's why you wrote the patch :-), but what happens in
> 
> ##########.........#.................#.....................#.....................
> 
> case? (That is idle system, with some tasks taking very small ammounts
> of CPU).
> 
> AFAICT, it will remember the (high) prev_load over the idle period,
> and use too high frequency for mostly idle system, no?
> 

Wow, great catch! I think the problem is that the prev-load is getting copied
over too many times; we need to restrict it to just one-copy and leave the
next sampling interval to the cpufreq governor's regular ramp-up, even if it
was an idle interval.

Below is an untested patch that implements that logic (and it also fixes the
64 bit division problem reported by Fengguang's build robot in the v2 of the
patch).

I'll test this patch and then send out the v3 later today. Please let me
know your thoughts!

Regards,
Srivatsa S. Bhat

---------------------------------------------------------------------------

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index e1c6433..3856a6b 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -36,14 +36,29 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	struct cpufreq_policy *policy;
+	unsigned int sampling_rate;
 	unsigned int max_load = 0;
 	unsigned int ignore_nice;
 	unsigned int j;
 
-	if (dbs_data->cdata->governor == GOV_ONDEMAND)
+	if (dbs_data->cdata->governor == GOV_ONDEMAND) {
+		struct od_cpu_dbs_info_s *od_dbs_info =
+				dbs_data->cdata->get_cpu_dbs_info_s(cpu);
+
+		/*
+		 * Sometimes, the ondemand governor uses an additional
+		 * multiplier to give long delays. So apply this multiplier to
+		 * the 'sampling_rate', so as to keep the wake-up-from-idle
+		 * detection logic a bit conservative.
+		 */
+		sampling_rate = od_tuners->sampling_rate;
+		sampling_rate *= od_dbs_info->rate_mult;
+
 		ignore_nice = od_tuners->ignore_nice_load;
-	else
+	} else {
+		sampling_rate = cs_tuners->sampling_rate;
 		ignore_nice = cs_tuners->ignore_nice_load;
+	}
 
 	policy = cdbs->cur_policy;
 
@@ -96,7 +111,36 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
-		load = 100 * (wall_time - idle_time) / wall_time;
+		/*
+		 * If the CPU had gone completely idle, and a task just woke up
+		 * on this CPU now, it would be unfair to calculate 'load' the
+		 * usual way for this elapsed time-window, because it will show
+		 * near-zero load, irrespective of how CPU intensive the new
+		 * task is. This is undesirable for latency-sensitive bursty
+		 * workloads.
+		 *
+		 * To avoid this, we reuse the 'load' from the previous
+		 * time-window and give this task a chance to start with a
+		 * reasonably high CPU frequency. (However, we shouldn't over-do
+		 * this copy, lest we get stuck at a high load (high frequency)
+		 * for too long, even when the current system load has actually
+		 * dropped down. So we perform the copy only once, upon the
+		 * first wake-up from idle.)
+		 *
+		 * Detecting this situation is easy: the governor's deferrable
+		 * timer would not have fired during CPU-idle periods. Hence
+		 * an unusually large 'wall_time' (as compared to the sampling
+		 * rate) indicates this scenario.
+		 */
+		if (unlikely(wall_time > (2 * sampling_rate)) &&
+						j_cdbs->copy_prev_load) {
+			load = j_cdbs->prev_load;
+			j_cdbs->copy_prev_load = false;
+		} else {
+			load = 100 * (wall_time - idle_time) / wall_time;
+			j_cdbs->prev_load = load;
+			j_cdbs->copy_prev_load = true;
+		}
 
 		if (load > max_load)
 			max_load = load;
@@ -318,11 +362,19 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_common_info *j_cdbs =
 				dbs_data->cdata->get_cpu_cdbs(j);
+			unsigned int prev_load;
 
 			j_cdbs->cpu = j;
 			j_cdbs->cur_policy = policy;
 			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
 					       &j_cdbs->prev_cpu_wall, io_busy);
+
+			prev_load = (unsigned int)
+				(j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
+			j_cdbs->prev_load = 100 * prev_load /
+					(unsigned int) j_cdbs->prev_cpu_wall;
+			j_cdbs->copy_prev_load = true;
+
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
 					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index bfb9ae1..c2a5b7e 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -134,6 +134,12 @@ struct cpu_dbs_common_info {
 	u64 prev_cpu_idle;
 	u64 prev_cpu_wall;
 	u64 prev_cpu_nice;
+	unsigned int prev_load;
+	/*
+	 * Flag to ensure that we copy the previous load only once, upon the
+	 * first wake-up from idle.
+	 */
+	bool copy_prev_load;
 	struct cpufreq_policy *cur_policy;
 	struct delayed_work work;
 	/*

