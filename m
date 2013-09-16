Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3IPSmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:42:16 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:47994 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab3IPSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:42:14 -0400
X-Greylist: delayed 8106 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2013 14:42:14 EDT
Message-ID: <1379356930.3422.71.camel@linaro1.home>
Subject: Re: [PATCH 1/2] cpufreq: unlock correct rwsem while updating
 policy->cpu
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Mon, 16 Sep 2013 19:42:10 +0100
In-Reply-To: <CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
	 <1379348823.3422.42.camel@linaro1.home>
	 <CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 22:38 +0530, Viresh Kumar wrote:
> On 16 September 2013 21:57, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> > If I take mainline code and just change the line above to:
> 
> You meant this line by above line?
> 
>          unlock_policy_rwsem_write(cpu);

Yes.

> >    up_write(&per_cpu(cpu_policy_rwsem, (per_cpu(cpufreq_cpu_data,
> > cpu))->last_cpu));
> > then the big_little cpufreq driver works for me.
> 
> That would be same as: up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));

Yes. (I had cut'n'pasted from the unlock_policy_rwsem_ macro)

> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index 43c24aa..c18bf7b 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -952,9 +952,16 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> >>       if (cpu == policy->cpu)
> >>               return;
> >>
> >> +     /* take direct locks as lock_policy_rwsem_write wouldn't work here */
> >> +     down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> >> +     down_write(&per_cpu(cpu_policy_rwsem, cpu));
> >> +
> >>       policy->last_cpu = policy->cpu;
> >>       policy->cpu = cpu;
> >>
> >> +     up_write(&per_cpu(cpu_policy_rwsem, cpu));
> >> +     up_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> >
> > You've just overwritten policy->cpu with cpu.
> 
> Stupid enough :)
> 
> > I tried using
> > policy->last_cpu to fix that, but it still doesn't work for me (giving
> > the lockdep warning I mentioned.) If I change the code to just lock the
> > original policy->cpu lock only, then all is fine.
> 
> Fixed my patch now.. find attached..

The commit log to that patch still mentions taking both locks.
The code itself fixes the lockdep errors I had, so

Tested-by: Jon Medhurst <tixy@linaro.org>

however, I still have concerns about the locking (below)...

>  It mentions why lock for last cpu is
> enough here. Copied that here too..
> 
> + /*
> + * Take direct locks as lock_policy_rwsem_write wouldn't work here.
> + * Also lock for last cpu is enough here as contention will happen only
> + * after policy->cpu is changed and after it is changed, other threads
> + * will try to acquire lock for new cpu. And policy is already updated
> + * by then.
> + */
> 
> > Also, this locking is now just happening around policy->cpu update,
> > whereas before this change, it was locked for the whole of
> > update_policy_cpu, i.e. cpufreq_frequency_table_update_policy_cpu and
> > the notifier callbacks. Is that change of lock coverage OK?
> 
> Yeah, the rwsem is only required for updating policy's fields and so that
> should be okay.

But what about reads, like in cpufreq_frequency_table_update_policy_cpu
which is called immediately after the unlocking writes? Should that not
be covered by a reader lock?

And after that call, policy is passed into blocking_notifier_call_chain,
do those callbacks not want to look at policy fields? Or are they going
to do there own locking?

Or is update_policy_cpu itself meant to be called with a read lock held?
(It doesn't appear to be as the semaphore 'activiy' field of the lock is
zero).

Or is there some other non-obvious synchronisation method which means
the policy object can't change?

This is the first time I've looked at this code, so feel free just to
say 'it's complicated, just trust me, I'm the expert, I know what I'm
doing'...

-- 
Tixy





