Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbAWBsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:48:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:55824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbbAWBsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:48:10 -0500
Date: Thu, 22 Jan 2015 17:48:03 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree
 extent cache
Message-ID: <20150123014802.GA17947@jaegeuk-mac02>
References: <000a01d02e37$8e245890$aa6d09b0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01d02e37$8e245890$aa6d09b0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:14:48PM +0800, Chao Yu wrote:
> This patch adds core functions including slab cache init function and
> init/lookup/update/shrink/destroy function for rb-tree based extent cache.
> 
> Thank Jaegeuk Kim and Changman Lee as they gave much suggestion about detail
> design and implementation of extent cache.
> 
> Todo:
>  * add a cached_ei into struct extent_tree for a quick recent cache.
>  * register rb-based extent cache shrink with mm shrink interface.
>  * disable dir inode's extent cache.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> ---
>  fs/f2fs/data.c | 458 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/node.c |   9 +-
>  2 files changed, 466 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 4f5b871e..bf8c5eb 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -25,6 +25,9 @@
>  #include "trace.h"
>  #include <trace/events/f2fs.h>
>  
> +struct kmem_cache *extent_tree_slab;
> +struct kmem_cache *extent_node_slab;
> +
>  static void f2fs_read_end_io(struct bio *bio, int err)
>  {
>  	struct bio_vec *bvec;
> @@ -373,6 +376,430 @@ end_update:
>  	return need_update;
>  }
>  
> +static struct extent_node *__lookup_extent_tree(struct extent_tree *et,
> +							unsigned int fofs)
> +{
> +	struct rb_node *node = et->root.rb_node;
> +	struct extent_node *en;
> +
> +	while (node) {
> +		en = rb_entry(node, struct extent_node, rb_node);
> +		if (fofs < en->ei.fofs)
> +			node = node->rb_left;
> +		else if (fofs >= en->ei.fofs + en->ei.len)
> +			node = node->rb_right;
> +		else
> +			return en;
> +	}
> +	return NULL;
> +}
> +
> +static inline void set_extent_info(struct extent_info *ei, unsigned int fofs,
> +						u32 blk, unsigned int len)
> +{
> +	ei->fofs = fofs;
> +	ei->blk = blk;
> +	ei->len = len;
> +}
> +
> +static inline bool __is_extent_mergeable(struct extent_info *back,
> +						struct extent_info *front)
> +{
> +	return (back->fofs + back->len == front->fofs &&
> +			back->blk + back->len == front->blk);
> +}
> +
> +static bool __is_back_mergeable(struct extent_info *cur,
> +						struct extent_info *back)
> +{
> +	return __is_extent_mergeable(back, cur);
> +}
> +
> +static bool __is_front_mergeable(struct extent_info *cur,
> +						struct extent_info *front)
> +{
> +	return __is_extent_mergeable(cur, front);
> +}


How about declaring these four functions as inline ones and locating them
inside f2fs.h?

