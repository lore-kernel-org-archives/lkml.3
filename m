Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3GAGM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:12:26 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49241 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GAGMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:12:25 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: bintian.wang@linaro.org
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        dmitry pervushin <dpervushin@gmail.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RFC] Add FAT_IOCTL_GET_VOLUME_ID
References: <1372646398-4204-1-git-send-email-bintian.wang@linaro.org>
Date: Mon, 01 Jul 2013 15:12:22 +0900
In-Reply-To: <1372646398-4204-1-git-send-email-bintian.wang@linaro.org>
	(bintian wang's message of "Mon, 1 Jul 2013 10:39:58 +0800")
Message-ID: <87wqpakdvd.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bintian.wang@linaro.org writes:

> This patch, originally from Android kernel, adds vfat directory ioctl command
> FAT_IOCTL_GET_VOLUME_ID, with this command we can get the vfat volume ID using
> following code:
>
> 	ioctl(dirfd(dir), FAT_IOCTL_GET_VOLUME_ID, &volume_ID)
>
> This patch is a modified version of the patch by Mike Lockwood, with changes
> from Dmitry Pervushin, who noticed the original patch makes some volume IDs
> abiguous with error returns: for example, if volume id is 0xFFFFFDAD, that
> matches -ENOIOCTLCMD, we get "FFFFFFFF" from the user space.
>
> So add a parameter to ioctl to get the correct volume ID.

Adding more specific usage example to changelog would help for
understanding this.

> +	case FAT_IOCTL_GET_VOLUME_ID:
> +		id = fat_ioctl_volume_id(inode);
> +		return copy_to_user((unsigned int *)arg, &id, sizeof(id));

> +	case FAT_IOCTL_GET_VOLUME_ID:
> +		id = fat_ioctl_volume_id(inode);
> +		return copy_to_user((unsigned int *)arg, &id, sizeof(id));

This pattern seems to from put_user().

Unnecessary cast of 1st arg. And copy_to_user() returns remaining bytes
when fail (not error code).

> +struct fat_boot_bsx {
> +	__u8     drive;     /* drive number */
> +	__u8     reserved1;
> +	__u8     signature; /* extended boot signature */
> +	__u8     vol_id[4]; /* volume ID */
> +	__u8     vol_label[11]; /* volume label */
> +	__u8     type[8];   /* file system type */
> +};
> +#define FAT16_BSX_OFFSET 36 /* offset of fat_boot_bsx in FAT12 and FAT16 */
> +#define FAT32_BSX_OFFSET 64 /* offset of fat_boot_bsx in FAT32 */

There is any issue to merge those to "struct fat_boot_sector"? I guess,
merging it is cleaner way.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
