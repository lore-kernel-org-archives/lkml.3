Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JWJNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:13:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51962 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3JWJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <1791712.tJBFGgQvyI@vostro.rjw.lan>
References: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
	<793a5fadad931d04c2adb3a61c64063b7e62d083.1378979483.git.viresh.kumar@linaro.org>
	<1791712.tJBFGgQvyI@vostro.rjw.lan>
Date: Wed, 23 Oct 2013 14:43:12 +0530
Message-ID: <CAKohpomWjBZfLLqYjnP=n059bTC6pDseqfWbJmZy894fqHW7Nw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 00:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> So the problem is real, but the fix seems to be of a "quick and dirty" kind.
>
> First of all, it looks like we need a clear "begin transition" call that
> I suppose drivers should execute from their .target() methods once they have
> decided to do a transition.  That would increment the "ongoing" counter etc.
>
> Second, we need a corresponding "end transition" call that would be executed
> whenever appropriate from the driver's perspective.
>
> Clearly, these two things should be independent of the notifiers and the
> notifications should only be done between "begin transition" and "end
> transition" and only by whoever called the "begin transition" to start with.
>
> Now, question is what should happen if "begin transition" is called when
> the previous transition hasn't been completed yet, should it block or should
> it fail?  There seem to be arguments for both, but I suppose blocking would be
> easier to implement.

I got another solution which is much simpler, and I really can't believe
(psychologically) that it will solve all the problems we were talking about..
Please see if there is any loophole in there..

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ec391d7..e4ed89a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -340,6 +340,13 @@ static void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
        }
 }

+void cpufreq_notify_transition_each_cpu(struct cpufreq_policy *policy,
+               struct cpufreq_freqs *freqs, unsigned int state)
+{
+       for_each_cpu(freqs->cpu, policy->cpus)
+               __cpufreq_notify_transition(policy, freqs, state);
+}
+
 /**
  * cpufreq_notify_transition - call notifier chain and adjust_jiffies
  * on frequency transition.
@@ -351,8 +358,34 @@ static void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
                struct cpufreq_freqs *freqs, unsigned int state)
 {
-       for_each_cpu(freqs->cpu, policy->cpus)
-               __cpufreq_notify_transition(policy, freqs, state);
+       if ((state != CPUFREQ_PRECHANGE) && (state != CPUFREQ_POSTCHANGE))
+               return cpufreq_notify_transition_each_cpu(policy, freqs, state);
+
+       /* Serialize pre-post notifications */
+       mutex_lock(&policy->transition_lock);
+       if (unlikely(WARN_ON(!policy->transition_ongoing &&
+                               (state == CPUFREQ_POSTCHANGE)))) {
+               mutex_unlock(&policy->transition_lock);
+               return;
+       }
+
+       if (state == CPUFREQ_PRECHANGE) {
+               while (policy->transition_ongoing) {
+                       mutex_unlock(&policy->transition_lock);
+                       cpu_relax();
+                       mutex_lock(&policy->transition_lock);
+               }
+
+               policy->transition_ongoing = true;
+               mutex_unlock(&policy->transition_lock);
+       }
+
+       cpufreq_notify_transition_each_cpu(policy, freqs, state);
+
+       if (state == CPUFREQ_POSTCHANGE) {
+               policy->transition_ongoing = false;
+               mutex_unlock(&policy->transition_lock);
+       }
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);

@@ -950,6 +983,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
                goto err_free_cpumask;

        INIT_LIST_HEAD(&policy->policy_list);
+       mutex_init(&policy->transition_lock);
+
        return policy;

 err_free_cpumask:
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 0aba2a6c..bb76909 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -85,6 +85,8 @@ struct cpufreq_policy {
        struct list_head        policy_list;
        struct kobject          kobj;
        struct completion       kobj_unregister;
+       bool                    transition_ongoing; /* Tracks
transition status */
+       struct mutex            transition_lock;
 };