> +
> +static struct extent_node *__try_back_merge(struct extent_tree *et,
> +						struct extent_node *en)
> +{
> +	struct extent_node *prev;
> +	struct rb_node *node;
> +
> +	node = rb_prev(&en->rb_node);
> +	if (!node)
> +		return NULL;
> +
> +	prev = rb_entry(node, struct extent_node, rb_node);
> +	if (__is_back_mergeable(&en->ei, &prev->ei)) {
> +		en->ei.fofs = prev->ei.fofs;
> +		en->ei.blk = prev->ei.blk;
> +		en->ei.len += prev->ei.len;
> +		rb_erase(&prev->rb_node, &et->root);
> +		et->count--;
> +		return prev;
> +	}
> +	return NULL;
> +}
> +
> +static struct extent_node *__try_front_merge(struct extent_tree *et,
> +						struct extent_node *en)
> +{
> +	struct extent_node *next;
> +	struct rb_node *node;
> +
> +	node = rb_next(&en->rb_node);
> +	if (!node)
> +		return NULL;
> +
> +	next = rb_entry(node, struct extent_node, rb_node);
> +	if (__is_front_mergeable(&en->ei, &next->ei)) {
> +		en->ei.len += next->ei.len;
> +		rb_erase(&next->rb_node, &et->root);
> +		et->count--;
> +		return next;
> +	}
> +	return NULL;
> +}
> +
> +static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
> +				struct extent_tree *et, struct extent_info *ei,
> +				struct extent_node **den)
> +{
> +	struct rb_node **p = &et->root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct extent_node *en;
> +
> +	while (*p) {
> +		parent = *p;
> +		en = rb_entry(parent, struct extent_node, rb_node);
> +
> +		if (ei->fofs < en->ei.fofs) {
> +			if (__is_front_mergeable(ei, &en->ei)) {
> +				f2fs_bug_on(sbi, !den);
> +				en->ei.fofs = ei->fofs;
> +				en->ei.blk = ei->blk;
> +				en->ei.len += ei->len;
> +				*den = __try_back_merge(et, en);
> +				return en;
> +			}
> +			p = &(*p)->rb_left;
> +		} else if (ei->fofs >= en->ei.fofs + en->ei.len) {
> +			if (__is_back_mergeable(ei, &en->ei)) {
> +				f2fs_bug_on(sbi, !den);
> +				en->ei.len += ei->len;
> +				*den = __try_front_merge(et, en);
> +				return en;
> +			}
> +			p = &(*p)->rb_right;
> +		} else
> +			f2fs_bug_on(F2FS_I_SB(inode), 1);

Coding style.

} else {
	...
}

> +	}

How about adding __attach_extent_node()?
{
> +
> +	en = kmem_cache_alloc(extent_node_slab, GFP_ATOMIC);

	en = f2fs_kmem_cache_alloc(.., GFP_ATOMIC);

> +	en->ei = *ei;
> +	INIT_LIST_HEAD(&en->list);
> +
> +	rb_link_node(&en->rb_node, parent, p);
> +	rb_insert_color(&en->rb_node, &et->root);
> +	atomic_inc(&sbi->total_ext_node);
> +	et->count++;

}

> +
> +	return en;
> +}
> +
> +static struct extent_node *__remove_extent_tree(struct extent_tree *et,
> +							unsigned int fofs)

This is __detach_extent_node()?

