Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaBZIz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:55:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38236 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBZIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:55:27 -0500
Date: Wed, 26 Feb 2014 09:55:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: per-thread vma caching
Message-ID: <20140226085518.GI3104@twins.programming.kicks-ass.net>
References: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
 <20140226085048.GE18404@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226085048.GE18404@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:50:48AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 25, 2014 at 10:16:46AM -0800, Davidlohr Bueso wrote:
> > +void vmacache_invalidate_all(void)
> > +{
> > +	struct task_struct *g, *p;
> > +
> > +	rcu_read_lock();
> > +	for_each_process_thread(g, p) {
> > +		/*
> > +		 * Only flush the vmacache pointers as the
> > +		 * mm seqnum is already set and curr's will
> > +		 * be set upon invalidation when the next
> > +		 * lookup is done.
> > +		 */
> > +		memset(p->vmacache, 0, sizeof(p->vmacache));
> > +	}
> > +	rcu_read_unlock();
> > +}
> 
> With all the things being said on this particular piece already; I
> wanted to add that the iteration there is incomplete; we can clone()
> using CLONE_VM without using CLONE_THREAD.
> 
> Its not common, but it can be done. In that case the above iteration
> will miss a task that shares the same mm.

Bugger; n/m that. I just spotted that it's yet another way to iterate
all tasks in the system.

Of course we need multiple macros to do this :/

Pretty horrifically expensive though.
