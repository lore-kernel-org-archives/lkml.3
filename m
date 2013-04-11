Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936338Ab3DKOsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:48:16 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:46571 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3DKOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:48:14 -0400
Message-ID: <5166CC87.5060301@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 20:15:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
References: <20130403193743.GB29151@sgi.com> <20130408155701.GB19974@gmail.com> <5162EC1A.4050204@zytor.com> <20130408165916.GA3672@sgi.com> <20130410111620.GB29752@gmail.com> <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com> <20130411053106.GA9042@drongo> <5166B05E.8010904@linux.vnet.ibm.com> <20130411142301.GB27990@sgi.com>
In-Reply-To: <20130411142301.GB27990@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041114-3864-0000-0000-000007AC4848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 07:53 PM, Russ Anderson wrote:
> On Thu, Apr 11, 2013 at 06:15:18PM +0530, Srivatsa S. Bhat wrote:
>> On 04/11/2013 11:01 AM, Paul Mackerras wrote:
>>> On Wed, Apr 10, 2013 at 08:10:05AM -0700, Linus Torvalds wrote:
>>>> The optimal solution would be to just speed up the
>>>> disable_nonboot_cpus() code so much that it isn't an issue. That would
>>>> be good for suspending too, although I guess suspend isn't a big issue
>>>> if you have a thousand CPU's.
>>>>
>>>> Has anybody checked whether we could do the cpu_down() on non-boot
>>>> CPU's in parallel? Right now we serialize the thing completely, with
>>>
>>> I thought Srivatsa S. Bhat had a patchset that did exactly that.
>>> Srivatsa?
>>>
>>
>> Thanks for the CC, Paul! Adding some more people to CC.
>>
>> Actually, my patchset was about removing stop_machine() from the CPU
>> offline path.
>> http://lwn.net/Articles/538819/
> 
> I certainly agree with the intent.
> 

Thank you!

>> And here is the performance improvement I had measured in the version
>> prior to that:
>> http://article.gmane.org/gmane.linux.kernel/1435249
>>
>> I'm planning to revive this patchset after the 3.10 merge window closes,
>> because it depends on doing a tree-wide sweep, and I think its a little
>> late to do it in time for the upcoming 3.10 merge window itself.
>>
>> Anyway, that's about removing stop_machine from CPU hotplug.
>>
>> Coming to bulk CPU hotplug, yes, I had ideas similar to what Russ suggested.
>> But I believe we can do more than that.
>>
>> As Russ pointed out, the notifiers are not thread-safe, so calling them
>> in parallel with different CPUs as arguments isn't going to work.
>>
>> So, first, we can convert all the CPU hotplug notifiers to take a cpumask
>> instead of a single CPU. So assuming that there are 'n' notifiers in total,
>> the number of function calls would become n, instead of n*1024.
>> But that itself most likely won't give us much benefit over the for-loop
>> that Russ has done in his patch, because it'll simply do longer processing
>> in each of those 'n' notifiers, by iterating over the cpumask inside each
>> notifier.
> 
> As an alternative, how about each cpu have their own notifier list?
> Then one task per cpu can spin through that cpu's notifier list, 
> allowing them to run in parallel.
> 
> I don't know if that would be a faster solution than adding cpumask
> to notifiers, but it my guess is it may.
> 

That might not work out well because those notifiers will have to lock
against each other. That is, notifier callback A cannot run as A(cpuX)
and A(cpuY) in parallel. They will have to serialize themselves, which
will make the whole effort useless. But, as I mentioned earlier, A(cpuX)
and B(cpuX) can run in parallel without additional serialization, if A
and B are completely different callbacks (ie., belonging to different
subsystems).

>> Now comes the interesting thing:
>>
>> Consider a notifier chain that looks like this:
>> Priority 0: A->B->C->D
>>
>> We can't invoke say notifier callback A simultaneously on 2 CPUs with 2
>> different hotcpus as argument. *However*, since A, B, C, D all (more or less)
>> belong to different subsystems, we can call A, B, C and D in parallel on
>> different CPUs. They won't even serialize amongst themselves because they
>> take locks (if any) of different subsystems. And since they are of same
>> priority, the ordering (A after B or B after A) doesn't matter as well.
>>
>> So with this, if we combine the idea I wrote above about giving a cpumask
>> to each of these notifiers to work with, we end up in this:
>>
>> CPU 0          CPU 1          CPU2           ....
>> A(cpumask)     B(cpumask)     C(cpumask)     ....
>>
>> So, for example, the CPU_DOWN_PREPARE notification can be processed in parallel
>> on multiple CPUs at a time, for a given cpumask! That should definitely
>> give us a good speed-up.
>>
>> One more thing we have to note is that, there are 4 notifiers for taking a
>> CPU offline:
>>
>> CPU_DOWN_PREPARE
>> CPU_DYING
>> CPU_DEAD
>> CPU_POST_DEAD
>>
>> The first can be run in parallel as mentioned above. The second is run in
>> parallel in the stop_machine() phase as shown in Russ' patch. But the third
>> and fourth set of notifications all end up running only on CPU0, which will
>> again slow down things.
> 
> In my testing the third and fourth set were a small part of the overall
> time.  Less than 10%, with cpu notifiers 90+% of the time.

*All* of them are cpu notifiers! All of them invoke __cpu_notify() internally.
So how did you differentiate between them and find out that the third and
fourth sets take less time?

>  So you may
> not need the added complexity, or at least fix the cpu notifier part
> first.
> 

To make the 3rd and 4th run fast, the only thing we need to do is take CPUs
offline in smaller steps, like 512, 256 etc.. It doesn't add any extra
complexity over and above what is necessary to make the cpu notifiers run
in parallel in the first place.

Regards,
Srivatsa S. Bhat

