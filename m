Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3JRGwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:52:12 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50395 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3JRGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:52:10 -0400
Date: Fri, 18 Oct 2013 08:52:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
Message-ID: <20131018065206.GA17512@gmail.com>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
 <1380753493.11046.82.camel@schen9-DESK>
 <20131003073212.GC5775@gmail.com>
 <1381186674.11046.105.camel@schen9-DESK>
 <20131009061551.GD7664@gmail.com>
 <1381336441.11046.128.camel@schen9-DESK>
 <20131010075444.GD17990@gmail.com>
 <1381882156.11046.178.camel@schen9-DESK>
 <20131016065526.GB22509@gmail.com>
 <1381960530.11046.200.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381960530.11046.200.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> 
> > 
> > It would be _really_ nice to stick this into tools/perf/bench/ as:
> > 
> > 	perf bench mem pagefaults
> > 
> > or so, with a number of parallelism and workload patterns. See 
> > tools/perf/bench/numa.c for a couple of workload generators - although 
> > those are not page fault intense.
> > 
> > So that future generations can run all these tests too and such.
> > 
> > > I compare the throughput where I have the complete rwsem patchset 
> > > against vanilla and the case where I take out the optimistic spin patch.  
> > > I have increased the run time by 10x from my pervious experiments and do 
> > > 10 runs for each case.  The standard deviation is ~1.5% so any changes 
> > > under 1.5% is statistically significant.
> > > 
> > > % change in throughput vs the vanilla kernel.
> > > Threads	all	No-optspin
> > > 1		+0.4%	-0.1%
> > > 2		+2.0%	+0.2%
> > > 3		+1.1%	+1.5%
> > > 4		-0.5%	-1.4%
> > > 5		-0.1%	-0.1%
> > > 10		+2.2%	-1.2%
> > > 20		+237.3%	-2.3%
> > > 40		+548.1%	+0.3%
> > 
> > The tail is impressive. The early parts are important as well, but it's 
> > really hard to tell the significance of the early portion without having 
> > an sttdev column.
> > 
> > ( "perf stat --repeat N" will give you sttdev output, in handy percentage 
> >   form. )
> 
> Quick naive question as I haven't hacked perf bench before.  

Btw., please use tip:master, I've got a few cleanups in there that should 
make it easier to hack.

> Now perf stat gives the statistics of the performance counter or events.
> How do I get it to compute the stats of 
> the throughput reported by perf bench?

What I do is that I measure the execution time, via:

  perf stat --null --repeat 10 perf bench ...

instead of relying on benchmark output.

> Something like
> 
> perf stat -r 10 -- perf bench mm memset --iterations 10
> 
> doesn't quite give what I need.

Yeha. So, perf bench also has a 'simple' output format:

  comet:~/tip> perf bench -f simple sched pipe
  10.378

We could extend 'perf stat' with an option to not measure time, but to 
take any numeric data output from the executed task and use that as the 
measurement result.

If you'd be interested in such a feature I can give it a try.

Thanks,

	Ingo
