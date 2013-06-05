Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3FENgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:36:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FENg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:36:29 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SF8-ipd7Fh4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=cu63OdLxYnwA:10 a=ZcvYF0MA5qH1lrMarkoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370439386.9844.12.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 05 Jun 2013 09:36:26 -0400
In-Reply-To: <20130605115147.GF8923@twins.programming.kicks-ass.net>
References: <1369785676.15552.55.camel@gandalf.local.home>
	 <20130605115147.GF8923@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:51 +0200, Peter Zijlstra wrote:

> > @@ -456,9 +471,13 @@ static int __unregister_ftrace_function(
> >  	/*
> >  	 * Dynamic ops may be freed, we must make sure that all
> >  	 * callers are done before leaving this function.
> > +	 *
> > +	 * Again, normal synchronize_sched() is not good enough.
> > +	 * We need to do a hard force of sched synchronization.
> >  	 */
> >  	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
> > -		synchronize_sched();
> > +		schedule_on_each_cpu(ftrace_sync);
> > +
> >  
> >  	return 0;
> >  }
> > 
> 
> So what happens if schedule_on_each_cpu() returns -ENOMEM? :-)

Hah! I was thinking the same thing when I wrote it, but as this was just
an RFC, I wanted to hear more about this current approach before adding
more.

I was going to also add something like this:

	if (schedule_on_each_cpu(ftrace_sync) < 0) {
		/*
		 * Crap, memory pressure caused this to fail.
		 * Do a synchronize_sched() and then a msleep().
		 * The race that  fails synchronize_sched() is really small
		 * and a msleep() should clear it (but not guaranteed like
		 * a schedule_on_each_cpu() does).
		 */
		synchronize_sched();
		msleep(5);
	}

-- Steve


