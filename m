Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaFWVk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:40:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:41593 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaFWVk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:40:58 -0400
Date: Tue, 24 Jun 2014 06:40:53 +0900
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 RESEND] f2fs: refactor flush_nat_entries
 codes for reducing NAT writes
Message-ID: <20140623214053.GA3088@jmac.local>
References: <003a01cf8c6b$ff39a170$fdace450$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003a01cf8c6b$ff39a170$fdace450$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

Thank you for the patch. :)
Just one minor suggestion.

[snip]

>  /*
> @@ -1792,80 +1864,87 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
>  	struct f2fs_summary_block *sum = curseg->sum_blk;
> -	struct nat_entry *ne, *cur;
> -	struct page *page = NULL;
> -	struct f2fs_nat_block *nat_blk = NULL;
> -	nid_t start_nid = 0, end_nid = 0;
> -	bool flushed;
> -
> -	flushed = flush_nats_in_journal(sbi);
> -
> -	if (!flushed)
> -		mutex_lock(&curseg->curseg_mutex);
> -
> -	/* 1) flush dirty nat caches */
> -	list_for_each_entry_safe(ne, cur, &nm_i->dirty_nat_entries, list) {
> -		nid_t nid;
> -		struct f2fs_nat_entry raw_ne;
> -		int offset = -1;
> -
> -		if (nat_get_blkaddr(ne) == NEW_ADDR)
> -			continue;
> +	struct nat_entry_set *nes, *tmp;
> +	struct list_head *head = &nm_i->nat_entry_set;
> +	bool to_journal = true;
>  
> -		nid = nat_get_nid(ne);
> +	/* merge nat entries of dirty list to nat entry set temporarily */
> +	merge_nats_in_set(sbi);
>  
> -		if (flushed)
> -			goto to_nat_page;
> +	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt)) {
> +		/*
> +		 * if there are no enough space in journal to store dirty nat
> +		 * entries, remove all entries from journal and merge them
> +		 * into nat entry set.
> +		 */
> +		remove_nats_in_journal(sbi);
> +		merge_nats_in_set(sbi);
> +	}

How about this?

	/*
	 * if there are no enough space in journal to store dirty nat
	 * entries, remove all entries from journal and merge them
	 * into nat entry set.
	 */
	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt))
		remove_nats_in_journal(sbi);
		
	/* merge nat entries of dirty list to nat entry set temporarily */
	merge_nats_in_set(sbi);

Thanks,

