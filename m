Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3HAJD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:03:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3HAJDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:03:51 -0400
Date: Thu, 1 Aug 2013 11:03:48 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davej@redhat.com, viro@zeniv.linux.org.uk, glommer@parallels.com
Subject: Re: [PATCH 07/11] writeback: periodically trim the writeback list
Message-ID: <20130801090348.GC19219@quack.suse.cz>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-8-git-send-email-david@fromorbit.com>
 <20130731151542.GI22930@quack.suse.cz>
 <20130801061618.GQ7118@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801061618.GQ7118@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-08-13 16:16:18, Dave Chinner wrote:
> On Wed, Jul 31, 2013 at 05:15:42PM +0200, Jan Kara wrote:
> > On Wed 31-07-13 14:15:46, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Inodes are removed lazily from the bdi writeback list, so in the
> > > absence of sync(2) work inodes will build up on the bdi writback
> > > list even though they are no longer under IO. Use the periodic
> > > kupdate work check to remove inodes no longer under IO from the
> > > writeback list.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/fs-writeback.c | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index 638f122..7c9bbf0 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -962,6 +962,23 @@ static long wb_check_background_flush(struct bdi_writeback *wb)
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * clean out writeback list for all inodes that don't have IO in progress
> > > + */
> > > +static void wb_trim_writeback_list(struct bdi_writeback *wb)
> > > +{
> > > +	struct inode *inode;
> > > +	struct inode *tmp;
> > > +
> > > +	spin_lock(&wb->list_lock);
> > > +	list_for_each_entry_safe(inode, tmp, &wb->b_writeback, i_wb_list) {
> > > +		if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
> > > +			list_del_init(&inode->i_wb_list);
> > > +	}
> >    Oo, and here you manipulate i_wb_list without mapping->tree_lock so that
> > can race with the list_empty() check in bdi_mark_inode_writeback().
> 
> I'm not sure it does - we only remove is the PAGECACHE_TAG_WRITEBACK
> is not set, and only insert after we set the tag. Hence, if we are
> walking the &wb->b_writeback list here and PAGECACHE_TAG_WRITEBACK
> is set because there is an insert in progress then we can't race
> with the insert because we won't be trying to delete it from the
> list...
  The following race seems to be possible:
        CPU1                                            CPU2
test_set_page_writeback()
  spin_lock_irqsave(&mapping->tree_lock, flags);
  ret = TestSetPageWriteback(page);
  if (!ret) {
    /* == false */
    on_wblist = mapping_tagged(mapping,
                               PAGECACHE_TAG_WRITEBACK);
                                                        wb_trim_writeback_list()
                                                          spin_lock(&wb->list_lock);
                                                          ...
                                                          if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)
    radix_tree_tag_set(&mapping->page_tree, ...)
    ...
    if (!on_wblist && mapping->host)
      bdi_mark_inode_writeback(bdi, mapping->host);
        if (list_empty(&inode->i_wb_list)) /* false */
                                                            list_del_init(&inode->i_wb_list);

And we end up with inode with PAGECACHE_TAG_WRITEBACK set but not on
i_wb_list. 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
