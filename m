Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3KZNrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:47:13 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34366 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3KZNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:47:08 -0500
Date: Tue, 26 Nov 2013 14:47:16 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jan Kara <jack@suse.cz>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20131126134659.GA528@tucsk.piliscsaba.szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
 <1384952512-21600-12-git-send-email-miklos@szeredi.hu>
 <20131126095125.GB1384@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126095125.GB1384@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:51:25AM +0100, Jan Kara wrote:
> On Wed 20-11-13 14:01:52, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Implement RENAME_EXCHANGE flag in renameat2 syscall.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> >  fs/ext4/namei.c | 97 ++++++++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 69 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index d258b354b937..5307e482f403 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> ...
> > -	old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
> > -	ext4_update_dx_flag(old.dir);
> > +	/* S_ISDIR(old.inode->i_mode */
> >  	if (old.dir_bh) {
> >  		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
> >  		if (retval)
> >  			goto end_rename;
> >  
> > -		ext4_dec_count(handle, old.dir);
> > -		if (new.inode) {
> > -			/* checked empty_dir above, can't have another parent,
> > -			 * ext4_dec_count() won't work for many-linked dirs */
> > -			clear_nlink(new.inode);
> > -		} else {
> > +		if (!(flags & RENAME_EXCHANGE) || !S_ISDIR(new.inode->i_mode))
> > +			ext4_dec_count(handle, old.dir);
> > +
> > +		if (!new.inode || !S_ISDIR(new.inode->i_mode)) {
> >  			ext4_inc_count(handle, new.dir);
> >  			ext4_update_dx_flag(new.dir);
> >  			ext4_mark_inode_dirty(handle, new.dir);
> >  		}
> >  	}
> > +	/* (flags & RENAME_EXCHANGE) && S_ISDIR(new.inode->i_mode */
> > +	if (new.dir_bh) {
> > +		retval = ext4_rename_dir_finish(handle, &new, old.dir->i_ino);
> > +		if (retval)
> > +			goto end_rename;
> > +
> > +		if (!S_ISDIR(old.inode->i_mode)) {
> > +			ext4_dec_count(handle, new.dir);
> > +			ext4_inc_count(handle, old.dir);
> > +			ext4_mark_inode_dirty(handle, new.dir);
> > +		}
> > +	}
> >  	ext4_mark_inode_dirty(handle, old.dir);
> > -	if (new.inode) {
> > +	if (!(flags & RENAME_EXCHANGE) && new.inode) {
> > +		ext4_dec_count(handle, new.inode);
> > +		new.inode->i_ctime = ext4_current_time(new.inode);
> > +		if (S_ISDIR(old.inode->i_mode)) {
> > +			/* checked empty_dir above, can't have another parent,
> > +			 * ext4_dec_count() won't work for many-linked dirs */
> > +			clear_nlink(new.inode);
> > +		}
>   This hunk looks strange. Why do you check S_ISDIR(old.inode->i_mode)? I'd
> presume we need to clear nlink if new.inode is a directory...

It's confusing, that's for sure.  I think it's correct, since S_ISDIR(old) is
equivalent to S_ISDIR(new) if not cross-renaming, but that's not a lot of
consolation to someone trying to understand the code.

> 
> >  		ext4_mark_inode_dirty(handle, new.inode);
> >  		if (!new.inode->i_nlink)
> > 			ext4_orphan_add(handle, new.inode);
>   Generally, I'm a bit unhappy about the number of various RENAME_EXCHANGE
> checks and the asymmetry between new & old which now shouldn't needed (that
> much). Especially the link count handling looks more complex than it should
> be.
> 
> I'd hope that it should be possible to "delete new.inode iff
> !RENAME_EXCHANGE" and then the rest shouldn't need to care about
> RENAME_EXCHANGE at all and treat old & new completely symmetrically... Now I
> realize this isn't that easy because we want to do all error checks first
> before doing any changes on disk but still I hope some improvement can be
> made (maybe just zero out new.inode in our 'new' ext4_renament to allow for
> code to be symmetric and delete it on disk only when ext4_rename() is
> finishing).
> 
> If the above won't be workable, we might at least make the link count
> handling more obvious by computing "old_link_cnt_update,
> new_link_cnt_update" - how link counts of parent dirs should be updated
> (-1, 0, +1) and then do the checks and updates based on this in one place.

Okay, will try to clean this up.  I agree that it became a bit too complicated.

Thanks,
Miklos
