Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3BKEjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:39:51 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46822 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3BKEju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=Rk-P_yhvu8WHmpy7UcYqhg4-Y0ragqNMBXgJAB_w4mQ@mail.gmail.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<b16436f3b3eba648500a287d552efbbf48bcc9bb.1359976493.git.viresh.kumar@linaro.org>
	<51180DA7.8040203@gmail.com>
	<CAKohpo=Rk-P_yhvu8WHmpy7UcYqhg4-Y0ragqNMBXgJAB_w4mQ@mail.gmail.com>
Date: Mon, 11 Feb 2013 10:09:49 +0530
Message-ID: <CAKohponaBym8mw-s4qecq-QxoZfmDy9r4hsRids_7hVGBwTz7Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] cpufreq: governor: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 09:46, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 11 February 2013 02:44, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
>> dbs_data->tuners is never freed, which means there is a memory leak
>> across CPUFREQ_GOV_POLICY_INIT and CPUFREQ_GOV_POLICY_EXIT events.
>>
>> The same goes for the ondemand governor.
>
> Thanks for pointing out. Would be fixed in next version.

Adding following to the original patch:

diff --git a/drivers/cpufreq/cpufreq_conservative.c
b/drivers/cpufreq/cpufreq_conservative.c
index 6b13f9f..5d03577 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -329,6 +329,11 @@ static int cs_init(struct dbs_data *dbs_data)
        return 0;
 }

+static void cs_exit(struct dbs_data *dbs_data)
+{
+       kfree(dbs_data->tuners);
+}
+
 define_get_cpu_dbs_routines(cs_cpu_dbs_info);

 static struct notifier_block cs_cpufreq_notifier_block = {
@@ -348,6 +353,7 @@ static struct common_dbs_data cs_dbs_cdata = {
        .gov_check_cpu = cs_check_cpu,
        .gov_ops = &cs_ops,
        .init = cs_init,
+       .exit = cs_exit,
 };

 static int cs_cpufreq_governor_dbs(struct cpufreq_policy *policy,
diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 925f5b3..7722505 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -255,6 +255,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
                                        latency * LATENCY_MULTIPLIER));
                return 0;
        case CPUFREQ_GOV_POLICY_EXIT:
+               cdata->exit(dbs_data);
                kfree(dbs_data);
                policy->governor_data = NULL;
                return 0;
diff --git a/drivers/cpufreq/cpufreq_governor.h
b/drivers/cpufreq/cpufreq_governor.h
index 8bd8df6..6301790 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -139,6 +139,7 @@ struct common_dbs_data {
        void (*gov_dbs_timer)(struct work_struct *work);
        void (*gov_check_cpu)(int cpu, unsigned int load);
        int (*init)(struct dbs_data *dbs_data);
+       void (*exit)(struct dbs_data *dbs_data);

        /* Governor specific ops, see below */
        void *gov_ops;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c
b/drivers/cpufreq/cpufreq_ondemand.c
index 5eda540..f2539e0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -525,6 +525,11 @@ static int od_init(struct dbs_data *dbs_data)
        return 0;
 }

+static void od_exit(struct dbs_data *dbs_data)
+{
+       kfree(dbs_data->tuners);
+}
+
 define_get_cpu_dbs_routines(od_cpu_dbs_info);

 static struct od_ops od_ops = {
@@ -542,6 +547,7 @@ static struct common_dbs_data od_dbs_cdata = {
        .gov_check_cpu = od_check_cpu,
        .gov_ops = &od_ops,
        .init = od_init,
+       .exit = od_exit,
 };

 static int od_cpufreq_governor_dbs(struct cpufreq_policy *policy,
