Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaDMD5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:57:49 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38787 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaDMD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:57:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: linux-kernel@vger.kernel.org, Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH v4] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1396279369-17855-1-git-send-email-cse.cem@gmail.com>
	<1396315037-12725-1-git-send-email-cse.cem@gmail.com>
Date: Sun, 13 Apr 2014 12:57:42 +0900
In-Reply-To: <1396315037-12725-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Mon, 31 Mar 2014 18:17:17 -0700")
Message-ID: <87zjjpvq2x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cemeyer@uw.edu> writes:

Hi,

Sorry for late reply.

> +
> +	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);

This would be better to use i_read_size(&sb->s_bdev->bd_inode->i_size)

> +		if (!fat_bpb_is_zero(b)) {
> +			fat_msg(sb, KERN_ERR, "%s; DOS 2.x BPB is non-zero",
> +				notdos1x);
> +			brelse(bh);
> +			goto out_invalid;
> +		}

Please don't message if silent. While auto detection, user don't want to
see message from kernel.

> +	if (sbi->options.dos1xfloppy) {
> +		/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
> +		if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
> +			fat_msg(sb, KERN_ERR, "%s; no bootstrapping code",
> +				notdos1x);
> +			brelse(bh);
> +			goto out_invalid;
> +		}

[...]

Looks like I was not explain my suggestion correctly. I was intended to
allow dos1xfloppy by option, not allow dos1xfloppy only.

I.e.

	err = read-from-bpb();
	if (err == -ENOTFATFS)
		if (dos1xfloppy)
			err = read-from-static-bpb();
	if (err)
		goto error;

> +	if (sbi->options.dos1xfloppy)
> +		total_sectors = fdefaults->nr_sectors;
> +	else
> +		total_sectors = get_unaligned_le16(&b->sectors);
>  	if (total_sectors == 0)
>  		total_sectors = le32_to_cpu(b->total_sect);

Can we make 2 helpers to read from BPB and static BPB? If possible, we
would not be bothered by if (dos1xfloppy), like above crappy pseudo.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> +
> +		for (i = 0; i < ARRAY_SIZE(floppy_defaults); i++) {
> +			if (floppy_defaults[i].nr_sectors == bd_sects) {
> +				fdefaults = &floppy_defaults[i];
> +				break;
> +			}
> +		}
> +
> +		if (fdefaults == NULL) {
> +			fat_msg(sb, KERN_WARNING,
> +				"This looks like a DOS 1.x volume, but isn't a recognized floppy size (%llu sectors)",
> +				(u64)bd_sects);
> +			brelse(bh);
> +			goto out_invalid;
> +		}
> +
> +		fat_msg(sb, KERN_INFO,
> +			"This looks like a DOS 1.x volume; assuming default BPB values");
> +	} else {
> +		if (!b->reserved) {
> +			if (!silent)
> +				fat_msg(sb, KERN_ERR,
> +					"bogus number of reserved sectors");
> +			brelse(bh);
> +			goto out_invalid;
> +		}
> +		if (!b->fats) {
> +			if (!silent)
> +				fat_msg(sb, KERN_ERR,
> +					"bogus number of FAT structure");
> +			brelse(bh);
> +			goto out_invalid;
> +		}
>  	}
>  
>  	/*
> @@ -1397,6 +1510,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  	 */
>  
>  	media = b->media;
> +	if (sbi->options.dos1xfloppy)
> +		media = fdefaults->media;
>  	if (!fat_valid_media(media)) {
>  		if (!silent)
>  			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
> @@ -1404,7 +1519,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  		brelse(bh);
>  		goto out_invalid;
>  	}
> -	logical_sector_size = get_unaligned_le16(&b->sector_size);
> +	if (sbi->options.dos1xfloppy)
> +		logical_sector_size = SECTOR_SIZE;
> +	else
> +		logical_sector_size = get_unaligned_le16(&b->sector_size);
>  	if (!is_power_of_2(logical_sector_size)
>  	    || (logical_sector_size < 512)
>  	    || (logical_sector_size > 4096)) {
> @@ -1414,7 +1532,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  		brelse(bh);
>  		goto out_invalid;
>  	}
> -	sbi->sec_per_clus = b->sec_per_clus;
> +	if (sbi->options.dos1xfloppy)
> +		sbi->sec_per_clus = fdefaults->sec_per_clus;
> +	else
> +		sbi->sec_per_clus = b->sec_per_clus;
>  	if (!is_power_of_2(sbi->sec_per_clus)) {
>  		if (!silent)
>  			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
> @@ -1450,10 +1571,18 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  	mutex_init(&sbi->s_lock);
>  	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
>  	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
> -	sbi->fats = b->fats;
> +	if (sbi->options.dos1xfloppy)
> +		sbi->fats = 2;
> +	else
> +		sbi->fats = b->fats;
>  	sbi->fat_bits = 0;		/* Don't know yet */
> -	sbi->fat_start = le16_to_cpu(b->reserved);
> -	sbi->fat_length = le16_to_cpu(b->fat_length);
> +	if (sbi->options.dos1xfloppy) {
> +		sbi->fat_start = 1;
> +		sbi->fat_length = fdefaults->fat_length;
> +	} else {
> +		sbi->fat_start = le16_to_cpu(b->reserved);
> +		sbi->fat_length = le16_to_cpu(b->fat_length);
> +	}
>  	sbi->root_cluster = 0;
>  	sbi->free_clusters = -1;	/* Don't know yet */
>  	sbi->free_clus_valid = 0;
> @@ -1515,7 +1644,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
>  
>  	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
> -	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
> +	if (sbi->options.dos1xfloppy)
> +		sbi->dir_entries = fdefaults->dir_entries;
> +	else
> +		sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
>  	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
>  		if (!silent)
>  			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
> @@ -1527,7 +1659,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  	rootdir_sectors = sbi->dir_entries
>  		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
>  	sbi->data_start = sbi->dir_start + rootdir_sectors;
> -	total_sectors = get_unaligned_le16(&b->sectors);
> +	if (sbi->options.dos1xfloppy)
> +		total_sectors = fdefaults->nr_sectors;
> +	else
> +		total_sectors = get_unaligned_le16(&b->sectors);
>  	if (total_sectors == 0)
>  		total_sectors = le32_to_cpu(b->total_sect);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
