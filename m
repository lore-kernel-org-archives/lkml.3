Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3GDJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3GDJ1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:27:44 -0400
Date: Thu, 4 Jul 2013 10:27:41 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mm: numa: Scan pages with elevated page_mapcount
Message-ID: <20130704092741.GM1875@suse.de>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-13-git-send-email-mgorman@suse.de>
 <20130703183517.GC18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130703183517.GC18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:35:17PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 03, 2013 at 03:21:39PM +0100, Mel Gorman wrote:
> > Initial support for automatic NUMA balancing was unable to distinguish
> > between false shared versus private pages except by ignoring pages with an
> > elevated page_mapcount entirely. This patch kicks away the training wheels
> > as initial support for identifying shared/private pages is now in place.
> > Note that the patch still leaves shared, file-backed in VM_EXEC vmas in
> > place guessing that these are shared library pages. Migrating them are
> > likely to be of major benefit as generally the expectation would be that
> > these are read-shared between caches and that iTLB and iCache pressure is
> > generally low.
> 
> This reminds me; there a clause in task_numa_work() that skips 'small' VMAs. I
> don't see the point of that.
> 

It was a stupid hack initially to keep scan rates down and it was on the
TODO list to get rid of it and replace it with something else. I'll just
get rid of it for now without the replacement. Patch looks like this.

---8<---
sched: Remove check that skips small VMAs

task_numa_work skips small VMAs. At the time the logic was to reduce the
scanning overhead which was considerable. It is a dubious hack at best. It
would make much more sense to cache where faults have been observed and
only rescan those regions during subsequent PTE scans. Remove this hack
as motivation to do it properly in the future.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3d34c6e..921265b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1075,10 +1075,6 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma))
 			continue;
 
-		/* Skip small VMAs. They are not likely to be of relevance */
-		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
-			continue;
-
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
