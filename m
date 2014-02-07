Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaBGWk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:40:57 -0500
Received: from fieldses.org ([174.143.236.118]:43663 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaBGWk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:40:56 -0500
Date: Fri, 7 Feb 2014 17:40:44 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 08/13] vfs: add cross-rename
Message-ID: <20140207224044.GC8801@fieldses.org>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-9-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-9-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:49:06PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If flags contain RENAME_EXCHANGE then exchange source and destination files.
> There's no restriction on the type of the files; e.g. a directory can be
> exchanged with a symlink.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>

I don't see any problem with the delegation stuff.  Some random
bikeshedding:

> @@ -2575,6 +2579,10 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
>  
>  	/* Unhash the target: dput() will then get rid of it */

I never understood the point of this comment.  It's not even right, is
it?  And if anything this makes it less so.  Delete?

>  	__d_drop(target);
> +	if (exchange) {
> +		__d_rehash(target,
> +			   d_hash(dentry->d_parent, dentry->d_name.hash));
> +	}
>  
>  	list_del(&dentry->d_u.d_child);
>  	list_del(&target->d_u.d_child);
...
> @@ -4042,7 +4057,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
>  	dget(new_dentry);
> -	if (!is_dir)
> +	if (!is_dir || (flags & RENAME_EXCHANGE))
>  		lock_two_nondirectories(source, target);
>  	else if (target)
>  		mutex_lock(&target->i_mutex);

I had to stop to think about that for a minute: OK, so in the normal
rename case we still need to lock the to-be-deleted target, and
lock_two_nondirectories won't do that for us because it ignores
directories.  Got it.

This feels a bit ugly but I don't have a better idea.

> @@ -4051,25 +4066,25 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,

Most of this function is under (flags & RENAME_EXCHANGE) conditionals at
this point.  Have you looked at how much is duplicated if you split this
into something like vfs_rename and vfs_exchange?

--b.
