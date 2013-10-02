Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3JBRwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:52:42 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48149 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:52:40 -0400
Date: Wed, 2 Oct 2013 10:52:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131002175213.GR5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100217-0928-0000-0000-00000230ADBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:00:20PM +0200, Oleg Nesterov wrote:
> On 10/02, Peter Zijlstra wrote:
> >
> > On Wed, Oct 02, 2013 at 02:13:56PM +0200, Oleg Nesterov wrote:
> > > In short: unless a gp elapses between _exit() and _enter(), the next
> > > _enter() does nothing and avoids synchronize_sched().
> >
> > That does however make the entire scheme entirely writer biased;
> 
> Well, this makes the scheme "a bit more" writer biased, but this is
> exactly what we want in this case.
> 
> We do not block the readers after xxx_exit() entirely, but we do want
> to keep them in SLOW state and avoid the costly SLOW -> FAST -> SLOW
> transitions.

Yes -- should help -a- -lot- for bulk write-side operations, such as
onlining all CPUs at boot time.  ;-)

							Thanx, Paul

> Lets even forget about disable_nonboot_cpus(), lets consider
> percpu_rwsem-like logic "in general".
> 
> Yes, it is heavily optimizied for readers. But if the writers come in
> a batch, or the same writer does down_write + up_write twice or more,
> I think state == FAST is pointless in between (if we can avoid it).
> This is the rare case (the writers should be rare), but if it happens
> it makes sense to optimize the writers too. And again, even
> 
> 	for (;;) {
> 		percpu_down_write();
> 		percpu_up_write();
> 	}
> 
> should not completely block the readers.
> 
> IOW. "turn sync_sched() into call_rcu_sched() in up_write()" is obviously
> a win. If the next down_write/xxx_enter "knows" that the readers are
> still in SLOW mode because gp was not completed yet, why should we
> add the artificial delay?
> 
> As for disable_nonboot_cpus(). You are going to move cpu_hotplug_begin()
> outside of the loop, this is the same thing.
> 
> Oleg.
> 

