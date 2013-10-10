Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3JJSeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:34:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46453 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3JJSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:34:23 -0400
Date: Thu, 10 Oct 2013 20:34:09 +0200
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
Message-ID: <20131010183409.GP13848@laptop.programming.kicks-ass.net>
References: <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:48:56AM -0700, Andrew Morton wrote:
> > > Very much agreed; now stop_machine() wouldn't actually work for hotplug
> > > because it will instantly preempt everybody, including someone who might
> > > be in the middle of using per-cpu state of the cpu we're about to
> > > remove.
> > 
> > Well, stop machine doesn't instantly preempt everybody. Only those that
> > don't have preemption disabled. Using per_cpu without preemption
> > disabled can be dangerous.

Can be, but there's more of that around than you want. Also that's not
the entire issue.

> Yes, I'd have thought that the cases where a CPU is fiddling with
> another CPU's percpu data with preemption enabled would be rather rare.

Look at kernel/events/core.c:swevent_hlist_get() it does something like:

  get_online_cpus();
  for_each_online_cpu() {
  	allocate_hash_table();
  }
  put_online_cpus();

Surely you don't want to do that with preemption disabled?

But my point is that even though there aren't many of these today; with
the growing number of cpus in 'commodity' hardware you want to move away
from using preempt_disable() as hotplug lock.
