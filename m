Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3LAMwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:52:53 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51480 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LAMwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:52:51 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 5/5] fat: permit to return phy block number by fibmap in fallocated region
References: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:52:47 +0900
In-Reply-To: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:38:35 +0900")
Message-ID: <87wqjod97k.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
> index c56bd7e..7777822 100644
> --- a/fs/fat/cache.c
> +++ b/fs/fat/cache.c
> @@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>  	sector_t last_block;
>  	int cluster, offset;
> +	loff_t i_size = i_size_read(inode);
>  
>  	*phys = 0;
>  	*mapped_blocks = 0;
> @@ -323,10 +324,20 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  		return 0;
>  	}
>  
> -	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
> +	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
>  	if (sector >= last_block) {
> -		if (!create)
> +		if (!create) {
> +			/*
> +			 * to map cluster in case of read request
> +			 * for a block in fallocated region
> +			 */
> +			if (MSDOS_I(inode)->i_disksize >
> +			    round_up(i_size, sb->s_blocksize)) {
> +				goto out_map_cluster;
> +			}

Said on another reply though, we will have to add new flag for
this. Because normal read get_block() operation should not return
mapping beyond ->i_size.

>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
> -	down_read(&MSDOS_I(mapping->host)->truncate_lock);
> +	mutex_lock(&mapping->host->i_mutex);
>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
> -	up_read(&MSDOS_I(mapping->host)->truncate_lock);
> +	mutex_unlock(&mapping->host->i_mutex);
>  
>  	return blocknr;
>  }

->i_mutex doesn't work for swapfile.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
