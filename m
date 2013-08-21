Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3HUXsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:48:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:37076 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab3HUXsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:48:13 -0400
Date: Thu, 22 Aug 2013 08:47:49 +0900 (JST)
Message-Id: <20130822.084749.403443431.konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rwheeler@redhat.com, avati@redhat.com,
        bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, raven@themaw.net
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20130821210037.GO27005@ZenIV.linux.org.uk>
References: <20130821054055.GN27005@ZenIV.linux.org.uk>
	<20130822.050459.85418575.konishi.ryusuke@lab.ntt.co.jp>
	<20130821210037.GO27005@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Thu, 22 Aug 2013 08:47:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 22:00:38 +0100, Al Viro wrote:
> On Thu, Aug 22, 2013 at 05:04:59AM +0900, Ryusuke Konishi wrote:
>> On Wed, 21 Aug 2013 06:40:56 +0100, Al Viro wrote:
>> > 	And I would like to understand what nilfs one is trying to do...
>> > Unless I'm seriously misreading that code, it's *not* on any kind of a hot
>> > path, so I really wonder why don't we simply do shrink_dcache_parent() +
>> > check if d_count has dropped to 1, without trying to look for submounts
>> > first - if we have any, shrink_dcache_parent() is simply going to leave
>> > us with d_count > 1 and that's it.  Actually, it's cheaper that way -
>> > no need to walk the tree twice.
>> 
>> > 	We are really getting too many tree walkers in fs/dcache.c and
>> > all that duplication is the prime breeding ground for bugs ;-/
>> 
>> I agree that we can eliminate have_submounts() from nilfs.  Please
>> apply the following patch if you hope so.
>> 
>> > Moreover, checking for d_count == 1
>> > case first is also pointless - in that case we have no children at all
>> > and shrink_dcache_parent() will return immediately.
>> 
>> This also looks true.  I will confirm whether we can remove the
>> pre-check for d_count == 1 case.
> 
> Umm...  How about the following, then?
> 

I confirmed the pre-check is also eliminable.
Then, yes, the following change is ok.

Reviewed-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Regards,
Ryusuke Konishi

> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index af3ba04..7ac2a12 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -994,23 +994,16 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
>  	return ret;
>  }
>  
> -static int nilfs_tree_was_touched(struct dentry *root_dentry)
> -{
> -	return d_count(root_dentry) > 1;
> -}
> -
>  /**
> - * nilfs_try_to_shrink_tree() - try to shrink dentries of a checkpoint
> + * nilfs_tree_is_busy() - try to shrink dentries of a checkpoint
>   * @root_dentry: root dentry of the tree to be shrunk
>   *
>   * This function returns true if the tree was in-use.
>   */
> -static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
> +static bool nilfs_tree_is_busy(struct dentry *root_dentry)
>  {
> -	if (have_submounts(root_dentry))
> -		return true;
>  	shrink_dcache_parent(root_dentry);
> -	return nilfs_tree_was_touched(root_dentry);
> +	return d_count(root_dentry) > 1;
>  }
>  
>  int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
> @@ -1034,8 +1027,7 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
>  		if (inode) {
>  			dentry = d_find_alias(inode);
>  			if (dentry) {
> -				if (nilfs_tree_was_touched(dentry))
> -					ret = nilfs_try_to_shrink_tree(dentry);
> +				ret = nilfs_tree_is_busy(dentry);
>  				dput(dentry);
>  			}
>  			iput(inode);
> @@ -1331,11 +1323,8 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
>  
>  		s->s_flags |= MS_ACTIVE;
>  	} else if (!sd.cno) {
> -		int busy = false;
> -
> -		if (nilfs_tree_was_touched(s->s_root)) {
> -			busy = nilfs_try_to_shrink_tree(s->s_root);
> -			if (busy && (flags ^ s->s_flags) & MS_RDONLY) {
> +		if (nilfs_tree_is_busy(s->s_root)) {
> +			if ((flags ^ s->s_flags) & MS_RDONLY) {
>  				printk(KERN_ERR "NILFS: the device already "
>  				       "has a %s mount.\n",
>  				       (s->s_flags & MS_RDONLY) ?
> @@ -1343,8 +1332,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
>  				err = -EBUSY;
>  				goto failed_super;
>  			}
> -		}
> -		if (!busy) {
> +		} else {
>  			/*
>  			 * Try remount to setup mount states if the current
>  			 * tree is not mounted and only snapshots use this sb.
