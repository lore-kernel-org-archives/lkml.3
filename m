Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3KASEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:04:42 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:42894 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3KASEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <1383292467-28922-5-git-send-email-yuanhan.liu@linux.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1383292467-28922-5-git-send-email-yuanhan.liu@linux.intel.com>
Date: Fri, 1 Nov 2013 11:04:40 -0700
X-Google-Sender-Auth: Iy2k9ldwLiH3sTAznMuYgF4rUSY
Message-ID: <CA+55aFzAxnP0R8LrO9d1MzjCs8LxKXGwxadnUtoKeXhAh3Mzqw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm/rmap.c: move anon_vma initialization code into anon_vma_ctor
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 12:54 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> @@ -67,19 +67,7 @@ static struct kmem_cache *anon_vma_chain_cachep;
>
>  static inline struct anon_vma *anon_vma_alloc(void)
>  {
> -       struct anon_vma *anon_vma;
> -
> -       anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> -       if (anon_vma) {
> -               atomic_set(&anon_vma->refcount, 1);
> -               /*
> -                * Initialise the anon_vma root to point to itself. If called
> -                * from fork, the root will be reset to the parents anon_vma.
> -                */
> -               anon_vma->root = anon_vma;
> -       }
> -
> -       return anon_vma;
> +       return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
>  }
>
>  static inline void anon_vma_free(struct anon_vma *anon_vma)
> @@ -293,8 +281,15 @@ static void anon_vma_ctor(void *data)
>         struct anon_vma *anon_vma = data;
>
>         rwlock_init(&anon_vma->rwlock);
> -       atomic_set(&anon_vma->refcount, 0);
>         anon_vma->rb_root = RB_ROOT;
> +
> +       atomic_set(&anon_vma->refcount, 1);
> +       /*
> +        * Initialise the anon_vma root to point to itself. If called
> +        * from fork, the root will be reset to the parents anon_vma.
> +        */
> +       anon_vma->root = anon_vma;
> +
>  }

This looks totally invalid.

The slab constructor is *not* called on every allocation. Quite the
reverse. Constructors are called when the underlying allocation is
initially done, and then *not* done again, even if that particular
object may be allocated and free'd many times.

So the reason we can do

    atomic_set(&anon_vma->refcount, 0);

in a constructor is that anybody who frees that allocation will do so
only when the refcount goes back down to zero, so zero is "valid
state" while the slab entry stays on some percpu freelist.

But the same is ABSOLUTELY NOT TRUE of the value "1", nor is it true
of the anon_vma->root. When the anonvma gets free'd, those values will
*not* be the same (the refcount has been decremented to zero, and the
root will have been set to whatever the root was.

So the rule about constructors is that the values they construct
absolutely *have* to be the ones they get free'd with. With one
special case.

Using slab constructors is almost always a mistake. The original
Sun/Solaris argument for them was to avoid initialization costs in
allocators, and that was pure and utter bullshit (initializing a whole
cacheline is generally cheaper than not initializing it and having to
fetch it from L3 caches, but it does hide the cost so that it is now
spread out in the users rather than in the allocator).

So the _original_ reason for slab is pure and utter BS, and we've
removed pretty much all uses of the constructors.

In fact, the only valid reason for using them any more is the special
case: locks and RCU.

The reason we still have constructors is that sometimes we want to
keep certain data structures "alive" across allocations together with
SLAB_DESTROY_BY_RCU (which delays the actual *page* destroying by RCU,
but the allocation can go to the free-list and get re-allocated
without a RCU grace-period).

But because allocations can now "stay active" over a
alloc/free/alloc-again sequence, that means that the allocation
sequence MUST NOT re-initialize the lock, because some RCU user may
still be looking at those fields (and in particular, unlocking an
allocation that in the meantime got free'd and re-allocated).

So these days, the *only* valid pattern for slab constructors is
together with SLAB_DESTROY_BY_RCU, and making sure that the fields
that RCU readers look at (and in particular, change) are "stable" over
such re-allocations.

Your patch is horribly wrong.

                  Linus
