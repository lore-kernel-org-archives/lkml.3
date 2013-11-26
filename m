Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab3KZWbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:31:24 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42187 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab3KZWbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:31:21 -0500
Date: Tue, 26 Nov 2013 17:30:46 -0500
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
Subject: Re: [patch 0/9] mm: thrash detection-based file cache sizing v6
Message-ID: <20131126223046.GI22729@cmpxchg.org>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <20131125165729.3ad409506fb6db058d88c258@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125165729.3ad409506fb6db058d88c258@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:57:29PM -0800, Andrew Morton wrote:
> On Sun, 24 Nov 2013 18:38:19 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > This series solves the problem by maintaining a history of pages
> > evicted from the inactive list, enabling the VM to detect frequently
> > used pages regardless of inactive list size and facilitate working set
> > transitions.
> 
> It's a very readable patchset - thanks for taking the time to do that.

Thanks.

> > 31 files changed, 1253 insertions(+), 401 deletions(-)
> 
> It's also a *ton* of stuff.  More code complexity, larger kernel data
> structures.  All to address a quite narrow class of workloads on a
> relatively small window of machine sizes.  How on earth do we decide
> whether it's worth doing?

The fileserver-type workload is not that unusual and not really
restricted to certain machine sizes.

But more importantly, these are reasonable workloads for which our
cache management fails completely, and we have no alternative solution
to offer.  What do we tell the people running these loads?

> Also, what's the memcg angle?  This is presently a global thing - do
> you think we're likely to want to make it per-memcg in the future?

Yes, it seemed easier to get the global case working first, but the
whole thing is designed with memcg in mind.  We can encode the unique
cgroup ID in the shadow entries as well and make the inactive_age per
lruvec instead of per-zone.

If space gets tight in the shadow entry (on 32 bit e.g.), instead of
counting every single eviction, we can group evictions into
generations of bigger chunks - the more memory, the less accurate the
refault distance has to be anyway - and can then get away with fewer
bits for the eviction timestamp.
