Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJAPGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:06:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:33067 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaJAPGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:06:51 -0400
Date: Wed, 1 Oct 2014 08:06:51 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 3/3] f2fs: refactor flush_nat_entries to
 remove costly reorganizing ops
Message-ID: <20141001150651.GA24084@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
 <1411447990-37919-3-git-send-email-jaegeuk@kernel.org>
 <006101cfdc74$783351e0$6899f5a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006101cfdc74$783351e0$6899f5a0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:04:20PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Tuesday, September 23, 2014 12:53 PM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 3/3] f2fs: refactor flush_nat_entries to remove costly reorganizing
> > ops
> > 
> > Previously, f2fs tries to reorganize the dirty nat entries into multiple sets
> > according to its nid ranges. This can improve the flushing nat pages, however,
> > if there are a lot of cached nat entries, it becomes a bottleneck.
> > 
> > This patch introduces a new set management flow by removing dirty nat list and
> > adding a series of set operations when the nat entry becomes dirty.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/f2fs.h |  13 +--
> >  fs/f2fs/node.c | 299 +++++++++++++++++++++++++++++----------------------------
> >  fs/f2fs/node.h |   9 +-
> >  3 files changed, 162 insertions(+), 159 deletions(-)
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 7b1e1d2..94cfdc4 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -164,6 +164,9 @@ struct fsync_inode_entry {
> >  #define sit_in_journal(sum, i)		(sum->sit_j.entries[i].se)
> >  #define segno_in_journal(sum, i)	(sum->sit_j.entries[i].segno)
> > 
> > +#define MAX_NAT_JENTRIES(sum)	(NAT_JOURNAL_ENTRIES - nats_in_cursum(sum))
> > +#define MAX_SIT_JENTRIES(sum)	(SIT_JOURNAL_ENTRIES - sits_in_cursum(sum))
> > +
> >  static inline int update_nats_in_cursum(struct f2fs_summary_block *rs, int i)
> >  {
> >  	int before = nats_in_cursum(rs);
> > @@ -182,9 +185,8 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int
> > size,
> >  								int type)
> >  {
> >  	if (type == NAT_JOURNAL)
> > -		return nats_in_cursum(sum) + size <= NAT_JOURNAL_ENTRIES;
> > -
> > -	return sits_in_cursum(sum) + size <= SIT_JOURNAL_ENTRIES;
> > +		return size <= MAX_NAT_JENTRIES(sum);
> > +	return size <= MAX_SIT_JENTRIES(sum);
> >  }
> > 
> >  /*
> > @@ -292,11 +294,10 @@ struct f2fs_nm_info {
> > 
> >  	/* NAT cache management */
> >  	struct radix_tree_root nat_root;/* root of the nat entry cache */
> > +	struct radix_tree_root nat_set_root;/* root of the nat set cache */
> >  	rwlock_t nat_tree_lock;		/* protect nat_tree_lock */
> > -	unsigned int nat_cnt;		/* the # of cached nat entries */
> >  	struct list_head nat_entries;	/* cached nat entry list (clean) */
> > -	struct list_head dirty_nat_entries; /* cached nat entry list (dirty) */
> > -	struct list_head nat_entry_set;	/* nat entry set list */
> > +	unsigned int nat_cnt;		/* the # of cached nat entries */
> >  	unsigned int dirty_nat_cnt;	/* total num of nat entries in set */
> > 
> >  	/* free node ids management */
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 21ed91b..f5a21f4 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -123,6 +123,57 @@ static void __del_from_nat_cache(struct f2fs_nm_info *nm_i, struct
> > nat_entry *e)
> >  	kmem_cache_free(nat_entry_slab, e);
> >  }
> > 
> > +static void __set_nat_cache_dirty(struct f2fs_nm_info *nm_i,
> > +						struct nat_entry *ne)
> > +{
> > +	nid_t set = ne->ni.nid / NAT_ENTRY_PER_BLOCK;
> 
> nid_t set = NAT_BLOCK_OFFSET(ne->ni.nid);
> 
> > +	struct nat_entry_set *head;
> > +
> > +	if (get_nat_flag(ne, IS_DIRTY))
> > +		return;
> > +retry:
> > +	head = radix_tree_lookup(&nm_i->nat_set_root, set);
> > +	if (!head) {
> > +		head = f2fs_kmem_cache_alloc(nat_entry_set_slab, GFP_ATOMIC);
> > +
> > +		INIT_LIST_HEAD(&head->entry_list);
> > +		INIT_LIST_HEAD(&head->set_list);
> > +		head->set = set;
> > +		head->entry_cnt = 0;
> > +
> > +		if (radix_tree_insert(&nm_i->nat_set_root, set, head)) {
> > +			cond_resched();
> > +			goto retry;
> > +		}
> > +	}
> > +	list_move_tail(&ne->list, &head->entry_list);
> > +	nm_i->dirty_nat_cnt++;
> > +	head->entry_cnt++;
> > +	set_nat_flag(ne, IS_DIRTY, true);
> > +}
> > +
> > +static void __clear_nat_cache_dirty(struct f2fs_nm_info *nm_i,
> > +						struct nat_entry *ne)
> > +{
> > +	nid_t set = ne->ni.nid / NAT_ENTRY_PER_BLOCK;
> > +	struct nat_entry_set *head;
> > +
> > +	head = radix_tree_lookup(&nm_i->nat_set_root, set);
> > +	if (head) {
> > +		list_move_tail(&ne->list, &nm_i->nat_entries);
> > +		set_nat_flag(ne, IS_DIRTY, false);
> > +		head->entry_cnt--;
> > +		nm_i->dirty_nat_cnt--;
> > +	}
> > +}
> > +
> > +static unsigned int __gang_lookup_nat_set(struct f2fs_nm_info *nm_i,
> > +		nid_t start, unsigned int nr, struct nat_entry_set **ep)
> > +{
> > +	return radix_tree_gang_lookup(&nm_i->nat_set_root, (void **)ep,
> > +							start, nr);
> > +}
> > +
> >  bool is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > @@ -1739,79 +1790,6 @@ skip:
> >  	return err;
> >  }
> > 
> > -static struct nat_entry_set *grab_nat_entry_set(void)
> > -{
> > -	struct nat_entry_set *nes =
> > -			f2fs_kmem_cache_alloc(nat_entry_set_slab, GFP_ATOMIC);
> > -
> > -	nes->entry_cnt = 0;
> > -	INIT_LIST_HEAD(&nes->set_list);
> > -	INIT_LIST_HEAD(&nes->entry_list);
> > -	return nes;
> > -}
> > -
> > -static void release_nat_entry_set(struct nat_entry_set *nes,
> > -						struct f2fs_nm_info *nm_i)
> > -{
> > -	nm_i->dirty_nat_cnt -= nes->entry_cnt;
> > -	list_del(&nes->set_list);
> > -	kmem_cache_free(nat_entry_set_slab, nes);
> > -}
> > -
> > -static void adjust_nat_entry_set(struct nat_entry_set *nes,
> > -						struct list_head *head)
> > -{
> > -	struct nat_entry_set *next = nes;
> > -
> > -	if (list_is_last(&nes->set_list, head))
> > -		return;
> > -
> > -	list_for_each_entry_continue(next, head, set_list)
> > -		if (nes->entry_cnt <= next->entry_cnt)
> > -			break;
> > -
> > -	list_move_tail(&nes->set_list, &next->set_list);
> > -}
> > -
> > -static void add_nat_entry(struct nat_entry *ne, struct list_head *head)
> > -{
> > -	struct nat_entry_set *nes;
> > -	nid_t start_nid = START_NID(ne->ni.nid);
> > -
> > -	list_for_each_entry(nes, head, set_list) {
> > -		if (nes->start_nid == start_nid) {
> > -			list_move_tail(&ne->list, &nes->entry_list);
> > -			nes->entry_cnt++;
> > -			adjust_nat_entry_set(nes, head);
> > -			return;
> > -		}
> > -	}
> > -
> > -	nes = grab_nat_entry_set();
> > -
> > -	nes->start_nid = start_nid;
> > -	list_move_tail(&ne->list, &nes->entry_list);
> > -	nes->entry_cnt++;
> > -	list_add(&nes->set_list, head);
> > -}
> > -
> > -static void merge_nats_in_set(struct f2fs_sb_info *sbi)
> > -{
> > -	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > -	struct list_head *dirty_list = &nm_i->dirty_nat_entries;
> > -	struct list_head *set_list = &nm_i->nat_entry_set;
> > -	struct nat_entry *ne, *tmp;
> > -
> > -	write_lock(&nm_i->nat_tree_lock);
> > -	list_for_each_entry_safe(ne, tmp, dirty_list, list) {
> > -		if (nat_get_blkaddr(ne) == NEW_ADDR)
> > -			continue;
> 
> Shouldn't we move this condition judgment into __flush_nat_entry_set?
> 
> > -		add_nat_entry(ne, set_list);
> > -		nm_i->dirty_nat_cnt++;
> > -	}
> > -	write_unlock(&nm_i->nat_tree_lock);
> > -}
> > -
> >  static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > @@ -1846,101 +1824,129 @@ found:
> >  	mutex_unlock(&curseg->curseg_mutex);
> >  }
> > 
> > -/*
> > - * This function is called during the checkpointing process.
> > - */
> > -void flush_nat_entries(struct f2fs_sb_info *sbi)
> > +static void __adjust_nat_entry_set(struct nat_entry_set *nes,
> > +						struct list_head *head, int max)
> >  {
> > -	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > -	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
> > -	struct f2fs_summary_block *sum = curseg->sum_blk;
> > -	struct nat_entry_set *nes, *tmp;
> > -	struct list_head *head = &nm_i->nat_entry_set;
> > -	bool to_journal = true;
> > +	struct nat_entry_set *cur;
> > +	nid_t dirty_cnt = 0;
> > 
> > -	/* merge nat entries of dirty list to nat entry set temporarily */
> > -	merge_nats_in_set(sbi);
> > +	if (nes->entry_cnt >= max)
> > +		goto add_out;
> > 
> > -	/*
> > -	 * if there are no enough space in journal to store dirty nat
> > -	 * entries, remove all entries from journal and merge them
> > -	 * into nat entry set.
> > -	 */
> > -	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt, NAT_JOURNAL)) {
> > -		remove_nats_in_journal(sbi);
> > -
> > -		/*
> > -		 * merge nat entries of dirty list to nat entry set temporarily
> > -		 */
> > -		merge_nats_in_set(sbi);
> > +	list_for_each_entry(cur, head, set_list) {
> > +		dirty_cnt += cur->entry_cnt;
> > +		if (dirty_cnt > max)
> > +			break;
> 
> Seems a problem here, For example:
> set no:		1	2	3	4	5	6	7
> nat number:	4	3	2	1	1	1	1
> max = 6
> set list will be: 3--4--2--1--1--1--1
> Then we will prior flush nat set with more entries in the set list, result in
> a degradation.
> We'd better not break the adjustment until we finish to traverse the whole
> sequential sorted set list to avoid above condition, so how about removing the
> codes relate to dirty_cnt?

Hi Chao,

Agreed.
I fixed that.
Thanks,

> 
> Thanks,
> Yu
> 
> > +		if (cur->entry_cnt >= nes->entry_cnt) {
> > +			list_add(&nes->set_list, cur->set_list.prev);
> > +			return;
> > +		}
> >  	}
> > +add_out:
> > +	list_add_tail(&nes->set_list, head);
> > +}
> > 
> > -	if (!nm_i->dirty_nat_cnt)
> > -		return;
> > +static void __flush_nat_entry_set(struct f2fs_sb_info *sbi,
> > +					struct nat_entry_set *set)
> > +{
> > +	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
> > +	struct f2fs_summary_block *sum = curseg->sum_blk;
> > +	nid_t start_nid = set->set * NAT_ENTRY_PER_BLOCK;
> > +	bool to_journal = true;
> > +	struct f2fs_nat_block *nat_blk;
> > +	struct nat_entry *ne, *cur;
> > +	struct page *page = NULL;
> > 
> >  	/*
> >  	 * there are two steps to flush nat entries:
> >  	 * #1, flush nat entries to journal in current hot data summary block.
> >  	 * #2, flush nat entries to nat page.
> >  	 */
> > -	list_for_each_entry_safe(nes, tmp, head, set_list) {
> > -		struct f2fs_nat_block *nat_blk;
> > -		struct nat_entry *ne, *cur;
> > -		struct page *page;
> > -		nid_t start_nid = nes->start_nid;
> > +	if (!__has_cursum_space(sum, set->entry_cnt, NAT_JOURNAL))
> > +		to_journal = false;
> > 
> > -		if (to_journal &&
> > -			!__has_cursum_space(sum, nes->entry_cnt, NAT_JOURNAL))
> > -			to_journal = false;
> > +	if (to_journal) {
> > +		mutex_lock(&curseg->curseg_mutex);
> > +	} else {
> > +		page = get_next_nat_page(sbi, start_nid);
> > +		nat_blk = page_address(page);
> > +		f2fs_bug_on(sbi, !nat_blk);
> > +	}
> > +
> > +	/* flush dirty nats in nat entry set */
> > +	list_for_each_entry_safe(ne, cur, &set->entry_list, list) {
> > +		struct f2fs_nat_entry *raw_ne;
> > +		nid_t nid = nat_get_nid(ne);
> > +		int offset;
> > 
> >  		if (to_journal) {
> > -			mutex_lock(&curseg->curseg_mutex);
> > +			offset = lookup_journal_in_cursum(sum,
> > +							NAT_JOURNAL, nid, 1);
> > +			f2fs_bug_on(sbi, offset < 0);
> > +			raw_ne = &nat_in_journal(sum, offset);
> > +			nid_in_journal(sum, offset) = cpu_to_le32(nid);
> >  		} else {
> > -			page = get_next_nat_page(sbi, start_nid);
> > -			nat_blk = page_address(page);
> > -			f2fs_bug_on(sbi, !nat_blk);
> > +			raw_ne = &nat_blk->entries[nid - start_nid];
> >  		}
> > +		raw_nat_from_node_info(raw_ne, &ne->ni);
> > 
> > -		/* flush dirty nats in nat entry set */
> > -		list_for_each_entry_safe(ne, cur, &nes->entry_list, list) {
> > -			struct f2fs_nat_entry *raw_ne;
> > -			nid_t nid = nat_get_nid(ne);
> > -			int offset;
> > +		write_lock(&NM_I(sbi)->nat_tree_lock);
> > +		nat_reset_flag(ne);
> > +		__clear_nat_cache_dirty(NM_I(sbi), ne);
> > +		write_unlock(&NM_I(sbi)->nat_tree_lock);
> > 
> > -			if (to_journal) {
> > -				offset = lookup_journal_in_cursum(sum,
> > -							NAT_JOURNAL, nid, 1);
> > -				f2fs_bug_on(sbi, offset < 0);
> > -				raw_ne = &nat_in_journal(sum, offset);
> > -				nid_in_journal(sum, offset) = cpu_to_le32(nid);
> > -			} else {
> > -				raw_ne = &nat_blk->entries[nid - start_nid];
> > -			}
> > -			raw_nat_from_node_info(raw_ne, &ne->ni);
> > +		if (nat_get_blkaddr(ne) == NULL_ADDR)
> > +			add_free_nid(sbi, nid, false);
> > +	}
> > 
> > -			if (nat_get_blkaddr(ne) == NULL_ADDR &&
> > -				add_free_nid(sbi, nid, false) <= 0) {
> > -				write_lock(&nm_i->nat_tree_lock);
> > -				__del_from_nat_cache(nm_i, ne);
> > -				write_unlock(&nm_i->nat_tree_lock);
> > -			} else {
> > -				write_lock(&nm_i->nat_tree_lock);
> > -				nat_reset_flag(ne);
> > -				__clear_nat_cache_dirty(nm_i, ne);
> > -				write_unlock(&nm_i->nat_tree_lock);
> > -			}
> > -		}
> > +	if (to_journal)
> > +		mutex_unlock(&curseg->curseg_mutex);
> > +	else
> > +		f2fs_put_page(page, 1);
> > 
> > -		if (to_journal)
> > -			mutex_unlock(&curseg->curseg_mutex);
> > -		else
> > -			f2fs_put_page(page, 1);
> > +	f2fs_bug_on(sbi, set->entry_cnt);
> > +	radix_tree_delete(&NM_I(sbi)->nat_set_root, set->set);
> > +	kmem_cache_free(nat_entry_set_slab, set);
> > +}
> > 
> > -		f2fs_bug_on(sbi, !list_empty(&nes->entry_list));
> > -		release_nat_entry_set(nes, nm_i);
> > +/*
> > + * This function is called during the checkpointing process.
> > + */
> > +void flush_nat_entries(struct f2fs_sb_info *sbi)
> > +{
> > +	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > +	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
> > +	struct f2fs_summary_block *sum = curseg->sum_blk;
> > +	struct nat_entry_set *setvec[NATVEC_SIZE];
> > +	struct nat_entry_set *set, *tmp;
> > +	unsigned int found;
> > +	nid_t set_idx = 0;
> > +	LIST_HEAD(sets);
> > +
> > +	/*
> > +	 * if there are no enough space in journal to store dirty nat
> > +	 * entries, remove all entries from journal and merge them
> > +	 * into nat entry set.
> > +	 */
> > +	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt, NAT_JOURNAL))
> > +		remove_nats_in_journal(sbi);
> > +
> > +	if (!nm_i->dirty_nat_cnt)
> > +		return;
> > +
> > +	while ((found = __gang_lookup_nat_set(nm_i,
> > +					set_idx, NATVEC_SIZE, setvec))) {
> > +		unsigned idx;
> > +		set_idx = setvec[found - 1]->set + 1;
> > +		for (idx = 0; idx < found; idx++)
> > +			__adjust_nat_entry_set(setvec[idx], &sets,
> > +							MAX_NAT_JENTRIES(sum));
> >  	}
> > 
> > -	f2fs_bug_on(sbi, !list_empty(head));
> > +	/* flush dirty nats in nat entry set */
> > +	list_for_each_entry_safe(set, tmp, &sets, set_list)
> > +		__flush_nat_entry_set(sbi, set);
> > +
> >  	f2fs_bug_on(sbi, nm_i->dirty_nat_cnt);
> >  }
> > 
> > @@ -1968,9 +1974,8 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
> >  	INIT_RADIX_TREE(&nm_i->free_nid_root, GFP_ATOMIC);
> >  	INIT_LIST_HEAD(&nm_i->free_nid_list);
> >  	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
> > +	INIT_RADIX_TREE(&nm_i->nat_set_root, GFP_ATOMIC);
> >  	INIT_LIST_HEAD(&nm_i->nat_entries);
> > -	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
> > -	INIT_LIST_HEAD(&nm_i->nat_entry_set);
> > 
> >  	mutex_init(&nm_i->build_lock);
> >  	spin_lock_init(&nm_i->free_nid_list_lock);
> > diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> > index b8ba63c..bd826d9 100644
> > --- a/fs/f2fs/node.h
> > +++ b/fs/f2fs/node.h
> > @@ -43,6 +43,7 @@ enum {
> >  	IS_CHECKPOINTED,	/* is it checkpointed before? */
> >  	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
> >  	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
> > +	IS_DIRTY,		/* this nat entry is dirty? */
> >  };
> > 
> >  struct nat_entry {
> > @@ -60,10 +61,6 @@ struct nat_entry {
> >  #define nat_get_version(nat)		(nat->ni.version)
> >  #define nat_set_version(nat, v)		(nat->ni.version = v)
> > 
> > -#define __set_nat_cache_dirty(nm_i, ne)					\
> > -		list_move_tail(&ne->list, &nm_i->dirty_nat_entries);
> > -#define __clear_nat_cache_dirty(nm_i, ne)				\
> > -		list_move_tail(&ne->list, &nm_i->nat_entries);
> >  #define inc_node_version(version)	(++version)
> > 
> >  static inline void set_nat_flag(struct nat_entry *ne,
> > @@ -113,9 +110,9 @@ enum mem_type {
> >  };
> > 
> >  struct nat_entry_set {
> > -	struct list_head set_list;	/* link with all nat sets */
> > +	struct list_head set_list;	/* link with other nat sets */
> >  	struct list_head entry_list;	/* link with dirty nat entries */
> > -	nid_t start_nid;		/* start nid of nats in set */
> > +	nid_t set;			/* set number*/
> >  	unsigned int entry_cnt;		/* the # of nat entries in set */
> >  };
> > 
> > --
> > 1.8.5.2 (Apple Git-48)
> > 
> > 
> > ------------------------------------------------------------------------------
> > Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
> > Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
> > Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
> > Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
> > http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
