Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaIVHjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:39:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:39420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaIVHjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:39:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="389612667"
Message-ID: <1411371529.9934.3.camel@yhuang-mobile.sh.intel.com>
Subject: Re: [f2fs-dev] [PATCH 2/3] f2fs: fix conditions to remain recovery
 information in f2fs_sync_file
From: Huang Ying <ying.huang@intel.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 22 Sep 2014 15:38:49 +0800
In-Reply-To: <005501cfd636$5b6f69c0$124e3d40$@samsung.com>
References: <1411019468-2201-1-git-send-email-jaegeuk@kernel.org>
	 <1411019468-2201-2-git-send-email-jaegeuk@kernel.org>
	 <005501cfd636$5b6f69c0$124e3d40$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 15:24 +0800, Chao Yu wrote:
> Hi Jaegeuk, Huang,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Thursday, September 18, 2014 1:51 PM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim; Huang Ying
> > Subject: [f2fs-dev] [PATCH 2/3] f2fs: fix conditions to remain recovery information in
> > f2fs_sync_file
> > 
> > This patch revisited whole the recovery information during the f2fs_sync_file.
> > 
> > In this patch, there are three information to make a decision.
> > 
> > a) IS_CHECKPOINTED,	/* is it checkpointed before? */
> > b) HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
> > c) HAS_LAST_FSYNC,	/* has the latest node fsync mark? */
> > 
> > And, the scenarios for our rule are based on:
> > 
> > [Term] F: fsync_mark, D: dentry_mark
> > 
> > 1. inode(x) | CP | inode(x) | dnode(F)
> > 2. inode(x) | CP | inode(F) | dnode(F)
> > 3. inode(x) | CP | dnode(F) | inode(x) | inode(F)
> > 4. inode(x) | CP | dnode(F) | inode(F)
> > 5. CP | inode(x) | dnode(F) | inode(DF)
> > 6. CP | inode(DF) | dnode(F)
> > 7. CP | dnode(F) | inode(DF)
> > 8. CP | dnode(F) | inode(x) | inode(DF)
> 
> No sure, do we missed these cases:
> inode(x) | CP | inode(F) | dnode(x) -> write inode(F)
> CP | inode(DF) | dnode(x) -> write inode(F)
> 
> In these cases we will write another inode with fsync flag because our last
> dnode is written out to disk by bdi-flusher (HAS_LAST_FSYNC is not marked). But
> this appended inode is not useful.
> 
> AFAIK, HAS_LAST_FSYNC(AKA fsync_done) is introduced in commit 479f40c44ae3
> ("f2fs: skip unnecessary node writes during fsync") to avoid writting multiple
> unneeded inode page by multiple redundant fsync calls. But for now, its role can
> be taken by HAS_FSYNCED_INODE.
> So, can we remove this flag to simplify our logic of fsync flow?
> 
> Then in fsync flow, the rule can be:
> If CPed before, there must be a inode(F) written in warm node chain;

How about

inode(x) | CP | dnode(F)

> If not CPed before, there must be a inode(DF) written in warm node chain.

For example below:

1) checkpoint
2) create "a", change "a"
3) fsync "a"
4) open "a", change "a"

Do we want recovery to stop at dnode(F) in step 3) or stop at dnode(x)
produced by step 4)?

Best Regards,
Huang, Ying

