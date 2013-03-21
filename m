Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3CUPyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:54:54 -0400
Received: from www.sr71.net ([198.145.64.142]:50118 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab3CUPyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:54:52 -0400
Message-ID: <514B2D94.8040206@sr71.net>
Date: Thu, 21 Mar 2013 08:56:04 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 04/30] radix-tree: implement preload for multiple
 contiguous elements
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-5-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-5-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Currently radix_tree_preload() only guarantees enough nodes to insert
> one element. It's a hard limit. You cannot batch a number insert under
> one tree_lock.
> 
> This patch introduces radix_tree_preload_count(). It allows to
> preallocate nodes enough to insert a number of *contiguous* elements.

You don't need to write a paper on how radix trees work, but it might be
nice to include a wee bit of text in here about how the existing preload
works, and how this new guarantee works.

> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index ffc444c..81318cb 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -83,6 +83,8 @@ do {									\
>  	(root)->rnode = NULL;						\
>  } while (0)
>  
> +#define RADIX_TREE_PRELOAD_NR		512 /* For THP's benefit */

This eventually boils down to making the radix_tree_preload array
larger.  Do we really want to do this unconditionally if it's only for
THP's benefit?

>  /**
>   * Radix-tree synchronization
>   *
> @@ -231,6 +233,7 @@ unsigned long radix_tree_next_hole(struct radix_tree_root *root,
>  unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
>  				unsigned long index, unsigned long max_scan);
>  int radix_tree_preload(gfp_t gfp_mask);
> +int radix_tree_preload_count(unsigned size, gfp_t gfp_mask);
>  void radix_tree_init(void);
>  void *radix_tree_tag_set(struct radix_tree_root *root,
>  			unsigned long index, unsigned int tag);
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index e796429..9bef0ac 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -81,16 +81,24 @@ static struct kmem_cache *radix_tree_node_cachep;
>   * The worst case is a zero height tree with just a single item at index 0,
>   * and then inserting an item at index ULONG_MAX. This requires 2 new branches
>   * of RADIX_TREE_MAX_PATH size to be created, with only the root node shared.
> + *
> + * Worst case for adding N contiguous items is adding entries at indexes
> + * (ULONG_MAX - N) to ULONG_MAX. It requires nodes to insert single worst-case
> + * item plus extra nodes if you cross the boundary from one node to the next.
> + *
>   * Hence:
>   */
> -#define RADIX_TREE_PRELOAD_SIZE (RADIX_TREE_MAX_PATH * 2 - 1)
> +#define RADIX_TREE_PRELOAD_MIN (RADIX_TREE_MAX_PATH * 2 - 1)
> +#define RADIX_TREE_PRELOAD_MAX \
> +	(RADIX_TREE_PRELOAD_MIN + \
> +	 DIV_ROUND_UP(RADIX_TREE_PRELOAD_NR - 1, RADIX_TREE_MAP_SIZE))
>  
>  /*
>   * Per-cpu pool of preloaded nodes
>   */
>  struct radix_tree_preload {
>  	int nr;
> -	struct radix_tree_node *nodes[RADIX_TREE_PRELOAD_SIZE];
> +	struct radix_tree_node *nodes[RADIX_TREE_PRELOAD_MAX];
>  };

For those of us too lazy to go compile a kernel and figure this out in
practice, how much bigger does this make the nodes[] array?

>  static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
>  
> @@ -257,29 +265,34 @@ radix_tree_node_free(struct radix_tree_node *node)
>  
>  /*
>   * Load up this CPU's radix_tree_node buffer with sufficient objects to
> - * ensure that the addition of a single element in the tree cannot fail.  On
> - * success, return zero, with preemption disabled.  On error, return -ENOMEM
> + * ensure that the addition of *contiguous* elements in the tree cannot fail.
> + * On success, return zero, with preemption disabled.  On error, return -ENOMEM
>   * with preemption not disabled.
>   *
>   * To make use of this facility, the radix tree must be initialised without
>   * __GFP_WAIT being passed to INIT_RADIX_TREE().
>   */
> -int radix_tree_preload(gfp_t gfp_mask)
> +int radix_tree_preload_count(unsigned size, gfp_t gfp_mask)
>  {
>  	struct radix_tree_preload *rtp;
>  	struct radix_tree_node *node;
>  	int ret = -ENOMEM;
> +	int alloc = RADIX_TREE_PRELOAD_MIN +
> +		DIV_ROUND_UP(size - 1, RADIX_TREE_MAP_SIZE);

Any chance I could talk you in to giving 'alloc' a better name?  Maybe
"preload_target" or "preload_fill_to".

> +	if (size > RADIX_TREE_PRELOAD_NR)
> +		return -ENOMEM;

I always wonder if these deep, logical -ENOMEMs deserve a WARN_ONCE().
We really don't expect to hit this unless something really funky is
going on, right?

>  	preempt_disable();
>  	rtp = &__get_cpu_var(radix_tree_preloads);
> -	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
> +	while (rtp->nr < alloc) {
>  		preempt_enable();
>  		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
>  		if (node == NULL)
>  			goto out;
>  		preempt_disable();
>  		rtp = &__get_cpu_var(radix_tree_preloads);
> -		if (rtp->nr < ARRAY_SIZE(rtp->nodes))
> +		if (rtp->nr < alloc)
>  			rtp->nodes[rtp->nr++] = node;
>  		else
>  			kmem_cache_free(radix_tree_node_cachep, node);
> @@ -288,6 +301,11 @@ int radix_tree_preload(gfp_t gfp_mask)
>  out:
>  	return ret;
>  }

