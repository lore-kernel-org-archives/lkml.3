Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3KIPap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:30:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3KIPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:30:41 -0500
Date: Sat, 9 Nov 2013 16:30:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109153034.GB4971@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131109152255.GC26079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109152255.GC26079@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:22:57PM +0100, Frederic Weisbecker wrote:
> > ---
> >  kernel/events/core.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 4dc078d18929..a3ad40f347c4 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -5289,6 +5289,16 @@ static void perf_log_throttle(struct perf_event *event, int enable)
> >  	perf_output_end(&handle);
> >  }
> >  
> > +static inline void perf_pending(struct perf_event *event)
> > +{
> > +	if (in_nmi()) {
> > +		irq_work_pending(&event->pending);
> 
> I guess you mean irq_work_queue()?

Uhm yah

> But there are much more reasons that just being in nmi to async
> wakeups, signal sending, etc...  The fact that an event can happen
> anywhere (rq lock acquire or whatever) makes perf events all fragile
> enough to always require irq work for these.

Fair enough :/

> Probably what we need is rather some limit. Maybe we can't seriously
> apply recursion checks here but perhaps the simple fact that we raise
> an irq work from an irq work should trigger an alarm of some sort.

I think irq_work was designed explicitly to allow this -- Oleg had some
usecase for this.

So my initial approach was trying to detect if there was a fasync signal
pending and break out of the loop in that case; but fasync gives me a
bloody headache.

It looks like you cannot even determine the signum you need to test
pending without acquiring locks, let alone find all the tasks it would
raise it against.


