Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaCaKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:16:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbaCaKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:16:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,763,1389715200"; 
   d="scan'208";a="9799974"
Message-ID: <53393E47.5070600@cn.fujitsu.com>
Date: Mon, 31 Mar 2014 18:07:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: ??? <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: use list_for_each_entry{_safe} for
 simplyfying code
References: <000001cf4aff$baaf99e0$300ecda0$@samsung.com>
In-Reply-To: <000001cf4aff$baaf99e0$300ecda0$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 18:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 18:13:06,
	Serialize complete at 2014/03/31 18:13:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
On 03/29/2014 11:33 AM, Chao Yu wrote:

> This patch use list_for_each_entry{_safe} instead of list_for_each{_safe} for
> simplfying code.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |   37 ++++++++++++++-----------------------
>  fs/f2fs/node.c       |   16 ++++++----------
>  fs/f2fs/recovery.c   |    6 ++----
>  fs/f2fs/segment.c    |    6 ++----
>  4 files changed, 24 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index d877f46..4aa521a 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -308,16 +308,15 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
>  
>  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
> -	struct list_head *head, *this;
> -	struct orphan_inode_entry *new = NULL, *orphan = NULL;
> +	struct list_head *head;
> +	struct orphan_inode_entry *new, *orphan;
>  
>  	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
>  	new->ino = ino;
>  
>  	spin_lock(&sbi->orphan_inode_lock);
>  	head = &sbi->orphan_inode_list;
> -	list_for_each(this, head) {
> -		orphan = list_entry(this, struct orphan_inode_entry, list);
> +	list_for_each_entry(orphan, head, list) {
>  		if (orphan->ino == ino) {
>  			spin_unlock(&sbi->orphan_inode_lock);
>  			kmem_cache_free(orphan_entry_slab, new);
> @@ -326,14 +325,10 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  
>  		if (orphan->ino > ino)
>  			break;
> -		orphan = NULL;
>  	}
>  
> -	/* add new_oentry into list which is sorted by inode number */
> -	if (orphan)
> -		list_add(&new->list, this->prev);
> -	else
> -		list_add_tail(&new->list, head);
> +	/* add new orphan entry into list which is sorted by inode number */
> +	list_add_tail(&new->list, &orphan->list);

It seems that the logic can not be changed here, otherwise the orphan list will not be in order if
the new ino is bigger than all the in-list ones.
E.g.
ino:5
1-->2-->3-->4
==>
1-->2-->3-->5-->4

Regards,
Gu

>  	spin_unlock(&sbi->orphan_inode_lock);
>  }
>  
> @@ -561,14 +556,12 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct list_head *head = &sbi->dir_inode_list;
> -	struct list_head *this;
> +	struct dir_inode_entry *entry;
>  
> -	list_for_each(this, head) {
> -		struct dir_inode_entry *entry;
> -		entry = list_entry(this, struct dir_inode_entry, list);
> +	list_for_each_entry(entry, head, list)
>  		if (unlikely(entry->inode == inode))
>  			return -EEXIST;
> -	}
> +
>  	list_add_tail(&new->list, head);
>  	stat_inc_dirty_dir(sbi);
>  	return 0;
> @@ -618,7 +611,8 @@ void add_dirty_dir_inode(struct inode *inode)
>  void remove_dirty_dir_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -	struct list_head *this, *head;
> +	struct list_head *head;
> +	struct dir_inode_entry *entry;
>  
>  	if (!S_ISDIR(inode->i_mode))
>  		return;
> @@ -630,9 +624,7 @@ void remove_dirty_dir_inode(struct inode *inode)
>  	}
>  
>  	head = &sbi->dir_inode_list;
> -	list_for_each(this, head) {
> -		struct dir_inode_entry *entry;
> -		entry = list_entry(this, struct dir_inode_entry, list);
> +	list_for_each_entry(entry, head, list) {
>  		if (entry->inode == inode) {
>  			list_del(&entry->list);
>  			stat_dec_dirty_dir(sbi);
> @@ -654,15 +646,14 @@ done:
>  struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
>  
> -	struct list_head *this, *head;
> +	struct list_head *head;
>  	struct inode *inode = NULL;
> +	struct dir_inode_entry *entry;
>  
>  	spin_lock(&sbi->dir_inode_lock);
>  
>  	head = &sbi->dir_inode_list;
> -	list_for_each(this, head) {
> -		struct dir_inode_entry *entry;
> -		entry = list_entry(this, struct dir_inode_entry, list);
> +	list_for_each_entry(entry, head, list) {
>  		if (entry->inode->i_ino == ino) {
>  			inode = entry->inode;
>  			break;
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 0021056..afda3d3 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1452,7 +1452,6 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
>  {
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct free_nid *i = NULL;
> -	struct list_head *this;
>  retry:
>  	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
>  		return false;
> @@ -1462,11 +1461,9 @@ retry:
>  	/* We should not use stale free nids created by build_free_nids */
>  	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
>  		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
> -		list_for_each(this, &nm_i->free_nid_list) {
> -			i = list_entry(this, struct free_nid, list);
> +		list_for_each_entry(i, &nm_i->free_nid_list, list)
>  			if (i->state == NID_NEW)
>  				break;
> -		}
>  
>  		f2fs_bug_on(i->state != NID_NEW);
>  		*nid = i->nid;
> @@ -1781,7 +1778,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
>  	struct f2fs_summary_block *sum = curseg->sum_blk;
> -	struct list_head *cur, *n;
> +	struct nat_entry *ne, *cur;
>  	struct page *page = NULL;
>  	struct f2fs_nat_block *nat_blk = NULL;
>  	nid_t start_nid = 0, end_nid = 0;
> @@ -1793,18 +1790,17 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
>  		mutex_lock(&curseg->curseg_mutex);
>  
>  	/* 1) flush dirty nat caches */
> -	list_for_each_safe(cur, n, &nm_i->dirty_nat_entries) {
> -		struct nat_entry *ne;
> +	list_for_each_entry_safe(ne, cur, &nm_i->dirty_nat_entries, list) {
>  		nid_t nid;
>  		struct f2fs_nat_entry raw_ne;
>  		int offset = -1;
>  		block_t new_blkaddr;
>  
> -		ne = list_entry(cur, struct nat_entry, list);
> -		nid = nat_get_nid(ne);
> -
>  		if (nat_get_blkaddr(ne) == NEW_ADDR)
>  			continue;
> +
> +		nid = nat_get_nid(ne);
> +
>  		if (flushed)
>  			goto to_nat_page;
>  
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index bbef4ed..b1ae89f 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -27,14 +27,12 @@ bool space_for_roll_forward(struct f2fs_sb_info *sbi)
>  static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
>  								nid_t ino)
>  {
> -	struct list_head *this;
>  	struct fsync_inode_entry *entry;
>  
> -	list_for_each(this, head) {
> -		entry = list_entry(this, struct fsync_inode_entry, list);
> +	list_for_each_entry(entry, head, list)
>  		if (entry->inode->i_ino == ino)
>  			return entry;
> -	}
> +
>  	return NULL;
>  }
>  
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 570ab9a..cb49e63 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -340,8 +340,7 @@ static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
>  void clear_prefree_segments(struct f2fs_sb_info *sbi)
>  {
>  	struct list_head *head = &(SM_I(sbi)->discard_list);
> -	struct list_head *this, *next;
> -	struct discard_entry *entry;
> +	struct discard_entry *entry, *this;
>  	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
>  	unsigned long *prefree_map = dirty_i->dirty_segmap[PRE];
>  	unsigned int total_segs = TOTAL_SEGS(sbi);
> @@ -370,8 +369,7 @@ void clear_prefree_segments(struct f2fs_sb_info *sbi)
>  	mutex_unlock(&dirty_i->seglist_lock);
>  
>  	/* send small discards */
> -	list_for_each_safe(this, next, head) {
> -		entry = list_entry(this, struct discard_entry, list);
> +	list_for_each_entry_safe(entry, this, head, list) {
>  		f2fs_issue_discard(sbi, entry->blkaddr, entry->len);
>  		list_del(&entry->list);
>  		SM_I(sbi)->nr_discards -= entry->len;


