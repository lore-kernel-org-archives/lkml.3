Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaCYTQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:16:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaCYTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:16:33 -0400
Message-ID: <5331D5DD.5090105@oracle.com>
Date: Tue, 25 Mar 2014 13:15:41 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com> <8761n25ckg.fsf@x220.int.ebiederm.org>
In-Reply-To: <8761n25ckg.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 12:59 PM, ebiederm@xmission.com wrote:
> Khalid Aziz <khalid.aziz@oracle.com> writes:
>
>> This patch adds a way for a thread to request additional timeslice from
>> the scheduler if it is about to be preempted, so it could complete any
>> critical task it is in the middle of. .......
>
>
> Let me see if I understand the problem.  Your simulated application has
> a ridiculous number of threads (1000) all contending for a single lock
> with fairly long lock hold times between 600 and 20000 clocks assuming
> no cache line misses.  So 1000 threads contending for about 10usec or
> 1/100 of a tick when HZ=1000.  Giving  you something like 1 chance in
> 100 of being preempted while holding the lock.  With 1000 threads
> those sound like pretty bad odds.

This problem does not happen because threads are holding the lock for 
too long, rather it happens when a thread does a large number of things 
in its loop and one small part of it requires it to hold a lock. So it 
holds the lock for a very short time but what can happen is thread is 
executing in non-critical section of its loop, it finally gets to the 
critical section just as its timeslice is about to end, it grabs the 
lock and is pre-empted right away. Now we start building a convoy of 
threads that want the same lock. This problem can be avoided if the 
locking thread could be given additional time to complete its critical 
section, release the lock and yield the processor if it indeed was 
granted amnesty by the scheduler.

>
> Either your test program is a serious exageration of what your userspace
> is doing or this looks like an application design problem.

If you are referring to the test I included in the patch, that test is 
designed to exaggerate this problem just so it could test the 
functionality. It is nothing more than a test for this functionality so 
we can test for any regressions in future.

>
> I am sorry no number of kernel patches can fix a stupid userspace
> application, and what is worse it looks like this approach will make
> the situation worse for applications that aren't stupid.  Because they
> will now suffer from much less predictability in how long they have to
> wait for the cpu.

New code in scheduler kicks in only for the threads that have explicitly 
asked kernel to use this functionality by sending it the address of a 
shared memory location. There is a very quick bail out at the top of new 
resched routine to check for this and not affect every thread.

>
> Maybe if this was limited to a cooperating set of userspace
> tasks/threads this might not be too bad.  As this exists I have users
> who would hunt me down with malicious intent if this code ever showed up
> on our servers, because it would make life for every other application
> on the server worse.
>

Yes, it is indeed limited to a cooperating set of userspace 
tasks/threads. Tasks/threads will explicitly choose to use this feature. 
It is a no-op for every one else.

> The only two sane versions of this I can see are (a) having the
> scheduler write the predicted next preemption time into the vdso page so
> your thread can yield preemptively before taking the lock if it doesn't
> look like it has enough time,

This was discussed as an option when I posted first version of this 
patch and dismissed due to lack of reliability of such a data.

> or (b) limiting this to just a small
> cooperating set of threads in a single cgroup.

and that is almost what this patch does. It is not limited to a cgroup, 
rather to the tasks/threads that ask to use this feature.

>
> As you have not limited the effects of this patch and as this will make
> latencies worse for every other program on a system I think this is a
> horrible approach.  This really is not something you can do unless all
> of the threads that could be affected are in the same code base, which
> is definitely not the case here.
>
> So for the general horrible idea.
> Nacked-With-Extreme-Prejudice-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Cooperative multitasking sucked in Windows 3.1 and it would be much
> worse now.  Please stop the crazy.  Linux is challenging enough to
> comprehend as it is, and I can't possibly see this patch makes anything
> more predictable.
>
> Eric
>

I completely agree with you on cooperative multitasking. I am definitely 
not trying to do anything like that.

Thanks,
Khalid

