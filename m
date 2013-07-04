Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3GDKdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:33:44 -0400
Received: from mout.gmx.net ([212.227.17.22]:62834 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GDKdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:33:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+u3F4iM1Cu/OCJGmk1ALxw01hvW7WnEglTDeo3HZ
	OHA4qPwLOEupBb
Message-ID: <1372934013.9046.16.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 04 Jul 2013 12:33:33 +0200
In-Reply-To: <51D5428D.7080805@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <20130702085202.GA23916@twins.programming.kicks-ass.net>
	 <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 17:38 +0800, Michael Wang wrote: 
> On 07/04/2013 05:13 PM, Peter Zijlstra wrote:
> [snip]
> > 
> > Right, but something like the below is limited in cost to at most 32/64 (I
> > forgot the type) shifts. Now its probably not worth doing, but it shows
> > things like that can be done in 'constant' time.
> > 
> >   now = jiffies;
> >   if (now - p->last_switch_decay > 8*sizeof(p->nr_wakee_switch)*HZ) {
> > 	p->nr_wakee_switch = 0;
> > 	p->last_switch_decay = now;
> >   } else while (now > p->last_switch_decay + HZ) {
> > 	p->nr_wakee_switch >>= 1;
> > 	p->last_switch_decay += HZ;
> >   }
> 
> Hmm...interesting, some kind of cataclysm decay, not sure how it works
> but yes, the cost was capped.
> 
> Well, seems like we still have many follow-up research works after fix
> the issue ;-)

Yeah.  Like how to how to exterminate the plus sign, they munch cache
lines, and have a general tendency to negatively impact benchmarks.

Q6600 box, hackbench -l 1000
                                                                       avg
3.10.0-regress     2.293     2.297     2.313     2.291     2.295     2.297     1.000
3.10.0-regressx    2.560     2.524     2.427     2.599     2.602     2.542     1.106

pahole said...

marge:/usr/local/src/kernel/linux-3.x.git # tail virgin
        long unsigned int          timer_slack_ns;       /*  1512     8 */
        long unsigned int          default_timer_slack_ns; /*  1520     8 */
        atomic_t                   ptrace_bp_refcnt;     /*  1528     4 */

        /* size: 1536, cachelines: 24, members: 125 */
        /* sum members: 1509, holes: 6, sum holes: 23 */
        /* bit holes: 1, sum bit holes: 26 bits */
        /* padding: 4 */
        /* paddings: 1, sum paddings: 4 */
};

marge:/usr/local/src/kernel/linux-3.x.git # tail michael
        long unsigned int          default_timer_slack_ns; /*  1552     8 */
        atomic_t                   ptrace_bp_refcnt;     /*  1560     4 */

        /* size: 1568, cachelines: 25, members: 128 */
        /* sum members: 1533, holes: 8, sum holes: 31 */
        /* bit holes: 1, sum bit holes: 26 bits */
        /* padding: 4 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 32 bytes */
};

..but plugging holes, didn't help, moving this/that around neither, nor
did letting pahole go wild to get the line back.  It's plus signs I tell
ya, the evil things must die ;-)

-Mike

