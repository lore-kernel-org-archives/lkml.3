Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbaCSMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:16:19 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51520 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:16:16 -0400
Message-ID: <53298A7D.3080400@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 17:45:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Subject: [RFC v3] cpufreq: Make sure frequency transitions are serialized
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org> <532840FD.308@linux.vnet.ibm.com> <CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com> <53296870.5010505@linux.vnet.ibm.com> <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
In-Reply-To: <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031912-5816-0000-0000-00000CEF83FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 03:39 PM, Viresh Kumar wrote:
> On 19 March 2014 15:20, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> No, its not about burden. Its about the elegance of the design. We should
>> not be overly "smart" in the cpufreq core. Hiding the synchronization inside
>> the cpufreq core only encourages people to write buggy code in their drivers.
> 
> What kind of buggy code can be there? They are supposed to call notifiers
> in the order mentioned and so it shouldn't be a problem at all.. Don't know..
> 
>> Why don't we go with what Rafael suggested? We can have dedicated
>> begin_transition() and end_transition() calls to demarcate the frequency
>> transitions. That way, it makes it very clear how the synchronization is
>> done. Of course, these functions would be provided (exported) by the cpufreq
>> core, by implementing them using locks/counters/whatever.
>>
>> Basically what I'm arguing against, is the idea of having the cpufreq
>> core figure out what the driver _intended_ to do, from inside the
>> cpufreq_notify_transition() call.
>>
>> What I would prefer instead is to have the cpufreq driver do something
>> like this:
>>
>> cpufreq_freq_transition_begin();
>>
>> cpufreq_notify_transition(CPUFREQ_PRECHANGE);
> 
> Why do we need two routines then? What about doing notification from
> inside cpufreq_freq_transition_begin()?
>

Hmm, that's a good idea. I thought about ways to simplify the synchronization
and this is what I came up with. Its completely untested though. Let me know
what you think!

---------------------------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3] cpufreq: Make sure frequency transitions are serialized

Whenever we change the frequency of a CPU, we call the PRECHANGE and
POSTCHANGE notifiers. They must be serialized, i.e. PRECHANGE and
POSTCHANGE notifiers should strictly alternate, thereby preventing
two different sets of PRECHANGE or POSTCHANGE notifiers from
interleaving arbitrarily.

The following examples illustrate why this is important:

Scenario 1:
-----------
A thread reading the value of cpuinfo_cur_freq, will call
__cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()

The ondemand governor can decide to change the frequency of the CPU at the
same time and hence it can end up sending the notifications via ->target().

If the notifiers are not serialized, the following sequence can occur:
- PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
- PRECHANGE Notification for freq B (from target())
- Freq changed by target() to B
- POSTCHANGE Notification for freq B
- POSTCHANGE Notification for freq A

We can see from the above that the last POSTCHANGE Notification happens for
freq A but the hardware is set to run at freq B.

Where would we break then?: adjust_jiffies() in cpufreq.c & cpufreq_callback()
in arch/arm/kernel/smp.c (which also adjusts the jiffies). All the
loops_per_jiffy calculations will get messed up.

Scenario 2:
-----------
The governor calls __cpufreq_driver_target() to change the frequency. At the
same time, if we change scaling_{min|max}_freq from sysfs, it will end up
calling the governor's CPUFREQ_GOV_LIMITS notification, which will also call
__cpufreq_driver_target(). And hence we end up issuing concurrent calls to
->target().

Typically, platforms have the following logic in their ->target() routines:
(Eg: cpufreq-cpu0, omap, exynos, etc)

A. If new freq is more than old: Increase voltage
B. Change freq
C. If new freq is less than old: decrease voltage

Now, if the two concurrent calls to ->target() are X and Y, where X is trying
to increase the freq and Y is trying to decrease it, we get the following
race condition:

X.A: voltage gets increased for larger freq
Y.A: nothing happens
Y.B: freq gets decreased
Y.C: voltage gets decreased
X.B: freq gets increased
X.C: nothing happens

Thus we can end up setting a freq which is not supported by the voltage we
have set. That will probably make the clock to the CPU unstable and the system
might not work properly anymore.

This patch introduces a set of synchronization primitives to serialize
frequency transitions, which are to be used as shown below:

cpufreq_freq_transition_begin();

//Perform the frequency change

cpufreq_freq_transition_end();

The _begin() call sends the PRECHANGE notification whereas the _end() call
sends the POSTCHANGE notification. Also, all the necessary synchronization
is handled within these calls. In particular, even drivers which set the
ASYNC_NOTIFICATION flag can also use these APIs for performing frequency
transitions (ie., you can call _begin() from one task, and call the
corresponding _end() from a different task).

The actual synchronization underneath is not that complicated:

The key challenge is to allow drivers to begin the transition from one thread
and end it in a completely different thread (this is to enable drivers that do
asynchronous POSTCHANGE notification from bottom-halves, to also use the same
interface).

To achieve this, a 'transition_ongoing' flag, a 'transition_lock' mutex and a
wait-queue are added per-policy. The flag and the wait-queue are used in
conjunction to create an "uninterrupted flow" from _begin() to _end(). The
mutex-lock is used to ensure that only one such "flow" is in flight at any
given time. Put together, this provides us all the necessary synchronization.

Based-on-patch-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   34 ++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |    5 +++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 199b52b..e90388f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -349,6 +349,38 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
 EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
 
 
+void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state)
+{
+wait:
+	wait_event(&policy->transition_wait, !policy->transition_ongoing);
+
+	if (!mutex_trylock(&policy->transition_lock))
+		goto wait;
+
+	policy->transition_ongoing++;
+
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
+
+	mutex_unlock(&policy->transition_lock);
+}
+
+void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state)
+{
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
+
+	/*
+	 * We don't need to take any locks for this update, since only
+	 * one POSTCHANGE notification can be pending at any time, and
+	 * at the moment, that's us :-)
+	 */
+	policy->transition_ongoing = false;
+
+	wake_up(&policy->transition_wait);
+}
+
+
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
@@ -968,6 +1000,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
 
 	INIT_LIST_HEAD(&policy->policy_list);
 	init_rwsem(&policy->rwsem);
+	mutex_init(&policy->transition_lock);
+	init_waitqueue_head(&policy->transition_wait);
 
 	return policy;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d89e0e..8bded24 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -101,6 +101,11 @@ struct cpufreq_policy {
 	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
+
+	/* Synchronization for frequency transitions */
+	bool			transition_ongoing; /* Tracks transition status */
+	struct mutex		transition_lock;
+	wait_queue_head_t	transition_wait;
 };
 
 /* Only for ACPI */


