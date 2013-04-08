Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935486Ab3DHRzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:55:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750Ab3DHRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:55:20 -0400
Date: Mon, 8 Apr 2013 19:55:17 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] fsfreeze: add new internal __sb_start_write_wait
Message-ID: <20130408175517.GA25878@quack.suse.cz>
References: <5162EEC5.4000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162EEC5.4000204@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 18:22:29, Marco Stornelli wrote:
> Added a new internal function __sb_start_write_wait. It must be called
> when we want wait for freeze events. We can wait in killable or
> uninterruptible state. The old __sb_start_write now it's used only
> when we don't want to wait. In addition, a new wrapper sb_start_write_killable
> is added.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/super.c         |   47 ++++++++++++++++++++++++++++++++++++++++-------
>  include/linux/fs.h |   23 ++++++++++++++++++-----
>  2 files changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 7465d43..cb0149b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1190,15 +1190,11 @@ static void acquire_freeze_lock(struct super_block *sb, int level, bool trylock,
>   * This is an internal function, please use sb_start_{write,pagefault,intwrite}
>   * instead.
>   */
> -int __sb_start_write(struct super_block *sb, int level, bool wait)
> +int __sb_start_write(struct super_block *sb, int level)
>  {
>  retry:
> -	if (unlikely(sb->s_writers.frozen >= level)) {
> -		if (!wait)
> -			return 0;
> -		wait_event(sb->s_writers.wait_unfrozen,
> -			   sb->s_writers.frozen < level);
> -	}
> +	if (unlikely(sb->s_writers.frozen >= level))
> +		return 0;
>  
>  #ifdef CONFIG_LOCKDEP
>  	acquire_freeze_lock(sb, level, !wait, _RET_IP_);
> @@ -1217,6 +1213,43 @@ retry:
>  }
>  EXPORT_SYMBOL(__sb_start_write);
>  
> +/*
> + * This is an internal function, please use sb_start_{write,pagefault,intwrite}
> + * instead. It returns zero if no error occured, the error code otherwise.
> + */
> +int __sb_start_write_wait(struct super_block *sb, int level, bool wait_killable)
> +{
> +	int ret = 0;
> +
> +retry:
> +	if (unlikely(sb->s_writers.frozen >= level)) {
> +		if (wait_killable)
> +			ret = wait_event_killable(sb->s_writers.wait_unfrozen,
> +						sb->s_writers.frozen < level);
> +			if (ret)
> +				return -EINTR;
> +		else
> +			wait_event(sb->s_writers.wait_unfrozen,
> +						sb->s_writers.frozen < level);
> +	}
> +
> +#ifdef CONFIG_LOCKDEP
> +	acquire_freeze_lock(sb, level, !wait, _RET_IP_);
> +#endif
> +	percpu_counter_inc(&sb->s_writers.counter[level-1]);
> +	/*
> +	 * Make sure counter is updated before we check for frozen.
> +	 * freeze_super() first sets frozen and then checks the counter.
> +	 */
> +	smp_mb();
> +	if (unlikely(sb->s_writers.frozen >= level)) {
> +		__sb_end_write(sb, level);
> +		goto retry;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(__sb_start_write_wait);
  Why do you duplicate this function? I'd prefer if you kept single
sb_start_write() core function which would conditionally wait (maybe wait
argument could have values NOWAIT, WAIT_KILLABLE, WAIT).

								Honza
> +
>  /**
>   * sb_wait_write - wait until all writers to given file system finish
>   * @sb: the super for which we wait
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2c28271..6428dbd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1333,7 +1333,8 @@ extern struct timespec current_fs_time(struct super_block *sb);
>   */
>  
>  void __sb_end_write(struct super_block *sb, int level);
> -int __sb_start_write(struct super_block *sb, int level, bool wait);
> +int __sb_start_write(struct super_block *sb, int level);
> +int __sb_start_write_wait(struct super_block *sb, int level, bool wait_killable);
>  
>  /**
>   * sb_end_write - drop write access to a superblock
> @@ -1392,12 +1393,24 @@ static inline void sb_end_intwrite(struct super_block *sb)
>   */
>  static inline void sb_start_write(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_WRITE, true);
> +	__sb_start_write_wait(sb, SB_FREEZE_WRITE, false);
> +}
> +
> +/**
> + * sb_start_write_killable - get write access to a superblock
> + * @sb: the super we write to
> + *
> + * Same semantic of sb_start_write, but we are going to wait in a killable
> + * state instead of waiting in uninterruptible state.
> + */
> +static inline int __must_check sb_start_write_killable(struct super_block *sb)
> +{
> +	return __sb_start_write_wait(sb, SB_FREEZE_WRITE, true);
>  }
>  
>  static inline int sb_start_write_trylock(struct super_block *sb)
>  {
> -	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
> +	return __sb_start_write(sb, SB_FREEZE_WRITE);
>  }
>  
>  /**
> @@ -1421,7 +1434,7 @@ static inline int sb_start_write_trylock(struct super_block *sb)
>   */
>  static inline void sb_start_pagefault(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
> +	__sb_start_write_wait(sb, SB_FREEZE_PAGEFAULT, false);
>  }
>  
>  /*
> @@ -1439,7 +1452,7 @@ static inline void sb_start_pagefault(struct super_block *sb)
>   */
>  static inline void sb_start_intwrite(struct super_block *sb)
>  {
> -	__sb_start_write(sb, SB_FREEZE_FS, true);
> +	__sb_start_write_wait(sb, SB_FREEZE_FS, false);
>  }
>  
>  
> -- 
> 1.7.3.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
