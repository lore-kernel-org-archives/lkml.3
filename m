Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3GAMBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:01:01 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49354 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3GAMA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:00:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: bintian.wang@linaro.org
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        dmitry pervushin <dpervushin@gmail.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RFC] Add FAT_IOCTL_GET_VOLUME_ID
References: <1372678828-11776-1-git-send-email-bintian.wang@linaro.org>
Date: Mon, 01 Jul 2013 21:00:54 +0900
In-Reply-To: <1372678828-11776-1-git-send-email-bintian.wang@linaro.org>
	(bintian wang's message of "Mon, 1 Jul 2013 19:40:28 +0800")
Message-ID: <87mwq6ij61.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bintian.wang@linaro.org writes:

> From: Mike Lockwood <lockwood@android.com>
>
> Adds vfat ioctl command FAT_IOCTL_GET_VOLUME_ID, with this command 
> we can get the vfat volume ID using following code:
>
> 	ioctl(fd, FAT_IOCTL_GET_VOLUME_ID, &volume_ID)
>
> This patch is a modified version of the android kernel patch by Mike Lockwood, 
> the original patch makes the return value of ioctl() as the volume ID, 
> Dmitry Pervushin noticed some volume IDs abiguous with error returns:
> for example, if volume id is set to "0xFFFFFDAD", that matches -ENOIOCTLCMD, 
> we get a wrong volume ID "0xFFFFFFFF" from the user space.
>
> This patch fixes above bug by adding a parameter to ioctl to get the correct
> volume ID.

Personally, I have no objection to do this small one in kernel
though. Please add use case of android to changelog, it would help to
understand.

> +static unsigned int fat_ioctl_volume_id(struct inode *inode)
> +{
> +	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
> +	return sbi->vol_id;
> +}
> +
>  long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> @@ -124,6 +130,8 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return fat_ioctl_get_attributes(inode, user_attr);
>  	case FAT_IOCTL_SET_ATTRIBUTES:
>  		return fat_ioctl_set_attributes(filp, user_attr);
> +	case FAT_IOCTL_GET_VOLUME_ID:
> +		return put_user(fat_ioctl_volume_id(inode), user_attr);
>  	default:
>  		return -ENOTTY;	/* Inappropriate ioctl for device */
>  	}

Please push put_user() down into fat_ioctl_volume_id() like others. So,
generic_ioctl() itself can forget about the detail of each ioctl.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
