Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3EaJgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:36:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:3033 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3EaJgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:36:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,777,1363158000"; 
   d="scan'208";a="310478661"
Date: Fri, 31 May 2013 17:36:30 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>
Subject: Re: [PATCH] writeback: make local functions as static
Message-ID: <20130531093630.GA3041@hli22-desktop>
References: <1369835379-5389-1-git-send-email-haicheng.li@linux.intel.com>
 <20130530092121.GB10177@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530092121.GB10177@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:21:21AM +0200, Jan Kara wrote:
> On Wed 29-05-13 21:49:38, Haicheng Li wrote:
> > Functions not used globally should be static.
>   I agree for wb_do_writeback().
Ok, thanks.

> You definitely shouldn't make
> writeback_inodes_sb_nr() static, that it part of generic writeback API
> (although it is currently unused, I agree). 
It seems never used globally since it was introduced by commit 3259f8be.

> I'm somewhat undecided about
> writeback_inodes_wb() - it may be handy for someone wanting to write out
> everything on the bdi and it is a sane interface, OTOH it is unused as you
> say and not exporting it wouldn't break consistency of the API...
It used to be referred only by bdi_forker_thread() until commit 839a8e86 moves
the calling into fs-writeback.c.

Yep, I think both are sane i/f but unnecessary to be exported globally.
Anyway, this is just a trivial cleanup, if people still think we need to keep
them exposed to global namespace, that's also fine.

Thank you for the patch review.
> 								Honza
> 
> > 
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> > ---
> >  fs/fs-writeback.c         |    7 +++----
> >  include/linux/writeback.h |    5 -----
> >  2 files changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 3be5718..1d66062 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -719,7 +719,7 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
> >  	return wrote;
> >  }
> >  
> > -long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
> > +static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
> >  				enum wb_reason reason)
> >  {
> >  	struct wb_writeback_work work = {
> > @@ -959,7 +959,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
> >  /*
> >   * Retrieve work items and do the writeback they describe
> >   */
> > -long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
> > +static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
> >  {
> >  	struct backing_dev_info *bdi = wb->bdi;
> >  	struct wb_writeback_work *work;
> > @@ -1269,7 +1269,7 @@ static void wait_sb_inodes(struct super_block *sb)
> >   * on how many (if any) will be written, and this function does not wait
> >   * for IO completion of submitted IO.
> >   */
> > -void writeback_inodes_sb_nr(struct super_block *sb,
> > +static void writeback_inodes_sb_nr(struct super_block *sb,
> >  			    unsigned long nr,
> >  			    enum wb_reason reason)
> >  {
> > @@ -1289,7 +1289,6 @@ void writeback_inodes_sb_nr(struct super_block *sb,
> >  	bdi_queue_work(sb->s_bdi, &work);
> >  	wait_for_completion(&done);
> >  }
> > -EXPORT_SYMBOL(writeback_inodes_sb_nr);
> >  
> >  /**
> >   * writeback_inodes_sb	-	writeback dirty inodes from given super_block
> > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> > index 579a500..ba3de47 100644
> > --- a/include/linux/writeback.h
> > +++ b/include/linux/writeback.h
> > @@ -86,15 +86,10 @@ struct writeback_control {
> >  struct bdi_writeback;
> >  int inode_wait(void *);
> >  void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
> > -void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
> > -							enum wb_reason reason);
> >  int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
> >  int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
> >  				  enum wb_reason reason);
> >  void sync_inodes_sb(struct super_block *);
> > -long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
> > -				enum wb_reason reason);
> > -long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
> >  void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
> >  void inode_wait_for_writeback(struct inode *inode);
> >  
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
