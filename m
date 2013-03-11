Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3CKQip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:38:45 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:40894 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3CKQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130311073908.GA9988@gmail.com>
References: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
	<20130309082650.GA9944@gmail.com>
	<CAFTL4hxt5y2hdh0_LNA-08+jNTYwkjeg=QHBfgNf_X_XCHie1w@mail.gmail.com>
	<20130311073908.GA9988@gmail.com>
Date: Mon, 11 Mar 2013 17:38:42 +0100
Message-ID: <CAFTL4hwezns_BvdV5zQLZes4cGTzRNkx9+8u-aBJa=KAApUx-g@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.9-rc1-nohz1
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/11 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> >  - Please outline how the current TODO entries affect upstream
>> >    mergability. Does it reduce the 'full'-ness of this dynticks mode?
>> >    Outright buggy behavior? Other trade-offs?
>>
>> Mostly this is about upstream features that won't be working with the current
>> state of the art: enqueuing a posix cpu timer on a nohz CPU may result in it being
>> ignored by the target due to the lack of ticking until expiration, perf events may
>> not be round-robined, etc... I'll make sure to document all these items.
>
> So it's "buggy behavior of existing features" it appears?

Right.

> It would be really useful to add some sort of 'make it safe easily' mechanism:
>
>  - if a posix timer is enqueued on a CPU, then the CPU should have a timer ticking
>
>  - if perf events are active on a CPU, then it should have a timer ticking
>
> this would make it mergable, as most of the time systems don't have any of these
> facilities active. Plus this dynticks-off mechanism would also allow us to cover any
> other (still unknown) facility that regresses. So it would be nice to have that
> option.

Yeah that's how I intended to solve the issue for these cases. I don't
worry that much about posix cpu timers and perf in fact. These should
be not hard to cope with. I'm more worried about scheduler details in
scheduler_tick().

I covered the rq clock and a part of update_cpu_load_active().

Now we have yet to care about sched_avg_update(),
calc_load_account_active() and sched_class::task_tick() to make sure
we are not letting something behind. There is rq->rt_avg that seem to
be used for load balancing when rt tasks are around. Then
calc_load_update. Idle load balancing is concerned as well. I haven't
looked deeply into these places so I don't know what can be shortcut
or not there.

> Later on we could gradually eliminate these limitations. It would also be apparent
> where they are, just from grepping the source.
>
> If that's done, and if it tests fine for a few weeks then this could be v3.10
> material IMO.

Ok, I won't be that optimistic about the release time but things are
certainly going to be faster now. I'm going to reshape and send you
what I have now then we'll have a fresher view of the rest.
