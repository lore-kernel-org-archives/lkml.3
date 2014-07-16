Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbaGPIaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:30:08 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55738 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374AbaGPIaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:30:01 -0400
MIME-Version: 1.0
In-Reply-To: <53C5C738.5040705@codeaurora.org>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<53C5C738.5040705@codeaurora.org>
Date: Wed, 16 Jul 2014 14:00:00 +0530
Message-ID: <CAKohpomt34NcMH=H5L_fhf-6R6p27_h=aCNcpT6T12u35d=Z+w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 05:58, Saravana Kannan <skannan@codeaurora.org> wrote:
>> +       if (!cpus && cpufreq_driver->stop_cpu &&
>> cpufreq_driver->setpolicy) {
>> +               cpufreq_driver->stop_cpu(policy);
>> +       }
>>
>
> Viresh, I tried your suggestion (and my initial thought too) to combine this
> as an if/else with the previous if. But the indentation got nasty and made
> it hard to read. I'm sure the compiler will optimize it. So, I would prefer
> to leave it this way.

Okay, I gave that comment again :)

Try this:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f72b2b7..092a0ba 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -991,8 +991,10 @@ static int cpufreq_change_policy_cpus(struct
cpufreq_policy *policy,
                                        CPUFREQ_UPDATE_POLICY_CPU, policy);
        }

-       cpus = !cpumask_empty(policy->cpus);
-       if (has_target() && cpus) {
+       if (!cpumask_empty(policy->cpus)) {
+               if (!has_target())
+                       goto unlock;
+
                ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
                if (!ret)
                        ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
@@ -1001,9 +1003,7 @@ static int cpufreq_change_policy_cpus(struct
cpufreq_policy *policy,
                        pr_err("%s: Failed to start governor\n", __func__);
                        goto unlock;
                }
-       }
-
-       if (!cpus && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
+       } else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
                cpufreq_driver->stop_cpu(policy);
        }
