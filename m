Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaBKPyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:54:04 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57130 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBKPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:54:01 -0500
Date: Tue, 11 Feb 2014 16:55:11 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 08/13] vfs: add cross-rename
Message-ID: <20140211155511.GB8204@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-9-git-send-email-miklos@szeredi.hu>
 <20140207224044.GC8801@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207224044.GC8801@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:40:44PM -0500, J. Bruce Fields wrote:
> On Fri, Feb 07, 2014 at 05:49:06PM +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > If flags contain RENAME_EXCHANGE then exchange source and destination files.
> > There's no restriction on the type of the files; e.g. a directory can be
> > exchanged with a symlink.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I don't see any problem with the delegation stuff.  Some random
> bikeshedding:
> 
> > @@ -2575,6 +2579,10 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
> >  
> >  	/* Unhash the target: dput() will then get rid of it */
> 
> I never understood the point of this comment.  It's not even right, is
> it?  And if anything this makes it less so.  Delete?

Not sure, but I think the comment refers to the fact that we can't use
d_delete() for the target, so instead we just unhash it here (which is exactly
what happens for d_delete() if the dentry is still used).

You're right, it makes no sense for the cross-rename case.  So adjusted comment
is:

	/*
	 * Unhash the target (d_delete() is not usable here).  If exchanging
	 * the two dentries, then rehash onto the other's hash queue.
	 */
> 
> >  	__d_drop(target);
> > +	if (exchange) {
> > +		__d_rehash(target,
> > +			   d_hash(dentry->d_parent, dentry->d_name.hash));
> > +	}
> >  
> >  	list_del(&dentry->d_u.d_child);
> >  	list_del(&target->d_u.d_child);
> ...
> > @@ -4042,7 +4057,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  
> >  	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
> >  	dget(new_dentry);
> > -	if (!is_dir)
> > +	if (!is_dir || (flags & RENAME_EXCHANGE))
> >  		lock_two_nondirectories(source, target);
> >  	else if (target)
> >  		mutex_lock(&target->i_mutex);
> 
> I had to stop to think about that for a minute: OK, so in the normal
> rename case we still need to lock the to-be-deleted target, and
> lock_two_nondirectories won't do that for us because it ignores
> directories.  Got it.
> 
> This feels a bit ugly but I don't have a better idea.
> 
> > @@ -4051,25 +4066,25 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> 
> Most of this function is under (flags & RENAME_EXCHANGE) conditionals at
> this point.  Have you looked at how much is duplicated if you split this
> into something like vfs_rename and vfs_exchange?

Split it up and it becomes 106 + 90 lines.  Combine it and it's 130 lines.  That
comes to 66 common, 64 conditional, doesn't it?  So it's half and half.

And I really can't tell which is better in this case.

Thanks,
Miklos
