Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3JJOzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:55:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53747 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3JJOzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:55:50 -0400
Date: Thu, 10 Oct 2013 07:55:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131010145532.GK5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102505.404025673@infradead.org>
 <20131008103830.117402375@infradead.org>
 <20131009224755.09d32206.akpm@linux-foundation.org>
 <20131010110616.GA22827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010110616.GA22827@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101014-3532-0000-0000-00000210C5E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 01:06:16PM +0200, Oleg Nesterov wrote:
> On 10/09, Andrew Morton wrote:
> >
> > On Tue, 08 Oct 2013 12:25:06 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > The current implementation of get_online_cpus() is global of nature
> > > and thus not suited for any kind of common usage.
> > >
> > > Re-implement the current recursive r/w cpu hotplug lock such that the
> > > read side locks are as light as possible.
> > >
> > > The current cpu hotplug lock is entirely reader biased; but since
> > > readers are expensive there aren't a lot of them about and writer
> > > starvation isn't a particular problem.
> > >
> > > However by making the reader side more usable there is a fair chance
> > > it will get used more and thus the starvation issue becomes a real
> > > possibility.
> > >
> > > Therefore this new implementation is fair, alternating readers and
> > > writers; this however requires per-task state to allow the reader
> > > recursion.
> >
> > Obvious question: can't we adapt lglocks for this?  It would need the
> > counter in task_struct to permit reader nesting, but what else is
> > needed?
> 
> Unlikely. If nothing else, get_online_cpus() is might_sleep().
> 
> But we can joing this with percpu_rw_semaphore (and I am going to try
> to do this). Ignoring the counter in task_struct this is the same thing,
> but get_online_cpus() is also optimized for the case when the writer
> is pending (percpu_down_read() uses down_read() in this case).

To Andrew's overall question, I believe that by the time we apply
this in the various places where it can help, it will have simplified
things a bit -- and made them faster and more scalable.

							Thanx, Paul

