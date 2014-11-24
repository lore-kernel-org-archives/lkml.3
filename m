Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaKYOUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:20:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaKYOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:20:27 -0500
Date: Mon, 24 Nov 2014 12:30:08 +0100
From: Jan Kara <jack@suse.cz>
To: David Drysdale <drysdale@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        David Miller <davem@davemloft.net>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCHv2 1/1] vfs: renumber FMODE_NONOTIFY and add to uniqueness
 check
Message-ID: <20141124113008.GF1888@quack.suse.cz>
References: <1416828199-3414-1-git-send-email-drysdale@google.com>
 <1416828199-3414-2-git-send-email-drysdale@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416828199-3414-2-git-send-email-drysdale@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24-11-14 11:23:19, David Drysdale wrote:
> Fix clashing values for O_PATH and FMODE_NONOTIFY on sparc.
> The clashing O_PATH value was added in 5229645bdc35f1cc43eb ("vfs: add
> nonconflicting values for O_PATH") but this can't be changed as it
> is user-visible.
> 
> FMODE_NONOTIFY is only used internally in the kernel, but it is in
> the same numbering space as the other O_* flags, as indicated by the
> comment at the top of include/uapi/asm-generic/fcntl.h (and its use
> in fs/notify/fanotify/fanotify_user.c).  So renumber it to avoid
> the clash.
> 
> All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
> FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this
> will happen again -- so update the uniqueness check in fcntl_init()
> to include __FMODE_NONOTIFY.
> 
> Signed-off-by: David Drysdale <drysdale@google.com>
> Acked-by: David S. Miller <davem@davemloft.net>
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fcntl.c                       | 5 +++--
>  include/linux/fs.h               | 2 +-
>  include/uapi/asm-generic/fcntl.h | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 99d440a4a6ba..ee85cd4e136a 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -740,14 +740,15 @@ static int __init fcntl_init(void)
>  	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
>  	 * is defined as O_NONBLOCK on some platforms and not on others.
>  	 */
> -	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
> +	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
>  		O_RDONLY	| O_WRONLY	| O_RDWR	|
>  		O_CREAT		| O_EXCL	| O_NOCTTY	|
>  		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
>  		__O_SYNC	| O_DSYNC	| FASYNC	|
>  		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
>  		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
> -		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
> +		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
> +		__FMODE_NONOTIFY
>  		));
>  
>  	fasync_cache = kmem_cache_create("fasync_cache",
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9ab779e8a63c..fc1c2488adbc 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -134,7 +134,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
>  
>  /* File was opened by fanotify and shouldn't generate fanotify events */
> -#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
> +#define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
>  
>  /*
>   * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> index 7543b3e51331..e063effe0cc1 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -5,7 +5,7 @@
>  
>  /*
>   * FMODE_EXEC is 0x20
> - * FMODE_NONOTIFY is 0x1000000
> + * FMODE_NONOTIFY is 0x4000000
>   * These cannot be used by userspace O_* until internal and external open
>   * flags are split.
>   * -Eric Paris
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
