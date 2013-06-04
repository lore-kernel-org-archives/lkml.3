Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3FDEQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:16:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3FDEQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:16:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,797,1363104000"; 
   d="scan'208";a="7453089"
Message-ID: <51AD698F.3020305@cn.fujitsu.com>
Date: Tue, 04 Jun 2013 12:14:07 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: Re: [PATCH 1/2] f2fs: add remount_fs callback support
References: <1370071212-7715-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1370071212-7715-1-git-send-email-linkinjeon@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/04 12:15:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/04 12:15:03,
	Serialize complete at 2013/06/04 12:15:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 03:20 PM, Namjae Jeon wrote:

> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add the f2fs_remount function call which will be used
> during the filesystem remounting. This function
> will help us to change the mount options specific to
> f2fs.
> 
> Also modify the f2fs background_gc mount option, which
> will allow the user to dynamically trun on/off the
> garbage collection in f2fs based on the background_gc
> value. If background_gc=0, Garbage collection will
> be turned off & if background_gc=1, Garbage collection
> will be truned on.


Hi Namjae,
  I think splitting these two changes into single ones seems better.
Refer to the inline comments.

Thanks,
Gu

> 
> By default the garbage collection is on in f2fs.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>

> ---
>  Documentation/filesystems/f2fs.txt |    8 +-
>  fs/f2fs/super.c                    |  223 +++++++++++++++++++++++-------------
>  2 files changed, 148 insertions(+), 83 deletions(-)
> 
> diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
> index bd3c56c..6a036ce 100644
> --- a/Documentation/filesystems/f2fs.txt
> +++ b/Documentation/filesystems/f2fs.txt
> @@ -98,8 +98,12 @@ Cleaning Overhead
>  MOUNT OPTIONS
>  ================================================================================
>  
> -background_gc_off      Turn off cleaning operations, namely garbage collection,
> -		       triggered in background when I/O subsystem is idle.
> +background_gc=%u       Turn on/off cleaning operations, namely garbage collection,
> +                       triggered in background when I/O subsystem is idle. If
> +                       background_gc=1, it will turn on the garbage collection &
> +                       if background_gc=0, garbage collection will be truned off.
> +                       Default value for this option is 1. So garbage collection
> +                       is on by default.
>  disable_roll_forward   Disable the roll-forward recovery routine
>  discard                Issue discard/TRIM commands when a segment is cleaned.
>  no_heap                Disable heap-style segment allocation which finds free
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 3ac305d..bcd68aa 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -34,7 +34,7 @@
>  static struct kmem_cache *f2fs_inode_cachep;
>  
>  enum {
> -	Opt_gc_background_off,
> +	Opt_gc_background,
>  	Opt_disable_roll_forward,
>  	Opt_discard,
>  	Opt_noheap,
> @@ -46,7 +46,7 @@ enum {
>  };
>  
>  static match_table_t f2fs_tokens = {
> -	{Opt_gc_background_off, "background_gc_off"},
> +	{Opt_gc_background, "background_gc=%u"},
>  	{Opt_disable_roll_forward, "disable_roll_forward"},
>  	{Opt_discard, "discard"},
>  	{Opt_noheap, "no_heap"},
> @@ -76,6 +76,86 @@ static void init_once(void *foo)
>  	inode_init_once(&fi->vfs_inode);
>  }
>  
> +static int parse_options(struct super_block *sb, struct f2fs_sb_info *sbi,
> +				char *options)
> +{
> +	substring_t args[MAX_OPT_ARGS];
> +	char *p;
> +	int arg = 0;
> +
> +	if (!options)
> +		return 0;
> +
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int token;
> +		if (!*p)
> +			continue;
> +		/*
> +		 * Initialize args struct so we know whether arg was
> +		 * found; some options take optional arguments.
> +		 */
> +		args[0].to = args[0].from = NULL;
> +		token = match_token(p, f2fs_tokens, args);
> +
> +		switch (token) {
> +		case Opt_gc_background:
> +			if (args->from && match_int(args, &arg))
> +				return -EINVAL;
> +			if (arg != 0 && arg != 1)
> +				return -EINVAL;
> +			if (arg == 0)
> +				clear_opt(sbi, BG_GC);
> +			else
> +				set_opt(sbi, BG_GC);
> +			break;
> +		case Opt_disable_roll_forward:
> +			set_opt(sbi, DISABLE_ROLL_FORWARD);
> +			break;
> +		case Opt_discard:
> +			set_opt(sbi, DISCARD);
> +			break;
> +		case Opt_noheap:
> +			set_opt(sbi, NOHEAP);
> +			break;
> +#ifdef CONFIG_F2FS_FS_XATTR
> +		case Opt_nouser_xattr:
> +			clear_opt(sbi, XATTR_USER);
> +			break;
> +#else
> +		case Opt_nouser_xattr:
> +			f2fs_msg(sb, KERN_INFO,
> +				"nouser_xattr options not supported");
> +			break;
> +#endif
> +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> +		case Opt_noacl:
> +			clear_opt(sbi, POSIX_ACL);
> +			break;
> +#else
> +		case Opt_noacl:
> +			f2fs_msg(sb, KERN_INFO, "noacl options not supported");
> +			break;
> +#endif
> +		case Opt_active_logs:
> +			if (args->from && match_int(args, &arg))
> +				return -EINVAL;
> +			if (arg != 2 && arg != 4 && arg != NR_CURSEG_TYPE)
> +				return -EINVAL;
> +			sbi->active_logs = arg;
> +			break;
> +		case Opt_disable_ext_identify:
> +			set_opt(sbi, DISABLE_EXT_IDENTIFY);
> +			break;
> +		default:
> +			f2fs_msg(sb, KERN_ERR,
> +				"Unrecognized mount option \"%s\" or missing value",
> +				p);
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static struct inode *f2fs_alloc_inode(struct super_block *sb)
>  {
>  	struct f2fs_inode_info *fi;
> @@ -214,10 +294,10 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(root->d_sb);
>  
> -	if (test_opt(sbi, BG_GC))
> -		seq_puts(seq, ",background_gc_on");
> +	if (!(root->d_sb->s_flags & MS_RDONLY) && test_opt(sbi, BG_GC))
> +		seq_printf(seq, ",background_gc=%u", 1);
>  	else
> -		seq_puts(seq, ",background_gc_off");
> +		seq_printf(seq, ",background_gc=%u", 0);


Though simply option show is enough, but I think the "background_gc=on/off" is more friendly.

>  	if (test_opt(sbi, DISABLE_ROLL_FORWARD))
>  		seq_puts(seq, ",disable_roll_forward");
>  	if (test_opt(sbi, DISCARD))
> @@ -244,6 +324,52 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
>  	return 0;
>  }
>  
> +static int f2fs_remount(struct super_block *sb, int *flags, char *data)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(sb);
> +	unsigned long old_sb_flags;
> +	struct f2fs_mount_info org_mount_opt;
> +	int err, active_logs;
> +
> +	/**
> +	 * Save the old mount options in case we
> +	 * need to restore them.
> +	 */
> +	old_sb_flags = sb->s_flags;
> +	org_mount_opt = sbi->mount_opt;
> +	active_logs = sbi->active_logs;
> +
> +	/* parse mount options */
> +	err = parse_options(sb, sbi, data);
> +	if (err)
> +		goto restore_opts;
> +
> +	/**
> +	 * We stop the GC thread if FS is mounted as RO
> +	 * or if background_gc = 0 is passed in mount
> +	 * option. Also sync the filesystem.
> +	 */
> +	if ((*flags & MS_RDONLY) || !test_opt(sbi, BG_GC)) {


Another condition: The old mount is not RO.

> +		stop_gc_thread(sbi);
> +		f2fs_sync_fs(sb, 1);
> +	} else if (test_opt(sbi, BG_GC) && !sbi->gc_thread) {
> +		err = start_gc_thread(sbi);
> +		if (err)
> +			goto restore_opts;
> +	}
> +
> +	/* Update the POSIXACL Flag */
> +	 sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
> +		(test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);


Maybe you forget to update the flags with MS_RDONLY or ~MS_RDONLY, if the flags changed.

> +	return 0;
> +
> +restore_opts:
> +	sb->s_flags = old_sb_flags;


There is no need to restore sb->s_flags, parse_options() did not change it.
no need to store the old sb->s_flags too.

> +	sbi->mount_opt = org_mount_opt;
> +	sbi->active_logs = active_logs;
> +	return err;
> +}
> +
>  static struct super_operations f2fs_sops = {
>  	.alloc_inode	= f2fs_alloc_inode,
>  	.drop_inode	= f2fs_drop_inode,
> @@ -256,6 +382,7 @@ static struct super_operations f2fs_sops = {
>  	.freeze_fs	= f2fs_freeze,
>  	.unfreeze_fs	= f2fs_unfreeze,
>  	.statfs		= f2fs_statfs,
> +	.remount_fs	= f2fs_remount,
>  };
>  
>  static struct inode *f2fs_nfs_get_inode(struct super_block *sb,
> @@ -303,78 +430,6 @@ static const struct export_operations f2fs_export_ops = {
>  	.get_parent = f2fs_get_parent,
>  };
>  
> -static int parse_options(struct super_block *sb, struct f2fs_sb_info *sbi,
> -				char *options)
> -{
> -	substring_t args[MAX_OPT_ARGS];
> -	char *p;
> -	int arg = 0;
> -
> -	if (!options)
> -		return 0;
> -
> -	while ((p = strsep(&options, ",")) != NULL) {
> -		int token;
> -		if (!*p)
> -			continue;
> -		/*
> -		 * Initialize args struct so we know whether arg was
> -		 * found; some options take optional arguments.
> -		 */
> -		args[0].to = args[0].from = NULL;
> -		token = match_token(p, f2fs_tokens, args);
> -
> -		switch (token) {
> -		case Opt_gc_background_off:
> -			clear_opt(sbi, BG_GC);
> -			break;
> -		case Opt_disable_roll_forward:
> -			set_opt(sbi, DISABLE_ROLL_FORWARD);
> -			break;
> -		case Opt_discard:
> -			set_opt(sbi, DISCARD);
> -			break;
> -		case Opt_noheap:
> -			set_opt(sbi, NOHEAP);
> -			break;
> -#ifdef CONFIG_F2FS_FS_XATTR
> -		case Opt_nouser_xattr:
> -			clear_opt(sbi, XATTR_USER);
> -			break;
> -#else
> -		case Opt_nouser_xattr:
> -			f2fs_msg(sb, KERN_INFO,
> -				"nouser_xattr options not supported");
> -			break;
> -#endif
> -#ifdef CONFIG_F2FS_FS_POSIX_ACL
> -		case Opt_noacl:
> -			clear_opt(sbi, POSIX_ACL);
> -			break;
> -#else
> -		case Opt_noacl:
> -			f2fs_msg(sb, KERN_INFO, "noacl options not supported");
> -			break;
> -#endif
> -		case Opt_active_logs:
> -			if (args->from && match_int(args, &arg))
> -				return -EINVAL;
> -			if (arg != 2 && arg != 4 && arg != NR_CURSEG_TYPE)
> -				return -EINVAL;
> -			sbi->active_logs = arg;
> -			break;
> -		case Opt_disable_ext_identify:
> -			set_opt(sbi, DISABLE_EXT_IDENTIFY);
> -			break;
> -		default:
> -			f2fs_msg(sb, KERN_ERR,
> -				"Unrecognized mount option \"%s\" or missing value",
> -				p);
> -			return -EINVAL;
> -		}
> -	}
> -	return 0;
> -}
>  
>  static loff_t max_file_size(unsigned bits)
>  {
> @@ -674,10 +729,16 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  				"Cannot recover all fsync data errno=%ld", err);
>  	}
>  
> -	/* After POR, we can run background GC thread */
> -	err = start_gc_thread(sbi);
> -	if (err)
> -		goto fail;
> +	/* After POR, we can run background GC thread.*/
> +	if (!(sb->s_flags & MS_RDONLY)) {
> +		/**
> +		 * If filesystem is mounted as read-only then
> +		 * do not start the gc_thread.
> +		 */

It seems that the comment here is against with the logic.

> +		err = start_gc_thread(sbi);
> +		if (err)
> +			goto fail;
> +	}
>  
>  	err = f2fs_build_stats(sbi);
>  	if (err)


