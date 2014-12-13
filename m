Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784AbaLMHgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 02:36:44 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48366 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbaLMHgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 02:36:42 -0500
Date: Sat, 13 Dec 2014 08:36:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Fix lost reschedule in __cond_resched()
Message-ID: <20141213073634.GD32572@gmail.com>
References: <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'm also not sure if the bug ever happens with preemption 
> disabled. Sasha, was that you who reported that you cannot 
> reproduce it without preemption? It strikes me that there's a 
> race condition in __cond_resched() wrt preemption, for example: 
> we do
> 
>         __preempt_count_add(PREEMPT_ACTIVE);
>         __schedule();
>         __preempt_count_sub(PREEMPT_ACTIVE);
> 
> and in between the __schedule() and __preempt_count_sub(), if 
> an interrupt comes in and wakes up some important process, it 
> won't reschedule (because preemption is active), but then we 
> enable preemption again and don't check whether we should 
> reschedule (again), and we just go on our merry ways.

Indeed, that's a really good find regardless of whether it's the 
source of these lockups - the (untested) patch below ought to 
cure that.

> Now, I don't see how that could really matter for a long time - 
> returning to user space will check need_resched, and sleeping 
> will obviously force a reschedule anyway, so these kinds of 
> races should at most delay things by just a tiny amount, but 
> maybe there is some case where we screw up in a bigger way. So 
> I do *not* believe that the one in __cond_resched() matters, 
> but I'm giving it as an example of the kind of things that 
> could go wrong.

(as you later note) NOHZ is somewhat special in this regard, 
because there we try really hard not to run anything 
periodically, so a lost reschedule will matter more.

But ... I'd be surprised if this patch made a difference: it 
should normally not be possible to go idle with tasks on the 
runqueue (even with this bug present), and with at least one busy 
task on the CPU we get the regular scheduler tick which ought to 
hide such latencies.

It's nevertheless a good thing to fix, I'm just not sure it's the 
root cause of the observed lockup here.

Thanks,

	Ingo

--

Reported-by: Linus Torvalds <torvalds@linux-foundation.org> 

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bb398c0c5f08..532809aa0544 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4207,6 +4207,8 @@ static void __cond_resched(void)
 	__preempt_count_add(PREEMPT_ACTIVE);
 	__schedule();
 	__preempt_count_sub(PREEMPT_ACTIVE);
+	if (need_resched())
+		__schedule();
 }
 
 int __sched _cond_resched(void)
