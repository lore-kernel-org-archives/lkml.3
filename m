Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaFCJeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:34:03 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56551 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaFCJeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:34:00 -0400
Message-ID: <538D9631.9090500@linux.vnet.ibm.com>
Date: Tue, 03 Jun 2014 15:02:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com>
In-Reply-To: <CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060309-8256-0000-0000-00000D84EB75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 01:48 PM, Viresh Kumar wrote:
> On 27 May 2014 02:23, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
> Looks fine, some nits..
> 
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
>> +                  unsigned int sampling_rate)
> 
> We don't need to pass a new argument, we can get all the information from
> dbs_data alone. Its already done for multiple routines. Let me know if you
> find it difficult to figure out..
> 

Sure, that would be a good improvement. Does something like the patch below
look good? I have only compile-tested it. I'll send out the patch with changelog
once I finish testing it.

Thank you!

Regards,
Srivatsa S. Bhat

----------------------------------------------------------------------------

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index e1c6433..3e8588f 100644
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
+		struct od_cpu_dbs_info_s *od_dbs_info;
+
+		/*
+		 * Sometimes, the ondemand governor uses an additional
+		 * multiplier to give long delays. So apply this multiplier to
+		 * the 'sampling_rate', so as to keep the wake-up-from-idle
+		 * detection logic a bit conservative.
+		 */
+		sampling_rate = od_tuners->sampling_rate;
+		od_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
+		sampling_rate *= od_dbs_info->rate_mult;
+
 		ignore_nice = od_tuners->ignore_nice_load;
-	else
+	} else {
+		sampling_rate = cs_tuners->sampling_rate;
 		ignore_nice = cs_tuners->ignore_nice_load;
+	}
 
 	policy = cdbs->cur_policy;
 
@@ -96,7 +111,29 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
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
+		 * reasonably high CPU frequency.
+		 *
+		 * Detecting this situation is easy: the governor's deferrable
+		 * timer would not have fired during CPU-idle periods. Hence
+		 * an unusually large 'wall_time' (as compared to the sampling
+		 * rate) indicates this scenario.
+		 */
+		if (unlikely(wall_time > (2 * sampling_rate))) {
+			load = j_cdbs->prev_load;
+		} else {
+			load = 100 * (wall_time - idle_time) / wall_time;
+			j_cdbs->prev_load = load;
+		}
 
 		if (load > max_load)
 			max_load = load;
@@ -323,6 +360,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			j_cdbs->cur_policy = policy;
 			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j,
 					       &j_cdbs->prev_cpu_wall, io_busy);
+			j_cdbs->prev_load = 100 * (j_cdbs->prev_cpu_wall -
+						   j_cdbs->prev_cpu_idle) /
+						   j_cdbs->prev_cpu_wall;
+
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
 					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index bfb9ae1..b56552b 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -134,6 +134,7 @@ struct cpu_dbs_common_info {
 	u64 prev_cpu_idle;
 	u64 prev_cpu_wall;
 	u64 prev_cpu_nice;
+	unsigned int prev_load;
 	struct cpufreq_policy *cur_policy;
 	struct delayed_work work;
 	/*

