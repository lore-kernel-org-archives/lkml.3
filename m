Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbaCUJVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:21:09 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49491 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403AbaCUJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <532BFB77.5060107@linux.vnet.ibm.com>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
	<f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
	<532BEE64.3090501@linux.vnet.ibm.com>
	<CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
	<532BFB77.5060107@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 14:51:02 +0530
Message-ID: <CAKohpomY4xf4tOFTGt-ykE7sUi4ks7vW5qp8ytgopm6CiY9QRg@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2014 14:12, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> You can find some information on this in
>> Documentation/memory-barriers.txt
>
> Yep, I know, I have read it several times, but I'm no expert ;-)

Not me either :) .. That file has so complex stuff in there that its
difficult to
understand what's all it says.. I read it several times the last time I went for
a interview (Almost 2 years back) and don't remember anything now :)

> I found this interesting section on "SLEEP AND WAKE-UP FUNCTIONS". It
> says that doing:
>
> policy->transition_ongoing = false;
> wake_up(&policy->transition_wait);
>
> is safe (as long as some tasks are woken up). So we don't have to worry
> about that part.

Okay..

> So only the first part remains to be solved: ensuring
> that the assignment occurs _after_ completing the invocation of the
> POSTCHANGE notifiers.
>
> For that, we can do:
>
> cpufreq_notify_post_transition();
>
> smp_mb();
>
> policy->transition_ongoing = false;
>
> That should take care of everything.
>
>> I don't think compiler or CPU will reorder calls to a function and
>> updates of a variable.
>
> I'm not sure about that. I think it is free to do so if it finds
> that there is no dependency that prevents it from reordering. In this
> case the update to the flag has no "visible" dependency on the call
> to post_transition().
>
>> And so this code might simply work. And
>> I hope there would be plenty of such code in kernel.
>>
>
> Sure, there are plenty of examples in the kernel where we call functions
> and update variables. But in this particular case, our synchronization
> _depends_ on those operations happening in a particular order. Hence
> we need to ensure the ordering is right. Otherwise the synchronization
> might get broken.

I still don't buy that.. Lets call an expert :)

> Here are some examples where memory barriers are inserted to avoid
> reordering of variable updates and function calls:
>
> kernel/rcu/torture.c: rcu_torture_barrier_cbs()

rcutorture.c instead.

> kernel/smp.c: kick_all_cpus_sync()

These examples are a bit different than what we have here..

@Catalin: We have a problem here and need your expert advice. After changing
CPU frequency we need to call this code:

cpufreq_notify_post_transition();
policy->transition_ongoing = false;

And the sequence must be like this only. Is this guaranteed without any
memory barriers? cpufreq_notify_post_transition() isn't touching
transition_ongoing at all..

--
thanks..
