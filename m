Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3BEF2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:28:36 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:33918 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3BEF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:28:33 -0500
MIME-Version: 1.0
In-Reply-To: <1359988901-7384-1-git-send-email-linkinjeon@gmail.com>
References: <1359988901-7384-1-git-send-email-linkinjeon@gmail.com>
Date: Tue, 5 Feb 2013 14:28:32 +0900
Message-ID: <CAKYAXd8QsGzz0FHUNZfBt7kskPQprVrTQcuag75oxx09_R22Ow@mail.gmail.com>
Subject: Re: [PATCH] f2fs: add compat_ioctl to provide backward compatability
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk.

Oops!, I was missing include header.
Sorry, I will send v2 patch again.

Thanks.

2013/2/4, Namjae Jeon <linkinjeon@gmail.com>:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> adding compat_ioctl to provide support for backward comptability - 32bit
> binary
> execution on 64bit kernel.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/f2fs.h |   15 +++++++++++++++
>  fs/f2fs/file.c |   20 ++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 58dd608..7bf86c8 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -104,6 +104,20 @@ static inline int update_sits_in_cursum(struct
> f2fs_summary_block *rs, int i)
>  }
>
>  /*
> + * ioctl commands
> + */
> +#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
> +#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
> +
> +#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> +/*
> + * ioctl commands in 32 bit emulation
> + */
> +#define F2FS_IOC32_GETFLAGS             FS_IOC32_GETFLAGS
> +#define F2FS_IOC32_SETFLAGS             FS_IOC32_SETFLAGS
> +#endif
> +
> +/*
>   * For INODE and NODE manager
>   */
>  #define XATTR_NODE_OFFSET	(-1)	/*
> @@ -850,6 +864,7 @@ void f2fs_truncate(struct inode *);
>  int f2fs_setattr(struct dentry *, struct iattr *);
>  int truncate_hole(struct inode *, pgoff_t, pgoff_t);
>  long f2fs_ioctl(struct file *, unsigned int, unsigned long);
> +long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
>
>  /*
>   * inode.c
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 633667e..e79d26a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -644,6 +644,23 @@ out:
>  	}
>  }
>
> +#ifdef CONFIG_COMPAT
> +long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long
> arg)
> +{
> +	switch (cmd) {
> +	case F2FS_IOC32_GETFLAGS:
> +		cmd = F2FS_IOC_GETFLAGS;
> +		break;
> +	case F2FS_IOC32_SETFLAGS:
> +		cmd = F2FS_IOC_SETFLAGS;
> +		break;
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +	return f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
> +}
> +#endif
> +
>  const struct file_operations f2fs_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= do_sync_read,
> @@ -655,6 +672,9 @@ const struct file_operations f2fs_file_operations = {
>  	.fsync		= f2fs_sync_file,
>  	.fallocate	= f2fs_fallocate,
>  	.unlocked_ioctl	= f2fs_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= f2fs_compat_ioctl,
> +#endif
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= generic_file_splice_write,
>  };
> --
> 1.7.9.5
>
>
