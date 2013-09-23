Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3IWQBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:01:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3IWQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:01:54 -0400
Date: Mon, 23 Sep 2013 18:01:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923160130.GC9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
 <20130923145446.GX9326@twins.programming.kicks-ass.net>
 <20130923111303.04b99db8@gandalf.local.home>
 <20130923155059.GO9093@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923155059.GO9093@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 08:50:59AM -0700, Paul E. McKenney wrote:
> Not a problem, just stuff the idx into some per-task thing.  Either
> task_struct or taskinfo will work fine.

Still not seeing the point of using srcu though..

srcu_read_lock() vs synchronize_srcu() is the same but far more
expensive than preempt_disable() vs synchronize_sched().

> Or to put it another way, if the underlying slow-path mutex is
> reader-preference, then the whole thing will be reader-preference.

Right, so 1) we have no such mutex so we're going to have to open-code
that anyway, and 2) like I just explained in the other email, I want the
pending writer case to be _fast_ as well.
