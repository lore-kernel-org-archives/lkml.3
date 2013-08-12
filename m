Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3HLQBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:01:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52715 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab3HLQBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:01:50 -0400
Date: Mon, 12 Aug 2013 12:00:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] mm: thrash detection-based file cache sizing
Message-ID: <20130812160059.GQ715@cmpxchg.org>
References: <1375829050-12654-1-git-send-email-hannes@cmpxchg.org>
 <1375829050-12654-9-git-send-email-hannes@cmpxchg.org>
 <20130809154943.1663e5f04999e1979886246c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809154943.1663e5f04999e1979886246c@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:49:43PM -0700, Andrew Morton wrote:
> On Tue,  6 Aug 2013 18:44:09 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > To accomplish this, a per-zone counter is increased every time a page
> > is evicted and a snapshot of that counter is stored as shadow entry in
> > the page's now empty page cache radix tree slot.
> 
> How do you handle wraparound of that counter on 32-bit machines?

The distance between two time stamps is an unsigned subtraction, so
it's accurate even when the counter has wrapped between them.

The per-zone counter lapping shadow entries is possible but not very
likely because the shadow pages are reclaimed when more than
2*global_dirtyable_memory() of them exist.  And usually they are
refaulted or reclaimed along with the inode before that happens.

There is an unlikely case where some shadow entries make it into an
inode and then that same inode is evicting and refaulting pages in
another area, which increases the counter while not producing an
excess of shadow entries.  Should the counter lap these inactive
shadow entries, the worst case is that a refault will incorrectly
interpret them as recently evicted and deactivate a page for every
such entry.  Which would at worst be a "regression" to how the code
was for a long time, where every reclaim run also always deactivated
some pages.
