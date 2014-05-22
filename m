Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaEVLzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:55:50 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33588 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaEVLzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:55:48 -0400
Message-ID: <537DE579.6000505@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 17:24:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
References: <1400750624-19238-1-git-send-email-bp@alien8.de> <537DC6D2.8040305@linux.vnet.ibm.com> <20140522100820.GE4383@pd.tnic>
In-Reply-To: <20140522100820.GE4383@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052211-9574-0000-0000-00000DBD8577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 03:38 PM, Borislav Petkov wrote:
> On Thu, May 22, 2014 at 03:13:46PM +0530, Srivatsa S. Bhat wrote:
>> On 05/22/2014 02:53 PM, Borislav Petkov wrote:
>>> From: Borislav Petkov <bp@suse.de>
>>>
>>> So 009f225ef050 ("powercap, intel-rapl: Fix CPU hotplug callback
>>> registration") says how get_/put_online_cpus() should be replaced with
>>> this cpu_notifier_register_begin/_done().
>>>
>>> But they're still there so what's up?
>>>
>>
>> Ok, so I retained that because the comments in the code said that
>> the caller of rapl_cleanup_data() should hold the hotplug lock.
>>
>> Here is the snippet from the patch's changelog:
>>
>>     ...
>>     Fix the intel-rapl code in the powercap driver by using this latter form
>>     of callback registration. But retain the calls to get/put_online_cpus(),
>>     since they also protect the function rapl_cleanup_data(). By nesting
>>     get/put_online_cpus() *inside* cpu_notifier_register_begin/done(), we avoid
>>     the ABBA deadlock possibility mentioned above.
> 
> My bad, I missed that part.
> 
>> But looking closer at the code, I think the only requirement is that
>> rapl_cleanup_data() should be protected against CPU hotplug, and we
>> don't actually need to hold the cpu_hotplug.lock per-se.
> 
> What is the difference between "CPU hotplug" and cpu_hotplug.lock?
> From looking at the code those are two different mutexes with
> cpu_hotplug.lock, i.e. get_online_cpus() having a preemption point.
> 
> And yet, you want to replace get_/put_online_cpus() with
> cpu_notifier_register_begin/_done()

Its not a plain replacement; it is only where both get/put_online_cpus()
as well as notifier-[un]registration is involved. I was trying to overcome
the problems with the existing notifier registration APIs in cpu hotplug,
which were simply impossible to use in a race-free way. But we can certainly
make this much better with a fresh redesign of the whole thing.

I had proposed some other ways of fixing this here:
http://www.kernelhub.org/?msg=26421&p=2

> which is kinda the same thing but
> not really. The one protects against hotplug operations and the other
> protects against cpu hotplug notifier registration.
> 
> Oh, and there's a third one, aliased to the notifier one, which
> is "attempting to serialize the updates to cpu_online_mask &
> cpu_present_mask."
> 
> So why, oh why do we need three? This is absolutely insane. Do we have
> at least one sensible reason why cpu hotplug users should need to know
> all that gunk?
> 

Yeah, its complicated and perhaps we can do much better than that. But I'll
try to explain why there are so many different locks in the existing code.

get/put_online_cpus() uses cpu_hotplug.lock underneath. Although that's just
a mutex, its not used in the usual way (more about that below).

cpu_maps_update_begin(), cpu_notifier_register_begin/done,
register/unregister_cpu_notifier  -- all of these use the cpu_add_remove_lock.

The fundamental difference between these 2 categories is the concurrency
allowed with the lock :-
get_online_cpus() is like a read_lock(). That is, it allows any number
of concurrent CPU hotplug readers (tasks that want to block hotplug), but it
ensures that a writer won't run concurrently with any reader.

Hence, this won't work for notifier registrations because register/unregister
has to _mutate_ the notifier linked-list, and obviously we can't have multiple
tasks trying to do this at the same time. So we need a proper mutex that
allows only 1 task at a time into the critical section. That's why the
cpu_add_remove_lock is used in all the register/unregister paths.

Now, let's look at why the CPU hotplug writer path (the task that actually
does hotplug) takes cpu_add_remove_lock in addition to the cpu_hotplug.lock.
First reason is simple: you don't want tasks that are doing notifier
[un]registrations to race with hotplug. But the second, although subtle reason
is that put_online_cpus() and cpu_hotplug_writer_begin()/done() require that
there is only 1 CPU hotplug writer at a time. The cpu_add_remove_lock provides
this guarantee, since it is taken in the writer path. (The long comment above
cpu_hotplug_begin() mentions this as well).

And then there is powerpc which uses cpu_maps_update_begin/done() to protect
dlpar operations (operations that change the cpu_present_mask etc). But ideally
it should have just used cpu_hotplug_begin() itself, like what driver/acpi/
processor_driver.c does, but then it would have to hold cpu_add_remove_lock
as well, due to the current design :(

That was just me trying to explain the current mess, not justifying it! :-/

I think Oleg had a proposed patch to use per-cpu rwsem in CPU hotplug to
drastically simplify this whole locking scheme. I think we could look at
that again.

Regards,
Srivatsa S. Bhat


