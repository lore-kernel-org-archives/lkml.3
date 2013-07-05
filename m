Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3GEEI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 00:08:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:63764 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3GEEI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 00:08:56 -0400
Message-ID: <1372997318.7315.23.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Fri, 05 Jul 2013 06:08:38 +0200
In-Reply-To: <51D633DB.5010508@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <20130702085202.GA23916@twins.programming.kicks-ass.net>
	 <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:No5jRwApgE7GbHU/9yEO9in0WGV8ENGeSDb/dkMuGuEhudk8cBw
 hxb8MTwE/iDP0iXe73A6iCShPd7UtQ4SHtEG5feGJXEVICFwfgDCGNcWikdQGhEuFo5zya/
 r6fBngZXqi32WqpdrjF+BuV23UFXUTz/c1caW4r/JR/QTQ482KxN/dqpNnBzLLrWKFgQ2GQ
 cwxFBtYTxGQ+T8PNkXKbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 10:47 +0800, Michael Wang wrote: 
> On 07/04/2013 06:33 PM, Mike Galbraith wrote:
> [snip]
> >> Well, seems like we still have many follow-up research works after fix
> >> the issue ;-)
> > 
> > Yeah.  Like how to how to exterminate the plus sign, they munch cache
> > lines, and have a general tendency to negatively impact benchmarks.
> > 
> > Q6600 box, hackbench -l 1000
> >                                                                        avg
> > 3.10.0-regress     2.293     2.297     2.313     2.291     2.295     2.297     1.000
> > 3.10.0-regressx    2.560     2.524     2.427     2.599     2.602     2.542     1.106
> 
> Wow, I used to think such issue is very hard to be tracked by
> benchmarks, is this regression stable?

Yeah, seems to be.  I was curious as to why you saw an improvement to
hackbench, didn't seem there should be any, so though I'd try it on my
little box on the way to a long weekend.  The unexpected happened.

> > pahole said...
> > 
> > marge:/usr/local/src/kernel/linux-3.x.git # tail virgin
> >         long unsigned int          timer_slack_ns;       /*  1512     8 */
> >         long unsigned int          default_timer_slack_ns; /*  1520     8 */
> >         atomic_t                   ptrace_bp_refcnt;     /*  1528     4 */
> > 
> >         /* size: 1536, cachelines: 24, members: 125 */
> >         /* sum members: 1509, holes: 6, sum holes: 23 */
> >         /* bit holes: 1, sum bit holes: 26 bits */
> >         /* padding: 4 */
> >         /* paddings: 1, sum paddings: 4 */
> > };
> > 
> > marge:/usr/local/src/kernel/linux-3.x.git # tail michael
> >         long unsigned int          default_timer_slack_ns; /*  1552     8 */
> >         atomic_t                   ptrace_bp_refcnt;     /*  1560     4 */
> > 
> >         /* size: 1568, cachelines: 25, members: 128 */
> >         /* sum members: 1533, holes: 8, sum holes: 31 */
> >         /* bit holes: 1, sum bit holes: 26 bits */
> >         /* padding: 4 */
> >         /* paddings: 1, sum paddings: 4 */
> >         /* last cacheline: 32 bytes */
> > };
> > 
> > ..but plugging holes, didn't help, moving this/that around neither, nor
> > did letting pahole go wild to get the line back.  It's plus signs I tell
> > ya, the evil things must die ;-)
> 
> Hmm...so the new members kicked some tail members to a new line...or may
> be totally different when compiler take part in...
> 
> It's really hard to estimate the influence, especially when the
> task_struct is still keep changing...

Yeah, could be memory layout crud that disappears with the next
pull/build.  Wouldn't be the first time.

-Mike

