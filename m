Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaGRXmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:42:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60062 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277AbaGRXmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:42:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/6] PM / Hibernate: Create a Radix-Tree to store memory bitmap
Date: Sat, 19 Jul 2014 02:00:39 +0200
Message-ID: <7231480.jWHmWTNGCG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405684643-30234-2-git-send-email-joro@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org> <1405684643-30234-2-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2014 01:57:18 PM Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This patch adds the code to allocate and build the radix
> tree to store the memory bitmap. The old data structure is
> left in place until the radix tree implementation is
> finished.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  kernel/power/snapshot.c | 224 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 223 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 1ea328a..d0f11ec 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -248,11 +248,24 @@ static void *chain_alloc(struct chain_allocator *ca, unsigned int size)
>   *	information is stored (in the form of a block of bitmap)
>   *	It also contains the pfns that correspond to the start and end of
>   *	the represented memory area.
> + *
> + *	The memory bitmap is organized as a radix tree to guarantee fast random
> + *	access to the bits. There is one radix tree for each zone (as returned
> + *	from create_mem_extents).
> + *
> + *	One radix tree is represented by one struct mem_zone_bm_rtree. There are
> + *	two linked lists for the nodes of the tree, one for the inner nodes and
> + *	one for the leave nodes. The linked leave nodes are used for fast linear
> + *	access of the memory bitmap.
> + *
> + *	The struct rtree_node represents one node of the radix tree.
>   */
>  
>  #define BM_END_OF_MAP	(~0UL)
>  
>  #define BM_BITS_PER_BLOCK	(PAGE_SIZE * BITS_PER_BYTE)
> +#define BM_BLOCK_SHIFT		(PAGE_SHIFT + 3)
> +#define BM_BLOCK_MASK		((1UL << BM_BLOCK_SHIFT) - 1)
>  
>  struct bm_block {
>  	struct list_head hook;	/* hook into a list of bitmap blocks */
> @@ -266,6 +279,31 @@ static inline unsigned long bm_block_bits(struct bm_block *bb)
>  	return bb->end_pfn - bb->start_pfn;
>  }
>  
> +/*
> + * struct rtree_node is a wrapper struct to link the nodes
> + * of the rtree together for easy linear iteration over
> + * bits and easy freeing
> + */
> +struct rtree_node {
> +	struct list_head list;
> +	unsigned long *data;
> +};
> +
> +/*
> + * struct mem_zone_bm_rtree represents a bitmap used for one
> + * populated memory zone.
> + */
> +struct mem_zone_bm_rtree {
> +	struct list_head list;		/* Link Zones together         */
> +	struct list_head nodes;		/* Radix Tree inner nodes      */
> +	struct list_head leaves;	/* Radix Tree leaves           */
> +	unsigned long start_pfn;	/* Zone start page frame       */
> +	unsigned long end_pfn;		/* Zone end page frame + 1     */
> +	struct rtree_node *rtree;	/* Radix Tree Root             */
> +	int levels;			/* Number of Radix Tree Levels */
> +	unsigned int blocks;		/* Number of Bitmap Blocks     */
> +};
> +
>  /* strcut bm_position is used for browsing memory bitmaps */
>  
>  struct bm_position {
> @@ -274,6 +312,7 @@ struct bm_position {
>  };
>  
>  struct memory_bitmap {
> +	struct list_head zones;
>  	struct list_head blocks;	/* list of bitmap blocks */
>  	struct linked_page *p_list;	/* list of pages used to store zone
>  					 * bitmap objects and bitmap block
> @@ -284,6 +323,167 @@ struct memory_bitmap {
>  
>  /* Functions that operate on memory bitmaps */
>  
> +#define BM_ENTRIES_PER_LEVEL	(PAGE_SIZE / sizeof(unsigned long))
> +#if BITS_PER_LONG == 32
> +#define BM_RTREE_LEVEL_SHIFT	(PAGE_SHIFT - 2)
> +#else
> +#define BM_RTREE_LEVEL_SHIFT	(PAGE_SHIFT - 3)
> +#endif
> +#define BM_RTREE_LEVEL_MASK	((1UL << BM_RTREE_LEVEL_SHIFT) - 1)
> +
> +/*
> + *	alloc_rtree_node - Allocate a new node and add it to the radix
> + *			   tree.

Please make this a single line.

> + *
> + *	This function is used to allocate inner nodes as well as the
> + *	leave nodes of the radix tree. It also adds the node to the
> + *	corresponding linked list passed in by the *list parameter.
> + */
> +static struct rtree_node *alloc_rtree_node(gfp_t gfp_mask, int safe_needed,
> +					   struct chain_allocator *ca,
> +					   struct list_head *list)
> +{
> +	struct rtree_node *node;
> +
> +	node = chain_alloc(ca, sizeof(struct rtree_node));
> +	if (!node)
> +		return NULL;
> +
> +	node->data = get_image_page(gfp_mask, safe_needed);
> +	if (!node->data)
> +		return NULL;
> +
> +	list_add_tail(&node->list, list);
> +
> +	return node;
> +}
> +
> +/*
> + *	add_rtree_block - Add a new leave node to the radix tree
> + *
> + *	The leave nodes need to be allocated in order to keep the leaves
> + *	linked list in order. This is guaranteed by the zone->blocks
> + *	counter.
> + */
> +static int add_rtree_block(struct mem_zone_bm_rtree *zone, gfp_t gfp_mask,
> +			   int safe_needed, struct chain_allocator *ca)
> +{
> +	struct rtree_node *node, *block, **dst;
> +	unsigned int levels_needed, block_nr;
> +	int i;
> +
> +	block_nr	= zone->blocks;

This isn't proper kernel coding style.  Please use spaces as separators
before the "=" here and elsewhere.

Rafael

