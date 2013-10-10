Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3JJLNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3JJLNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:13:36 -0400
Date: Thu, 10 Oct 2013 13:06:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131010110616.GA22827@redhat.com>
References: <20131008102505.404025673@infradead.org> <20131008103830.117402375@infradead.org> <20131009224755.09d32206.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009224755.09d32206.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Andrew Morton wrote:
>
> On Tue, 08 Oct 2013 12:25:06 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
>
> > The current implementation of get_online_cpus() is global of nature
> > and thus not suited for any kind of common usage.
> >
> > Re-implement the current recursive r/w cpu hotplug lock such that the
> > read side locks are as light as possible.
> >
> > The current cpu hotplug lock is entirely reader biased; but since
> > readers are expensive there aren't a lot of them about and writer
> > starvation isn't a particular problem.
> >
> > However by making the reader side more usable there is a fair chance
> > it will get used more and thus the starvation issue becomes a real
> > possibility.
> >
> > Therefore this new implementation is fair, alternating readers and
> > writers; this however requires per-task state to allow the reader
> > recursion.
>
> Obvious question: can't we adapt lglocks for this?  It would need the
> counter in task_struct to permit reader nesting, but what else is
> needed?

Unlikely. If nothing else, get_online_cpus() is might_sleep().

But we can joing this with percpu_rw_semaphore (and I am going to try
to do this). Ignoring the counter in task_struct this is the same thing,
but get_online_cpus() is also optimized for the case when the writer
is pending (percpu_down_read() uses down_read() in this case).

Oleg.

