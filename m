Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3EVQJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:09:40 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62792 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3EVQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <1369181381.6828.159.camel@gandalf.local.home>
References: <1369158390.6828.148.camel@gandalf.local.home>
	<CAFTL4hwWHqNhF3-iE+kspXO4gWFX81t8Sb30NS6UYxAO_bgG_g@mail.gmail.com>
	<1369181381.6828.159.camel@gandalf.local.home>
Date: Wed, 22 May 2013 18:09:37 +0200
Message-ID: <CAFTL4hwdEM1HxsZ3Q=hnte9b26gv=in8GWHCrzKrLnuT6BXK1g@mail.gmail.com>
Subject: Re: [PATCH][3.10] nohz: Fix lockup on restart from wrong error code
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/22, Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-05-21 at 22:14 +0200, Frederic Weisbecker wrote:
>> 2013/5/21 Steven Rostedt <rostedt@goodmis.org>:
>> > commit a382bf934449 "nohz: Assign timekeeping duty to a CPU outside the
>> > full dynticks range" added a cpu notifier callback that would prevent
>> > the time keeping CPU from going offline if the have_nohz_full_mask was
>> > set.
>> >
>> > This also prevents the CPU from going offline on system reboot.
>> >
>> > Worse yet, the return code was -EINVAL, but the notifier does not
>> > recognize error codes, and it must be wrapped by a
>> > notifier_from_errno()
>> > function. This means that even though the CPU would fail to go down,
>> > the
>> > notifier would think it succeeded, and the cpu down process would
>> > continue.
>> >
>> > This caused two different problems. One, the migration thread after
>> > moving tasks from the CPU would park itself and then a task, namely the
>> > reboot task, could migrate onto that CPU. Then the reboot task spins
>> > waiting for the cpu to go idle. But because the reboot task happens to
>> > be spinning on the cpu its waiting for, the system hangs.
>>
>> Can that happen if that CPU is the boot CPU? Note this is the only
>> possible timekeeper with the upstream code.
>
> Yep it can happen in upstream (that's all I'm using). In
> tick_broadcast_setup_oneshot(), it sets the tick_do_timer_cpu to the
> current CPU, which can be something other than the boot CPU. Now that
> CPU wont be able to be hot plugged.

Ah indeed it can happen on broadcast timer initialization. A secondary
CPU then steal the duty from the boot CPU. Hmm this reminds me of this
patch:  https://patchwork.kernel.org/patch/2302951/
I thought it deserved some attention due its code simplification but
it could also solve the issue.

>>
>> >
>> > The other error that happened was that the sched_domain re-setup would
>> > get confused, and in get_group() the cpu = cpumask_first() would
>> > process
>> > a mask that had nothing set, and return cpu > nr_cpu_ids. Later it
>> > would
>> > reference the per_cpu sg with this CPU and get a bogus pointer and
>> > crash.
>>
>> Ouch, when are we doing this domain re-setup? I remember we
>> repartition the domains after cpu down/up but I don't understand how
>> that can interfere with this issue.
>
> I haven't looked hard enough yet, but this problem only appeared when
> this bug triggered. By telling the system a CPU is offline, but still
> having tasks schedule to it, causes all sorts of weird side effects. I
> haven't figured out in detail how this affected the sched domains, but I
> don't get the sched domain corruption after fixing this bug.

Weird. but the CPU refuses to offline so how could it see itself
online? Anyway if that happen again I'll have a look when I'm fully
back next week.
