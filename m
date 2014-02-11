Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBKJdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:33:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38110 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKJd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:33:28 -0500
Message-ID: <52F9ED11.5010800@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 14:57:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of callback
 registration functions
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com>
In-Reply-To: <1392081980.5612.123.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021109-9264-0000-0000-0000056E4FD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 06:56 AM, Toshi Kani wrote:
> On Thu, 2014-02-06 at 03:34 +0530, Srivatsa S. Bhat wrote:
>  :
[...]
>>
>> Also, since cpu_maps_update_begin/done() is like a super-set of
>> get/put_online_cpus(), the former naturally protects the critical sections
>> from concurrent hotplug operations.
> 
> get/put_online_cpus() is a reader-lock and concurrent executions are
> allowed among the readers.  They won't be serialized until a cpu
> online/offline operation begins.  By replacing this lock with
> cpu_maps_update_begin/done(), we now serialize all readers.  Isn't that
> too restrictive?

That's an excellent line of thought! It doesn't really hurt at the moment
because the for_each_online_cpu() kind of loop that the initcalls of various
subsystems run (before registering the notifier) are really tiny (typically
the loop runs for just 1 cpu, the boot-cpu). In other words, this change
represents a tiny increase in the critical section size; so its effect
shouldn't be noticeable. (Note that in the old model, register_cpu_notifier()
already takes the cpu_add_remove_lock, so they will be serialized at that
point, and this is necessary).

However, going forward, when we start using more aggressive CPU onlining
techniques during boot (such as parallel CPU hotplug), the issue you pointed
out can become a real bottleneck, since for_each_online_cpu() can become
quite a large loop, and hence explicit (and unnecessary) mutual exclusion
will start hurting.
 
>  Can we fix the issue with CPU_POST_DEAD and continue
> to use get_online_cpus()?
> 

We don't want to get rid of CPU_POST_DEAD, so unfortunately we can't continue
to use get_online_cpus(). However, I am thinking of introducing a Reader-Writer
semaphore for this purpose, so that the registration routines can run in
parallel most of the time. (Basically, the rw-semaphore is like
get/put_online_cpus(), except that it protects the full hotplug critical section,
including the CPU_POST_DEAD stage.)

The usage would be like this:

	cpu_notifier_register_begin(); //does down_read(&cpu_hotplug_rwsem);

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Takes cpu_add_remove_lock mutex */
	register_cpu_notifier(&foobar_cpu_notifier);

	cpu_notifier_register_end(); //does up_read(&cpu_hotplug_rwsem);

An untested RFC patch is shown below. With this, the task performing CPU hotplug
will take the locks in this order:

	down_write(&cpu_hotplug_rwsem);
	mutex_lock(&cpu_add_remove_lock);

	mutex_lock(&cpu_hotplug.lock);

	//Perform CPU hotplug

	mutex_unlock(&cpu_hotplug.lock);

	mutex_unlock(&cpu_add_remove_lock);
	up_write(&cpu_hotplug_rwsem);


The APIs register/unregister_cpu_notifiers will take only the
cpu_add_remove_lock mutex during callback registration.


-----------------------------------------------------------------------------

diff --git a/kernel/cpu.c b/kernel/cpu.c
index deff2e6..8054e6f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -23,6 +23,19 @@
 #include "smpboot.h"
 
 #ifdef CONFIG_SMP
+
+static DECLARE_RWSEM(cpu_hotplug_rwsem);
+
+void cpu_notifier_register_begin(void)
+{
+	down_read(&cpu_hotplug_rwsem);
+}
+
+void cpu_notifier_register_end(void)
+{
+	up_read(&cpu_hotplug_rwsem);
+}
+
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
@@ -32,12 +45,14 @@ static DEFINE_MUTEX(cpu_add_remove_lock);
  */
 void cpu_maps_update_begin(void)
 {
+	down_write(&cpu_hotplug_rwsem);
 	mutex_lock(&cpu_add_remove_lock);
 }
 
 void cpu_maps_update_done(void)
 {
 	mutex_unlock(&cpu_add_remove_lock);
+	up_write(&cpu_hotplug_rwsem);
 }
 
 static RAW_NOTIFIER_HEAD(cpu_chain);
@@ -160,9 +175,10 @@ void cpu_hotplug_enable(void)
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
-	cpu_maps_update_begin();
+
+	mutex_lock(&cpu_add_remove_lock);
 	ret = raw_notifier_chain_register(&cpu_chain, nb);
-	cpu_maps_update_done();
+	mutex_unlock(&cpu_add_remove_lock);
 	return ret;
 }
 
@@ -192,9 +208,9 @@ EXPORT_SYMBOL(register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
-	cpu_maps_update_begin();
+	mutex_lock(&cpu_add_remove_lock);
 	raw_notifier_chain_unregister(&cpu_chain, nb);
-	cpu_maps_update_done();
+	mutex_unlock(&cpu_add_remove_lock);
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 

Regards,
Srivatsa S. Bhat

