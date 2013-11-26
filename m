Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3KZCQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:16:32 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41927 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3KZCQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:16:30 -0500
Date: Mon, 25 Nov 2013 21:15:46 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/9] mm: thrash detection-based file cache sizing
Message-ID: <20131126021546.GW3556@cmpxchg.org>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-8-git-send-email-hannes@cmpxchg.org>
 <20131125155011.2f1320ab422436b1204bd15e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125155011.2f1320ab422436b1204bd15e@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:50:11PM -0800, Andrew Morton wrote:
> On Sun, 24 Nov 2013 18:38:26 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > ...
> >
> > + *		Access frequency and refault distance
> > + *
> > + * A workload is trashing when its pages are frequently used but they
> > + * are evicted from the inactive list every time before another access
> > + * would have promoted them to the active list.
> > + *
> > + * In cases where the average access distance between thrashing pages
> > + * is bigger than the size of memory there is nothing that can be
> > + * done - the thrashing set could never fit into memory under any
> > + * circumstance.
> > + *
> > + * However, the average access distance could be bigger than the
> > + * inactive list, yet smaller than the size of memory.  In this case,
> > + * the set could fit into memory if it weren't for the currently
> > + * active pages - which may be used more, hopefully less frequently:
> > + *
> > + *      +-memory available to cache-+
> > + *      |                           |
> > + *      +-inactive------+-active----+
> > + *  a b | c d e f g h i | J K L M N |
> > + *      +---------------+-----------+
> 
> So making the inactive list smaller will worsen this problem?

Only if the inactive list size is a factor in detecting repeatedly
used pages.  This patch series is all about removing that dependency
and using non-residency information to cover that deficit a small
inactive list would otherwise create.

> If so, don't we have a conflict with this objective:
> 
> > Right now we have a fixed ratio (50:50) between inactive and active
> > list but we already have complaints about working sets exceeding half
> > of memory being pushed out of the cache by simple streaming in the
> > background.  Ultimately, we want to adjust this ratio and allow for a
> > much smaller inactive list.

No, this IS the objective.  The patches get us there by being able to
detect repeated references with an arbitrary inactive list size.

> > + * It is prohibitively expensive to accurately track access frequency
> > + * of pages.  But a reasonable approximation can be made to measure
> > + * thrashing on the inactive list, after which refaulting pages can be
> > + * activated optimistically to compete with the existing active pages.
> > + *
> > + * Approximating inactive page access frequency - Observations:
> > + *
> > + * 1. When a page is accesed for the first time, it is added to the
> 
> "accessed"

Whoopsa :-)  Will fix that up.
