Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbbAWGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:16:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbAWGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:16:55 -0500
X-AuditID: cbfee61a-f79c06d000004e71-cc-54c1e7528c34
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <000a01d02e37$8e245890$aa6d09b0$@samsung.com>
 <20150123014802.GA17947@jaegeuk-mac02>
In-reply-to: <20150123014802.GA17947@jaegeuk-mac02>
Subject: RE: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree
 extent cache
Date: Fri, 23 Jan 2015 14:15:56 +0800
Message-id: <00ed01d036d4$28fb0310$7af10930$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKeVPLQy9+F4bGTWoVZW3/EA2BwswFKrMx+myZ/fUA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd3g5wdDDC5fZrS4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxoGZZ5gL
	btdXzH17iqmBsSupi5GTQ0LARGLh3PvsELaYxIV769m6GLk4hAQWMUo8aj3JAuH8YJT4MPUa
	I0gVm4CKxPKO/0wgtoiAmkTvvilANgcHs0CRxKoVAiBhIYEkibN/v7GC2JwCxhKXPr9nA7GF
	BWIk+t++ZAaxWQRUJZqPXwSr4RWwlOh7sZMRwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQ
	hypI7Dj7mhHiBCuJKSu+s0LUiEtsPHKLZQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiOgWdSOxhXNlgcYhTgYFTi4W3YcjBEiDWxrLgy9xCjBAezkghv
	9yOgEG9KYmVValF+fFFpTmrxIUZpDhYlcV4l+7YQIYH0xJLU7NTUgtQimCwTB6dUA2PJ14tp
	T71tW/1m/RPsOKSi6HLR55Ne7XwWto9vvZoYC281b1p24tPHdStlXrFN4TGN+7hGXeukxNTQ
	xi1nGj5uWftaSsA5PEupTFEq8MvVjAf8IdFXLdRs3O3UmtxM9yR8ES2buqx4cdnhv5va6wPN
	tl3QNG1bxNJS7aF1LPfaMc3okFWLtJRYijMSDbWYi4oTAY9SCvR9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, January 23, 2015 9:48 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree extent cache
