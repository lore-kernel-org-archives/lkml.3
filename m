Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JBPSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:18:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3JBPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:17:58 -0400
Date: Wed, 2 Oct 2013 17:17:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131002151734.GT3081@twins.programming.kicks-ass.net>
References: <7632387.20FXkuCITr@vostro.rjw.lan>
 <524B0233.8070203@linux.vnet.ibm.com>
 <20131001173615.GW3657@laptop.programming.kicks-ass.net>
 <20131001174508.GA17411@redhat.com>
 <20131001175640.GQ15690@laptop.programming.kicks-ass.net>
 <20131001180750.GA18261@redhat.com>
 <20131002090859.GE12926@twins.programming.kicks-ass.net>
 <20131002121356.GA21581@redhat.com>
 <20131002133137.GG28601@twins.programming.kicks-ass.net>
 <20131002140020.GA25256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002140020.GA25256@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:00:20PM +0200, Oleg Nesterov wrote:
> And again, even
> 
> 	for (;;) {
> 		percpu_down_write();
> 		percpu_up_write();
> 	}
> 
> should not completely block the readers.

Sure there's a tiny window, but don't forget that a reader will have to
wait for the gp_state cacheline to transfer to shared state and the
per-cpu refcount cachelines to be brought back into exclusive mode and
the above can be aggressive enough that by that time we'll observe
state == blocked again.

So I don't think that in practise a reader will get in.

Also, since the write side is exposed to userspace; you've got an
effective DoS.

So I'll stick to waitcount -- as you can see in the patches I've just
posted.
