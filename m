Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3FCSMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:12:50 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46352 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab3FCSMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:12:48 -0400
Date: Mon, 3 Jun 2013 14:12:02 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, metin d <metdos@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 10/10] mm: workingset: keep shadow entries in check
Message-ID: <20130603181202.GI15576@cmpxchg.org>
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
 <1369937046-27666-11-git-send-email-hannes@cmpxchg.org>
 <20130603082533.GH5910@twins.programming.kicks-ass.net>
 <20130603152032.GF15576@cmpxchg.org>
 <20130603171558.GE8923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603171558.GE8923@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 07:15:58PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 03, 2013 at 11:20:32AM -0400, Johannes Weiner wrote:
> > On Mon, Jun 03, 2013 at 10:25:33AM +0200, Peter Zijlstra wrote:
> > > On Thu, May 30, 2013 at 02:04:06PM -0400, Johannes Weiner wrote:
> > > > Previously, page cache radix tree nodes were freed after reclaim
> > > > emptied out their page pointers.  But now reclaim stores shadow
> > > > entries in their place, which are only reclaimed when the inodes
> > > > themselves are reclaimed.  This is problematic for bigger files that
> > > > are still in use after they have a significant amount of their cache
> > > > reclaimed, without any of those pages actually refaulting.  The shadow
> > > > entries will just sit there and waste memory.  In the worst case, the
> > > > shadow entries will accumulate until the machine runs out of memory.
> > > > 
> > > 
> > > Can't we simply prune all refault entries that have a distance larger
> > > than the memory size? Then we must assume that no refault entry means
> > > its too old, which I think is a fair assumption.
> > 
> > Two workloads bound to two nodes might not push pages through the LRUs
> > at the same pace, so a distance might be bigger than memory due to the
> > faster moving node, yet still be a hit in the slower moving one.  We
> > can't really know until we evaluate it on a per-zone basis.
> 
> But wasn't patch 1 of this series about making sure each zone is scanned
> proportionally to its size?

Only within any given zonelist.  It's just so that pages used together
are aged fairly.  But if the tasks are isolated from each other their
pages may age at different paces without it being unfair since the
tasks do not contend for the same memory.

> But given that, sure maybe 1 memory size is a bit strict, but surely we
> can put a limit on things at about 2 memory sizes?

That's what this 10/10 patch does (prune everything older than 2 *
global_dirtyable_memory()), so I think we're talking past each other.

Maybe the wording of the changelog was confusing?  The paragraph you
quoted above explains the problem resulting from 9/10 but which this
patch 10/10 fixes.