> > 
> > For example, #3, the three conditions should be changed as follows.
> > 
> >    inode(x) | CP | dnode(F) | inode(x) | inode(F)
> > a)    x       o      o          o          o
> > b)    x       x      x          x          o
> > c)    x       o      o          x          o
> > 
> > If f2fs_sync_file stops   ------^,
> >  it should write inode(F)    --------------^
> > 
> > So, the need_inode_block_update should return true, since
> >  c) get_nat_flag(e, HAS_LAST_FSYNC), is false.
> > 
> > For example, #8,
> >       CP | alloc | dnode(F) | inode(x) | inode(DF)
> > a)    o      x        x          x          x
> > b)    x               x          x          o
> > c)    o               o          x          o
> > 
> > If f2fs_sync_file stops   -------^,
> >  it should write inode(DF)    --------------^
> > 
> > Note that, the roll-forward policy should follow this rule, which means,
> > if there are any missing blocks, we doesn't need to recover that inode.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/data.c |  3 ---
> >  fs/f2fs/f2fs.h |  6 +++---
> >  fs/f2fs/file.c | 10 ++++++----
> >  fs/f2fs/node.c | 56 +++++++++++++++++++++++++++++++++++---------------------
> >  fs/f2fs/node.h | 21 ++++++++++++---------
> >  5 files changed, 56 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 0e37658..fdc3dbe 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -1089,9 +1089,6 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
> >  	if (check_direct_IO(inode, rw, iter, offset))
> >  		return 0;
> > 
> > -	/* clear fsync mark to recover these blocks */
> > -	fsync_mark_clear(F2FS_I_SB(inode), inode->i_ino);
> > -
> >  	trace_f2fs_direct_IO_enter(inode, offset, count, rw);
> > 
> >  	err = blockdev_direct_IO(rw, iocb, inode, iter, offset, get_data_block);
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 9fc1bcd..fd44083 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1224,9 +1224,9 @@ struct dnode_of_data;
> >  struct node_info;
> > 
> >  bool available_free_memory(struct f2fs_sb_info *, int);
> > -int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
> > -bool fsync_mark_done(struct f2fs_sb_info *, nid_t);
> > -void fsync_mark_clear(struct f2fs_sb_info *, nid_t);
> > +bool is_checkpointed_node(struct f2fs_sb_info *, nid_t);
> > +bool has_fsynced_inode(struct f2fs_sb_info *, nid_t);
> > +bool need_inode_block_update(struct f2fs_sb_info *, nid_t);
> >  void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
> >  int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
> >  int truncate_inode_blocks(struct inode *, pgoff_t);
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index af06e22..3035c79 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -207,15 +207,17 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> > datasync)
> >  			up_write(&fi->i_sem);
> >  		}
> >  	} else {
> > -		/* if there is no written node page, write its inode page */
> > -		while (!sync_node_pages(sbi, ino, &wbc)) {
> > -			if (fsync_mark_done(sbi, ino))
> > -				goto out;
> > +sync_nodes:
> > +		sync_node_pages(sbi, ino, &wbc);
> > +
> > +		if (need_inode_block_update(sbi, ino)) {
> >  			mark_inode_dirty_sync(inode);
> >  			ret = f2fs_write_inode(inode, NULL);
> >  			if (ret)
> >  				goto out;
> > +			goto sync_nodes;
> >  		}
> > +
> >  		ret = wait_on_node_pages_writeback(sbi, ino);
> >  		if (ret)
> >  			goto out;
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index d19d6b1..7a2d9c9 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -123,44 +123,48 @@ static void __del_from_nat_cache(struct f2fs_nm_info *nm_i, struct
> > nat_entry *e)
> >  	kmem_cache_free(nat_entry_slab, e);
> >  }
> > 
> > -int is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
> > +bool is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> >  	struct nat_entry *e;
> > -	int is_cp = 1;
> > +	bool is_cp = true;
> > 
> >  	read_lock(&nm_i->nat_tree_lock);
> >  	e = __lookup_nat_cache(nm_i, nid);
> >  	if (e && !get_nat_flag(e, IS_CHECKPOINTED))
> > -		is_cp = 0;
> > +		is_cp = false;
> >  	read_unlock(&nm_i->nat_tree_lock);
> >  	return is_cp;
> >  }
> > 
> > -bool fsync_mark_done(struct f2fs_sb_info *sbi, nid_t nid)
> > +bool has_fsynced_inode(struct f2fs_sb_info *sbi, nid_t ino)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> >  	struct nat_entry *e;
> > -	bool fsync_done = false;
> > +	bool fsynced = false;
> > 
> >  	read_lock(&nm_i->nat_tree_lock);
> > -	e = __lookup_nat_cache(nm_i, nid);
> > -	if (e)
> > -		fsync_done = get_nat_flag(e, HAS_FSYNC_MARK);
> > +	e = __lookup_nat_cache(nm_i, ino);
> > +	if (e && get_nat_flag(e, HAS_FSYNCED_INODE))
> > +		fsynced = true;
> >  	read_unlock(&nm_i->nat_tree_lock);
> > -	return fsync_done;
> > +	return fsynced;
> >  }
> > 
> > -void fsync_mark_clear(struct f2fs_sb_info *sbi, nid_t nid)
> > +bool need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> >  	struct nat_entry *e;
> > +	bool need_update = true;
> > 
> > -	write_lock(&nm_i->nat_tree_lock);
> > -	e = __lookup_nat_cache(nm_i, nid);
> > -	if (e)
> > -		set_nat_flag(e, HAS_FSYNC_MARK, false);
> > -	write_unlock(&nm_i->nat_tree_lock);
> > +	read_lock(&nm_i->nat_tree_lock);
> > +	e = __lookup_nat_cache(nm_i, ino);
> > +	if (e && get_nat_flag(e, HAS_LAST_FSYNC) &&
> > +			(get_nat_flag(e, IS_CHECKPOINTED) ||
> > +			 get_nat_flag(e, HAS_FSYNCED_INODE)))
> > +		need_update = false;
> > +	read_unlock(&nm_i->nat_tree_lock);
> > +	return need_update;
> >  }
> > 
> >  static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
> > @@ -176,7 +180,7 @@ static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t
> > nid)
> >  	}
> >  	memset(new, 0, sizeof(struct nat_entry));
> >  	nat_set_nid(new, nid);
> > -	set_nat_flag(new, IS_CHECKPOINTED, true);
> > +	nat_reset_flag(new);
> >  	list_add_tail(&new->list, &nm_i->nat_entries);
> >  	nm_i->nat_cnt++;
> >  	return new;
> > @@ -244,12 +248,17 @@ retry:
> > 
> >  	/* change address */
> >  	nat_set_blkaddr(e, new_blkaddr);
> > +	if (new_blkaddr == NEW_ADDR || new_blkaddr == NULL_ADDR)
> > +		set_nat_flag(e, IS_CHECKPOINTED, false);
> >  	__set_nat_cache_dirty(nm_i, e);
> > 
> >  	/* update fsync_mark if its inode nat entry is still alive */
> >  	e = __lookup_nat_cache(nm_i, ni->ino);
> > -	if (e)
> > -		set_nat_flag(e, HAS_FSYNC_MARK, fsync_done);
> > +	if (e) {
> > +		if (fsync_done && ni->nid == ni->ino)
> > +			set_nat_flag(e, HAS_FSYNCED_INODE, true);
> > +		set_nat_flag(e, HAS_LAST_FSYNC, fsync_done);
> > +	}
> >  	write_unlock(&nm_i->nat_tree_lock);
> >  }
> > 
> > @@ -1121,10 +1130,14 @@ continue_unlock:
> > 
> >  			/* called by fsync() */
> >  			if (ino && IS_DNODE(page)) {
> > -				int mark = !is_checkpointed_node(sbi, ino);
> >  				set_fsync_mark(page, 1);
> > -				if (IS_INODE(page))
> > -					set_dentry_mark(page, mark);
> > +				if (IS_INODE(page)) {
> > +					if (!is_checkpointed_node(sbi, ino) &&
> > +						!has_fsynced_inode(sbi, ino))
> > +						set_dentry_mark(page, 1);
> > +					else
> > +						set_dentry_mark(page, 0);
> > +				}
> >  				nwritten++;
> >  			} else {
> >  				set_fsync_mark(page, 0);
> > @@ -1912,6 +1925,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
> >  				write_unlock(&nm_i->nat_tree_lock);
> >  			} else {
> >  				write_lock(&nm_i->nat_tree_lock);
> > +				nat_reset_flag(ne);
> >  				__clear_nat_cache_dirty(nm_i, ne);
> >  				write_unlock(&nm_i->nat_tree_lock);
> >  			}
> > diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> > index 3043778..b8ba63c 100644
> > --- a/fs/f2fs/node.h
> > +++ b/fs/f2fs/node.h
> > @@ -41,7 +41,8 @@ struct node_info {
> > 
> >  enum {
> >  	IS_CHECKPOINTED,	/* is it checkpointed before? */
> > -	HAS_FSYNC_MARK,		/* has the latest node fsync mark? */
> > +	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
> > +	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
> >  };
> > 
> >  struct nat_entry {
> > @@ -60,15 +61,9 @@ struct nat_entry {
> >  #define nat_set_version(nat, v)		(nat->ni.version = v)
> > 
> >  #define __set_nat_cache_dirty(nm_i, ne)					\
> > -	do {								\
> > -		set_nat_flag(ne, IS_CHECKPOINTED, false);		\
> > -		list_move_tail(&ne->list, &nm_i->dirty_nat_entries);	\
> > -	} while (0)
> > +		list_move_tail(&ne->list, &nm_i->dirty_nat_entries);
> >  #define __clear_nat_cache_dirty(nm_i, ne)				\
> > -	do {								\
> > -		set_nat_flag(ne, IS_CHECKPOINTED, true);		\
> > -		list_move_tail(&ne->list, &nm_i->nat_entries);		\
> > -	} while (0)
> > +		list_move_tail(&ne->list, &nm_i->nat_entries);
> >  #define inc_node_version(version)	(++version)
> > 
> >  static inline void set_nat_flag(struct nat_entry *ne,
> > @@ -87,6 +82,14 @@ static inline bool get_nat_flag(struct nat_entry *ne, unsigned int type)
> >  	return ne->flag & mask;
> >  }
> > 
> > +static inline void nat_reset_flag(struct nat_entry *ne)
> > +{
> > +	/* these states can be set only after checkpoint was done */
> > +	set_nat_flag(ne, IS_CHECKPOINTED, true);
> > +	set_nat_flag(ne, HAS_FSYNCED_INODE, false);
> > +	set_nat_flag(ne, HAS_LAST_FSYNC, true);
> > +}
> > +
> >  static inline void node_info_from_raw_nat(struct node_info *ni,
> >  						struct f2fs_nat_entry *raw_ne)
> >  {
> > --
> > 1.8.5.2 (Apple Git-48)
> > 
> > 
> > ------------------------------------------------------------------------------
> > Want excitement?
> > Manually upgrade your production database.
> > When you want reliability, choose Perforce
> > Perforce version control. Predictably reliable.
> > http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 


