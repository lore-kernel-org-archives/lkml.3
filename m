Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaEUVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:34:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:42081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaEUVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:34:02 -0400
Date: Wed, 21 May 2014 23:33:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] mm: filemap: Avoid unnecessary barries and waitqueue
 lookups in unlock_page fastpath v5
Message-ID: <20140521213354.GL2485@laptop.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
 <20140513125313.GR23991@suse.de>
 <20140513141748.GD2485@laptop.programming.kicks-ass.net>
 <20140514161152.GA2615@redhat.com>
 <20140514192945.GA10830@redhat.com>
 <20140515104808.GF23991@suse.de>
 <20140515142414.16c47315a03160c58ceb9066@linux-foundation.org>
 <20140521121501.GT23991@suse.de>
 <20140521142622.049d0b3af5fc94912d5a1472@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521142622.049d0b3af5fc94912d5a1472@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:26:22PM -0700, Andrew Morton wrote:
> > +static inline void
> > +__prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait,
> > +			struct page *page, int state, bool exclusive)
> 
> Putting MM stuff into core waitqueue code is rather bad.  I really
> don't know how I'm going to explain this to my family.

Right, so we could avoid all that and make the functions in mm/filemap.c
rather large and opencode a bunch of wait.c stuff.

Which is pretty much what I initially pseudo proposed.

> > +		__ClearPageWaiters(page);
> 
> We're freeing the page - if someone is still waiting on it then we have
> a huge bug?  It's the mysterious collision thing again I hope?

Yeah, so we only clear that bit when at 'unlock' we find there are no
more pending waiters, so if the last unlock still had a waiter, we'll
leave the bit set. So its entirely reasonable to still have it set when
we free a page etc..
