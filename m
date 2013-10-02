Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3JBKTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:19:11 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47710 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3JBKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:19:09 -0400
Message-ID: <524BF210.4070301@linux.vnet.ibm.com>
Date: Wed, 02 Oct 2013 15:44:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
References: <20130925175055.GA25914@redhat.com> <20130928144720.GL15690@laptop.programming.kicks-ass.net> <20130928163104.GA23352@redhat.com> <7632387.20FXkuCITr@vostro.rjw.lan> <524B0233.8070203@linux.vnet.ibm.com> <20131001173615.GW3657@laptop.programming.kicks-ass.net> <524B111F.9060003@linux.vnet.ibm.com>
In-Reply-To: <524B111F.9060003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100210-1396-0000-0000-000003A3BBC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:44 PM, Srivatsa S. Bhat wrote:
> On 10/01/2013 11:06 PM, Peter Zijlstra wrote:
>> On Tue, Oct 01, 2013 at 10:41:15PM +0530, Srivatsa S. Bhat wrote:
>>> However, as Oleg said, its definitely worth considering whether this proposed
>>> change in semantics is going to hurt us in the future. CPU_POST_DEAD has certainly
>>> proved to be very useful in certain challenging situations (commit 1aee40ac9c
>>> explains one such example), so IMHO we should be very careful not to undermine
>>> its utility.
>>
>> Urgh.. crazy things. I've always understood POST_DEAD to mean 'will be
>> called at some time after the unplug' with no further guarantees. And my
>> patch preserves that.
>>
>> Its not at all clear to me why cpufreq needs more; 1aee40ac9c certainly
>> doesn't explain it.
>>
> 
> Sorry if I was unclear - I didn't mean to say that cpufreq needs more guarantees
> than that. I was just saying that the cpufreq code would need certain additional
> changes/restructuring to accommodate the change in the semantics brought about
> by this patch. IOW, it won't work as it is, but it can certainly be fixed.
> 


Ok, so I thought a bit more about the changes you are proposing, and I agree
that they would be beneficial in the long run, especially given that it can
eventually lead to a more stream-lined hotplug process where different CPUs
can be hotplugged independently without waiting on each other, like you
mentioned in your other mail. So I'm fine with the new POST_DEAD guarantees
you are proposing - that they are run after unplug, and will be completed
before UP_PREPARE of the same CPU. And its also very convenient that we need
to fix only cpufreq to accommodate this change.

So below is a quick untested patch that modifies the cpufreq hotplug
callbacks appropriately. With this, cpufreq should be able to handle the
POST_DEAD changes, irrespective of whether we do that in the regular path
or in the suspend/resume path. (Because, I've restructured it in such a way
that the races that I had mentioned earlier are totally avoided. That is,
the POST_DEAD handler now performs only the bare-minimal final cleanup, which
doesn't race with or depend on anything else).



diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 04548f7..0a33c1a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1165,7 +1165,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 					bool frozen)
 {
 	unsigned int cpu = dev->id, cpus;
-	int new_cpu, ret;
+	int new_cpu, ret = 0;
 	unsigned long flags;
 	struct cpufreq_policy *policy;
 
@@ -1200,9 +1200,10 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 			policy->governor->name, CPUFREQ_NAME_LEN);
 #endif
 
-	lock_policy_rwsem_read(cpu);
+	lock_policy_rwsem_write(cpu);
 	cpus = cpumask_weight(policy->cpus);
-	unlock_policy_rwsem_read(cpu);
+	cpumask_clear_cpu(cpu, policy->cpus);
+	unlock_policy_rwsem_write(cpu);
 
 	if (cpu != policy->cpu) {
 		if (!frozen)
@@ -1220,7 +1221,23 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		}
 	}
 
-	return 0;
+	/* If no target, nothing more to do */
+	if (!cpufreq_driver->target)
+		return 0;
+
+	/* If cpu is last user of policy, cleanup the policy governor */
+	if (cpus == 1) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
+		if (ret)
+			pr_err("%s: Failed to exit governor\n",	__func__);
+	} else {
+		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
+				(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
+			pr_err("%s: Failed to start governor\n", __func__);
+		}
+	}
+
+	return ret;
 }
 
 static int __cpufreq_remove_dev_finish(struct device *dev,
@@ -1243,25 +1260,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		return -EINVAL;
 	}
 
-	WARN_ON(lock_policy_rwsem_write(cpu));
+	WARN_ON(lock_policy_rwsem_read(cpu));
 	cpus = cpumask_weight(policy->cpus);
-
-	if (cpus > 1)
-		cpumask_clear_cpu(cpu, policy->cpus);
-	unlock_policy_rwsem_write(cpu);
+	unlock_policy_rwsem_read(cpu);
 
 	/* If cpu is last user of policy, free policy */
-	if (cpus == 1) {
-		if (cpufreq_driver->target) {
-			ret = __cpufreq_governor(policy,
-					CPUFREQ_GOV_POLICY_EXIT);
-			if (ret) {
-				pr_err("%s: Failed to exit governor\n",
-						__func__);
-				return ret;
-			}
-		}
-
+	if (cpus == 0) {
 		if (!frozen) {
 			lock_policy_rwsem_read(cpu);
 			kobj = &policy->kobj;
@@ -1294,15 +1298,6 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 
 		if (!frozen)
 			cpufreq_policy_free(policy);
-	} else {
-		if (cpufreq_driver->target) {
-			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
-					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
-				pr_err("%s: Failed to start governor\n",
-						__func__);
-				return ret;
-			}
-		}
 	}
 
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;



Regards,
Srivatsa S. Bhat

