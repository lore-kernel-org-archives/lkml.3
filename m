Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaGNI1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaGNI1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:27:01 -0400
Date: Mon, 14 Jul 2014 10:26:39 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vfs: Turn the unlinked inode counter into a percpu
 counter
In-Reply-To: <1405110219-2969-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1407141022580.13527@localhost.localdomain>
References: <1405110219-2969-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Andi Kleen wrote:

> Date: Fri, 11 Jul 2014 13:23:39 -0700
> From: Andi Kleen <andi@firstfloor.org>
> To: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
>     Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>
> Subject: [PATCH] vfs: Turn the unlinked inode counter into a percpu counter
> 
> From: Andi Kleen <ak@linux.intel.com>
> 
> The unlinked open inodes super block counter that was added some time ago
> unfortunately becomes a very hot cache line in some delete heavy
> high IOPs or tmpfs workloads with enough cores, when files
> are frequently removed. With TSX it also causes plenty of aborts.
> 
> Turn the atomic into a percpu_counter. It's nearly perfectly
> suited for a percpu counter because it is only checked
> in very slow paths, like remount.
> 
> Original commit:
> 
> commit 7ada4db88634429f4da690ad1c4eb73c93085f0c
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Mon Nov 21 12:11:32 2011 +0100
> 
>     vfs: count unlinked inodes
> 
>     Add a new counter to the superblock that keeps track of unlinked but
>     not yet deleted inodes.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/ext2/super.c    |  2 +-
>  fs/inode.c         | 14 ++++++--------
>  fs/namespace.c     |  4 ++--
>  fs/super.c         |  3 +++
>  include/linux/fs.h |  2 +-
>  5 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3750031..ac0ad9a 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1218,7 +1218,7 @@ static int ext2_freeze(struct super_block *sb)
>  	 * because we have unattached inodes and thus filesystem is not fully
>  	 * consistent.
>  	 */
> -	if (atomic_long_read(&sb->s_remove_count)) {
> +	if (percpu_counter_sum(&sb->s_remove_counters)) {
>  		ext2_sync_fs(sb, 1);
>  		return 0;
>  	}
> diff --git a/fs/inode.c b/fs/inode.c
> index f96d2a6..4820c35 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -234,10 +234,8 @@ void __destroy_inode(struct inode *inode)
>  	BUG_ON(inode_has_buffers(inode));
>  	security_inode_free(inode);
>  	fsnotify_inode_delete(inode);
> -	if (!inode->i_nlink) {
> -		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);

This is not mentioned in the description, but I guess it makes sense since
it'd be quite expensive.

-Lukas

> -		atomic_long_dec(&inode->i_sb->s_remove_count);
> -	}
> +	if (!inode->i_nlink)
> +		percpu_counter_dec(&inode->i_sb->s_remove_counters);
>  
>  #ifdef CONFIG_FS_POSIX_ACL
>  	if (inode->i_acl && inode->i_acl != ACL_NOT_CACHED)
> @@ -281,7 +279,7 @@ void drop_nlink(struct inode *inode)
>  	WARN_ON(inode->i_nlink == 0);
>  	inode->__i_nlink--;
>  	if (!inode->i_nlink)
> -		atomic_long_inc(&inode->i_sb->s_remove_count);
> +		percpu_counter_inc(&inode->i_sb->s_remove_counters);
>  }
>  EXPORT_SYMBOL(drop_nlink);
>  
> @@ -297,7 +295,7 @@ void clear_nlink(struct inode *inode)
>  {
>  	if (inode->i_nlink) {
>  		inode->__i_nlink = 0;
> -		atomic_long_inc(&inode->i_sb->s_remove_count);
> +		percpu_counter_inc(&inode->i_sb->s_remove_counters);
>  	}
>  }
>  EXPORT_SYMBOL(clear_nlink);
> @@ -317,7 +315,7 @@ void set_nlink(struct inode *inode, unsigned int nlink)
>  	} else {
>  		/* Yes, some filesystems do change nlink from zero to one */
>  		if (inode->i_nlink == 0)
> -			atomic_long_dec(&inode->i_sb->s_remove_count);
> +			percpu_counter_dec(&inode->i_sb->s_remove_counters);
>  
>  		inode->__i_nlink = nlink;
>  	}
> @@ -336,7 +334,7 @@ void inc_nlink(struct inode *inode)
>  {
>  	if (unlikely(inode->i_nlink == 0)) {
>  		WARN_ON(!(inode->i_state & I_LINKABLE));
> -		atomic_long_dec(&inode->i_sb->s_remove_count);
> +		percpu_counter_dec(&inode->i_sb->s_remove_counters);
>  	}
>  
>  	inode->__i_nlink++;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 182bc41..20d33d9 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -535,7 +535,7 @@ int sb_prepare_remount_readonly(struct super_block *sb)
>  	int err = 0;
>  
>  	/* Racy optimization.  Recheck the counter under MNT_WRITE_HOLD */
> -	if (atomic_long_read(&sb->s_remove_count))
> +	if (percpu_counter_sum(&sb->s_remove_counters) != 0)
>  		return -EBUSY;
>  
>  	lock_mount_hash();
> @@ -549,7 +549,7 @@ int sb_prepare_remount_readonly(struct super_block *sb)
>  			}
>  		}
>  	}
> -	if (!err && atomic_long_read(&sb->s_remove_count))
> +	if (!err && percpu_counter_sum(&sb->s_remove_counters) != 0)
>  		err = -EBUSY;
>  
>  	if (!err) {
> diff --git a/fs/super.c b/fs/super.c
> index 48377f7..b7a8a45 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -142,6 +142,7 @@ static void destroy_super(struct super_block *s)
>  	list_lru_destroy(&s->s_inode_lru);
>  	for (i = 0; i < SB_FREEZE_LEVELS; i++)
>  		percpu_counter_destroy(&s->s_writers.counter[i]);
> +	percpu_counter_destroy(&s->s_remove_counters);
>  	security_sb_free(s);
>  	WARN_ON(!list_empty(&s->s_mounts));
>  	kfree(s->s_subtype);
> @@ -171,6 +172,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
>  	if (security_sb_alloc(s))
>  		goto fail;
>  
> +	if (percpu_counter_init(&s->s_remove_counters, 0) < 0)
> +		goto fail;
>  	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
>  		if (percpu_counter_init(&s->s_writers.counter[i], 0) < 0)
>  			goto fail;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8780312..0374552 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1240,7 +1240,7 @@ struct super_block {
>  	struct shrinker s_shrink;	/* per-sb shrinker handle */
>  
>  	/* Number of inodes with nlink == 0 but still referenced */
> -	atomic_long_t s_remove_count;
> +	struct percpu_counter s_remove_counters;
>  
>  	/* Being remounted read-only */
>  	int s_readonly_remount;
> 
