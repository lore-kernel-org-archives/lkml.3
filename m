Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3I1ArA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:47:00 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19526 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3I1Aq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:46:58 -0400
Message-ID: <524626F1.6010104@hp.com>
Date: Fri, 27 Sep 2013 20:46:41 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com> <5245DD4E.60009@hurleysoftware.com>
In-Reply-To: <5245DD4E.60009@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 03:32 PM, Peter Hurley wrote:
> On 09/27/2013 03:00 PM, Waiman Long wrote:
>> With the 3.12-rc2 kernel, there is sizable spinlock contention on
>> the rwsem wakeup code path when running AIM7's high_systime workload
>> on a 8-socket 80-core DL980 (HT off) as reported by perf:
>>
>>    7.64%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
>>               |--41.77%-- rwsem_wake
>>    1.61%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irq
>>               |--92.37%-- rwsem_down_write_failed
>>
>> That was 4.7% of recorded CPU cycles.
>>
>> On a large NUMA machine, it is entirely possible that a fairly large
>> number of threads are queuing up in the ticket spinlock queue to do
>> the wakeup operation. In fact, only one will be needed.  This patch
>> tries to reduce spinlock contention by doing just that.
>>
>> A new wakeup field is added to the rwsem structure. This field is
>> set on entry to rwsem_wake() and __rwsem_do_wake() to mark that a
>> thread is pending to do the wakeup call. It is cleared on exit from
>> those functions.
>>
>> By checking if the wakeup flag is set, a thread can exit rwsem_wake()
>> immediately if another thread is pending to do the wakeup instead of
>> waiting to get the spinlock and find out that nothing need to be done.
>
> This will leave readers stranded if a former writer is in __rwsem_do_wake
> to wake up the readers and another writer steals the lock, but before
> the former writer exits without having woken up the readers, the locking
> stealing writer drops the lock and sees the wakeup flag is set, so
> doesn't bother to wake the readers.
>
> Regards,
> Peter Hurley
>

Yes, you are right. That can be a problem. Thank for pointing this out. 
The workloads that I used doesn't seem to exercise the readers. I will 
modify the patch to add code handle this failure case by resetting the 
wakeup flag, pushing it out and then retrying one more time to get the 
read lock. I  think that should address the problem.

Regards,
Longman
