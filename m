Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaCaOHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:07:40 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:34499 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:07:38 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
Date: Mon, 31 Mar 2014 23:07:32 +0900
In-Reply-To: <1396120235-27844-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Sat, 29 Mar 2014 12:10:35 -0700")
Message-ID: <87ioqufom3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cemeyer@uw.edu> writes:

> +static void fat_update_archaic_boot_sector(struct super_block *sb,
> +	struct fat_boot_sector *b)
> +{
> +	struct fat_floppy_defaults *di;
> +	sector_t bd_sects;
> +
> +	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
> +	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90)
> +		return;
> +
> +	/*
> +	 * If any value in this region is non-zero, don't assume it is archaic
> +	 * DOS.
> +	 */
> +	if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
> +		b->reserved != 0 || b->fats != 0 ||
> +		get_unaligned_le16(&b->dir_entries) != 0 ||
> +		get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
> +		b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
> +		b->secs_track != 0 || b->heads != 0)
> +		return;

Probably, too weak detection to use by default. So, how about to use
mount option to enable this?

And only if user asked to enable explicitly by mount option, allow this
format.

> +	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
> +	for (di = floppy_defaults; di->nr_sectors; di++) {
> +		if (di->nr_sectors == bd_sects)
> +			break;
> +	}
> +	if (di->nr_sectors == 0) {
> +		fat_msg(sb, KERN_WARNING,
> +			"DOS volume lacks BPB and isn't a recognized floppy size (%ld sectors)",
> +			(long)bd_sects);
> +		return;
> +	}
> +
> +	fat_msg(sb, KERN_INFO,
> +		"Volume lacks BPB but looks like archaic DOS; assuming default BPB values");
> +
> +	b->sec_per_clus = di->sec_per_clus;
> +	put_unaligned_le16(di->dir_entries, &b->dir_entries);
> +	b->media = di->media;
> +	b->fat_length = cpu_to_le16(di->fat_length);
> +	put_unaligned_le16(SECTOR_SIZE, &b->sector_size);
> +	b->reserved = cpu_to_le16(1);
> +	b->fats = 2;
> +	put_unaligned_le16(bd_sects, &b->sectors);
> +}
> +
> +/*
>   * Read the super block of an MS-DOS FS.
>   */
>  int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
> @@ -1297,6 +1387,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  	}
>  
>  	b = (struct fat_boot_sector *) bh->b_data;
> +	fat_update_archaic_boot_sector(sb, b);

This would be better to set sbi->* directly, not via modified BPB.

>  	if (!b->reserved) {
>  		if (!silent)
>  			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
> @@ -1364,6 +1456,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  			goto out_fail;
>  		}
>  		b = (struct fat_boot_sector *) bh->b_data;
> +		fat_update_archaic_boot_sector(sb, b);

This doesn't need. If logical_sector_size is 512, this format doesn't work.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
