Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaD2EvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:51:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64240 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaD2EvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
	<20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 29 Apr 2014 10:21:11 +0530
Message-ID: <CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice effort.

On 29 April 2014 00:25, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Now all such drivers have been fixed, but debugging this issue was not
> very straight-forward (even lockdep didn't catch this). So let us add a
> debug infrastructure to the cpufreq core to catch such issues more easily
> in the future.

BUT, I am not sure if we really need it :(

I think we just got into the 'barrier' stuff as we had some doubts about it
earlier and were quite sure that nothing else could go wrong. Otherwise
the only problem could have been present was the second queuing
from the same thread. And we will surely get stuck if that happens and
we can't just miss that error..

> Scenario 1: (Deadlock-free)
> ----------
>
>          Task A                                         Task B
>
>     /* 1st freq transition */
>     Invoke _begin() {
>             ...
>             ...
>     }
>
>     Change the frequency
>
>                                                 Got interrupt for successful
>                                                 change of frequency.
>
>                                                 /* 1st freq transition */
>                                                 Invoke _end() {
>                                                         ...
>                                                         ...
>     /* 2nd freq transition */                           ...
>     Invoke _begin() {                                   ...
>             ... //waiting for B                         ...
>             ... //to finish _end()              }
>             ...
>             ...
>     }
>
>
> This scenario is actually deadlock-free because Task A can wait inside the
> second call to _begin() without self-deadlocking, because it is the
> responsibility of Task B to finish the first sequence by invoking the
> corresponding _end().
>
> By setting the value of 'transition_task' again explicitly in _end(), we
> ensure that the code won't print a false-positive warning in this case.
>
> However the same code successfully catches the following deadlock-prone
> scenario even in ASYNC_NOTIFICATION drivers:
>
> Scenario 2: (Deadlock-prone)
> ----------
>
>          Task A                                         Task B
>
>     /* 1st freq transition */
>     Invoke _begin() {
>             ...
>             ...
>     }
>
>     /* 2nd freq transition */
>     Invoke _begin() {
>             ...
>             ...
>     }
>
>     Change the frequency
>
>
> Here the bug is that Task A called the second _begin() *before* actually
> performing the 1st frequency transition. In other words, it failed to set
> Task B in motion for the 1st frequency transition, and hence it will
> self-deadlock. This is very similar to the case of drivers which do
> synchronous notification, and hence the debug infrastructure developed
> in this patch can catch this scenario easily.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   12 ++++++++++++
>  include/linux/cpufreq.h   |    1 +
>  2 files changed, 13 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index abda660..2c99a6c 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -354,6 +354,10 @@ static void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
>  void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
>                 struct cpufreq_freqs *freqs)
>  {
> +
> +       /* Catch double invocations of _begin() which lead to self-deadlock */
> +       WARN_ON(current == policy->transition_task);
> +
>  wait:
>         wait_event(policy->transition_wait, !policy->transition_ongoing);
>
> @@ -365,6 +369,7 @@ wait:
>         }
>
>         policy->transition_ongoing = true;
> +       policy->transition_task = current;
>
>         spin_unlock(&policy->transition_lock);
>
> @@ -378,9 +383,16 @@ void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
>         if (unlikely(WARN_ON(!policy->transition_ongoing)))
>                 return;
>
> +       /*
> +        * The task invoking _end() could be different from the one that
> +        * invoked the _begin(). So set ->transition_task again here
> +        * explicity.
> +        */
> +       policy->transition_task = current;
>         cpufreq_notify_post_transition(policy, freqs, transition_failed);
>
>         policy->transition_ongoing = false;
> +       policy->transition_task = NULL;
>
>         wake_up(&policy->transition_wait);
>  }
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 5ae5100..8f44d79 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -110,6 +110,7 @@ struct cpufreq_policy {
>         bool                    transition_ongoing; /* Tracks transition status */
>         spinlock_t              transition_lock;
>         wait_queue_head_t       transition_wait;
> +       struct task_struct      *transition_task; /* Task which is doing the transition */
>  };
>
>  /* Only for ACPI */
>