> +{
> +	struct rb_node *p = et->root.rb_node;
> +	struct extent_node *en;
> +
> +	while (p) {
> +		en = rb_entry(p, struct extent_node, rb_node);
> +
> +		if (fofs < en->ei.fofs)
> +			p = p->rb_left;

Coding style.

if () {
} else {
}

> +		else if (fofs >= en->ei.fofs + en->ei.len)
> +			p = p->rb_right;
> +		else {
> +			rb_erase(&en->rb_node, &et->root);
> +			et->count--;

Add here?
			atomic_dec(&sbi->total_ext_node);

> +			return en;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static unsigned int __free_extent_tree(struct f2fs_sb_info *sbi,
> +					struct extent_tree *et, bool free_all)
> +{
> +	struct rb_node *node, *next;
> +	struct extent_node *en;
> +	unsigned int count = et->count;
> +
> +	node = rb_first(&et->root);
> +	while (node) {
> +		next = rb_next(node);
> +		en = rb_entry(node, struct extent_node, rb_node);
> +
> +		if (free_all) {
> +			spin_lock(&sbi->extent_lock);
> +			if (!list_empty(&en->list))
> +				list_del_init(&en->list);
> +			spin_unlock(&sbi->extent_lock);
> +		}
> +
> +		if (free_all || list_empty(&en->list)) {
> +			rb_erase(node, &et->root);
> +			kmem_cache_free(extent_node_slab, en);
> +			atomic_dec(&sbi->total_ext_node);
> +			et->count--;
> +		}
> +		node = next;
> +	}
> +
> +	return count - et->count;
> +}
> +
> +static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
> +							struct extent_info *ei)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> +	struct extent_tree *et;
> +	struct extent_node *en;
> +
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> +		return false;
> +
> +	down_read(&sbi->extent_tree_lock);
> +	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
> +	if (!et) {
> +		up_read(&sbi->extent_tree_lock);
> +		return false;
> +	}
> +	atomic_inc(&et->refcount);
> +	up_read(&sbi->extent_tree_lock);
> +
> +	read_lock(&et->lock);
> +	en = __lookup_extent_tree(et, pgofs);
> +	if (en) {
> +		*ei = en->ei;
> +		spin_lock(&sbi->extent_lock);
> +		if (!list_empty(&en->list))
> +			list_move_tail(&en->list, &sbi->extent_list);
> +		spin_unlock(&sbi->extent_lock);
> +		stat_inc_read_hit(sbi->sb);
> +	}
> +	stat_inc_total_hit(sbi->sb);
> +	read_unlock(&et->lock);
> +
> +	atomic_dec(&et->refcount);
> +	return en ? true : false;
> +}
> +
> +static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
> +							block_t blkaddr)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> +	nid_t ino = inode->i_ino;
> +	struct extent_tree *et;
> +	struct extent_node *en = NULL, *en1 = NULL, *en2 = NULL, *en3 = NULL;
> +	struct extent_node *den = NULL;
> +	struct extent_info *pei;
> +	struct extent_info ei;
> +	unsigned int endofs;
> +
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> +		return;
> +
> +retry:
> +	down_write(&sbi->extent_tree_lock);
> +	et = radix_tree_lookup(&sbi->extent_tree_root, ino);
> +	if (!et) {
> +		et = kmem_cache_alloc(extent_tree_slab, GFP_ATOMIC);

et = f2fs_kmem_cache_alloc(.., GFP_ATOMIC);

> +		if (!et) {
> +			up_write(&sbi->extent_tree_lock);
> +			goto retry;
> +		}
> +		if (radix_tree_insert(&sbi->extent_tree_root, ino, et)) {
> +			up_write(&sbi->extent_tree_lock);
> +			kmem_cache_free(extent_tree_slab, et);
> +			goto retry;
> +		}
> +		memset(et, 0, sizeof(struct extent_tree));
> +		et->ino = ino;
> +		et->root = RB_ROOT;
> +		rwlock_init(&et->lock);
> +		atomic_set(&et->refcount, 0);
> +		et->count = 0;
> +		sbi->total_ext_tree++;
> +	}
> +	atomic_inc(&et->refcount);
> +	up_write(&sbi->extent_tree_lock);
> +
> +	write_lock(&et->lock);
> +
> +	/* 1. lookup and remove exist extent info in cache */

                                existing

> +	en = __remove_extent_tree(et, fofs);

en = __detach_extent_node();?

> +	if (!en)
> +		goto update_extent;
> +
> +	pei = &en->ei;
> +	/* 2. if extent can be split more, split and insert the left part */
> +	if (pei->len > 1) {
> +		/*  insert left part of split extent into cache */
> +		if (pei->fofs < fofs) {
> +			set_extent_info(&ei, pei->fofs, pei->blk,
> +							fofs - pei->fofs);
> +			en1 = __insert_extent_tree(sbi, et, &ei, NULL);
> +		}
> +
> +		/* insert right part of split extent into cache */
> +		endofs = pei->fofs + pei->len - 1;
> +		if (endofs > fofs) {
> +			set_extent_info(&ei, fofs + 1,
> +				fofs - pei->fofs + pei->blk, endofs - fofs);
> +			en2 = __insert_extent_tree(sbi, et, &ei, NULL);
> +		}
> +	}
> +
> +update_extent:
> +	/* 3. update extent in extent cache */
> +	if (blkaddr) {
> +		set_extent_info(&ei, fofs, blkaddr, 1);
> +		en3 = __insert_extent_tree(sbi, et, &ei, &den);
> +	}
> +
> +	/* 4. update in global extent list */
> +	spin_lock(&sbi->extent_lock);
> +	if (en && !list_empty(&en->list))
> +		list_del_init(&en->list);
> +	/*
> +	 * en1 and en2 split from en, they will become more and more smaller
> +	 * fragments after splitting several times. So if the length is smaller
> +	 * than F2FS_MIN_EXTENT_LEN, we will not add them into extent_list,
> +	 * but just waiting shrinker to free them for reclaiming when OOM.
> +	 */

