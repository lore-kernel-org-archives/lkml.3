Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaLVTRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:17:47 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:50485 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbaLVTRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:17:45 -0500
Date: Mon, 22 Dec 2014 21:14:52 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>, Davidlohr Bueso <dave@stgolabs.net>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, dave@stgolabs.net,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm: NULL ptr deref in unlink_file_vma
Message-ID: <20141222191452.GA20295@node.dhcp.inet.fi>
References: <549832E2.8060609@oracle.com>
 <20141222180102.GA8072@node.dhcp.inet.fi>
 <54985D59.5010506@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54985D59.5010506@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 01:05:13PM -0500, Sasha Levin wrote:
> On 12/22/2014 01:01 PM, Kirill A. Shutemov wrote:
> > On Mon, Dec 22, 2014 at 10:04:02AM -0500, Sasha Levin wrote:
> >> > Hi all,
> >> > 
> >> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> > kernel, I've stumbled on the following spew:
> >> > 
> >> > [  432.376425] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> >> > [  432.378876] IP: down_write (./arch/x86/include/asm/rwsem.h:105 ./arch/x86/include/asm/rwsem.h:121 kernel/locking/rwsem.c:71)
> > Looks like vma->vm_file->mapping is NULL. Somebody freed ->vm_file from
> > under us?
> > 
> > I suspect Davidlohr's patchset on i_mmap_lock, but I cannot find any code
> > path which could lead to the crash.
> 
> I've reported a different issue which that patchset: https://lkml.org/lkml/2014/12/9/741
> 
> I guess it could be related?

Maybe.

Other thing:

 unmap_mapping_range()
   i_mmap_lock_read(mapping);
   unmap_mapping_range_tree()
     unmap_mapping_range_vma()
       zap_page_range_single()
         unmap_single_vma()
	   untrack_pfn()
	     vma->vm_flags &= ~VM_PAT;

It seems we modify ->vm_flags without mmap_sem taken, means we can corrupt
them.

Sasha could you check if you hit untrack_pfn()?

The problem probably was hidden by exclusive i_mmap_lock on
unmap_mapping_range(), but it's not exclusive anymore afrer Dave's
patchset.

Konstantin, you've modified untrack_pfn() back in 2012 to change
->vm_flags. Any coments?

For now, I would propose to revert the commit and probably re-introduce it
after v3.19:

>From 14392c69fcfeeda34eb9f75d983dad32698cdd5c Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 22 Dec 2014 21:01:54 +0200
Subject: [PATCH] Revert "mm/memory.c: share the i_mmap_rwsem"

This reverts commit c8475d144abb1e62958cc5ec281d2a9e161c1946.

There are several[1][2] of bug reports which points to this commit as potential
cause[3].

Let's revert it until we figure out what's going on.

[1] https://lkml.org/lkml/2014/11/14/342
[2] https://lkml.org/lkml/2014/12/22/213
[3] https://lkml.org/lkml/2014/12/9/741

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 649e7d440bd7..ca920d1fd314 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2378,12 +2378,12 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 
 
-	i_mmap_lock_read(mapping);
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	i_mmap_unlock_read(mapping);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
 Kirill A. Shutemov
