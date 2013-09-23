Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3IWPWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:22:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3IWPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:22:44 -0400
Date: Mon, 23 Sep 2013 17:22:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923152223.GZ9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
 <20130923145446.GX9326@twins.programming.kicks-ass.net>
 <20130923111303.04b99db8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923111303.04b99db8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:13:03AM -0400, Steven Rostedt wrote:
> Well, the point I was trying to do was to let readers go very fast
> (well, with a mb instead of a mutex), and then when the CPU hotplug
> happens, it goes back to the current method.

Well, for that the thing Oleg proposed works just fine and the
preempt_disable() section vs synchronize_sched() is hardly magic.

But I'd really like to get the writer pending case fast too.

> That is, once we set __cpuhp_write, and then run synchronize_srcu(),
> the system will be in a state that does what it does today (grabbing
> mutexes, and upping refcounts).

Still no point in using srcu for this; preempt_disable +
synchronize_sched() is similar and much faster -- its the rcu_sched
equivalent of what you propose.

> I thought the whole point was to speed up the get_online_cpus() when no
> hotplug is happening. This does that, and is rather simple. It only
> gets slow when hotplug is in effect.

No, well, it also gets slow when a hotplug is pending, which can be
quite a while if we go sprinkle get_online_cpus() all over the place and
the machine is busy.

One we start a hotplug attempt we must wait for all readers to quiesce
-- since the lock is full reader preference this can take an infinite
amount of time -- while we're waiting for this all 4k+ CPUs will be
bouncing the one mutex around on every get_online_cpus(); of which we'll
have many since that's the entire point of making them cheap, to use
more of them.