> 
> On Mon, Jan 12, 2015 at 03:14:48PM +0800, Chao Yu wrote:
> > This patch adds core functions including slab cache init function and
> > init/lookup/update/shrink/destroy function for rb-tree based extent cache.
> >
> > Thank Jaegeuk Kim and Changman Lee as they gave much suggestion about detail
> > design and implementation of extent cache.
> >
> > Todo:
> >  * add a cached_ei into struct extent_tree for a quick recent cache.
> >  * register rb-based extent cache shrink with mm shrink interface.
> >  * disable dir inode's extent cache.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> > ---
> >  fs/f2fs/data.c | 458 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/f2fs/node.c |   9 +-
> >  2 files changed, 466 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 4f5b871e..bf8c5eb 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -25,6 +25,9 @@
> >  #include "trace.h"
> >  #include <trace/events/f2fs.h>
> >
> > +struct kmem_cache *extent_tree_slab;
> > +struct kmem_cache *extent_node_slab;
> > +
> >  static void f2fs_read_end_io(struct bio *bio, int err)
> >  {
> >  	struct bio_vec *bvec;
> > @@ -373,6 +376,430 @@ end_update:
> >  	return need_update;
> >  }
> >
> > +static struct extent_node *__lookup_extent_tree(struct extent_tree *et,
> > +							unsigned int fofs)
> > +{
> > +	struct rb_node *node = et->root.rb_node;
> > +	struct extent_node *en;
> > +
> > +	while (node) {
> > +		en = rb_entry(node, struct extent_node, rb_node);
> > +		if (fofs < en->ei.fofs)
> > +			node = node->rb_left;
> > +		else if (fofs >= en->ei.fofs + en->ei.len)
> > +			node = node->rb_right;
> > +		else
> > +			return en;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static inline void set_extent_info(struct extent_info *ei, unsigned int fofs,
> > +						u32 blk, unsigned int len)
> > +{
> > +	ei->fofs = fofs;
> > +	ei->blk = blk;
> > +	ei->len = len;
> > +}
> > +
> > +static inline bool __is_extent_mergeable(struct extent_info *back,
> > +						struct extent_info *front)
> > +{
> > +	return (back->fofs + back->len == front->fofs &&
> > +			back->blk + back->len == front->blk);
> > +}
> > +
> > +static bool __is_back_mergeable(struct extent_info *cur,
> > +						struct extent_info *back)
> > +{
> > +	return __is_extent_mergeable(back, cur);
> > +}
> > +
> > +static bool __is_front_mergeable(struct extent_info *cur,
> > +						struct extent_info *front)
> > +{
> > +	return __is_extent_mergeable(cur, front);
> > +}
> 
> 
> How about declaring these four functions as inline ones and locating them
> inside f2fs.h?

Good idea! Will do.

> 
> > +
> > +static struct extent_node *__try_back_merge(struct extent_tree *et,
> > +						struct extent_node *en)
> > +{
> > +	struct extent_node *prev;
> > +	struct rb_node *node;
> > +
> > +	node = rb_prev(&en->rb_node);
> > +	if (!node)
> > +		return NULL;
> > +
> > +	prev = rb_entry(node, struct extent_node, rb_node);
> > +	if (__is_back_mergeable(&en->ei, &prev->ei)) {
> > +		en->ei.fofs = prev->ei.fofs;
> > +		en->ei.blk = prev->ei.blk;
> > +		en->ei.len += prev->ei.len;
> > +		rb_erase(&prev->rb_node, &et->root);
> > +		et->count--;
> > +		return prev;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static struct extent_node *__try_front_merge(struct extent_tree *et,
> > +						struct extent_node *en)
> > +{
> > +	struct extent_node *next;
> > +	struct rb_node *node;
> > +
> > +	node = rb_next(&en->rb_node);
> > +	if (!node)
> > +		return NULL;
> > +
> > +	next = rb_entry(node, struct extent_node, rb_node);
> > +	if (__is_front_mergeable(&en->ei, &next->ei)) {
> > +		en->ei.len += next->ei.len;
> > +		rb_erase(&next->rb_node, &et->root);
> > +		et->count--;
> > +		return next;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
> > +				struct extent_tree *et, struct extent_info *ei,
> > +				struct extent_node **den)
> > +{
> > +	struct rb_node **p = &et->root.rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct extent_node *en;
> > +
> > +	while (*p) {
> > +		parent = *p;
> > +		en = rb_entry(parent, struct extent_node, rb_node);
> > +
> > +		if (ei->fofs < en->ei.fofs) {
> > +			if (__is_front_mergeable(ei, &en->ei)) {
> > +				f2fs_bug_on(sbi, !den);
> > +				en->ei.fofs = ei->fofs;
> > +				en->ei.blk = ei->blk;
> > +				en->ei.len += ei->len;
> > +				*den = __try_back_merge(et, en);
> > +				return en;
> > +			}
> > +			p = &(*p)->rb_left;
> > +		} else if (ei->fofs >= en->ei.fofs + en->ei.len) {
> > +			if (__is_back_mergeable(ei, &en->ei)) {
> > +				f2fs_bug_on(sbi, !den);
> > +				en->ei.len += ei->len;
> > +				*den = __try_front_merge(et, en);
> > +				return en;
> > +			}
> > +			p = &(*p)->rb_right;
> > +		} else
> > +			f2fs_bug_on(F2FS_I_SB(inode), 1);
> 
> Coding style.
> 
> } else {
> 	...
> }

will fix.

> 
> > +	}
> 
> How about adding __attach_extent_node()?

That's more readable.

How do you think of the following functions:

struct extent_node *__attach_extent_node(struct f2fs_sb_info *sbi,
				struct extent_tree *et, struct extent_info *ei,
				struct rb_node *parent, struct rb_node **p)
{
	struct extent_node *en;

	en = kmem_cache_alloc(extent_node_slab, GFP_ATOMIC);
	if (!en)
		return NULL;

	en->ei = *ei;
	INIT_LIST_HEAD(&en->list);

	rb_link_node(&en->rb_node, parent, p);
	rb_insert_color(&en->rb_node, &et->root);
	et->count++;
	atomic_inc(&sbi->total_ext_node);
	return en;
}

static void __detach_extent_node(struct f2fs_sb_info *sbi,
				struct extent_tree *et, struct extent_node *en)
{
	rb_erase(&en->rb_node, &et->root);
	et->count--;
	atomic_dec(&sbi->total_ext_node);
}

> {
> > +
> > +	en = kmem_cache_alloc(extent_node_slab, GFP_ATOMIC);
> 
> 	en = f2fs_kmem_cache_alloc(.., GFP_ATOMIC);

We should avoid cond_resched() in f2fs_kmem_cache_alloc when we are holding write_lock.

IMO, it's better to return NULL if we fail to alloc extent_node here.
Otherwise we'd better alloc extent_node before write_lock.

> 
> > +	en->ei = *ei;
> > +	INIT_LIST_HEAD(&en->list);
> > +
> > +	rb_link_node(&en->rb_node, parent, p);
> > +	rb_insert_color(&en->rb_node, &et->root);
> > +	atomic_inc(&sbi->total_ext_node);
> > +	et->count++;
> 
> }
> 
> > +
> > +	return en;
> > +}
> > +
> > +static struct extent_node *__remove_extent_tree(struct extent_tree *et,
> > +							unsigned int fofs)
> 
> This is __detach_extent_node()?
> 
> > +{
> > +	struct rb_node *p = et->root.rb_node;
> > +	struct extent_node *en;
> > +
> > +	while (p) {
> > +		en = rb_entry(p, struct extent_node, rb_node);
> > +
> > +		if (fofs < en->ei.fofs)
> > +			p = p->rb_left;
> 
> Coding style.
> 
> if () {
> } else {
> }

will fix.

> 
> > +		else if (fofs >= en->ei.fofs + en->ei.len)
> > +			p = p->rb_right;
> > +		else {
> > +			rb_erase(&en->rb_node, &et->root);
> > +			et->count--;
> 
> Add here?
> 			atomic_dec(&sbi->total_ext_node);

Agree, see __detach_extent_node() implementation above.

> 
> > +			return en;
> > +		}
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static unsigned int __free_extent_tree(struct f2fs_sb_info *sbi,
> > +					struct extent_tree *et, bool free_all)
> > +{
> > +	struct rb_node *node, *next;
> > +	struct extent_node *en;
> > +	unsigned int count = et->count;
> > +
> > +	node = rb_first(&et->root);
> > +	while (node) {
> > +		next = rb_next(node);
> > +		en = rb_entry(node, struct extent_node, rb_node);
> > +
> > +		if (free_all) {
> > +			spin_lock(&sbi->extent_lock);
> > +			if (!list_empty(&en->list))
> > +				list_del_init(&en->list);
> > +			spin_unlock(&sbi->extent_lock);
> > +		}
> > +
> > +		if (free_all || list_empty(&en->list)) {
> > +			rb_erase(node, &et->root);
> > +			kmem_cache_free(extent_node_slab, en);
> > +			atomic_dec(&sbi->total_ext_node);
> > +			et->count--;
> > +		}
> > +		node = next;
> > +	}
> > +
> > +	return count - et->count;
> > +}
> > +
> > +static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
> > +							struct extent_info *ei)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> > +	struct extent_tree *et;
> > +	struct extent_node *en;
> > +
> > +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> > +		return false;
> > +
> > +	down_read(&sbi->extent_tree_lock);
> > +	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
> > +	if (!et) {
> > +		up_read(&sbi->extent_tree_lock);
> > +		return false;
> > +	}
> > +	atomic_inc(&et->refcount);
> > +	up_read(&sbi->extent_tree_lock);
> > +
> > +	read_lock(&et->lock);
> > +	en = __lookup_extent_tree(et, pgofs);
> > +	if (en) {
> > +		*ei = en->ei;
> > +		spin_lock(&sbi->extent_lock);
> > +		if (!list_empty(&en->list))
> > +			list_move_tail(&en->list, &sbi->extent_list);
> > +		spin_unlock(&sbi->extent_lock);
> > +		stat_inc_read_hit(sbi->sb);
> > +	}
> > +	stat_inc_total_hit(sbi->sb);
> > +	read_unlock(&et->lock);
> > +
> > +	atomic_dec(&et->refcount);
> > +	return en ? true : false;
> > +}
> > +
> > +static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
> > +							block_t blkaddr)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> > +	nid_t ino = inode->i_ino;
> > +	struct extent_tree *et;
> > +	struct extent_node *en = NULL, *en1 = NULL, *en2 = NULL, *en3 = NULL;
> > +	struct extent_node *den = NULL;
> > +	struct extent_info *pei;
> > +	struct extent_info ei;
> > +	unsigned int endofs;
> > +
> > +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> > +		return;
> > +
> > +retry:
> > +	down_write(&sbi->extent_tree_lock);
> > +	et = radix_tree_lookup(&sbi->extent_tree_root, ino);
> > +	if (!et) {
> > +		et = kmem_cache_alloc(extent_tree_slab, GFP_ATOMIC);
> 
> et = f2fs_kmem_cache_alloc(.., GFP_ATOMIC);

How about modifying as below to avoid holding extent_tree_lock for long time?

et = kmem_cache_alloc(extent_tree_slab, GFP_ATOMIC);
if (!et) {
	up_write(&sbi->extent_tree_lock);
	cond_resched();
	goto retry;
}

> 
> > +		if (!et) {
> > +			up_write(&sbi->extent_tree_lock);
> > +			goto retry;
> > +		}
> > +		if (radix_tree_insert(&sbi->extent_tree_root, ino, et)) {
> > +			up_write(&sbi->extent_tree_lock);
> > +			kmem_cache_free(extent_tree_slab, et);

cond_resched()?

> > +			goto retry;
> > +		}
> > +		memset(et, 0, sizeof(struct extent_tree));
> > +		et->ino = ino;
> > +		et->root = RB_ROOT;
> > +		rwlock_init(&et->lock);
> > +		atomic_set(&et->refcount, 0);
> > +		et->count = 0;
> > +		sbi->total_ext_tree++;
> > +	}
> > +	atomic_inc(&et->refcount);
> > +	up_write(&sbi->extent_tree_lock);
> > +
> > +	write_lock(&et->lock);
> > +
> > +	/* 1. lookup and remove exist extent info in cache */
> 
>                                 existing

got it.

> 
> > +	en = __remove_extent_tree(et, fofs);
> 
> en = __detach_extent_node();?

OK, it seems that most codes of __remove_extent_tree and __lookup_extent_tree 
are the same, so here I want to remove extent node like this:

	en = __lookup_extent_tree(et, fofs);
	if (!en)
		goto update_extent;

	dei = en->ei;
	__detach_extent_node(sbi, et, en);

How do you think?

> 
> > +	if (!en)
> > +		goto update_extent;
> > +
> > +	pei = &en->ei;
> > +	/* 2. if extent can be split more, split and insert the left part */
> > +	if (pei->len > 1) {
> > +		/*  insert left part of split extent into cache */
> > +		if (pei->fofs < fofs) {
> > +			set_extent_info(&ei, pei->fofs, pei->blk,
> > +							fofs - pei->fofs);
> > +			en1 = __insert_extent_tree(sbi, et, &ei, NULL);
> > +		}
> > +
> > +		/* insert right part of split extent into cache */
> > +		endofs = pei->fofs + pei->len - 1;
> > +		if (endofs > fofs) {
> > +			set_extent_info(&ei, fofs + 1,
> > +				fofs - pei->fofs + pei->blk, endofs - fofs);
> > +			en2 = __insert_extent_tree(sbi, et, &ei, NULL);
> > +		}
> > +	}
> > +
> > +update_extent:
> > +	/* 3. update extent in extent cache */
> > +	if (blkaddr) {
> > +		set_extent_info(&ei, fofs, blkaddr, 1);
> > +		en3 = __insert_extent_tree(sbi, et, &ei, &den);
> > +	}
> > +
> > +	/* 4. update in global extent list */
> > +	spin_lock(&sbi->extent_lock);
> > +	if (en && !list_empty(&en->list))
> > +		list_del_init(&en->list);
> > +	/*
> > +	 * en1 and en2 split from en, they will become more and more smaller
> > +	 * fragments after splitting several times. So if the length is smaller
> > +	 * than F2FS_MIN_EXTENT_LEN, we will not add them into extent_list,
> > +	 * but just waiting shrinker to free them for reclaiming when OOM.
> > +	 */
> 
> Can we just remove en1 and en2 in __insert_extent_tree?

en1 and en2 is newly added, in __attach_extent_node we do not add en1 and en2 into
lru list, so if you do not want to keep split part in lru list, let's just remove
the below codes.

> 
> > +	if (en1 && en1->ei.len >= F2FS_MIN_EXTENT_LEN)
> > +		list_add_tail(&en1->list, &sbi->extent_list);
> > +	if (en2 && en2->ei.len >= F2FS_MIN_EXTENT_LEN)
> > +		list_add_tail(&en2->list, &sbi->extent_list);
> > +	if (en3) {
> > +		if (list_empty(&en3->list))
> > +			list_add_tail(&en3->list, &sbi->extent_list);
> > +		else
> > +			list_move_tail(&en3->list, &sbi->extent_list);
> > +	}
> > +	if (den && !list_empty(&den->list))
> > +		list_del_init(&den->list);
> > +	spin_unlock(&sbi->extent_lock);
> > +
> > +	if (en) {
> > +		kmem_cache_free(extent_node_slab, en);
> > +		atomic_dec(&sbi->total_ext_node);
> 
> 		--> move into __detach_extent_node().

will do.

> 
> > +	}
> > +	if (den) {
> > +		kmem_cache_free(extent_node_slab, den);
> > +		atomic_dec(&sbi->total_ext_node);
> > +	}
> > +
> > +	write_unlock(&et->lock);
> > +	atomic_dec(&et->refcount);
> > +}
> > +
> > +void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
> > +{
> > +	struct extent_tree *treevec[EXT_TREE_VEC_SIZE];
> > +	struct extent_node *en, *tmp;
> > +	unsigned long ino = F2FS_ROOT_INO(sbi);
> > +	struct radix_tree_iter iter;
> > +	void **slot;
> > +	unsigned int found;
> > +	unsigned int node_cnt = 0, tree_cnt = 0;
> > +
> > +	if (available_free_memory(sbi, EXTENT_CACHE))
> > +		return;
> > +
> > +	spin_lock(&sbi->extent_lock);
> > +	list_for_each_entry_safe(en, tmp, &sbi->extent_list, list) {
> > +		if (!nr_shrink--)
> > +			break;
> > +		list_del_init(&en->list);
> > +	}
> > +	spin_unlock(&sbi->extent_lock);
> > +
> > +	down_read(&sbi->extent_tree_lock);
> > +	while ((found = radix_tree_gang_lookup(&sbi->extent_tree_root,
> > +				(void **)treevec, ino, EXT_TREE_VEC_SIZE))) {
> > +		unsigned i;
> > +
> > +		ino = treevec[found - 1]->ino + 1;
> > +		for (i = 0; i < found; i++) {
> > +			struct extent_tree *et = treevec[i];
> > +
> > +			atomic_inc(&et->refcount);
> > +			write_lock(&et->lock);
> > +			node_cnt += __free_extent_tree(sbi, et, false);
> > +			write_unlock(&et->lock);
> > +			atomic_dec(&et->refcount);
> > +		}
> > +	}
> > +	up_read(&sbi->extent_tree_lock);
> > +
> > +	down_write(&sbi->extent_tree_lock);
> > +	radix_tree_for_each_slot(slot, &sbi->extent_tree_root, &iter,
> > +							F2FS_ROOT_INO(sbi)) {
> > +		struct extent_tree *et = (struct extent_tree *)*slot;
> > +
> > +		if (!atomic_read(&et->refcount) && !et->count) {
> > +			radix_tree_delete(&sbi->extent_tree_root, et->ino);
> > +			kmem_cache_free(extent_tree_slab, et);
> > +			sbi->total_ext_tree--;
> > +			tree_cnt++;
> 
> No use of tree_cnt.

This is used by trace function in RFC PATCH 10/10.

Thanks for your review! :)

Regards,
Yu

> 
> Thanks,

[snip]

