Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaBEUde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:33:34 -0500
Received: from mail.efficios.com ([78.47.125.74]:57395 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860AbaBEUdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:33:31 -0500
Date: Wed, 5 Feb 2014 20:33:25 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de, Heinz Egger <Heinz.Egger@linutronix.de>,
        bigeasy@linutronix.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <1797612812.19896.1391632405880.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140205080518.GF2936@laptop.programming.kicks-ass.net>
References: <104831840.19303.1391553779700.JavaMail.zimbra@efficios.com> <238497929.19329.1391554584871.JavaMail.zimbra@efficios.com> <20140205080518.GF2936@laptop.programming.kicks-ass.net>
Subject: Re: Perf user-space ABI sequence lock memory barriers
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.201.126.139]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF26 (Linux)/8.0.5_GA_5839)
Thread-Topic: Perf user-space ABI sequence lock memory barriers
Thread-Index: HtNimyKIa5rUrO8nj5hxa5jl/1kSqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Peter Zijlstra" <peterz@infradead.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: tglx@linutronix.de, "Heinz Egger" <Heinz.Egger@linutronix.de>, bigeasy@linutronix.de, "Linux Kernel Mailing List"
> <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@kernel.org>, "rostedt" <rostedt@goodmis.org>, "Paul E.
> McKenney" <paulmck@linux.vnet.ibm.com>
> Sent: Wednesday, February 5, 2014 3:05:18 AM
> Subject: Re: Perf user-space ABI sequence lock memory barriers
> 
> On Tue, Feb 04, 2014 at 10:56:24PM +0000, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I'm currently integrating user-space performance counters from
> > Perf into LTTng-UST, and I'm noticing something odd regarding
> > the home-made sequence lock found at:
> > 
> > kernel/events/core.c: perf_event_update_userpage()
> > 
> >         ++userpg->lock;
> >         barrier();
> > [...]
> >         barrier();
> >         ++userpg->lock;
> > 
> > This goes in pair with something like this at user-level:
> > 
> >         do {
> >                 seq = pc->lock;
> 
> You could make that:
> 
> 		while ((seq = pc->lock) & 1);

Ah, yes, although since as you describe, the data structure
is per-thread, there would be no need to do this.

> 
> >                 barrier();
> > 
> >                 idx = pc->index;
> >                 count = pc->offset;
> >                 if (idx)
> >                         count += rdpmc(idx - 1);
> > 
> >                 barrier();
> >         } while (pc->lock != seq);
> > 
> > As we see, only compiler barrier() are protecting all this.
> > First question, is it possible that the update be performed
> > by a thread running on a different CPU than the thread reading
> > the info in user-space ?
> 
> You can make that so, but that is not a 'supported' case. This all
> assumes you're monitoring yourself, in which case the event is ran on
> the cpu you are running on too and the updates are matched on cpu, or
> separated by schedule() which includes the required memory barriers to
> make it appear its all on the same cpu anyway.
> 
> > I would be tempted to use a volatile semantic on all reads of the
> > lock field (ACCESS_ONCE()).
> 
> Since its all separated by the compiler barrier all the reads should be
> contained and the compiler is not allowed to re-read once outside.
> 
> So I don't see the point of volatile/ACCESS_ONCE here.
> 
> You could make an argument for ACCESS_ONCE(pc->lock) though.

Yes, this is what I meant, but I'm not sure it's absolutely required.

> 
> > Secondly, read sequence locks usually use a
> > smp_rmb() at the end of the seqcount_begin(), and at the beginning
> > of the seqcount_retry(). Moreover, this is usually matched
> > by smp_wmb() in write_seqcount begin/end().
> 
> Given this is all for self-monitoring and hard assuming the event runs
> on the same cpu, smp barriers are pointless.
> 
> > Am I missing something special about this lock that makes these
> > barriers unnecessary ?
> 
> The self-monitoring aspect perhaps? But there's a NOTE in struct
> perf_event_mmap_page() that's rather a dead give-away on that though.

The one things that confused me in the note:

         * NOTE: for obvious reason this only works on self-monitoring
         *       processes.

is the use of the word "process" for a user-space API, when it actually
means "thread" in user-space semantic. Yes, I must have been doing too much
userland stuff lately. ;-)

Thanks for the clarification,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
