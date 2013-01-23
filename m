Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3AWP6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:58:17 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:43962 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3AWP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:58:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130110122621.GA13629@redhat.com>
References: <20130107113144.GA7544@redhat.com>
	<20130109183248.GA8293@somewhere.redhat.com>
	<20130110122621.GA13629@redhat.com>
Date: Wed, 23 Jan 2013 16:58:14 +0100
Message-ID: <CAFTL4hy9akOVvR=9erBx+4DzKS0x0D69vtVz0TO3op9+PH=euA@mail.gmail.com>
Subject: Re: [PATCH v2 repost] sched: cputime: avoid multiplication overflow
 (in common cases)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/10 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Wed, Jan 09, 2013 at 07:33:03PM +0100, Frederic Weisbecker wrote:
>> On Mon, Jan 07, 2013 at 12:31:45PM +0100, Stanislaw Gruszka wrote:
>> > We scale stime, utime values based on rtime (sum_exec_runtime converted
>> > to jiffies). During scaling we multiple rtime * utime, what seems to be
>> > fine, since both values are converted to u64, but is not.
>> >
>> > Let assume HZ is 1000 - 1ms tick. Process consist of 64 threads, run
>> > for 1 day, threads utilize 100% cpu on user space. Machine has 64 cpus.
>> >
>> > Process rtime = utime will be 64 * 24 * 60 * 60 * 1000 jiffies, what is
>> > 0x149970000. Multiplication rtime * utime result is 0x1a855771100000000,
>> > which can not be covered in 64 bits.
>> >
>> > Result of overflow is stall of utime values visible in user space
>> > (prev_utime in kernel), even if application still consume lot of CPU
>> > time.
>> >
>> > Probably good fix for the problem, will be using 128 bit variable and
>> > proper mul128 and div_u128_u64 primitives. While mul128 is on it's
>> > way to kernel, there is no 128 bit division yet. I'm not sure, if we
>> > want to add it to kernel. Perhaps we could also change the way how
>> > stime and utime are calculated, but I don't know how, so I come with
>> > the below solution for the problem.
>> >
>> > To avoid overflow patch change value we scale to min(stime, utime). This
>> > is more like workaround, but will work for processes, which perform
>> > mostly on user space or mostly on kernel space. Unfortunately processes,
>> > which perform on kernel and user space equally, and additionally utilize
>> > lot of CPU time, still will hit this overflow pretty quickly. However
>> > such processes seems to be uncommon.
>> >
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>
>> I can easily imagine that overflow to happen with user time on intensive
>> CPU bound loads, or may be guests.
>>
>> But can we easily reach the same for system time? Even on intensive I/O bound
>> loads we shouldn't spend that much time in the kernel. Most of it probably goes
>> to idle.
>>
>> What do you think?
>
> I think you are right :-)
>
>> If that assumption is right in most cases, the following patch should solve the
>> issue:
>
> I'm fine with this patch, it achives the same effect as my patch, but is simpler.

Cool! So I can add your acked-by, right? I'll send this patch to Ingo soon.

Thanks!
