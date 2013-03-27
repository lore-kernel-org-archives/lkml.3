Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3C0E32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:29:28 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46623 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3C0E30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130326194832.GB24945@jshin-Toonie>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
	<CAKohponTZ29BX6CrUvFMy9RXV==0wRFu4C-W1xd6t1RmLASTvQ@mail.gmail.com>
	<2565053.YP0dCLmaW9@vostro.rjw.lan>
	<20130326152059.GA1698@jshin-Toonie>
	<CAKohpons4Tr8F2RuRGCxbOFmJaK9YbAafV-3v6=cijRupe2hUA@mail.gmail.com>
	<20130326194832.GB24945@jshin-Toonie>
Date: Wed, 27 Mar 2013 09:59:25 +0530
Message-ID: <CAKohpomaTLPZjxcTGKo2mmcqgPvqQVsj1778X1u2rbb3wV+phA@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 01:18, Jacob Shin <jacob.shin@amd.com> wrote:
> On Wed, Mar 27, 2013 at 01:02:15AM +0530, Viresh Kumar wrote:
>> +struct dbs_data *gdbs_data;
>> +
>
> Hmm .. I don't think this works for both ondemand and conservative
> governors running at the same time .

Yes, this should fix it (untested for now, i will provide a complete fix
today):

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index f29feb4..54ca5fc 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -29,9 +29,6 @@

 #include "cpufreq_governor.h"

-/* Common data for platforms that don't need governor instance per policy */
-struct dbs_data *gdbs_data;
-
 static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 {
        u64 idle_time;
@@ -233,7 +230,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
        if (have_multiple_policies())
                dbs_data = policy->governor_data;
        else
-               dbs_data = gdbs_data;
+               dbs_data = cdata->gdbs_data;

        WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));

@@ -289,7 +286,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
                }

                if (!have_multiple_policies())
-                       gdbs_data = dbs_data;
+                       cdata->gdbs_data = dbs_data;

                return 0;
        case CPUFREQ_GOV_POLICY_EXIT:
@@ -307,7 +304,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,

                        cdata->exit(dbs_data);
                        kfree(dbs_data);
-                       gdbs_data = NULL;
+                       cdata->gdbs_data = NULL;
                }

                policy->governor_data = NULL;
diff --git a/drivers/cpufreq/cpufreq_governor.h
b/drivers/cpufreq/cpufreq_governor.h
index 1f7de13..cc4a189 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -133,6 +133,9 @@ struct common_dbs_data {
        int governor;
        struct attribute_group *attr_group;

+       /* Common data for platforms that don't set have_multiple_policies */
+       struct dbs_data *gdbs_data;
+
        struct cpu_dbs_common_info *(*get_cpu_cdbs)(int cpu);
        void *(*get_cpu_dbs_info_s)(int cpu);
        void (*gov_dbs_timer)(struct work_struct *work);