>  
> -		/* if there is room for nat enries in curseg->sumpage */
> -		offset = lookup_journal_in_cursum(sum, NAT_JOURNAL, nid, 1);
> -		if (offset >= 0) {
> -			raw_ne = nat_in_journal(sum, offset);
> -			goto flush_now;
> -		}
> -to_nat_page:
> -		if (!page || (start_nid > nid || nid > end_nid)) {
> -			if (page) {
> -				f2fs_put_page(page, 1);
> -				page = NULL;
> -			}
> -			start_nid = START_NID(nid);
> -			end_nid = start_nid + NAT_ENTRY_PER_BLOCK - 1;
> +	if (!nm_i->dirty_nat_cnt)
> +		return;
>  
> -			/*
> -			 * get nat block with dirty flag, increased reference
> -			 * count, mapped and lock
> -			 */
> +	/*
> +	 * there are two steps to flush nat entries:
> +	 * #1, flush nat entries to journal in current hot data summary block.
> +	 * #2, flush nat entries to nat page.
> +	 */
> +	list_for_each_entry_safe(nes, tmp, head, set_list) {
> +		struct f2fs_nat_block *nat_blk;
> +		struct nat_entry *ne, *cur;
> +		struct page *page;
> +		nid_t start_nid = nes->start_nid;
> +
> +		if (to_journal && !__has_cursum_space(sum, nes->entry_cnt))
> +			to_journal = false;
> +
> +		if (to_journal) {
> +			mutex_lock(&curseg->curseg_mutex);
> +		} else {
>  			page = get_next_nat_page(sbi, start_nid);
>  			nat_blk = page_address(page);
> +			f2fs_bug_on(!nat_blk);
>  		}
>  
> -		f2fs_bug_on(!nat_blk);
> -		raw_ne = nat_blk->entries[nid - start_nid];
> -flush_now:
> -		raw_nat_from_node_info(&raw_ne, &ne->ni);
> -
> -		if (offset < 0) {
> -			nat_blk->entries[nid - start_nid] = raw_ne;
> -		} else {
> -			nat_in_journal(sum, offset) = raw_ne;
> -			nid_in_journal(sum, offset) = cpu_to_le32(nid);
> -		}
> +		/* flush dirty nats in nat entry set */
> +		list_for_each_entry_safe(ne, cur, &nes->entry_list, list) {
> +			struct f2fs_nat_entry *raw_ne;
> +			nid_t nid = nat_get_nid(ne);
> +			int offset;
> +
> +			if (to_journal) {
> +				offset = lookup_journal_in_cursum(sum,
> +							NAT_JOURNAL, nid, 1);
> +				f2fs_bug_on(offset < 0);
> +				raw_ne = &nat_in_journal(sum, offset);
> +				nid_in_journal(sum, offset) = cpu_to_le32(nid);
> +			} else {
> +				raw_ne = &nat_blk->entries[nid - start_nid];
> +			}
> +			raw_nat_from_node_info(raw_ne, &ne->ni);
>  
> -		if (nat_get_blkaddr(ne) == NULL_ADDR &&
> +			if (nat_get_blkaddr(ne) == NULL_ADDR &&
>  				add_free_nid(sbi, nid, false) <= 0) {
> -			write_lock(&nm_i->nat_tree_lock);
> -			__del_from_nat_cache(nm_i, ne);
> -			write_unlock(&nm_i->nat_tree_lock);
> -		} else {
> -			write_lock(&nm_i->nat_tree_lock);
> -			__clear_nat_cache_dirty(nm_i, ne);
> -			write_unlock(&nm_i->nat_tree_lock);
> +				write_lock(&nm_i->nat_tree_lock);
> +				__del_from_nat_cache(nm_i, ne);
> +				write_unlock(&nm_i->nat_tree_lock);
> +			} else {
> +				write_lock(&nm_i->nat_tree_lock);
> +				__clear_nat_cache_dirty(nm_i, ne);
> +				write_unlock(&nm_i->nat_tree_lock);
> +			}
>  		}
> +
> +		if (to_journal)
> +			mutex_unlock(&curseg->curseg_mutex);
> +		else
> +			f2fs_put_page(page, 1);
> +
> +		release_nat_entry_set(nes, nm_i);
>  	}
> -	if (!flushed)
> -		mutex_unlock(&curseg->curseg_mutex);
> -	f2fs_put_page(page, 1);
> +
> +	f2fs_bug_on(!list_empty(head));
> +	f2fs_bug_on(nm_i->dirty_nat_cnt);
>  }
>  
>  static int init_node_manager(struct f2fs_sb_info *sbi)
> @@ -1894,6 +1973,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
>  	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
>  	INIT_LIST_HEAD(&nm_i->nat_entries);
>  	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
> +	INIT_LIST_HEAD(&nm_i->nat_entry_set);
>  
>  	mutex_init(&nm_i->build_lock);
>  	spin_lock_init(&nm_i->free_nid_list_lock);
> @@ -1974,19 +2054,30 @@ int __init create_node_manager_caches(void)
>  	nat_entry_slab = f2fs_kmem_cache_create("nat_entry",
>  			sizeof(struct nat_entry));
>  	if (!nat_entry_slab)
> -		return -ENOMEM;
> +		goto fail;
>  
>  	free_nid_slab = f2fs_kmem_cache_create("free_nid",
>  			sizeof(struct free_nid));
> -	if (!free_nid_slab) {
> -		kmem_cache_destroy(nat_entry_slab);
> -		return -ENOMEM;
> -	}
> +	if (!free_nid_slab)
> +		goto destory_nat_entry;
> +
> +	nat_entry_set_slab = f2fs_kmem_cache_create("nat_entry_set",
> +			sizeof(struct nat_entry_set));
> +	if (!nat_entry_set_slab)
> +		goto destory_free_nid;
>  	return 0;
> +
> +destory_free_nid:
> +	kmem_cache_destroy(free_nid_slab);
> +destory_nat_entry:
> +	kmem_cache_destroy(nat_entry_slab);
> +fail:
> +	return -ENOMEM;
>  }
>  
>  void destroy_node_manager_caches(void)
>  {
> +	kmem_cache_destroy(nat_entry_set_slab);
>  	kmem_cache_destroy(free_nid_slab);
>  	kmem_cache_destroy(nat_entry_slab);
>  }
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index 7281112..8a116a4 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -89,6 +89,13 @@ enum mem_type {
>  	DIRTY_DENTS	/* indicates dirty dentry pages */
>  };
>  
> +struct nat_entry_set {
> +	struct list_head set_list;	/* link with all nat sets */
> +	struct list_head entry_list;	/* link with dirty nat entries */
> +	nid_t start_nid;		/* start nid of nats in set */
> +	unsigned int entry_cnt;		/* the # of nat entries in set */
> +};
> +
>  /*
>   * For free nid mangement
>   */
> -- 
> 1.7.9.5

-- 
Jaegeuk Kim
