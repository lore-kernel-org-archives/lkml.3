Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaCYViX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:38:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48639 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaCYViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:38:21 -0400
Message-ID: <5331F716.30906@oracle.com>
Date: Tue, 25 Mar 2014 15:37:26 -0600
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
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>	<8761n25ckg.fsf@x220.int.ebiederm.org> <5331D5DD.5090105@oracle.com> <87y4zyrpfb.fsf@x220.int.ebiederm.org>
In-Reply-To: <87y4zyrpfb.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 02:31 PM, ebiederm@xmission.com wrote:
>> Yes, it is indeed limited to a cooperating set of userspace
>> tasks/threads. Tasks/threads will explicitly choose to use this feature. It is a
>> no-op for every one else.
>
> It is absolutely not a no-op for me if my task can't be scheduled soon
> enough because your task executed sched-prempt.
>
> It means my latency goes up and the *random bad thing* will happen
> because I missed my deadline because I was not scheduled fast enough.
>

This patch changes only CFS, so SCHED_RR and SCHED_FIFO are not affected 
by this change. Does CFS ever guarantee that any task will be scheduled 
fast enough to meet its critical deadline? Shouldn't a system that 
requires guarantees to meet deadline use SCHED_FIFO or SCHED_RR? Even if 
a task that has an important deadline to meet and is ready to run, it 
can be denied processor time simply based upon which other tasks are 
ready to run, how long they have run previously and what their 
priorities are. I don't see how CFS can guarantee temporal determinism 
other than every task will get a chance to run in a finite time period. 
Please do correct me if my understanding of CFS is flawed.

Any task that asks for extension of its current timeslice will get 
charged this additional time in p->se.vruntime and cause it to move to 
the right on rbtree. This amounts to a task borrowing time from its 
future runtime as opposed to being able to get more processor time than 
others.

>>> or (b) limiting this to just a small
>>> cooperating set of threads in a single cgroup.
>>
>> and that is almost what this patch does. It is not limited to a cgroup, rather
>> to the tasks/threads that ask to use this feature.
>
> Except you do not appear to be considering what could be scheduled in
> your tasks place.
>
> You allow any task to extend it's timeslice.

Would you recommend a policy that determines which tasks are allowed to 
extend their timeslice?

>
> Which means I will get the question why does why does
> really_important_job only miss it's latency guarantees when running on
> the same box as sched_preempt_using_job?

I would expect a system that requires latency guarantees to be designed 
using SCHED_FIFO or SCHED_RR, not SCHED_OTHER.

Hope this makes sense.

Thanks,
Khalid


