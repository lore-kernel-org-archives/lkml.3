Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3HUScP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:32:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HUScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:32:13 -0400
Date: Wed, 21 Aug 2013 20:31:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821183157.GE31370@twins.programming.kicks-ass.net>
References: <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <52138BE9.5090005@linux.intel.com>
 <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
 <20130821124849.GB31370@twins.programming.kicks-ass.net>
 <20130821170927.GA15838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821170927.GA15838@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 07:09:27PM +0200, Oleg Nesterov wrote:
> So, unlike me, you like -02 more than -Os ;)

I haven't checked the actual flags they enable in a while, but I think I
prefer something in the middle.

Esp. -freorder-blocks and the various -falign flags are something you
really want with -Os.

> > +static inline long schedule_timeout(long timeout)
> > +{
> > +	if (timeout == MAX_SCHEDULE_TIMEOUT) {
> > +		schedule();
> > +		return timeout;
> > +	}
> > +	return __schedule_timeout(timeout);
> > +}
> 
> Well this means that every caller will do the MAX_SCHEDULE_TIMEOUT
> check inline, and this case is unlikely. 

OK, so do not remove the MAX_SCHEDULE_TIMEOUT check from
__schedule_timeout() and change the above to:

static __always_inline long schedule_timeout(long timeout)
{
	if (__builtin_constant_p(timeout) && timeout == MAX_SCHEDULE_TIMEOUT) {
		schedule();
		return timeout;
	}
	return __schedule_timeout(timeout);
}

That should avoid extra code generation for the runtime sites while
still allowing what we set out to do.
