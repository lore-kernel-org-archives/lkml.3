Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaAPSm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:42:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAPSm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:42:57 -0500
Date: Thu, 16 Jan 2014 19:42:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 0/2] preempt: Track unmatched preempt_enable() to
 preempt_disable()
Message-ID: <20140116184251.GA11314@laptop.programming.kicks-ass.net>
References: <20140116171824.748919700@goodmis.org>
 <20140116174536.GB9655@laptop.programming.kicks-ass.net>
 <20140116133906.50bcbc93@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116133906.50bcbc93@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 01:39:06PM -0500, Steven Rostedt wrote:
> On Thu, 16 Jan 2014 18:45:36 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Jan 16, 2014 at 12:18:24PM -0500, Steven Rostedt wrote:
> > 
> > Didn't see anything horrible in there, so fine with me.
> > 
> > Another thing I recently ran into was:
> > 
> >   local_irq_disable();
> >   preempt_disable();
> >   local_irq_enable();
> > 
> >   local_irq_disable();
> >   preempt_enable();
> >   local_irq_enable();
> > 
> > I'm not sure any of our debugging catches that, I meant to extend
> > lockdep, but maybe it could also be hooked into something else.
> 
> Hmm, what's wrong with the above?

Suppose a reschedule interrupt happens in the middle; we set
NEED_RESCHED but won't act because preempt is disabled.

When we hit preempt_enable() we'll call into preempt_schedule() but fail
because preemptible() finds irqs_disabled().

And in the end we do not schedule, but have NEED_RESCHED set.

FAIL.
