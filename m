Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKEBAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:00:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKEBAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:00:00 -0500
Message-ID: <1415149183.6673.12.camel@linux-t7sj.site>
Subject: Re: [PATCH 10/10] mm/hugetlb: share the i_mmap_rwsem
From: Davidlohr Bueso <dave@stgolabs.net>
To: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 04 Nov 2014 16:59:43 -0800
In-Reply-To: <alpine.LSU.2.11.1411032208390.15596@eggly.anvils>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
	 <1414697657-1678-11-git-send-email-dave@stgolabs.net>
	 <alpine.LSU.2.11.1411032208390.15596@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 22:35 -0800, Hugh Dickins wrote:
> On Thu, 30 Oct 2014, Davidlohr Bueso wrote:
> 
> > The i_mmap_rwsem protects shared pages against races
> > when doing the sharing and unsharing, ultimately
> > calling huge_pmd_share/unshare() for PMD pages --
> > it also needs it to avoid races when populating the pud
> > for pmd allocation when looking for a shareable pmd page
> > for hugetlb. Ultimately the interval tree remains intact.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
>                                                 linux.intel.com
> 
> I'm uncomfortable with this one: I'm certainly not prepared to Ack it;
> but that could easily be that I'm just not thinking hard enough - I'd
> rather leave the heavy thinking to someone else!
> 
> The fs/hugetlbfs/inode.c part of it should be okay, but the rest is
> iffy.  It gets into huge page table sharing territory, which is very
> tricky and surprising territory indeed (take a look at my
> __unmap_hugepage_range_final() comment, for one example).
> 
> You're right that the interval tree remains intact, but I've a feeling
> we end up using i_mmap_mutex for more exclusion than just that (rather
> like how huge_memory.c finds anon_vma lock useful for other exclusions).

Yeah, that certainly wouldn't surprise me, and this particular patch was
the one I was most unsure about for that exact same reason. Hopefully
others could confirm if this is truly doable and safe.

> I think Mel (already Cc'ed) and Michal (adding him) both have past
> experience with the shared page table (as do I, but I'm in denial).
> 
> I wonder if the huge shared page table would be a good next target
> for Kirill's removal of mm nastiness.  (Removing it wouldn't hurt
> Google for one: we have it "#if 0"ed out, though I forget why at
> this moment.)
> 
> But, returning to the fs/hugetlbfs/inode.c part of it, that reminds
> me: you're missing one patch from the series, aren't you?  Why no
> i_mmap_lock_read() in mm/memory.c unmap_mapping_range()?  I doubt
> it will add much useful parallelism, but it would be correct.

Oh yes, not sure why I didn't update that function, I had it marked it
safe to share the lock. Thanks for taking a close look at the series.

8<------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 11/10] mm/memory.c: share the i_mmap_rwsem

The unmap_mapping_range family of functions do the unmapping
of user pages (ultimately via zap_page_range_single) without
touching the actual interval tree, thus share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2ca3105..06f2458 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2396,12 +2396,12 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
1.8.4.5



