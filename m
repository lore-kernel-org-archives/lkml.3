Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3G1LlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 07:41:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45771 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3G1LlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 07:41:03 -0400
Date: Sun, 28 Jul 2013 07:40:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 71/79] ext4: fix error handling in ext4_ext_truncate()
Message-ID: <20130728114053.GA19995@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
 <20130726204730.256399621@linuxfoundation.org>
 <1374960811.3607.15.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374960811.3607.15.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 10:33:31PM +0100, Ben Hutchings wrote:
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4386,9 +4386,20 @@ void ext4_ext_truncate(handle_t *handle,
> >  
> >  	last_block = (inode->i_size + sb->s_blocksize - 1)
> >  			>> EXT4_BLOCK_SIZE_BITS(sb);
> > +retry:
> >  	err = ext4_es_remove_extent(inode, last_block,
> >  				    EXT_MAX_BLOCKS - last_block);
> > +	if (err == ENOMEM) {
> 
> Positive ENOMEM?!  It looks like this value is bubbled up from
> __es_insert_extent() which returns the usual negative error codes.

Nice catch.  Yup, that's a problem.  I'll fix this upstream and mark
it cc:stable.

Until this goes upstream stable kernel maintainers can either: (a) fix
up this patch by making the line read "err == -ENOMEM", (b) hold back
this patch until the companion patch to fix this goes upstream, or (c)
apply this now, since it's otherwise harmless and it does add error
checking to the ext4_ext_remove_space() call.

> 
> Ben.
> 
> > +		cond_resched();
> > +		congestion_wait(BLK_RW_ASYNC, HZ/50);
> > +		goto retry;
> > +	}
> > +	if (err) {
> > +		ext4_std_error(inode->i_sb, err);
> > +		return;
> > +	}
> >  	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
> > +	ext4_std_error(inode->i_sb, err);
> >  }
> >  
> >  static void ext4_falloc_update_inode(struct inode *inode,
> > 
> 
> -- 
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.


