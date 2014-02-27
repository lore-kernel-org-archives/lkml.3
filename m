Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaB0GyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:54:09 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:37483 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaB0GyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:54:07 -0500
MIME-Version: 1.0
In-Reply-To: <1393459641.25123.21.camel@buesod1.americas.hpqcorp.net>
References: <1393459641.25123.21.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 26 Feb 2014 22:47:10 -0800
Message-ID: <CANN689FmKv1wy-sM--VOnEc=+r9=xesfT4frq=3TEH-uMHhjjA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: per-thread vma caching
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agree with Linus; this is starting to look pretty good.

I still have nits though :)

On Wed, Feb 26, 2014 at 4:07 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> @@ -0,0 +1,45 @@
> +#ifndef __LINUX_VMACACHE_H
> +#define __LINUX_VMACACHE_H
> +
> +#include <linux/mm.h>
> +
> +#ifdef CONFIG_MMU
> +#define VMACACHE_BITS 2
> +#else
> +#define VMACACHE_BITS 0
> +#endif

I wouldn't even both with the #ifdef here - why not just always use 2 bits ?

> +#define vmacache_flush(tsk)                                     \
> +       do {                                                     \
> +               memset(tsk->vmacache, 0, sizeof(tsk->vmacache)); \
> +       } while (0)

I think inline functions are preferred

> diff --git a/mm/nommu.c b/mm/nommu.c
> index 8740213..9a5347b 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -768,16 +768,19 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
>   */
>  static void delete_vma_from_mm(struct vm_area_struct *vma)
>  {
> +       int i;
>         struct address_space *mapping;
>         struct mm_struct *mm = vma->vm_mm;
> +       struct task_struct *curr = current;
>
>         kenter("%p", vma);
>
>         protect_vma(vma, 0);
>
>         mm->map_count--;
> -       if (mm->mmap_cache == vma)
> -               mm->mmap_cache = NULL;
> +       for (i = 0; i < VMACACHE_SIZE; i++)
> +               if (curr->vmacache[i] == vma)
> +                       curr->vmacache[i] = NULL;

Why is the invalidation done differently here ? shouldn't it be done
by bumping the mm's sequence number so that invalidation works accross
all threads sharing that mm ?

> +#ifndef CONFIG_MMU
> +struct vm_area_struct *vmacache_find_exact(struct mm_struct *mm,
> +                                          unsigned long start,
> +                                          unsigned long end)
> +{
> +       int i;
> +
> +       if (!vmacache_valid(mm))
> +               return NULL;
> +
> +       for (i = 0; i < VMACACHE_SIZE; i++) {
> +               struct vm_area_struct *vma = current->vmacache[i];
> +
> +               if (vma && vma->vm_start == start && vma->vm_end == end)
> +                       return vma;
> +       }
> +
> +       return NULL;
> +
> +}
> +#endif

I think the caller could do instead
vma = vmacache_find(mm, start)
if (vma && vma->vm_start == start && vma->vm_end == end) {
}

I.e. better deal with it at the call site than add a new vmacache
function for it.

These are nits, the code looks good already.

I would like to propose an LRU eviction scheme to replace your
VMACACHE_HASH mechanism; I will probably do that as a follow-up once
you have the code in andrew's tree.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
