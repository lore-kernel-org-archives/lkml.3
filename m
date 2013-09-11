Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3IKKZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:25:55 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58063 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3IKKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:25:52 -0400
Message-ID: <52304439.3030301@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 15:51:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>
In-Reply-To: <2521560.SfeNbV74nj@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091110-9264-0000-0000-000004824D5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
>> On 09/09/2013 05:14 PM, Rafael J. Wysocki wrote:
>>> On Monday, September 09, 2013 03:29:06 PM Stephen Warren wrote:
>>>> On 09/09/2013 02:24 PM, Rafael J. Wysocki wrote:
>>>>> On Monday, September 09, 2013 02:01:32 PM Stephen Warren wrote:
>>>>>> On 09/09/2013 02:01 PM, Rafael J. Wysocki wrote:
>>>>>>> On Monday, September 09, 2013 01:22:23 PM Stephen Warren wrote:
>>>>>>>> Viresh,
>>>>>>>>
>>>>>>>> I'm seeing the crash below when suspending my system for the second time.
>>>>>>>>
>>>>>>>> I can avoid this with the following patch, which adds a check which
>>>>>>>> already exists in all-but-one other places that the same lookup is made:
>>>>>>>
>>>>>>> Which kernel did you test?
>>>>>>
>>>>>> next-20130909.
>>>>>
>>>>> Is it reproducible with the current mainline?
>>>>
>>>> This does not affect v3.11, but does affect current HEAD; 300893b "Merge
>>>> tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs".
>>>
>>> What system does it break on?
>>
>> A dual-core ARM system (NVIDIA Tegra20 SoC, Harmony board).
>>
>>> Any chance to bisect cpufreq changes between 3.11 and the current HEAD?
>>
>> Sure, it's due to 5302c3f "cpufreq: Perform light-weight init/teardown
>> during suspend/resume".
> 
> Thanks!
> 
> Srivatsa, any chance to look into this?
>

Sure, Rafael. Thanks for CC'ing me.

Stephen, I went through the code and I think I found out what is going wrong.
Can you please try the following patch?

Regards,
Srivatsa S. Bhat

----------------------------------------------------------------------------


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Fix crash in cpufreq-stats during suspend/resume

Stephen Warren reported that the cpufreq-stats code hits a NULL pointer
dereference during the second attempt to suspend a system. He also
pin-pointed the problem to commit 5302c3f "cpufreq: Perform light-weight
init/teardown during suspend/resume".

That commit actually ensured that the cpufreq-stats table and the
cpufreq-stats sysfs entries are *not* torn down (ie., not freed) during
suspend/resume, which makes it all the more surprising. However, it turns
out that the root-cause is not that we access an already freed memory, but
that the reference to the allocated memory gets moved around and we lose
track of that during resume, leading to the reported crash in a subsequent
suspend attempt.

In the suspend path, during CPU offline, the value of policy->cpu is updated
by choosing one of the surviving CPUs in that policy, as long as there is
atleast one CPU in that policy. And cpufreq_stats_update_policy_cpu() is
invoked to update the reference to the stats structure by assigning it to
the new CPU. However, in the resume path, during CPU online, we end up
assigning a fresh CPU as the policy->cpu, without letting cpufreq-stats
know about this. Thus the reference to the stats structure remains
(incorrectly) associated with the old CPU. So, in a subsequent suspend attempt,
during CPU offline, we end up accessing an incorrect location to get the
stats structure, which eventually leads to the NULL pointer dereference.

Fix this by letting cpufreq-stats know about the update of the policy->cpu
during CPU online in the resume path. (Also, move the update_policy_cpu()
function higher up in the file, so that __cpufreq_add_dev() can invoke
it).

Reported-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5a64f66..62bdb95 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -947,6 +947,18 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 	kfree(policy);
 }
 
+static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
+{
+	policy->last_cpu = policy->cpu;
+	policy->cpu = cpu;
+
+#ifdef CONFIG_CPU_FREQ_TABLE
+	cpufreq_frequency_table_update_policy_cpu(policy);
+#endif
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_UPDATE_POLICY_CPU, policy);
+}
+
 static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 			     bool frozen)
 {
@@ -1000,7 +1012,18 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	if (!policy)
 		goto nomem_out;
 
-	policy->cpu = cpu;
+
+	/*
+	 * In the resume path, since we restore a saved policy, the assignment
+	 * to policy->cpu is like an update of the existing policy, rather than
+	 * the creation of a brand new one. So we need to perform this update
+	 * by invoking update_policy_cpu().
+	 */
+	if (frozen && cpu != policy->cpu)
+		update_policy_cpu(policy, cpu);
+	else
+		policy->cpu = cpu;
+
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
@@ -1092,18 +1115,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	return __cpufreq_add_dev(dev, sif, false);
 }
 
-static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
-{
-	policy->last_cpu = policy->cpu;
-	policy->cpu = cpu;
-
-#ifdef CONFIG_CPU_FREQ_TABLE
-	cpufreq_frequency_table_update_policy_cpu(policy);
-#endif
-	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
-			CPUFREQ_UPDATE_POLICY_CPU, policy);
-}
-
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 					   unsigned int old_cpu, bool frozen)
 {


