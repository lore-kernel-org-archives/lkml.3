Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3JJQx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:53:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44074 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3JJQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:53:55 -0400
Date: Thu, 10 Oct 2013 18:53:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20131010165337.GT3081@twins.programming.kicks-ass.net>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010094355.6f75e5a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:43:55AM -0700, Andrew Morton wrote:
> > But we would like to remove stomp machine from
> > CPU hotplug.
> 
> We do?  That's news.  It wasn't mentioned in the changelog and should
> have been.  Why?  

It would be an unrelated change to this and unrelated to the reasons as
to why I want a faster get_online_cpus().

> > Why prevent all CPUs from running when we want to remove
> > one?
> 
> So get_online_cpus() goes away.  Nothing is more scalable than nothing!

Very much agreed; now stop_machine() wouldn't actually work for hotplug
because it will instantly preempt everybody, including someone who might
be in the middle of using per-cpu state of the cpu we're about to
remove.

The freeze suggestion from Ingo would actually work because we freeze
tasks at known good points (userspace and kthread_freeze() points) where
we know they're not fiddling with per-cpu state.
