Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3JJG1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:27:46 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40384 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3JJG1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:27:45 -0400
Date: Thu, 10 Oct 2013 08:27:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010062741.GA9999@gmail.com>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009225006.7101379c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 08 Oct 2013 12:25:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > The current cpu hotplug lock is a single global lock; therefore 
> > excluding hotplug is a very expensive proposition even though it is 
> > rare occurrence under normal operation.
> > 
> > There is a desire for a more light weight implementation of 
> > {get,put}_online_cpus() from both the NUMA scheduling as well as the 
> > -RT side.
> > 
> > The current hotplug lock is a full reader preference lock -- and thus 
> > supports reader recursion. However since we're making the read side 
> > lock much cheaper it is the expectation that it will also be used far 
> > more. Which in turn would lead to writer starvation.
> > 
> > Therefore the new lock proposed is completely fair; albeit somewhat 
> > expensive on the write side. This in turn means that we need a 
> > per-task nesting count to support reader recursion.
> 
> This is a lot of code and a lot of new complexity.  It needs some pretty 
> convincing performance numbers to justify its inclusion, no?

Should be fairly straightforward to test: the sys_sched_getaffinity() and 
sys_sched_setaffinity() syscalls both make use of 
get_online_cpus()/put_online_cpus(), so a testcase frobbing affinities on 
N CPUs in parallel ought to demonstrate scalability improvements pretty 
nicely.

[ It's not just about affinities: in particular sys_sched_getaffinity() 
  also gets used as a NR_CPUS runtime detection method in apps, so it 
  matters to regular non-affine loads as well. ]

Thanks,

	Ingo
