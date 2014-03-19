Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaCSGIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:08:49 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55692 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaCSGIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <532840FD.308@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 11:38:45 +0530
Message-ID: <CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
Subject: Re: [RFC V2] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 18:20, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 03/14/2014 01:13 PM, Viresh Kumar wrote:
>> +     if ((state != CPUFREQ_PRECHANGE) && (state != CPUFREQ_POSTCHANGE))
>
> Wait a min, when is this condition ever true? I mean, what else can
> 'state' ever be, apart from CPUFREQ_PRECHANGE and POSTCHANGE?

There were two more 'unused' states available:
CPUFREQ_RESUMECHANGE and CPUFREQ_SUSPENDCHANGE

I have sent a patch to remove them now and this code would go away..

>> +             return notify_transition_for_each_cpu(policy, freqs, state);
>> +
>> +     /* Serialize pre-post notifications */
>> +     mutex_lock(&policy->transition_lock);
>
> Nope, this is definitely not the way to go, IMHO. We should enforce that
> the *callers* serialize the transitions, something like this:
>
>         cpufreq_transition_lock();
>
>         cpufreq_notify_transition(CPUFREQ_PRECHANGE);
>
>         //Perform the frequency change
>
>         cpufreq_notify_transition(CPUFREQ_POSTCHANGE);
>
>         cpufreq_transition_unlock();
>
> That's it!
>
> [ We can either introduce a new "transition" lock or perhaps even reuse
> the cpufreq_driver_lock if it fits... but the point is, the _caller_ has
> to perform the locking; trying to be smart inside cpufreq_notify_transition()
> is a recipe for headache :-( ]
>
> Is there any problem with this approach due to which you didn't take
> this route?

I didn't wanted drivers to handle this as core must make sure things are in
order. Over that it would have helped by not pasting redundant code
everywhere..

Drivers are anyway going to call cpufreq_notify_transition(), why increase
burden on them?

>> +     if (unlikely(WARN_ON(!policy->transition_ongoing &&
>> +                             (state == CPUFREQ_POSTCHANGE)))) {
>> +             mutex_unlock(&policy->transition_lock);
>> +             return;
>> +     }
>> +
>> +     if (state == CPUFREQ_PRECHANGE) {
>> +             while (policy->transition_ongoing) {
>> +                     mutex_unlock(&policy->transition_lock);
>> +                     /* TODO: Can we do something better here? */
>> +                     cpu_relax();
>> +                     mutex_lock(&policy->transition_lock);
>
> If the caller takes care of the synchronization, we can avoid
> these sorts of acrobatics ;-)

If we are fine with taking a mutex for the entire transition, then
we can avoid above kind of acrobatics by just taking the mutex
from PRECHANGE and leaving it at POSTCHANGE..

It will look like this then, hope this looks fine :)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2677ff1..3b9eac4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -335,8 +335,15 @@ static void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
                struct cpufreq_freqs *freqs, unsigned int state)
 {
+       if (state == CPUFREQ_PRECHANGE)
+               mutex_lock(&policy->transition_lock);
+
+       /* Send notifications */
        for_each_cpu(freqs->cpu, policy->cpus)
                __cpufreq_notify_transition(policy, freqs, state);
+
+       if (state == CPUFREQ_POSTCHANGE)
+               mutex_unlock(&policy->transition_lock);
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);

@@ -983,6 +990,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)

        INIT_LIST_HEAD(&policy->policy_list);
        init_rwsem(&policy->rwsem);
+       mutex_init(&policy->transition_lock);

        return policy;

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 31c431e..5f9209a 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -104,6 +104,7 @@ struct cpufreq_policy {
         *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
         */
        struct rw_semaphore     rwsem;
+       struct mutex            transition_lock;
 };
