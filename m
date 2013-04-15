Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936178Ab3DPQga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:36:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935921Ab3DPQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:25 -0400
Date: Mon, 15 Apr 2013 13:57:14 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/3] fsfreeze: wait in killable state in
 __sb_start_write
Message-ID: <20130415115714.GB2299@quack.suse.cz>
References: <5169350A.9090600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5169350A.9090600@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 13-04-13 12:35:54, Marco Stornelli wrote:
> Added a new enum to decide if we want to sleep in uninterruptible or
> killable state or we want simply to return immediately.
  I like the patch. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/super.c         |   24 ++++++++++++++++++------
>  include/linux/fs.h |   19 +++++++++++++------
>  2 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 7465d43..6b70c7f 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1190,14 +1190,25 @@ static void acquire_freeze_lock(struct super_block *sb, int level, bool trylock,
>   * This is an internal function, please use sb_start_{write,pagefault,intwrite}
>   * instead.
>   */
> -int __sb_start_write(struct super_block *sb, int level, bool wait)
> +int __sb_start_write(struct super_block *sb, int level, int wait)
>  {
> +	int ret = 0;
>  retry:
>  	if (unlikely(sb->s_writers.frozen >= level)) {
> -		if (!wait)
> -			return 0;
> -		wait_event(sb->s_writers.wait_unfrozen,
> -			   sb->s_writers.frozen < level);
> +		switch (wait) {
> +		case FREEZE_NOWAIT:
> +			return ret;
> +		case FREEZE_WAIT:
> +			wait_event(sb->s_writers.wait_unfrozen,
> +				   sb->s_writers.frozen < level);
> +			break;
> +		case FREEZE_WAIT_KILLABLE:
> +			ret = wait_event_killable(sb->s_writers.wait_unfrozen,
> +				   sb->s_writers.frozen < level);
> +			if (ret)
> +				return -EINTR;
> +			break;
> +		}
>  	}
>  
>  #ifdef CONFIG_LOCKDEP
> @@ -1213,7 +1224,8 @@ retry:
>  		__sb_end_write(sb, level);
>  		goto retry;
>  	}
> -	return 1;
> +	ret = 1;
> +	return ret;
>  }
>  EXPORT_SYMBOL(__sb_start_write);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8d47c9a..c8b7325 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1220,6 +1220,13 @@ enum {
>  
>  #define SB_FREEZE_LEVELS (SB_FREEZE_COMPLETE - 1)
>  
> +/* Possible waiting modes */
> +enum {
> +	FREEZE_NOWAIT = 0,		/* no blocking call */
> +	FREEZE_WAIT	= 1,		/* wait in uninterruptible state */
> +	FREEZE_WAIT_KILLABLE = 2,	/* wait in killable state */
> +};
> +
>  struct sb_writers {
>  	/* Counters for counting writers at each level */
>  	struct percpu_counter	counter[SB_FREEZE_LEVELS];
> @@ -1335,7 +1342,7 @@ extern struct timespec current_fs_time(struct super_block *sb);
>   */
>  
>  void __sb_end_write(struct super_block *sb, int level);
> -int __sb_start_write(struct super_block *sb, int level, bool wait);
> +int __sb_start_write(struct super_block *sb, int level, int wait);
>  
>  /**
>   * sb_end_write - drop write access to a superblock
> @@ -1394,12 +1401,12 @@ static inline void sb_end_intwrite(struct super_block *sb)
>   */
>  static inline void sb_start_write(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_WRITE, true);
> +	__sb_start_write(sb, SB_FREEZE_WRITE, FREEZE_WAIT);
>  }
>  
>  static inline int sb_start_write_trylock(struct super_block *sb)
>  {
> -	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
> +	return __sb_start_write(sb, SB_FREEZE_WRITE, FREEZE_NOWAIT);
>  }
>  
>  /**
> @@ -1423,7 +1430,7 @@ static inline int sb_start_write_trylock(struct super_block *sb)
>   */
>  static inline void sb_start_pagefault(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
> +	__sb_start_write(sb, SB_FREEZE_PAGEFAULT, FREEZE_WAIT);
>  }
>  
>  /*
> @@ -1441,7 +1448,7 @@ static inline void sb_start_pagefault(struct super_block *sb)
>   */
>  static inline void sb_start_intwrite(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_FS, true);
> +	__sb_start_write(sb, SB_FREEZE_FS, FREEZE_WAIT);
>  }
>  
>  
> @@ -2224,7 +2231,7 @@ static inline void file_start_write(struct file *file)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return;
> -	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
> +	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, FREEZE_WAIT);
>  }
>  
>  static inline void file_end_write(struct file *file)
> -- 
> 1.7.3.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
