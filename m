Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3BAFnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 00:43:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36855 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3BAFnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 00:43:09 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        fabio.baltieri@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: governors: Reset tunables only for cpufreq_unregister_governor()
Date: Fri,  1 Feb 2013 11:12:58 +0530
Message-Id: <d9de945975ad2064693275335b4022c8efd013e3.1359697315.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 01 Feb 2013 05:43:05.0777 (UTC) FILETIME=[020E8A10:01CE003F]
X-MC-Unique: 113020105430700201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r115hEbW024187

Currently, whenever governor->governor() is called for CPUFRREQ_GOV_START event
we reset few tunables of governor. Which isn't correct, as this routine is
called for every cpu hot-[un]plugging event. We should actually be resetting
these only when the governor module is removed and re-installed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c          |  4 ++++
 drivers/cpufreq/cpufreq_governor.c | 24 ++++++++++++++++--------
 include/linux/cpufreq.h            |  1 +
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 8d521422..9656420 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1561,6 +1561,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 						policy->cpu, event);
 	ret = policy->governor->governor(policy, event);
 
+	if (!policy->governor->initialized && (event == CPUFREQ_GOV_START))
+		policy->governor->initialized = 1;
+
 	/* we keep one module reference alive for
 			each CPU governed by this CPU */
 	if ((event != CPUFREQ_GOV_START) || ret)
@@ -1584,6 +1587,7 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
 
 	mutex_lock(&cpufreq_governor_mutex);
 
+	governor->initialized = 0;
 	err = -EBUSY;
 	if (__find_governor(governor->name) == NULL) {
 		err = 0;
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 7aaa9b1..79795c4 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -254,11 +254,6 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 			return rc;
 		}
 
-		/* policy latency is in nS. Convert it to uS first */
-		latency = policy->cpuinfo.transition_latency / 1000;
-		if (latency == 0)
-			latency = 1;
-
 		/*
 		 * conservative does not implement micro like ondemand
 		 * governor, thus we are bound to jiffes/HZ
@@ -270,20 +265,33 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 			cpufreq_register_notifier(cs_ops->notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
 
-			dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
-				jiffies_to_usecs(10);
+			if (!policy->governor->initialized)
+				dbs_data->min_sampling_rate =
+					MIN_SAMPLING_RATE_RATIO *
+					jiffies_to_usecs(10);
 		} else {
 			od_dbs_info->rate_mult = 1;
 			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
 			od_ops->powersave_bias_init_cpu(cpu);
-			od_tuners->io_is_busy = od_ops->io_busy();
+
+			if (!policy->governor->initialized)
+				od_tuners->io_is_busy = od_ops->io_busy();
 		}
 
+		if (policy->governor->initialized)
+			goto unlock;
+
+		/* policy latency is in nS. Convert it to uS first */
+		latency = policy->cpuinfo.transition_latency / 1000;
+		if (latency == 0)
+			latency = 1;
+
 		/* Bring kernel and HW constraints together */
 		dbs_data->min_sampling_rate = max(dbs_data->min_sampling_rate,
 				MIN_LATENCY_MULTIPLIER * latency);
 		*sampling_rate = max(dbs_data->min_sampling_rate, latency *
 				LATENCY_MULTIPLIER);
+unlock:
 		mutex_unlock(&dbs_data->mutex);
 
 		/* Initiate timer time stamp */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index feb360c..6bf3f2d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -183,6 +183,7 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
 
 struct cpufreq_governor {
 	char	name[CPUFREQ_NAME_LEN];
+	int	initialized;
 	int	(*governor)	(struct cpufreq_policy *policy,
 				 unsigned int event);
 	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
-- 
1.7.12.rc2.18.g61b472e


