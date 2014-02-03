Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaBCXN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:13:28 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48840 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <87eh3kx1n6.fsf@devron.myhome.or.jp>
References: <1387953112-2828-1-git-send-email-linkinjeon@gmail.com>
	<87eh3kx1n6.fsf@devron.myhome.or.jp>
Date: Tue, 4 Feb 2014 08:13:26 +0900
Message-ID: <CAKYAXd9mm6KmMu6XvQoFynQtyAC8yR5rCd12SMoB_PFgojbEiw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] fat: permit to return phy block number by fibmap
 in fallocated region
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-03, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Make the fibmap call the return the proper physical block number for any
>> offset request in the fallocated range.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/fat/cache.c |   13 ++++++++++---
>>  fs/fat/fat.h   |    3 +++
>>  fs/fat/inode.c |    3 +++
>>  3 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
>> index a132666..d22c1a2 100644
>> --- a/fs/fat/cache.c
>> +++ b/fs/fat/cache.c
>> @@ -325,19 +325,26 @@ int fat_bmap(struct inode *inode, sector_t sector,
>> sector_t *phys,
>>
>>  	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
>>  	if (sector >= last_block) {
>> -		if (!create)
>> -			return 0;
>> -
>>  		/*
>>  		 * Both ->mmu_private and ->i_disksize can access
>>  		 * on only allocation path. (caller must hold ->i_mutex)
>>  		 */
>>  		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>>  			>> blocksize_bits;
>> +		if (!create) {
>> +			/* Map a block in fallocated region */
>> +			if (atomic_read(&MSDOS_I(inode)->beyond_isize))
>> +				if (sector < last_block)
>> +					goto out_map_cluster;
>> +
>> +			return 0;
>> +		}
>> +
>>  		if (sector >= last_block)
>>  			return 0;
>>  	}
>>
>> +out_map_cluster:
>>  	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
>>  	offset  = sector & (sbi->sec_per_clus - 1);
>>  	cluster = fat_bmap_cluster(inode, cluster);
>> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
>> index 7b5851f..b884276 100644
>> --- a/fs/fat/fat.h
>> +++ b/fs/fat/fat.h
>> @@ -129,6 +129,9 @@ struct msdos_inode_info {
>>  	struct hlist_node i_dir_hash;	/* hash by i_logstart */
>>  	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
>>  	struct inode vfs_inode;
>> +
>> +	/* for getting block number beyond file size in case of fallocate */
>> +	atomic_t beyond_isize;
>>  };
>>
>>  struct fat_slot_info {
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 3636617..1c3192b 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -256,7 +256,10 @@ static sector_t _fat_bmap(struct address_space
>> *mapping, sector_t block)
>>
>>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
>>  	down_read(&MSDOS_I(mapping->host)->truncate_lock);
>> +	/* To get block number beyond file size in fallocated region */
>> +	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 1);
>>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
>> +	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 0);
>>  	up_read(&MSDOS_I(mapping->host)->truncate_lock);
>
> This is racy. While user is using bmap, kernel can allocate new blocks.
> We should use another function for this.
I understand that fat can map fallocated blocks in read case while
user is using bmap.
But I can not find the case allocate new blocks.
If I am missing something, Could you please elaborate more ?
Is it a case of _bmap request returning the block number for block
allocated in parallel write path ?

Thanks.
>
> For example, something like
>
> fat_get_block_bmap()
> {
>         [...]
> 	fat_get_block2(inode, iblock, &max_blocks, bh_result, create, bmap);
>         [...]
> }
>
> blocknr = generic_block_bmap(mapping, block, fat_get_block_bmap);
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
