Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3JJGdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:33:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3JJGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:33:31 -0400
Date: Wed, 9 Oct 2013 23:34:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
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
Message-Id: <20131009233419.ea3d0b80.akpm@linux-foundation.org>
In-Reply-To: <20131010062741.GA9999@gmail.com>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010062741.GA9999@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 08:27:41 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 08 Oct 2013 12:25:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > The current cpu hotplug lock is a single global lock; therefore 
> > > excluding hotplug is a very expensive proposition even though it is 
> > > rare occurrence under normal operation.
> > > 
> > > There is a desire for a more light weight implementation of 
> > > {get,put}_online_cpus() from both the NUMA scheduling as well as the 
> > > -RT side.
> > > 
> > > The current hotplug lock is a full reader preference lock -- and thus 
> > > supports reader recursion. However since we're making the read side 
> > > lock much cheaper it is the expectation that it will also be used far 
> > > more. Which in turn would lead to writer starvation.
> > > 
> > > Therefore the new lock proposed is completely fair; albeit somewhat 
> > > expensive on the write side. This in turn means that we need a 
> > > per-task nesting count to support reader recursion.
> > 
> > This is a lot of code and a lot of new complexity.  It needs some pretty 
> > convincing performance numbers to justify its inclusion, no?
> 
> Should be fairly straightforward to test: the sys_sched_getaffinity() and 
> sys_sched_setaffinity() syscalls both make use of 
> get_online_cpus()/put_online_cpus(), so a testcase frobbing affinities on 
> N CPUs in parallel ought to demonstrate scalability improvements pretty 
> nicely.

Well, an in-kernel microbenchmark which camps in a loop doing get/put
would measure this as well.

But neither approach answers the question "how useful is this patchset".
