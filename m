Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbaCUIm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:42:56 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44809 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaCUImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:42:50 -0400
Message-ID: <532BFB77.5060107@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 14:12:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are serialized
References: <cover.1395379422.git.viresh.kumar@linaro.org> <f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org> <532BEE64.3090501@linux.vnet.ibm.com> <CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
In-Reply-To: <CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032108-8256-0000-0000-00000C0F5957
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 01:28 PM, Viresh Kumar wrote:
> On 21 March 2014 13:16, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> We need this assignment to happen exactly at this point, that is, *after*
>> the call to post_transition() completes and before calling wake_up().
>>
>> If the compiler or the CPU reorders the instructions and moves this
>> assignment to some other place, then we will be in trouble!
>>
>> We might need memory barriers to ensure this doesn't get reordered.
>> Alternatively, we can simply hold the spin-lock around this assignment,
>> since locks automatically imply memory barriers. As an added advantage,
>> the code will then look more intuitive and easier to understand as well.
>>
>> Thoughts?
> 
> I may be wrong but this is how I understand locks. Yes, spinlocks have
> memory barriers implemented but it wouldn't guarantee what you are
> asking for in the above explanation.
> 
> It will guarantee that transition_ongoing will be updated after the lock
> is taken but the notification() can happen after the lock is taken and
> also after the variable is modified.
>

Actually, yes, that's true. The lock and unlock act as one-way barriers,
hence they ensure that the critical section doesn't seep outside of the
locks, but don't necessarily ensure that pieces of code outside the
critical section don't seep -into- the critical section. IOW, my reasoning
was not quite correct, but see below.
 
> You can find some information on this in
> Documentation/memory-barriers.txt
>

Yep, I know, I have read it several times, but I'm no expert ;-)

I found this interesting section on "SLEEP AND WAKE-UP FUNCTIONS". It
says that doing:

policy->transition_ongoing = false;
wake_up(&policy->transition_wait);

is safe (as long as some tasks are woken up). So we don't have to worry
about that part. So only the first part remains to be solved: ensuring
that the assignment occurs _after_ completing the invocation of the
POSTCHANGE notifiers.

For that, we can do:

cpufreq_notify_post_transition();

smp_mb();

policy->transition_ongoing = false;

That should take care of everything.

> I don't think compiler or CPU will reorder calls to a function and
> updates of a variable.

I'm not sure about that. I think it is free to do so if it finds
that there is no dependency that prevents it from reordering. In this
case the update to the flag has no "visible" dependency on the call
to post_transition().

> And so this code might simply work. And
> I hope there would be plenty of such code in kernel.
> 

Sure, there are plenty of examples in the kernel where we call functions
and update variables. But in this particular case, our synchronization
_depends_ on those operations happening in a particular order. Hence
we need to ensure the ordering is right. Otherwise the synchronization
might get broken.

Here are some examples where memory barriers are inserted to avoid
reordering of variable updates and function calls:

kernel/rcu/torture.c: rcu_torture_barrier_cbs()
kernel/smp.c: kick_all_cpus_sync()

Regards,
Srivatsa S. Bhat

