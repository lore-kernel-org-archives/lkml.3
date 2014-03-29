Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaC2R4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:56:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:33943 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaC2R4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:56:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1396045290-9795-1-git-send-email-cse.cem@gmail.com>
Date: Sun, 30 Mar 2014 02:56:46 +0900
In-Reply-To: <1396045290-9795-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Fri, 28 Mar 2014 15:21:30 -0700")
Message-ID: <87mwg8ga75.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cemeyer@uw.edu> writes:

Hi,

> When possible, infer DOS 2.x BIOS Parameter Block from block device
> geometry (for floppies and floppy images). Update in-memory only. We
> only perform this update when the entire BPB region is zeroed, like
> produced by DOS 1.x-era FORMAT (and other OEM variations on DOS).
>
> Fixes kernel.org bug #42617.
>
> BPB default values are inferred from media size and a table.[0] Media
> size is assumed to be static for archaic FAT volumes. See also [1].
>
> [0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
> [1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

[...]

> +static void fat_update_archaic_boot_sector(struct super_block *sb,
> +	struct fat_boot_sector *b)
> +{
> +	sector_t bd_sects;
> +
> +	if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
> +		b->reserved != 0 || b->fats != 0 ||
> +		get_unaligned_le16(&b->dir_entries) != 0 ||
> +		get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
> +		b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
> +		b->secs_track != 0 || b->heads != 0)
> +		return;
> +
> +	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
> +	switch (bd_sects) {
> +	case 160 * KB_IN_SECTORS:
> +		b->sec_per_clus = 1;
> +		put_unaligned_le16(64, &b->dir_entries);
> +		b->media = 0xFE;
> +		b->fat_length = cpu_to_le16(1);
> +		break;

[...]

Hm, this looks like check the volume size. But if there is newer fat
format on same volume size, how to detect it? Or, it is conflicting?

[BTW, we should avoid to mount if it doesn't seem fatfs, to prevent
mis-mount as fatfs (auto mount is depending on this detection).]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
