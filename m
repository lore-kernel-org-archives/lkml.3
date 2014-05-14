Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaENQM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:12:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaENQMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:12:55 -0400
Date: Wed, 14 May 2014 18:11:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 19/19] mm: filemap: Avoid unnecessary barries and
	waitqueue lookups in unlock_page fastpath
Message-ID: <20140514161152.GA2615@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513141748.GD2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subsequent discussion was "off-topic", and it seems that the patch
itself needs a bit more discussion,

On 05/13, Peter Zijlstra wrote:
>
> On Tue, May 13, 2014 at 01:53:13PM +0100, Mel Gorman wrote:
> > On Tue, May 13, 2014 at 10:45:50AM +0100, Mel Gorman wrote:
> > >  void unlock_page(struct page *page)
> > >  {
> > > +	wait_queue_head_t *wqh = clear_page_waiters(page);
> > > +
> > >  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> > > +
> > > +	/*
> > > +	 * No additional barrier needed due to clear_bit_unlock barriering all updates
> > > +	 * before waking waiters
> > > +	 */
> > >  	clear_bit_unlock(PG_locked, &page->flags);
> > > -	smp_mb__after_clear_bit();
> > > -	wake_up_page(page, PG_locked);
> >
> > This is wrong.

Yes,

> > The smp_mb__after_clear_bit() is still required to ensure
> > that the cleared bit is visible before the wakeup on all architectures.

But note that "the cleared bit is visible before the wakeup" is confusing.
I mean, we do not need mb() before __wake_up(). We need it only because
__wake_up_bit() checks waitqueue_active().


And at least

	fs/cachefiles/namei.c:cachefiles_delete_object()
	fs/block_dev.c:blkdev_get()
	kernel/signal.c:task_clear_jobctl_trapping()
	security/keys/gc.c:key_garbage_collector()

look obviously wrong.

I would be happy to send the fix, but do I need to split it per-file?
Given that it is trivial, perhaps I can send a single patch?

Oleg.

