Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3GPBkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:40:49 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:43736 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3GPBks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:40:48 -0400
Message-ID: <51E4A491.8030201@hp.com>
Date: Mon, 15 Jul 2013 21:40:33 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 01/12] spinlock: A new lockref structure for lockless
 update of refcount
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <1373035656-40600-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307051911110.32106@ionos.tec.linutronix.de> <51DACADF.4000802@hp.com> <alpine.DEB.2.02.1307151612090.11918@ionos.tec.linutronix.de> <51E468A4.3030605@hp.com> <alpine.DEB.2.02.1307160109490.11918@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307160109490.11918@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 07:47 PM, Thomas Gleixner wrote:
> On Mon, 15 Jul 2013, Waiman Long wrote:
>> On 07/15/2013 10:41 AM, Thomas Gleixner wrote:
>>> On Mon, 8 Jul 2013, Waiman Long wrote:
>>> Sigh. GENERIC means, that you use the generic implementation, ARCH
>>> means the architecture has a private implementation of that code.
>>>
>>> The generic implementation can use arch specific includes and if there
>>> is none we simply fallback to the asm-generic one.
>> I used the ARCH+GENERIC to mean using the generic code but with arch specific
>> include.
> And what's the point of that? I just explained it to you that you do
> not need the ARCH=y and GENERIC=y at all.

As I said in my previous mail, I can remove the ARCH+GENERIC option.

>>>    >   Let's start with a simple version because it IS simple and easy
>>>>> to analyze and debug and then incrementally build improvements on it
>>>>> instead of creating an heuristics monster in the first place, i.e.:
>>>>>
>>>>>       if (!spin_is_locked(&lr->lock)&&    try_cmpxchg_once(lr))
>>>>>          return 0;
>>>>>       return 1;
>>>>>
>>>>> Take numbers for this on a zoo of different machines: Intel and AMD,
>>>>> old and new.
>>>>>
>>>>> Then you can add an incremental patch on that, which add loops and
>>>>> hoops. Along with numbers on the same zoo of machines.
>>>> I originally tried to do a cmpxchg without waiting and there was
>>>> practically no performance gain. I believe that as soon as
>>> Well, you did not see a difference on your particular machine. Still
>>> we don't have an idea how all of this works on a set of different
>>> machines. There is a world beside 8 socket servers.
>> I understand that. I can live with try_cmpxchg_once, though doing it
>> twice will give a slightly better performance. However, without
> I asked you several times now to explain and document the whole thing
> with numbers instead of your handwaving "slightly better performance"
> arguments.

I will provide performance data for 1 and 2 retries in my next patch 
version.

>
>> waiting for the lock to be free, this patch won't do much good. To
>> keep it simple, I can remove the ability to do customization while
>> doing cmpxchg once and wait until the lock is free. Please let me
>> know if this is acceptable to you.
> No, it's not acceptable at all if you are not able to provide data for
> 1,2,4,8 socket machines (from single core to your precious big
> boxes). It's that simple. We are not accepting patches which optimize
> for a single use case and might negatively affect 99,9999% of the
> existing users which have no access to this kind of hardware unless
> proven otherwise.

I did provide performance data for 1,2,4 and 8 socket configurations in 
my commit message. I used numactl to simulate different socket 
configuration by forcing the code to use only a subset of total number 
of sockets. I know that is not ideal, but I think it should be close 
enough. I will provide performance data on a more common 2 socket test 
machine that I have.

Yes, I don't provide data for single-thread use case. I will also 
provide that data in my next version by measuring the average time for 
doing low-level reference count update using lock and lockless update 
like what I had done for the qrwlock patch. For single thread case, I 
don't believe any real workload will show any appreciable difference in 
performance due to the differing reference count update mechanisms.

>>> Also what's the approach to tune that? Running some random testbench
>>> and monitor the results for various settings?
>>>
>>> If that's the case we better have a that as variables with generic
>>> initial values in the code, which can be modified by sysctl.
>> As I said above, I can remove the customization. I may reintroduce user
>> customization using sysctl as you suggested in the a follow up patch after
>> this one is merged.
> And I asked for a step by step approach in the first review, but you
> decided to ignore that. And now you think that it's accetable for you
> as long as you get what you want. That's not the way it works, really.

I am trying to provide what you are asking for while at the same time 
meet my own need.

>>>>>> +		getnstimeofday(&tv2);
>>>>>> +		ns = (tv2.tv_sec - tv1.tv_sec) * NSEC_PER_SEC +
>>>>>> +		     (tv2.tv_nsec - tv1.tv_nsec);
>>>>>> +		pr_info("lockref wait loop time = %lu ns\n", ns);
>>>>> Using getnstimeofday() for timestamping and spamming the logs with
>>>>> printouts? You can't be serious about that?
>>>>>
> q>  >  >  >  Thats what tracepoints are for. Tracing is the only way to get proper
>>>>> numbers which take preemption, interrupts etc. into account without
>>>>> hurting runtime performace.
>>>> The _SHOW_WAIT_LOOP_TIME is for debugging and instrumentation purpose only
>>>> during development cycle. It is not supposed to be turned on at production
>>>> system. I will document that in the code.
>>> No, no, no! Again: That's what tracepoints are for.
>>>
>>> This kind of debugging is completely pointless. Tracepoints are
>>> designed to be low overhead and can be enabled on production
>>> systems.
>>>
>>> Your debugging depends on slow timestamps against CLOCK_REALTIME and
>>> an even slower output via printk. How useful is that if you want to
>>> really instrument the behaviour of this code?
>> This code is not critical and I can certainly remove it.
> Did you even try to understand what I wrote? I did not ask you to
> remove instrumentation. I asked you to use useful instrumentation
> instead of some totally useless crap.

I am not that familiar with using the tracepoints instrumentation for 
timing measurement. I will try to use that in the code for that purpose.

Regards,
Longman