Can we just remove en1 and en2 in __insert_extent_tree?

> +	if (en1 && en1->ei.len >= F2FS_MIN_EXTENT_LEN)
> +		list_add_tail(&en1->list, &sbi->extent_list);
> +	if (en2 && en2->ei.len >= F2FS_MIN_EXTENT_LEN)
> +		list_add_tail(&en2->list, &sbi->extent_list);
> +	if (en3) {
> +		if (list_empty(&en3->list))
> +			list_add_tail(&en3->list, &sbi->extent_list);
> +		else
> +			list_move_tail(&en3->list, &sbi->extent_list);
> +	}
> +	if (den && !list_empty(&den->list))
> +		list_del_init(&den->list);
> +	spin_unlock(&sbi->extent_lock);
> +
> +	if (en) {
> +		kmem_cache_free(extent_node_slab, en);
> +		atomic_dec(&sbi->total_ext_node);

		--> move into __detach_extent_node().

> +	}
> +	if (den) {
> +		kmem_cache_free(extent_node_slab, den);
> +		atomic_dec(&sbi->total_ext_node);
> +	}
> +
> +	write_unlock(&et->lock);
> +	atomic_dec(&et->refcount);
> +}
> +
> +void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
> +{
> +	struct extent_tree *treevec[EXT_TREE_VEC_SIZE];
> +	struct extent_node *en, *tmp;
> +	unsigned long ino = F2FS_ROOT_INO(sbi);
> +	struct radix_tree_iter iter;
> +	void **slot;
> +	unsigned int found;
> +	unsigned int node_cnt = 0, tree_cnt = 0;
> +
> +	if (available_free_memory(sbi, EXTENT_CACHE))
> +		return;
> +
> +	spin_lock(&sbi->extent_lock);
> +	list_for_each_entry_safe(en, tmp, &sbi->extent_list, list) {
> +		if (!nr_shrink--)
> +			break;
> +		list_del_init(&en->list);
> +	}
> +	spin_unlock(&sbi->extent_lock);
> +
> +	down_read(&sbi->extent_tree_lock);
> +	while ((found = radix_tree_gang_lookup(&sbi->extent_tree_root,
> +				(void **)treevec, ino, EXT_TREE_VEC_SIZE))) {
> +		unsigned i;
> +
> +		ino = treevec[found - 1]->ino + 1;
> +		for (i = 0; i < found; i++) {
> +			struct extent_tree *et = treevec[i];
> +
> +			atomic_inc(&et->refcount);
> +			write_lock(&et->lock);
> +			node_cnt += __free_extent_tree(sbi, et, false);
> +			write_unlock(&et->lock);
> +			atomic_dec(&et->refcount);
> +		}
> +	}
> +	up_read(&sbi->extent_tree_lock);
> +
> +	down_write(&sbi->extent_tree_lock);
> +	radix_tree_for_each_slot(slot, &sbi->extent_tree_root, &iter,
> +							F2FS_ROOT_INO(sbi)) {
> +		struct extent_tree *et = (struct extent_tree *)*slot;
> +
> +		if (!atomic_read(&et->refcount) && !et->count) {
> +			radix_tree_delete(&sbi->extent_tree_root, et->ino);
> +			kmem_cache_free(extent_tree_slab, et);
> +			sbi->total_ext_tree--;
> +			tree_cnt++;

No use of tree_cnt.

Thanks,

> +		}
> +	}
> +	up_write(&sbi->extent_tree_lock);
> +}
> +
> +void f2fs_destroy_extent_tree(struct inode *inode)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> +	struct extent_tree *et;
> +	unsigned int node_cnt = 0;
> +
> +	down_read(&sbi->extent_tree_lock);
> +	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
> +	if (!et) {
> +		up_read(&sbi->extent_tree_lock);
> +		goto out;
> +	}
> +	atomic_inc(&et->refcount);
> +	up_read(&sbi->extent_tree_lock);
> +
> +	/* free all extent info belong to this extent tree */
> +	write_lock(&et->lock);
> +	node_cnt = __free_extent_tree(sbi, et, true);
> +	write_unlock(&et->lock);
> +
> +	atomic_dec(&et->refcount);
> +
> +	/* try to find and delete extent tree entry in radix tree */
> +	down_write(&sbi->extent_tree_lock);
> +	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
> +	if (!et) {
> +		up_write(&sbi->extent_tree_lock);
> +		goto out;
> +	}
> +	f2fs_bug_on(sbi, atomic_read(&et->refcount) || et->count);
> +	radix_tree_delete(&sbi->extent_tree_root, inode->i_ino);
> +	kmem_cache_free(extent_tree_slab, et);
> +	sbi->total_ext_tree--;
> +	up_write(&sbi->extent_tree_lock);
> +out:
> +	return;
> +}
> +
>  static bool f2fs_lookup_extent_cache(struct inode *inode, pgoff_t pgofs,
>  							struct extent_info *ei)
>  {
> @@ -1198,6 +1625,37 @@ static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
>  	return generic_block_bmap(mapping, block, get_data_block);
>  }
>  
> +void init_extent_cache_info(struct f2fs_sb_info *sbi)
> +{
> +	INIT_RADIX_TREE(&sbi->extent_tree_root, GFP_NOFS);
> +	init_rwsem(&sbi->extent_tree_lock);
> +	INIT_LIST_HEAD(&sbi->extent_list);
> +	spin_lock_init(&sbi->extent_lock);
> +	sbi->total_ext_tree = 0;
> +	atomic_set(&sbi->total_ext_node, 0);
> +}
> +
> +int __init create_extent_cache(void)
> +{
> +	extent_tree_slab = f2fs_kmem_cache_create("f2fs_extent_tree",
> +			sizeof(struct extent_tree));
> +	if (!extent_tree_slab)
> +		return -ENOMEM;
> +	extent_node_slab = f2fs_kmem_cache_create("f2fs_extent_node",
> +			sizeof(struct extent_node));
> +	if (!extent_node_slab) {
> +		kmem_cache_destroy(extent_tree_slab);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +void destroy_extent_cache(void)
> +{
> +	kmem_cache_destroy(extent_node_slab);
> +	kmem_cache_destroy(extent_tree_slab);
> +}
> +
>  const struct address_space_operations f2fs_dblock_aops = {
>  	.readpage	= f2fs_read_data_page,
>  	.readpages	= f2fs_read_data_pages,
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index d7c1436..387017f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -41,7 +41,9 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
>  	/* only uses low memory */
>  	avail_ram = val.totalram - val.totalhigh;
>  
> -	/* give 25%, 25%, 50%, 50% memory for each components respectively */
> +	/*
> +	 * give 25%, 25%, 50%, 50%, 50% memory for each components respectively
> +	 */
>  	if (type == FREE_NIDS) {
>  		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >>
>  							PAGE_CACHE_SHIFT;
> @@ -62,6 +64,11 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
>  			mem_size += (sbi->im[i].ino_num *
>  				sizeof(struct ino_entry)) >> PAGE_CACHE_SHIFT;
>  		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
> +	} else if (type == EXTENT_CACHE) {
> +		mem_size = (sbi->total_ext_tree * sizeof(struct extent_tree) +
> +				atomic_read(&sbi->total_ext_node) *
> +				sizeof(struct extent_node)) >> PAGE_CACHE_SHIFT;
> +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
>  	} else {
>  		if (sbi->sb->s_bdi->dirty_exceeded)
>  			return false;
> -- 
> 2.2.1
