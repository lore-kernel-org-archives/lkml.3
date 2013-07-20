Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3GTUaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:30:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab3GTUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:30:03 -0400
Date: Sat, 20 Jul 2013 13:30:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: viro@zeniv.linux.org.uk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: livelock avoidance in sget()
Message-ID: <20130720203013.GA12294@kroah.com>
References: <20130720193427.665E5660972@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720193427.665E5660972@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Is the patch below something that we need to worry about for 3.10 and
older kernels?  Or does the recent changes to the vfs in 3.11-rc1 make
it so that this can't be hit in older kernels?

thanks,

greg k-h

On Sat, Jul 20, 2013 at 07:34:27PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=acfec9a5a892f98461f52ed5770de99a3e571ae2
> Commit:     acfec9a5a892f98461f52ed5770de99a3e571ae2
> Parent:     ba57ea64cb1820deb37637de0fdb107f0dc90089
> Author:     Al Viro <viro@zeniv.linux.org.uk>
> AuthorDate: Sat Jul 20 03:13:55 2013 +0400
> Committer:  Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Sat Jul 20 04:58:58 2013 +0400
> 
>     livelock avoidance in sget()
>     
>     Eric Sandeen has found a nasty livelock in sget() - take a mount(2) about
>     to fail.  The superblock is on ->fs_supers, ->s_umount is held exclusive,
>     ->s_active is 1.  Along comes two more processes, trying to mount the same
>     thing; sget() in each is picking that superblock, bumping ->s_count and
>     trying to grab ->s_umount.  ->s_active is 3 now.  Original mount(2)
>     finally gets to deactivate_locked_super() on failure; ->s_active is 2,
>     superblock is still ->fs_supers because shutdown will *not* happen until
>     ->s_active hits 0.  ->s_umount is dropped and now we have two processes
>     chasing each other:
>     s_active = 2, A acquired ->s_umount, B blocked
>     A sees that the damn thing is stillborn, does deactivate_locked_super()
>     s_active = 1, A drops ->s_umount, B gets it
>     A restarts the search and finds the same superblock.  And bumps it ->s_active.
>     s_active = 2, B holds ->s_umount, A blocked on trying to get it
>     ... and we are in the earlier situation with A and B switched places.
>     
>     The root cause, of course, is that ->s_active should not grow until we'd
>     got MS_BORN.  Then failing ->mount() will have deactivate_locked_super()
>     shut the damn thing down.  Fortunately, it's easy to do - the key point
>     is that grab_super() is called only for superblocks currently on ->fs_supers,
>     so it can bump ->s_count and grab ->s_umount first, then check MS_BORN and
>     bump ->s_active; we must never increment ->s_count for superblocks past
>     ->kill_sb(), but grab_super() is never called for those.
>     
>     The bug is pretty old; we would've caught it by now, if not for accidental
>     exclusion between sget() for block filesystems; the things like cgroup or
>     e.g. mtd-based filesystems don't have anything of that sort, so they get
>     bitten.  The right way to deal with that is obviously to fix sget()...
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/super.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 7465d43..68307c0 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -336,19 +336,19 @@ EXPORT_SYMBOL(deactivate_super);
>   *	and want to turn it into a full-blown active reference.  grab_super()
>   *	is called with sb_lock held and drops it.  Returns 1 in case of
>   *	success, 0 if we had failed (superblock contents was already dead or
> - *	dying when grab_super() had been called).
> + *	dying when grab_super() had been called).  Note that this is only
> + *	called for superblocks not in rundown mode (== ones still on ->fs_supers
> + *	of their type), so increment of ->s_count is OK here.
>   */
>  static int grab_super(struct super_block *s) __releases(sb_lock)
>  {
> -	if (atomic_inc_not_zero(&s->s_active)) {
> -		spin_unlock(&sb_lock);
> -		return 1;
> -	}
> -	/* it's going away */
>  	s->s_count++;
>  	spin_unlock(&sb_lock);
> -	/* wait for it to die */
>  	down_write(&s->s_umount);
> +	if ((s->s_flags & MS_BORN) && atomic_inc_not_zero(&s->s_active)) {
> +		put_super(s);
> +		return 1;
> +	}
>  	up_write(&s->s_umount);
>  	put_super(s);
>  	return 0;
> @@ -463,11 +463,6 @@ retry:
>  				destroy_super(s);
>  				s = NULL;
>  			}
> -			down_write(&old->s_umount);
> -			if (unlikely(!(old->s_flags & MS_BORN))) {
> -				deactivate_locked_super(old);
> -				goto retry;
> -			}
>  			return old;
>  		}
>  	}
> @@ -660,10 +655,10 @@ restart:
>  		if (hlist_unhashed(&sb->s_instances))
>  			continue;
>  		if (sb->s_bdev == bdev) {
> -			if (grab_super(sb)) /* drops sb_lock */
> -				return sb;
> -			else
> +			if (!grab_super(sb))
>  				goto restart;
> +			up_write(&sb->s_umount);
> +			return sb;
>  		}
>  	}
>  	spin_unlock(&sb_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
