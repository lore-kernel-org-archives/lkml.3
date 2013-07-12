Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3GLPhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:37:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785Ab3GLPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:37:13 -0400
Date: Fri, 12 Jul 2013 17:32:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: turn vma_set_policy() into
	vma_dup_policy()
Message-ID: <20130712153205.GA18825@redhat.com>
References: <20130710170205.GA26425@redhat.com> <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11, David Rientjes wrote:
>
> On Wed, 10 Jul 2013, Oleg Nesterov wrote:
>
> > +int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
> > +{
> > +	struct mempolicy *pol = mpol_dup(vma_policy(src));
> > +
> > +	if (IS_ERR(pol))
> > +		return PTR_ERR(pol);
>
> PTR_ERR() returns long, so vma_dup_policy() needs to return long.

I think that "int" should be fine, or we should fix IS_ERR/ERR_PTR. If
nothing else, the changed code did the same. And there are a lot of other
"int" functions which return PTR_ERR().

But I agree, this is only correct because vma_dup_policy() checks IS_ERR()
before PTR_ERR(), and because mpol_dup() doesn't do the wrong things with
ERR_PTR().

For example, ERR_PTR(args->err) in hw_breakpoint_handler() looks really
strange and imho should be killed. But correct, it is not actually the
error.

> > @@ -2505,12 +2504,9 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
> >  		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
> >  	}
> >
> > -	pol = mpol_dup(vma_policy(vma));
> > -	if (IS_ERR(pol)) {
> > -		err = PTR_ERR(pol);
> > +	err = vma_dup_policy(vma, new);
> > +	if (err)
> >  		goto out_free_vma;
> > -	}
> > -	vma_set_policy(new, pol);
> >
> >  	if (anon_vma_clone(new, vma))
> >  		goto out_free_mpol;
>
> This isn't the first occurrence in mm/mmap.c, what about vma_adjust()?
> Probably need to patch 3.10 or later.

Ah, sorry for confusion, I forgot to mention that this is on top of
another -mm patch,

	mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch

attached below just in case.

> Otherwise looks good.

Thanks for review ;)

Oleg.

-----------------------------------------------------------------------
[PATCH] mm: mempolicy: fix mbind_range() && vma_adjust() interaction

vma_adjust() does vma_set_policy(vma, vma_policy(next)) and this
is doubly wrong:

1. This leaks vma->vm_policy if it is not NULL and not equal to
   next->vm_policy.

   This can happen if vma_merge() expands "area", not prev (case 8).

2. This sets the wrong policy if vma_merge() joins prev and area,
   area is the vma the caller needs to update and it still has the
   old policy.

Revert 1444f92c "mm: merging memory blocks resets mempolicy" which
introduced these problems.

Change mbind_range() to recheck mpol_equal() after vma_merge() to
fix the problem 1444f92c tried to address.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
---
 mm/mempolicy.c |    6 +++++-
 mm/mmap.c      |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7431001..4baf12e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -732,7 +732,10 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
-			continue;
+			if (mpol_equal(vma_policy(vma), new_pol))
+				continue;
+			/* vma_merge() joined vma && vma->next, case 8 */
+			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
 			err = split_vma(vma->vm_mm, vma, vmstart, 1);
@@ -744,6 +747,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 			if (err)
 				goto out;
 		}
+ replace:
 		err = vma_replace_policy(vma, new_pol);
 		if (err)
 			goto out;
diff --git a/mm/mmap.c b/mm/mmap.c
index 7fe7f0b..42234b8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -865,7 +865,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
-		vma_set_policy(vma, vma_policy(next));
+		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-- 
1.5.5.1


