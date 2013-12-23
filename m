Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3LWPpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 10:45:51 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41147 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3LWPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 10:45:49 -0500
Message-ID: <52B85AA4.6070609@linaro.org>
Date: Mon, 23 Dec 2013 21:15:40 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed
 to come back after resume
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>	<1651441.C2UQleWVoy@vostro.rjw.lan> <871u14i00j.fsf@nemi.mork.no>	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>	<87d2kokqdl.fsf@nemi.mork.no> <52B7EC81.6060202@linaro.org>	<877gavgbuv.fsf@nemi.mork.no>	<CAKohpo=0HRihdTiQLk+mKiarUdXOPO3n7GCJ9CUoi=4xJ_AYcg@mail.gmail.com>	<87txdzx2bb.fsf@nemi.mork.no>	<CAKohpon7nn5cpJVNZzzXxbYUkACEsFgyPR20kSSMMsShw0=HVA@mail.gmail.com> <87pponx07s.fsf@nemi.mork.no>
In-Reply-To: <87pponx07s.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 December 2013 05:12 PM, Bjørn Mork wrote:
> That would be great.  This could be just me.  I am quite good at
> breaking stuff.

No its not you. While we tried to make sure everything is preserved,
few special things still stayed out :)

And they are solved with this patch, log should be good enough to give
proper reasoning:

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 23 Dec 2013 20:51:54 +0530
Subject: [PATCH] cpufreq: preserve user_policy across suspend/resume

In __cpufreq_add_dev() we are reinitializing user_policy with default values and
hence would loose values of user_policy.{min|max|policy|governor} fields.

Preserve them by not overriding these for suspend/resume.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 16d7b4a..c5c3dac 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -839,9 +839,6 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)

 	/* set default policy */
 	ret = cpufreq_set_policy(policy, &new_policy);
-	policy->user_policy.policy = policy->policy;
-	policy->user_policy.governor = policy->governor;
-
 	if (ret) {
 		pr_debug("setting policy failed\n");
 		if (cpufreq_driver->exit)
@@ -1069,8 +1066,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);

-	policy->user_policy.min = policy->min;
-	policy->user_policy.max = policy->max;
+	if (!frozen) {
+		policy->user_policy.min = policy->min;
+		policy->user_policy.max = policy->max;
+	}

 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
@@ -1101,6 +1100,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,

 	cpufreq_init_policy(policy);

+	if (!frozen) {
+		policy->user_policy.policy = policy->policy;
+		policy->user_policy.governor = policy->governor;
+	}
+
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	up_read(&cpufreq_rwsem);


