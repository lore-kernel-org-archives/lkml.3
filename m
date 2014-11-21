Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaKUUYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:24:03 -0500
Received: from mout.gmx.net ([212.227.15.18]:55296 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbaKUUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:24:00 -0500
Message-ID: <546F9D79.7050009@gmx.de>
Date: Fri, 21 Nov 2014 21:15:53 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>
CC: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: renumber FMODE_NONOTIFY and add to uniqueness check
References: <1416562882-21190-1-git-send-email-drysdale@google.com>
In-Reply-To: <1416562882-21190-1-git-send-email-drysdale@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3/36+4JR2i37Mmsoa3LtPo2XZuvBeMcDEuhHTvtJ6fvApAlvBJo
 K/aAsJFrr1zNwCLbRw61s3z+y7F3OoxnUwV7kVw5oEvoI8CuoRJJUQldcpX7agiNv1tSQ8w
 i+Eqree/BCe5ZVcat3sONXtFBPH75elDIDY592bCCuZwMuRKrJl3Ny+toeWWYVCKcVXNHAJ
 ZD4gy+gIA+Ia/TRhab5Zw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 10:41, David Drysdale wrote:
> Although FMODE_NONOTIFY is only used internally in the kernel it is in
> the same numbering space as the other O_* flags, as indicated by the
> comment at the top of include/uapi/asm-generic/fcntl.h (and its use
> in fs/notify/fanotify/fanotify_user.c).  However, its current value
> clashes with the value of O_PATH on sparc, so renumber it to avoid
> the clash.
>
> All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
> FMODE_NONOTIFY and __O_SYNC in sparc conflict"),

vfs: add nonconflicting values for O_PATH
5229645bdc35f1cc43eb8b25b6993c8fa58b4b43
unfortunately introduced a new conflict.

> and all of this
> will happen again -- so update the uniqueness check in fcntl_init()
> to include __FMODE_NONOTIFY.


>
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>   fs/fcntl.c                       | 5 +++--
>   include/linux/fs.h               | 4 ++--
>   include/uapi/asm-generic/fcntl.h | 2 +-
>   3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 99d440a4a6ba..ee85cd4e136a 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -740,14 +740,15 @@ static int __init fcntl_init(void)
>   	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
>   	 * is defined as O_NONBLOCK on some platforms and not on others.
>   	 */
> -	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
> +	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
>   		O_RDONLY	| O_WRONLY	| O_RDWR	|
>   		O_CREAT		| O_EXCL	| O_NOCTTY	|
>   		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
>   		__O_SYNC	| O_DSYNC	| FASYNC	|
>   		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
>   		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
> -		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
> +		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
> +		__FMODE_NONOTIFY
>   		));
>
>   	fasync_cache = kmem_cache_create("fasync_cache",
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9ab779e8a63c..fd8611d423a0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -80,7 +80,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>
>   /*
>    * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
> - * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
> + * to O_WRONLY and O_RDWR via the strange trick in OPEN_FMODE() below.

Please, put this change into a separate patch.
It seems unrelated to the definition of __FMODE_NONOTIFY.

>    */
>
>   /* file is open for reading */
> @@ -134,7 +134,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>   #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
>
>   /* File was opened by fanotify and shouldn't generate fanotify events */
> -#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
> +#define FMODE_NONOTIFY		((__force fmode_t)0x4000000)

The cause of the pain is
arch/sparc/include/uapi/asm/fcntl.h:37:
#define O_PATH           0x1000000
We cannot change that definition due to the need for backwards 
compatibility.

>
>   /*
>    * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> index 7543b3e51331..e063effe0cc1 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -5,7 +5,7 @@
>
>   /*
>    * FMODE_EXEC is 0x20
> - * FMODE_NONOTIFY is 0x1000000
> + * FMODE_NONOTIFY is 0x4000000
>    * These cannot be used by userspace O_* until internal and external open
>    * flags are split.
>    * -Eric Paris
>

The patch is applicable to 3.18.0-rc4.

I CC Jan as he has done a lot of the recent file notification development.

Best regards

Heinrich Schuchardt
