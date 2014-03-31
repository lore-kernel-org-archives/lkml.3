Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaCaWNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:13:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:13:39 -0400
Date: Mon, 31 Mar 2014 15:13:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        Mark <markk@clara.co.uk>, Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
Message-Id: <20140331151337.f6a46a8fcab6206f4d21be08@linux-foundation.org>
In-Reply-To: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2014 12:10:35 -0700 Conrad Meyer <cemeyer@uw.edu> wrote:

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
> 
> ...
>
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -35,9 +35,47 @@
>  #define CONFIG_FAT_DEFAULT_IOCHARSET	""
>  #endif
>  
> +#define KB_IN_SECTORS 2
> +
>  static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
>  static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
>  
> +static struct fat_floppy_defaults {
> +	unsigned nr_sectors;
> +	unsigned sec_per_clus;
> +	unsigned dir_entries;
> +	unsigned media;
> +	unsigned fat_length;
> +} floppy_defaults[] = {
> +{
> +	.nr_sectors = 160 * KB_IN_SECTORS,
> +	.sec_per_clus = 1,
> +	.dir_entries = 64,
> +	.media = 0xFE,
> +	.fat_length = 1,
> +},
> +{
> +	.nr_sectors = 180 * KB_IN_SECTORS,
> +	.sec_per_clus = 1,
> +	.dir_entries = 64,
> +	.media = 0xFC,
> +	.fat_length = 2,
> +},
> +{
> +	.nr_sectors = 320 * KB_IN_SECTORS,
> +	.sec_per_clus = 2,
> +	.dir_entries = 112,
> +	.media = 0xFF,
> +	.fat_length = 1,
> +},
> +{
> +	.nr_sectors = 360 * KB_IN_SECTORS,
> +	.sec_per_clus = 2,
> +	.dir_entries = 112,
> +	.media = 0xFD,
> +	.fat_length = 2,
> +},
> +{ 0 } };

We don't really need this EOF element.

>  static int fat_add_cluster(struct inode *inode)
>  {
> @@ -1246,6 +1284,58 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
>  }
>  
>  /*
> + * If this FAT filesystem is archaic (lacking a BIOS Parameter Block, ca. DOS
> + * 1.x), fix it up in-place by creating a DOS 2.x BIOS Parameter Block from
> + * defaults for the media size.
> + */
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

Impressive!

> +		return;
> +
> +	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
> +	for (di = floppy_defaults; di->nr_sectors; di++) {

Can do something like

	for (di = floppy_defaults;
		di < floppy_defaults + ARRAY_SIZE(floppy_defaults); di++) {

> +		if (di->nr_sectors == bd_sects)
> +			break;
> +	}
> +	if (di->nr_sectors == 0) {
> +		fat_msg(sb, KERN_WARNING,
> +			"DOS volume lacks BPB and isn't a recognized floppy size (%ld sectors)",
> +			(long)bd_sects);

sector_t can be u64 on 32-bit so one should really use %Lu and cast to
u64.

>
> ...
>
