Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaDWTAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:00:04 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:48091 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbaDWTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140415105138.GO11096@twins.programming.kicks-ass.net>
References: <1396469872-14877-1-git-send-email-dvlasenk@redhat.com>
 <1396469872-14877-2-git-send-email-dvlasenk@redhat.com> <20140415105138.GO11096@twins.programming.kicks-ass.net>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 23 Apr 2014 20:59:40 +0200
Message-ID: <CAK1hOcMu2ECy086oFSUsprejQZ9u=0noAFAA8_tUBUPoNOwoTA@mail.gmail.com>
Subject: Re: [PATCH 2/2] nohz: Synchronize sleep time stats with memory barriers
To: Peter Zijlstra <peterz@infradead.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 02, 2014 at 10:17:52PM +0200, Denys Vlasenko wrote:
>> When some call site uses get_cpu_*_time_us() to read a sleeptime
>> stat, it deduces the total sleeptime by adding the pending time
>> to the last sleeptime snapshot if the CPU target is idle.
>>
>> But this only works if idle_sleeptime, idle_entrytime and idle_active are
>> read and updated under some disciplined order.
>>
>> This patch changes updaters to modify idle_entrytime,
>> {idle,iowait}_sleeptime, and idle_active exactly in this order,
>> with write barriers on SMP to ensure other CPUs see then in this order too.
>> Readers are changed read them in the opposite order, with read barriers.
>> When readers detect a race by seeing cleared idle_entrytime,
>> they retry the reads.
>>
>> The "iowait-ness" of every idle period is decided at the moment it starts:
>> if this CPU's run-queue had tasks waiting on I/O, then this idle
>> period's duration will be added to iowait_sleeptime.
>> This, along with proper SMP syncronization, fixes the bug where iowait
>> counts could go backwards.
>
> It also makes for a near infinite source of iowait. Who is to say the
> CPU that started with iowait will ever wake up? The nohz sleep time is
> practically unbounded.

Yes, it does that.
I prepared a new patchset which fixes that.

It also addresses your other points:

>>       /* Updates the per cpu time idle statistics counters */
>>       delta = ktime_sub(now, ts->idle_entrytime);
>> +     ts->idle_entrytime.tv64 = 0;
>
> One must at all times describe the memory ordering and pairing barrier
> in a comment when placing barriers.

Done.

>> +             if (start.tv64 == 0)
>> +                     /* Other CPU is updating the count.
>> +                      * We don't know whether fetched count is valid.
>> +                      */
>> +                     goto again;
>
> This is double wrong; any multi line stmt (even if its a single stmt)
> should have {}. Also, wrong multi line comment style.

Fixed.

> You're not nearly lazy enough; this is a near identical copy of the
> above, two nearly identical copies of 'tricky' code is a bad idea.

True. I was planning to address that, but new logic added
to avoid overcounting iowait made these two functions
not as similar as they used to be.

Please review a newer patchset, I'll send it in a minute.
