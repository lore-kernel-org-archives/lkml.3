Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab3HMWNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:13:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:37392 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab3HMWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:13:53 -0400
Message-ID: <520AAF9C.1050702@tilera.com>
Date: Tue, 13 Aug 2013 18:13:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
References: <5202CEAA.9040204@linux.vnet.ibm.com> <201308072335.r77NZZwl022494@farm-0012.internal.tilera.com> <20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org> <52099187.80301@tilera.com> <20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org> <20130813201958.GA28996@mtj.dyndns.org> <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org> <520A9E4A.2050203@tilera.com> <20130813141329.c55deccf462f3ad49129bbca@linux-foundation.org>
In-Reply-To: <20130813141329.c55deccf462f3ad49129bbca@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2013 5:13 PM, Andrew Morton wrote:
> On Tue, 13 Aug 2013 16:59:54 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:
>
>>> Then again, why does this patchset exist?  It's a performance
>>> optimisation so presumably someone cares.  But not enough to perform
>>> actual measurements :(
>> The patchset exists because of the difference between zero overhead on
>> cpus that don't have drainable lrus, and non-zero overhead.  This turns
>> out to be important on workloads where nohz cores are handling 10 Gb
>> traffic in userspace and really, really don't want to be interrupted,
>> or they drop packets on the floor.
> But what is the effect of the patchset?  Has it been tested against the
> problematic workload(s)?

Yes.  The result is that syscalls such as mlockall(), which otherwise interrupt
every core, don't interrupt the cores that are running purely in userspace.
Since they are purely in userspace they don't have any drainable pagevecs,
so the patchset means they don't get interrupted and don't drop packets.

I implemented this against Linux 2.6.38 and our home-grown version of nohz
cpusets back in July 2012, and we have been shipping it to customers since then.

>>>> the logical thing to do
>>>> would be pre-allocating per-cpu buffers instead of depending on
>>>> dynamic allocation.  Do the invocations need to be stackable?
>>> schedule_on_each_cpu() calls should if course happen concurrently, and
>>> there's the question of whether we wish to permit async
>>> schedule_on_each_cpu().  Leaving the calling CPU twiddling thumbs until
>>> everyone has finished is pretty sad if the caller doesn't want that.
>>>
>>>>> That being said, the `cpumask_var_t mask' which was added to
>>>>> lru_add_drain_all() is unneeded - it's just a temporary storage which
>>>>> can be eliminated by creating a schedule_on_each_cpu_cond() or whatever
>>>>> which is passed a function pointer of type `bool (*call_needed)(int
>>>>> cpu, void *data)'.
>>>> I'd really like to avoid that.  Decision callbacks tend to get abused
>>>> quite often and it's rather sad to do that because cpumask cannot be
>>>> prepared and passed around.  Can't it just preallocate all necessary
>>>> resources?
>>> I don't recall seeing such abuse.  It's a very common and powerful
>>> tool, and not implementing it because some dummy may abuse it weakens
>>> the API for all non-dummies.  That allocation is simply unneeded.
>> The problem with a callback version is that it's not clear that
>> it helps with Andrew's original concern about allocation.  In
>> schedule_on_each_cpu() we need to track which cpus we scheduled work
>> on so that we can flush_work() after all the work has been scheduled.
>> Even with a callback approach, we'd still end up wanting to record
>> the results of the callback in the first pass so that we could
>> properly flush_work() on the second pass.  Given that, having the
>> caller just create the cpumask in the first place makes more sense.
> Nope.  schedule_on_each_cpu() can just continue to do
>
> 	for_each_cpu(cpu, mask)
> 		flush_work(per_cpu_ptr(works, cpu));
>
> lru_add_drain_all() can do that as well.  An optimisation would be to
> tag the unused works as not-needing-flush.  Set work.entry,next to
> NULL, for example.

Good point - we already have a per-cpu data structure sitting there
handy, so we might as well use it rather than allocating another cpumask.

>> As Andrew suggests, we could also just have an asynchronous version
>> of schedule_on_each_cpu(), but I don't know if that's beneficial
>> enough to the swap code to make it worthwhile, or if it's tricky
>> enough on the workqueue side to make it not worthwhile; it does seem
>> like we would need to rethink the work_struct allocation, and
>> e.g. avoid re-issuing the flush to a cpu that hadn't finished the
>> previous flush, etc.  Potentially tricky, particularly if
>> lru_add_drain_all() doesn't care about performance in the first place.
> lru_add_drain_all() wants synchronous behavior.  I don't know how much
> call there would be for an async schedule_on_each_cpu_cond().

Let me work up a patchset using callbacks, and we can look at that as
an example and see how it feels for both workqueue.c and swap.c. 

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

