Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3HAF7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:59:36 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8438 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab3HAF7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:59:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFANT3+VF5LPxHgWdsb2JhbABavQ2FLoEfFw4BARYmKIIkAQEEAScTHCMFCwgDDgoJJQ8FJQMhE4gKBblEFo9xB4QLA5delHQq
Date: Thu, 1 Aug 2013 15:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        glommer@parallels.com
Subject: Re: [PATCH 06/11] bdi: add a new writeback list for sync
Message-ID: <20130801055931.GP7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-7-git-send-email-david@fromorbit.com>
 <20130731151114.GG22930@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731151114.GG22930@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:11:14PM +0200, Jan Kara wrote:
> On Wed 31-07-13 14:15:45, Dave Chinner wrote:
> >  /*
> > + * mark an inode as under writeback on the given bdi
> > + */
> > +void bdi_mark_inode_writeback(struct backing_dev_info *bdi, struct inode *inode)
> > +{
> > +	WARN_ON_ONCE(bdi != inode_to_bdi(inode));
> > +	if (list_empty(&inode->i_wb_list)) {
> > +		spin_lock(&bdi->wb.list_lock);
> > +		if (list_empty(&inode->i_wb_list))
> > +			list_add_tail(&inode->i_wb_list, &bdi->wb.b_writeback);
> > +		spin_unlock(&bdi->wb.list_lock);
> > +	}
> > +}
> > +
> > +/*
> > + * clear an inode as under writeback on the given bdi
> > + */
> > +static void bdi_clear_inode_writeback(struct backing_dev_info *bdi,
> > +				      struct inode *inode)
> > +{
> > +	WARN_ON_ONCE(bdi != inode_to_bdi(inode));
> > +	if (!list_empty(&inode->i_wb_list)) {
> > +		spin_lock(&bdi->wb.list_lock);
> > +		list_del_init(&inode->i_wb_list);
> > +		spin_unlock(&bdi->wb.list_lock);
> > +	}
> > +}
>   Umm, are these list_empty() checks without lock really safe?

I think they are.....

>   Looking into
> the code in more detail, it seems that mapping->tree_lock saves us from
> races between insert & removal but it definitely deserves a comment (or maybe
> even an assertion) that the function requires it.
> bdi_clear_inode_writeback() is safe only because it is called only when the
> inode is practically dead. Again, I think it deserves a comment...

Ok.

> > @@ -1264,9 +1330,21 @@ static void wait_sb_inodes(struct super_block *sb)
> >  
> >  		cond_resched();
> >  
> > -		spin_lock(&sb->s_inode_list_lock);
> > +                /*
> > +                 * the inode has been written back now, so check whether we
> > +                 * still have pages under IO and move it back to the primary
> > +                 * list if necessary
> > +                 */
> > +                spin_lock_irq(&mapping->tree_lock);
> > +                spin_lock(&bdi->wb.list_lock);
> > +                if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> > +                        WARN_ON(list_empty(&inode->i_wb_list));
> > +                        list_move(&inode->i_wb_list, &bdi->wb.b_writeback);
> > +                } else
> > +			list_del_init(&inode->i_wb_list);
> > +                spin_unlock_irq(&mapping->tree_lock);
>   Whitespace is damaged in the above hunk...

Bizarre. I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
