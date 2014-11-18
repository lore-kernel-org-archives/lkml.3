Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaKRJPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:15:54 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:25508 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbaKRJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:15:50 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43557962"
Message-ID: <546B0F16.90901@cn.fujitsu.com>
Date: Tue, 18 Nov 2014 17:19:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
References: <20141113220927.GF2598@htj.dyndns.org>
In-Reply-To: <20141113220927.GF2598@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 06:09 AM, Tejun Heo wrote:
> Implement set of pointers.  Pointers can be added, deleted and
> iterated.  It's currently implemented as a thin rbtree wrapper making
> addition and removal O(log N).  A drawback is that iteration isn't RCU
> safe, which is okay for now.  This will be used to remove
> inode->i_devices.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/ptrset.h |   74 +++++++++++++++++++++++++++
>  lib/Makefile           |    2 
>  lib/ptrset.c           |  131 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 206 insertions(+), 1 deletion(-)
> 
> --- /dev/null
> +++ b/include/linux/ptrset.h
> @@ -0,0 +1,74 @@
> +/*
> + * include/linux/ptrset.h - set of pointers
> + *
> + * Copyright (C) 2014		Tejun Heo, Red Hat Inc.
> + *
> + * A ptrset contains an unordered set of pointers.  Pointers can be added,
> + * deleted and iterated.  Addition and removal complexities are O(log N)
> + * where N is the total number of elements in the ptrset.
> + */
> +
> +#ifndef __PTRSET_H
> +#define __PTRSET_H
> +
> +#include <linux/preempt.h>
> +#include <linux/rbtree.h>
> +
> +struct ptrset {
> +	struct rb_root		root;
> +};
> +
> +struct ptrset_elem {
> +	void			*ptr;
> +	struct rb_node		node;
> +};
> +
> +struct ptrset_iter {
> +	struct ptrset_elem	*pos;
> +	struct ptrset_elem	*next;
> +};
> +
> +#define PTRSET_INITIALIZER	{ .root = RB_ROOT, }
> +#define DEFINE_PTRSET(set)	struct ptrset set = PTRSET_INITIALIZER
> +
> +static inline void ptrset_init(struct ptrset *set)
> +{
> +	*set = (struct ptrset)PTRSET_INITIALIZER;
> +}
> +
> +void ptrset_preload(gfp_t gfp);
> +int __must_check ptrset_add(void *ptr, struct ptrset *set, gfp_t gfp);
> +int ptrset_del(void *ptr, struct ptrset *set);
> +
> +/**
> + * ptrset_preload_end - end preload section started with ptrset_preload()
> + *
> + * Each ptrset_preload() should be matched with an invocation of this
> + * function.  See ptrset_preload() for details.
> + */
> +static inline void ptrset_preload_end(void)
> +{
> +	preempt_enable();
> +}
> +
> +/**
> + * ptrset_for_each - iterate pointers in a ptrset
> + * @ptr_cur: the cursor pointer variable (can be a pointer to any type)
> + * @set: the target ptrset
> + * @iter: pointer to struct ptrset_iter used to store iteration state
> + *
> + * Iterate @ptr_cur over all pointers in @set using @iter as the temp
> + * storage.  The order of iteration is undefined and the iterated pointers
> + * may be deleted during iteration.
> + *
> + * The caller is responsible for synchronization.  This is not RCU safe.
> + */
> +#define ptrset_for_each(ptr_cur, set, iter)				\
> +	rbtree_postorder_for_each_entry_safe((iter)->pos, (iter)->next,	\
> +					     &(set)->root, node)	\
> +		if (({	(ptr_cur) = (iter)->pos->ptr;			\
> +			false; }))					\
> +			;						\
> +		else
> +
> +#endif	/* __PTRSET_H */
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -8,7 +8,7 @@ KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLA
>  endif
>  
>  lib-y := ctype.o string.o vsprintf.o cmdline.o \
> -	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
> +	 rbtree.o radix-tree.o dump_stack.o timerqueue.o ptrset.o \
>  	 idr.o int_sqrt.o extable.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
> --- /dev/null
> +++ b/lib/ptrset.c
> @@ -0,0 +1,131 @@
> +/*
> + * lib/ptrset.c - set of pointers
> + *
> + * Copyright (C) 2014		Tejun Heo, Red Hat Inc.
> + */
> +
> +#include <linux/ptrset.h>
> +#include <linux/slab.h>
> +#include <linux/percpu.h>
> +
> +static DEFINE_PER_CPU(struct ptrset_elem *, ptrset_preload_elem);
> +
> +/**
> + * ptrset_preload - preload for ptrset_add()
> + * @gfp: allocation mask to use for preloading
> + *
> + * Preload per-cpu ptrset_elem buffer for ptrset_add().  Can only be used
> + * from process context and each ptrset_preload() invocation should be
> + * matched with ptrset_preload_end().  Note that preemption is disabled
> + * while preloaded.
> + *
> + * The first ptrset_add() in the preloaded section can be treated as if it
> + * were invoked with @gfp used for preloading.  This allows using more
> + * permissive allocation masks for ptrsets protected by spinlocks.
> + */
> +void ptrset_preload(gfp_t gfp)
> +{
> +	/*
> +	 * Consuming preload buffer from non-process context breaks preload
> +	 * allocation guarantee.  Disallow usage from those contexts.
> +	 */
> +	WARN_ON_ONCE(in_interrupt());
> +	might_sleep_if(gfp & __GFP_WAIT);
> +
> +	preempt_disable();
> +
> +	if (!__this_cpu_read(ptrset_preload_elem)) {
> +		struct ptrset_elem *new;
> +
> +		preempt_enable();
> +		new = kmalloc(sizeof(*new), gfp);
> +		preempt_disable();
> +
> +		new = __this_cpu_xchg(ptrset_preload_elem, new);
> +		kfree(new);
> +	}
> +}

Is it too ugly?
What will be the most important result it achieve?
