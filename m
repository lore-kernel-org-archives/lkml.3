Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081Ab3DQLeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:34:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59286 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965882Ab3DQLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:34:13 -0400
Message-ID: <516E880C.9050402@linux.vnet.ibm.com>
Date: Wed, 17 Apr 2013 17:01:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
References: <20130416095827.GJ3672@sgi.com> <20130416113256.GA10452@gmail.com> <20130416120624.GO3658@sgi.com> <516D72B7.2040608@linux.vnet.ibm.com> <20130416162238.GT3658@sgi.com> <20130417074835.GB31607@gmail.com> <20130417100317.GE3658@sgi.com>
In-Reply-To: <20130417100317.GE3658@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041711-2000-0000-0000-00000BC42B0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 03:33 PM, Robin Holt wrote:
> On Wed, Apr 17, 2013 at 09:48:35AM +0200, Ingo Molnar wrote:
>>
>> * Robin Holt <holt@sgi.com> wrote:
>>
>>> On Tue, Apr 16, 2013 at 09:18:07PM +0530, Srivatsa S. Bhat wrote:
>>>> On 04/16/2013 05:36 PM, Robin Holt wrote:
>>>>> On Tue, Apr 16, 2013 at 01:32:56PM +0200, Ingo Molnar wrote:
>>>>>>
>>>>>> * Robin Holt <holt@sgi.com> wrote:
>>>>>>
>>>>>>> We recently noticed that reboot of a 1024 cpu machine takes approx 16
>>>>>>> minutes of just stopping the cpus.  The slowdown was tracked to commit
>>>>>>> f96972f.
>>>>>>>
>>>>>>> The current implementation does all the work of hot removing the cpus
>>>>>>> before halting the system.  We are switching to just migrating to the
>>>>>>> boot cpu and then continuing with shutdown/reboot.
>>>>>>>
>>>>>>> This also has the effect of not breaking x86's command line parameter for
>>>>>>> specifying the reboot cpu.  Note, this code was shamelessly copied from
>>>>>>> arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
>>>>>>> command line parameter.
>>>>>>>
[...]
>>>>>>> ---
>>>>>>>  kernel/sys.c | 22 +++++++++++++++++++---
>>>>>>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/kernel/sys.c b/kernel/sys.c
>>>>>>> index 0da73cf..5ef7aa2 100644
>>>>>>> --- a/kernel/sys.c
>>>>>>> +++ b/kernel/sys.c
>>>>>>> @@ -357,6 +357,22 @@ int unregister_reboot_notifier(struct notifier_block *nb)
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL(unregister_reboot_notifier);
>>>>>>>  
>>>>>>> +void migrate_to_reboot_cpu(void)
>>>>>>
>>>>>> It appears to be file-scope, so should be static I guess?
>>>>>
>>>>> Done.
>>>>>
>>>>>>> +{
>>>>>>> +	/* The boot cpu is always logical cpu 0 */
>>>>>>> +	int reboot_cpu_id = 0;
>>>>>>> +
>>>>>>> +	/* Make certain the cpu I'm about to reboot on is online */
>>>>>>> +	if (!cpu_online(reboot_cpu_id))
>>>>>>> +		reboot_cpu_id = smp_processor_id();
>>>>>>
>>>>>> Shouldn't we pick the first online CPU instead, to make it deterministic?
>>>>>
>>>>> Done.
>>>>>
>>>>> 		reboot_cpu_id = cpumask_first(cpu_online_mask);
>>>>>
>>>>
>>>> Let me ask again: if CPU 0 (or whatever the preferred reboot cpu is)
>>>> is offline, then why should we even bother pinning the task to (another)
>>>> CPU? Why not just proceed with the reboot?
>>>
>>> No idea.  I copied it from the arch/x86 code.  I can not defend it.
>>
>> I'd say it's a quality of implementation improvement if the choice of the CPU is 
>> deterministic, as long as the current configuration of CPUs is deterministic.
>>
>> I.e. instead of 'reboot on the first CPU, or a random CPU', make the rule 'reboot 
>> on the first online CPU'. That's a simple rule to think about.
>>
>> ( On most architectures CPU#0 cannot be unplugged, so the rule will effectively be 
>>   'reboot on CPU#0'. Like the current upstream behavior. )
> 
> Would you be more comfortable with:
> 
> static void migrate_to_reboot_cpu(void)
> {
>         /* The boot cpu is always logical cpu 0 */
>         int reboot_cpu_id = reboot_cpuid;
> 
>         get_online_cpus();
> 
>         /* Make certain the cpu I'm about to reboot on is online */
>         if (!cpu_online(reboot_cpu_id))
>                 reboot_cpu_id = 0;

This assignment is not required. cpumask_first() gives you 0 if CPU 0
is online.

>         if (!cpu_online(reboot_cpu_id))
>                 reboot_cpu_id = cpumask_first(cpu_online_mask);
> 
>         /* Prevent races with other tasks migrating this task */
>         current->flags |= PF_THREAD_BOUND;
> 
>         /* Make certain I only run on the appropriate processor */
>         set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
> 
>         put_online_cpus();
> }
> 

The get/put_online_cpus() doesn't help in this case, because if a
hotplug operation is started _after_ this function returns, then
your task will get force migrated - which makes the get/put_online_cpus()
pointless. What we need to do is *disable* CPU hotplug altogether.
We need not even enable it back, since we are rebooting/powering off
anyway.

So how about using the following patch in your series and using
cpu_hotplug_disable() to achieve the goal?


------------------------------------------------------------->
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] CPU hotplug: Provide a generic helper to disable/enable CPU hotplug

There are instances in the kernel where we would like to disable
CPU hotplug (from sysfs) during some important operation. Today
the freezer code depends on this and the code to do it was kinda
tailor-made for that.

Restructure the code and make it generic enough to be useful for
other usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..28769f5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -541,29 +541,20 @@ static int __init alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
  */
-void cpu_hotplug_disable_before_freeze(void)
+void cpu_hotplug_disable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 1;
 	cpu_maps_update_done();
 }
 
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
+void cpu_hotplug_enable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
@@ -589,12 +580,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:


