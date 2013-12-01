Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3LAMta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:49:30 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51472 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3LAMt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:49:26 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 3/5] fat: zero out seek range on _fat_get_block
References: <1384688291-2935-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:49:20 +0900
In-Reply-To: <1384688291-2935-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:38:11 +0900")
Message-ID: <8761r8enxr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> --- a/fs/fat/cache.c
> +++ b/fs/fat/cache.c
> @@ -334,7 +334,8 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  		 */
>  		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>  			>> blocksize_bits;
> -		if (sector >= last_block)
> +		if (sector >= last_block &&
> +		    MSDOS_I(inode)->mmu_private == MSDOS_I(inode)->i_disksize)
>  			return 0;

This is strange check. Why do we want to map even if "sector > ->i_disksize"
(when ->mmu_private != ->i_disksize)?


Another point, for ->bmap(), maybe we will need new flag to read beyond
->i_size? Because ->bmap() returns physical address even if > ->i_size.

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 655dcc7..12a37a9 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -61,15 +61,26 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
>  	struct super_block *sb = inode->i_sb;
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	unsigned long mapped_blocks;
> -	sector_t phys;
> +	sector_t phys, last_block, disk_block;
>  	int err, offset;
> +	const unsigned long blocksize = sb->s_blocksize;
> +	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>  
>  	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
>  	if (err)
>  		return err;
>  	if (phys) {
> -		map_bh(bh_result, sb, phys);
>  		*max_blocks = min(mapped_blocks, *max_blocks);
> +		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
> +			>> blocksize_bits;
> +		disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
> +			>> blocksize_bits;
> +		if (iblock >= last_block && iblock <= disk_block) {
> +			MSDOS_I(inode)->mmu_private +=
> +				*max_blocks << blocksize_bits;
> +			set_buffer_new(bh_result);
> +		}
> +		map_bh(bh_result, sb, phys);
>  		return 0;
>  	}
>  	if (!create)

Let's give the name for this operation for readability, and make it
static function. With this, I think this one much readable.

static void check_fallocate_region()
{
	/* code here */
}
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
