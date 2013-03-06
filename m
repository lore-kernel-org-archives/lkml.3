Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3CFOPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:15:48 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:58102 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756919Ab3CFOPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:15:46 -0500
Message-ID: <51374F8D.9040300@semaphore.gr>
Date: Wed, 06 Mar 2013 16:15:41 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 linux-next] cpufreq: conservative: Use an inline function
 to evaluate freq_target
References: <51366C77.3080309@semaphore.gr> <CAKohpokdG2vd5Cp4Lmcnc5ZrLsa-_4Kcy-DvLjG--6SMVsGZkg@mail.gmail.com>
In-Reply-To: <CAKohpokdG2vd5Cp4Lmcnc5ZrLsa-_4Kcy-DvLjG--6SMVsGZkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 03:23 PM, Viresh Kumar wrote:
> Atleast my poor mind can't make out how. To me it looks like broken now.
> 
> 
> When can we enter this "if" block, probably only in case where max freq is
> less than 100 KHz (And because we have freq unit in KHz in cpufreq, its exact
> value is less than 100). Lets say its 90.
> 
> So, we will get into your "if" block now and would set freq_target to 90 - 5000.
> 
> So its broken, isn't it.
> 
> Rest is fine.
> 

Of course your are right. I'm sorry for this confusion.

Below v2 of this patch.

Thanks,
Stratos

--------------------------------8<------------------------
Use an inline function to evaluate freq_target to avoid duplicate code.

Also, define a macro for the default frequency step.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_conservative.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 08be431..3fb921d 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -28,6 +28,7 @@
 /* Conservative governor macros */
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_FREQUENCY_DOWN_THRESHOLD		(20)
+#define DEF_FREQUENCY_STEP			(5)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(10)
 
@@ -39,9 +40,20 @@ static struct cs_dbs_tuners cs_tuners = {
 	.down_threshold = DEF_FREQUENCY_DOWN_THRESHOLD,
 	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
 	.ignore_nice = 0,
-	.freq_step = 5,
+	.freq_step = DEF_FREQUENCY_STEP,
 };
 
+static inline unsigned int get_freq_target(struct cpufreq_policy *policy)
+{
+	unsigned int freq_target = (cs_tuners.freq_step * policy->max) / 100;
+
+	/* max freq cannot be less than 100. But who knows... */
+	if (unlikely(freq_target == 0))
+		freq_target = DEF_FREQUENCY_STEP;
+
+	return freq_target;
+}
+
 /*
  * Every sampling_rate, we check, if current idle time is less than 20%
  * (default), then we try to increase frequency. Every sampling_rate *
@@ -55,7 +67,6 @@ static void cs_check_cpu(int cpu, unsigned int load)
 {
 	struct cs_cpu_dbs_info_s *dbs_info = &per_cpu(cs_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
-	unsigned int freq_target;
 
 	/*
 	 * break out if we 'cannot' reduce the speed as the user might
@@ -72,13 +83,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
 		if (dbs_info->requested_freq == policy->max)
 			return;
 
-		freq_target = (cs_tuners.freq_step * policy->max) / 100;
-
-		/* max freq cannot be less than 100. But who knows.... */
-		if (unlikely(freq_target == 0))
-			freq_target = 5;
-
-		dbs_info->requested_freq += freq_target;
+		dbs_info->requested_freq += get_freq_target(policy);
 		if (dbs_info->requested_freq > policy->max)
 			dbs_info->requested_freq = policy->max;
 
@@ -94,9 +99,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
 
 	/* Check for frequency decrease */
 	if (load < cs_tuners.down_threshold) {
-		freq_target = (cs_tuners.freq_step * policy->max) / 100;
-
-		dbs_info->requested_freq -= freq_target;
+		dbs_info->requested_freq -= get_freq_target(policy);
 		if (dbs_info->requested_freq < policy->min)
 			dbs_info->requested_freq = policy->min;
 
-- 
1.8.1.4

 
