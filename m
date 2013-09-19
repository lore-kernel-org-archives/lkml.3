Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3ISSP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:15:29 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55088 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ISSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:15:28 -0400
Message-ID: <523B3E4B.6080003@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 23:41:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <523AF50E.1040502@linux.vnet.ibm.com>
In-Reply-To: <523AF50E.1040502@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091918-8256-0000-0000-0000094BD1DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 06:28 PM, Srivatsa S. Bhat wrote:
> On 09/19/2013 06:25 PM, Linus Walleij wrote:
>> On Thu, Sep 19, 2013 at 2:46 PM, Srivatsa S. Bhat
>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>>>>> I don't really know if this is the right solution at all, so please
>>>>> help me out here... if you want that patch I can send it once
>>>>> I understand this properly.
>>>
>>> IIRC, recent kernels didn't return 0 or any error code when the !policy
>>> condition was matched. So can you check whether this problem occurs with
>>> 3.11 or 3.10 as well?
>>
>> v3.11 works fine.
>>

Ok, now that I got a chance to look at the code and the git logs, I think
I have a clearer idea of what is happening.

Basically commit 474deff74 (cpufreq: remove cpufreq_policy_cpu per-cpu
variable) exposed a hidden issue. Before that commit, the code looked like
this:

static DEFINE_PER_CPU(int, cpufreq_policy_cpu);

[...]

static int lock_policy_rwsem_##mode(int cpu)                            \
{                                                                       \
        int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);              \
        BUG_ON(policy_cpu == -1);                                       \
        down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));            \
                                                                        \
        return 0;                                                       \
}

But there was no code to set the per-cpu values to -1 to begin with. Since
the per-cpu variable was defined as static, it would have been initialized
to zero. Thus, we would never actually hit the BUG_ON() condition, since
policy_cpu didn't turn out to be -1.

(The per-cpu variable was set to -1 only during error in __cpufreq_add_dev
and during cpufreq_remove_dev, both of which are irrelevant to the scenario
we are dealing with here).

So, code ended up accessing and locking CPU 0's rwsemaphore. But how was
its initialization taken care of? The answer is the initcall sequence.
Cpufreq core code initialized itself at the core_initcall stage, and the
sa1100 cpufreq driver initialized itself at the arch_initcall stage, like
Viresh mentioned. And core-initcall comes before arch-initcall. So the
cpufreq core would have finished initializing the per-cpu rwsemaphores,
so that locking/unlocking them wouldn't crash the system or get complaints
from lockdep.

To summarize, I think before commit 474deff74, we were accessing CPU0's
rwsems (perhaps incorrectly) and due to the lacking initialization of the
per-cpu vars, the BUG_ON() would never fire.

To confirm this, you can perhaps try out one commit before 474deff74 and see
if it works for you. Or equivalently, you can apply the following patch
(revert of 474deff74) over mainline and see if it works.

That said, I'm still not sure how to fix the original issue. I'll do some
more digging later.

Regards,
Srivatsa S. Bhat

[The following is an untested plain revert of 474deff74, with a small
correction to account for the movement of update_policy_cpu() function.
If this doesn't work, please try a commit below 474deff74.]


diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 82ecbe3..5164529 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -64,14 +64,15 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
  * - Lock should not be held across
  *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
  */
+static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
 static int lock_policy_rwsem_##mode(int cpu)				\
 {									\
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
-	BUG_ON(!policy);						\
-	down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
+	BUG_ON(policy_cpu == -1);					\
+	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 									\
 	return 0;							\
 }
@@ -82,9 +83,9 @@ lock_policy_rwsem(write, cpu);
 #define unlock_policy_rwsem(mode, cpu)					\
 static void unlock_policy_rwsem_##mode(int cpu)				\
 {									\
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
-	BUG_ON(!policy);						\
-	up_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
+	BUG_ON(policy_cpu == -1);					\
+	up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 }
 
 unlock_policy_rwsem(read, cpu);
@@ -880,6 +881,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
+	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -949,6 +951,9 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
+	int j;
+	unsigned long flags;
+
 	if (cpu == policy->cpu)
 		return;
 
@@ -966,6 +971,13 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 
 	up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+
+	for_each_cpu(j, policy->cpus)
+		per_cpu(cpufreq_policy_cpu, j) = cpu;
+
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 #ifdef CONFIG_CPU_FREQ_TABLE
 	cpufreq_frequency_table_update_policy_cpu(policy);
 #endif
@@ -1041,6 +1053,9 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
+	/* Initially set CPU itself as the policy_cpu */
+	per_cpu(cpufreq_policy_cpu, cpu) = cpu;
+
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
@@ -1078,8 +1093,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 #endif
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
+		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
+	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!frozen) {
@@ -1103,11 +1120,15 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 
 err_out_unregister:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = NULL;
+		if (j != cpu)
+			per_cpu(cpufreq_policy_cpu, j) = -1;
+	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 err_set_policy_cpu:
+	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	cpufreq_policy_free(policy);
 nomem_out:
 	up_read(&cpufreq_rwsem);
@@ -1133,6 +1154,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 					   unsigned int old_cpu, bool frozen)
 {
 	struct device *cpu_dev;
+	unsigned long flags;
 	int ret;
 
 	/* first sibling now owns the new sysfs dir */
@@ -1149,6 +1171,11 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 
 		WARN_ON(lock_policy_rwsem_write(old_cpu));
 		cpumask_set_cpu(old_cpu, policy->cpus);
+
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		per_cpu(cpufreq_cpu_data, old_cpu) = policy;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 		unlock_policy_rwsem_write(old_cpu);
 
 		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
@@ -1174,6 +1201,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	policy = per_cpu(cpufreq_cpu_data, cpu);
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 	/* Save the policy somewhere when doing a light-weight tear-down */
 	if (frozen)
@@ -1305,7 +1333,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		}
 	}
 
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
+	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	return 0;
 }
 
@@ -2185,8 +2213,10 @@ static int __init cpufreq_core_init(void)
 	if (cpufreq_disabled())
 		return -ENODEV;
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		per_cpu(cpufreq_policy_cpu, cpu) = -1;
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
+	}
 
 	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);

