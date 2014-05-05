Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaEEHXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:23:43 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46444 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaEEHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:23:41 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3] cpufreq: Catch double invocations of
 cpufreq_freq_transition_begin/end
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: ego@linux.vnet.ibm.com, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 05 May 2014 12:52:39 +0530
Message-ID: <20140505072129.14454.25747.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050507-8878-0000-0000-00000C421980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cpufreq drivers were redundantly invoking the _begin() and _end()
APIs around frequency transitions, and this double invocation (one from
the cpufreq core and the other from the cpufreq driver) used to result
in a self-deadlock, leading to system hangs during boot. (The _begin()
API makes contending callers wait until the previous invocation is
complete. Hence, the cpufreq driver would end up waiting on itself!).

Now all such drivers have been fixed, but debugging this issue was not
very straight-forward (even lockdep didn't catch this). So let us add a
debug infrastructure to the cpufreq core to catch such issues more easily
in the future.

We add a new field called 'transition_task' to the policy structure, to keep
track of the task which is performing the frequency transition. Using this
field, we make note of this task during _begin() and print a warning if we
find a case where the same task is calling _begin() again, before completing
the previous frequency transition using the corresponding _end().

We have left out ASYNC_NOTIFICATION drivers from this debug infrastructure
for 2 reasons:

1. At the moment, we have no way to avoid a particular scenario where this
   debug infrastructure can emit false-positive warnings for such drivers.
   The scenario is depicted below:


         Task A						Task B

    /* 1st freq transition */
    Invoke _begin() {
            ...
            ...
    }

    Change the frequency

    /* 2nd freq transition */
    Invoke _begin() {
	    ...	//waiting for B to
            ... //finish _end() for
	    ... //the 1st transition
	    ...	      |				Got interrupt for successful
	    ...	      |				change of frequency (1st one).
	    ...       |
	    ...	      |				/* 1st freq transition */
	    ...	      |				Invoke _end() {
	    ...	      |					...
	    ...	      V				}
	    ...
	    ...
    }

   This scenario is actually deadlock-free because, once Task A changes the
   frequency, it is Task B's responsibility to invoke the corresponding
   _end() for the 1st frequency transition. Hence it is perfectly legal for
   Task A to go ahead and attempt another frequency transition in the meantime.
   (Of course it won't be able to proceed until Task B finishes the 1st _end(),
   but this doesn't cause a deadlock or a hang).

   The debug infrastructure cannot handle this scenario and will treat it as
   a deadlock and print a warning. To avoid this, we exclude such drivers
   from the purview of this code.

2. Luckily, we don't _need_ this infrastructure for ASYNC_NOTIFICATION drivers
   at all! The cpufreq core does not automatically invoke the _begin() and
   _end() APIs during frequency transitions in such drivers. Thus, the driver
   alone is responsible for invoking _begin()/_end() and hence there shouldn't
   be any conflicts which lead to double invocations. So, we can skip these
   drivers, since the probability that such drivers will hit this problem is
   extremely low, as outlined above.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Changes in v3:
Expanded the comment in the code to briefly mention why ASYNC_NOTIFICATION
drivers are left out from the check, as suggested by Gautham R. Shenoy.
No code changes in this version.

v2: https://lkml.org/lkml/2014/4/29/283
v1: https://lkml.org/lkml/2014/4/28/469

 drivers/cpufreq/cpufreq.c |   14 ++++++++++++++
 include/linux/cpufreq.h   |    1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index abda660..a05c921 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -354,6 +354,18 @@ static void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
 void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs)
 {
+
+	/*
+	 * Catch double invocations of _begin() which lead to self-deadlock.
+	 * ASYNC_NOTIFICATION drivers are left out because the cpufreq core
+	 * doesn't invoke _begin() on their behalf, and hence the chances of
+	 * double invocations are very low. Moreover, there are scenarios
+	 * where these checks can emit false-positive warnings in these
+	 * drivers; so we avoid that by skipping them altogether.
+	 */
+	WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
+				&& current == policy->transition_task);
+
 wait:
 	wait_event(policy->transition_wait, !policy->transition_ongoing);
 
@@ -365,6 +377,7 @@ wait:
 	}
 
 	policy->transition_ongoing = true;
+	policy->transition_task = current;
 
 	spin_unlock(&policy->transition_lock);
 
@@ -381,6 +394,7 @@ void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
 	cpufreq_notify_post_transition(policy, freqs, transition_failed);
 
 	policy->transition_ongoing = false;
+	policy->transition_task = NULL;
 
 	wake_up(&policy->transition_wait);
 }
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5ae5100..8f44d79 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -110,6 +110,7 @@ struct cpufreq_policy {
 	bool			transition_ongoing; /* Tracks transition status */
 	spinlock_t		transition_lock;
 	wait_queue_head_t	transition_wait;
+	struct task_struct	*transition_task; /* Task which is doing the transition */
 };
 
 /* Only for ACPI */

