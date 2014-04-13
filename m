Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaDMWO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:14:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38989 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaDMWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:14:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cse.cem@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1397398200-6510-1-git-send-email-cse.cem@gmail.com>
Date: Mon, 14 Apr 2014 07:14:51 +0900
In-Reply-To: <1397398200-6510-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Sun, 13 Apr 2014 07:10:00 -0700")
Message-ID: <87vbucvpus.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cse.cem@gmail.com> writes:

> +	sbi->sec_per_clus = fdefaults->sec_per_clus;
> +	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
> +	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
> +	sbi->fats = 2;
> +	sbi->fat_start = 1;
> +	sbi->fat_length = fdefaults->fat_length;
> +
> +	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
> +	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
> +	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
> +	sbi->dir_entries = fdefaults->dir_entries;
> +
> +	rootdir_sectors = sbi->dir_entries
> +		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
> +	sbi->data_start = sbi->dir_start + rootdir_sectors;
> +	total_sectors = fdefaults->nr_sectors;
> +	total_clusters = (total_sectors - sbi->data_start) / sbi->sec_per_clus;
> +	sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
> +
> +	/* some OSes set FAT_STATE_DIRTY and clean it on unmount. */
> +	sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
> +
> +	/* check that FAT table does not overflow */
> +	fat_clusters = calc_fat_clusters(sb);
> +	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);

Ah, you meant this duplicated one.

Let's use structure like fat_boot_sector (but more cpu friendly) on
stack or something, instead of modify bh (BPB). Modifying bh in bdev is
visible via /dev/foo, this is why I want to avoid to modify.

With this, we can share almost all codes on both of read_bpb() and
static_bpb(), and avoids to modify bdev buffer? And those 2 helpers only
has small chunk of code, and provide the required parameters?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
