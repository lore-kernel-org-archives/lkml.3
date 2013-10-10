Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3JJRNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:13:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57941 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755389Ab3JJRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:13:08 -0400
Date: Thu, 10 Oct 2013 13:13:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010131305.58558079@gandalf.local.home>
In-Reply-To: <20131010165337.GT3081@twins.programming.kicks-ass.net>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 18:53:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Oct 10, 2013 at 09:43:55AM -0700, Andrew Morton wrote:
> > > But we would like to remove stomp machine from
> > > CPU hotplug.
> > 
> > We do?  That's news.  It wasn't mentioned in the changelog and should
> > have been.  Why?  
> 
> It would be an unrelated change to this and unrelated to the reasons as
> to why I want a faster get_online_cpus().

Yeah, sorry for the confusion. My comment wasn't really about this
change set but about stop machine and hotplug in general. Needing stop
machine for hotplug has been a complaint by many, but off topic for
this particular change set.

> 
> > > Why prevent all CPUs from running when we want to remove
> > > one?
> > 
> > So get_online_cpus() goes away.  Nothing is more scalable than nothing!
> 
> Very much agreed; now stop_machine() wouldn't actually work for hotplug
> because it will instantly preempt everybody, including someone who might
> be in the middle of using per-cpu state of the cpu we're about to
> remove.

Well, stop machine doesn't instantly preempt everybody. Only those that
don't have preemption disabled. Using per_cpu without preemption
disabled can be dangerous. Except for the migrate disable we want to
add for -rt. Then we can't rely on migrate disable and stop machine
making sure per_cpu data isn't being used. Oh, and for threads that use
per_cpu that are bound to a CPU. But then they need to be taken care of
too for their CPU going off line.

But this would also require the "get_online_cpu()s" to disable
preemption as well. Not quite a "nothing" we are looking for.


-- Steve
