Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3KTWQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:16:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3KTWQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:16:37 -0500
Date: Wed, 20 Nov 2013 22:16:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [git pull] vfs.git bits and pieces
Message-ID: <20131120221636.GH10323@ZenIV.linux.org.uk>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
 <20131120174712.GG10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120174712.GG10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 05:47:12PM +0000, Al Viro wrote:
> On Wed, Nov 20, 2013 at 05:42:11PM +0000, Al Viro wrote:
> > [Apologies for delay; I'd spent the last day hunting down something that
> > turned out to be a VM leak completely unrelated to this stuff - it's
> > present in mainline, for starters.  Unreliable reproducers make for fun
> > bisects ;-/  Anyway, by now I'm absolutely sure that this is a VM bug and
> > not something I had somehow managed to break, so...]
> 
> BTW, something odd happened to mm/memory.c - either a mangled patch
> or a lost followup.  Take a look at the last commit in there:
> commit ea1e7ed33708c7a760419ff9ded0a6cb90586a50
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Thu Nov 14 14:31:53 2013 -0800
> 
>     mm: create a separate slab for page->ptl allocation
>     
>     If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
>     is 72 bytes.  For page->ptl they will be allocated from kmalloc-96 slab,
>     so we loose 24 on each.  An average system can easily allocate few tens
>     thousands of page->ptl and overhead is significant.
>     
>     Let's create a separate slab for page->ptl allocation to solve this.
>     
>     Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Fair enough, and yes, it does create that separate slab.  The problem is,
> it's still using kmalloc/kfree for those beasts - page_ptl_cachep isn't
> used at all...

While digging in the same area:

Wrong page freed on preallocate_pmds() failure exit

Note that pmds[i] is simply uninitialized at that point...
Granted, it's very hard to hit (you need split page locks
*and* kmalloc(sizeof(spinlock_t), GFP_KERNEL) failing),
but the code is obviously bogus.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index a7cccb6d..36aa999 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -209,7 +209,7 @@ static int preallocate_pmds(pmd_t *pmds[])
 		if (!pmd)
 			failed = true;
 		if (pmd && !pgtable_pmd_page_ctor(virt_to_page(pmd))) {
-			free_page((unsigned long)pmds[i]);
+			free_page((unsigned long)pmd);
 			pmd = NULL;
 			failed = true;
 		}
