Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaKJFUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:20:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:56940 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKJFUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:20:12 -0500
Date: Sun, 9 Nov 2014 21:20:09 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Changman Lee <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 3/5] f2fs: control the memory footprint used
 by ino entries
Message-ID: <20141110052009.GB21743@jaegeuk-mac02.mot-mobility.com>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
 <1415518569-20626-3-git-send-email-jaegeuk@kernel.org>
 <20141110032834.GA14659@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110032834.GA14659@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:28:34PM +0900, Changman Lee wrote:
> On Sat, Nov 08, 2014 at 11:36:07PM -0800, Jaegeuk Kim wrote:
> > This patch adds to control the memory footprint used by ino entries.
> > This will conduct best effort, not strictly.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/node.c    | 28 ++++++++++++++++++++++------
> >  fs/f2fs/node.h    |  3 ++-
> >  fs/f2fs/segment.c |  3 ++-
> >  3 files changed, 26 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 44b8afe..4ea2c47 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -31,22 +31,38 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
> >  {
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> >  	struct sysinfo val;
> > +	unsigned long avail_ram;
> >  	unsigned long mem_size = 0;
> >  	bool res = false;
> >  
> >  	si_meminfo(&val);
> > -	/* give 25%, 25%, 50% memory for each components respectively */
> > +
> > +	/* only uses low memory */
> > +	avail_ram = val.totalram - val.totalhigh;
> > +
> > +	/* give 25%, 25%, 50%, 50% memory for each components respectively */
> 
> Hi Jaegeuk,
> 
> The memory usage of nm_i should be 100% but it's 125%.
> Mistake or intended?

I contemplated whether this 100% was an exact number that we expected.
The answer was NO, since this number was just an estimated one.
There were no strict constrains to limit memory footprints even the previous
codes were used whatever 25%, 25%, and 50%.

So, here, I'd like to add additional threshold for INO_ENTRIES on a basis
of the given threshold.
In addition, I don't want to add any complex equations to satisfy 100% at all.
It's meaningless.

Thanks,

> 
> >  	if (type == FREE_NIDS) {
> > -		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >> 12;
> > -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
> > +		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >>
> > +							PAGE_CACHE_SHIFT;
> > +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
> >  	} else if (type == NAT_ENTRIES) {
> > -		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
> > -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
> > +		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >>
> > +							PAGE_CACHE_SHIFT;
> > +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
> >  	} else if (type == DIRTY_DENTS) {
> >  		if (sbi->sb->s_bdi->dirty_exceeded)
> >  			return false;
> >  		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
> > -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
> > +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
> > +	} else if (type == INO_ENTRIES) {
> > +		int i;
> > +
> > +		if (sbi->sb->s_bdi->dirty_exceeded)
> > +			return false;
> > +		for (i = 0; i <= UPDATE_INO; i++)
> > +			mem_size += (sbi->ino_num[i] * sizeof(struct ino_entry))
> > +							>> PAGE_CACHE_SHIFT;
> > +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
> >  	}
> >  	return res;
> >  }
> > diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> > index acb71e5..d10b644 100644
> > --- a/fs/f2fs/node.h
> > +++ b/fs/f2fs/node.h
> > @@ -106,7 +106,8 @@ static inline void raw_nat_from_node_info(struct f2fs_nat_entry *raw_ne,
> >  enum mem_type {
> >  	FREE_NIDS,	/* indicates the free nid list */
> >  	NAT_ENTRIES,	/* indicates the cached nat entry */
> > -	DIRTY_DENTS	/* indicates dirty dentry pages */
> > +	DIRTY_DENTS,	/* indicates dirty dentry pages */
> > +	INO_ENTRIES,	/* indicates inode entries */
> >  };
> >  
> >  struct nat_entry_set {
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 16721b5d..e094675 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -276,7 +276,8 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
> >  {
> >  	/* check the # of cached NAT entries and prefree segments */
> >  	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
> > -				excess_prefree_segs(sbi))
> > +			excess_prefree_segs(sbi) ||
> > +			available_free_memory(sbi, INO_ENTRIES))
> >  		f2fs_sync_fs(sbi->sb, true);
> >  }
> >  
> > -- 
> > 2.1.1
> > 
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
