Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JHJ7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:59:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3JHJ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:59:39 -0400
Date: Tue, 8 Oct 2013 11:59:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo.kernel.org@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131008095927.GS3081@twins.programming.kicks-ass.net>
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
 <20131005080416.GA25193@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005080416.GA25193@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 10:04:16AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Oct 04, 2013 at 10:44:05PM +0200, Peter Zijlstra wrote:
> > > 
> > > slightly related; do we want to do something like the following two
> > > patches?
> > 
> > and
> 
> Yeah, both look good to me - but I'd move them into 
> kernel/sched/completion.c and kernel/sched/wait.c if no-one objects.

Do you also want to suck in semaphore.c mutex.c rwsem.c spinlock.c etc?
Or do you want to create something like kernel/locking/ for all that.

I don't really mind too much either way except that I think that wait.c
and completion.c on their own make for a somewhat random split or
primitives.

> > --- /dev/null
> > +++ b/kernel/completion.c
> > @@ -0,0 +1,287 @@
> > +
> > +#include <linux/sched.h>
> > +#include <linux/completion.h>
> 
> Also, mind adding a small blurb at the top explaining what it's all about? 
> Just one sentence or two.

It got a bit longer:

+/*
+ * Generic wait-for-completion handler;
+ *
+ * It differs from semaphores in that their default case is the opposite,
+ * wait_for_completion default blocks whereas semaphore default non-block. The
+ * interface also makes it easy to 'complete' multiple waiting threads,
+ * something which isn't entirely natural for semaphores.
+ *
+ * But more importantly, the primitive documents the usage. Semaphores would
+ * typically be used for exclusion which gives rise to priority inversion.
+ * Waiting for completion is a typically sync point, but not an exclusion point.
+ */
