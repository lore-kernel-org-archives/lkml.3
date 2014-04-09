Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaDIMuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:50:20 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35520 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbaDIMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140407181736.GA4106@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
 <20140404160328.GA10042@localhost.localdomain> <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
 <20140405100813.GA16696@localhost.localdomain> <CAK1hOcO2X7juCSkKrd85q8_i8Xv4vhZg2YKtzybwmWukoCEyow@mail.gmail.com>
 <20140407181736.GA4106@localhost.localdomain>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 9 Apr 2014 14:49:55 +0200
Message-ID: <CAK1hOcPjTxUaUjKYngpgsxY0yN-xNnGH7CVxPqjB4jb8r=Z74w@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 8:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> The following example displays all the nonsense of that stat:
>
>     CPU 0                     CPU 1
>
>     task A block on IO        ...
>     task B runs for 1 min     ...
>     task A completes IO
>
> So in the above we've been waiting on IO for 1 minute. But none of that
> have been accounted.

If there is task B which can put CPU to use while task A
waits for IO, then *system performance is not IO bound*.


> OTOH if task B were to run on CPU 1 (it could have,
> really here this is about scheduler load balancing internals, hence pure
> randomness for the user), the iowait time would have been accounted.

Case A: overall system stats are: 50% busy, 50% idle
Case B: overall system stats are: 50% busy, 50% iowait

You are right, this does not look correct.

Lets step back and look at the situation from a high-level POV.
I believe I have a solution for this problem.

Let's say we have a heavily loaded file server machine where CPUs
are busy only 5% of the time. It makes sense to say that machine
as a whole is "95% waiting for IO".

Our existing accounting did exactly that for single-CPU machines.

But for, say, 2-CPU machine it can show 5% busy, 45% iowait, 50% idle
if there is only one task reading files, or 5% busy, 95% iowait
if there are more than one task.

But it's wrong! NONE of the CPUs are "idle" as long as there even
one task blocked on IO. The machine is still IO-bound, not idling.
In my example, it should not matter whether the machine has one
or 64 CPUs, it should show 5% busy, 95% iowait overall state
in both cases.

Does the above make sense to you?

My proposal is to count each CPU's time towards iowait
if there are task(s) blocked on IO, *regardless on which
runqueue they are*. Only if there are none, then time
is counted towards idle.


> I doubt that users are interested in such random accounting. They want
> to know either:
>
> 1) how much time was spent waiting on IO by the whole system

Hmm, I think I just said the same thing :)

> 2) how much time was spent waiting on IO per task
> 3) how much time was spent waiting on IO per CPU that initiated
>    IOs, or per CPU which ran task completing IOs. In order to have
>    an overview on where these mostly happened.

Some people may want to know these things, and I am not objecting
to adding whatever counters to help with that.

-- 
vda
