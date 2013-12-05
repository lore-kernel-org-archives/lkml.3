Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3LEOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:15:34 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50743 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3LEOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:15:32 -0500
MIME-Version: 1.0
In-Reply-To: <8761r8enxr.fsf@devron.myhome.or.jp>
References: <1384688291-2935-1-git-send-email-linkinjeon@gmail.com>
	<8761r8enxr.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:15:31 +0900
Message-ID: <CAKYAXd8wtivUVPPp+aYB-_dAzR-i+xNfZ7atP67M=JK7N3rN2g@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] fat: zero out seek range on _fat_get_block
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> --- a/fs/fat/cache.c
>> +++ b/fs/fat/cache.c
>> @@ -334,7 +334,8 @@ int fat_bmap(struct inode *inode, sector_t sector,
>> sector_t *phys,
>>  		 */
>>  		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>>  			>> blocksize_bits;
>> -		if (sector >= last_block)
>> +		if (sector >= last_block &&
>> +		    MSDOS_I(inode)->mmu_private == MSDOS_I(inode)->i_disksize)
>>  			return 0;
>
> This is strange check. Why do we want to map even if "sector >
> ->i_disksize"
> (when ->mmu_private != ->i_disksize)?
Yes, Don't want it. I will fix it.
>
>
> Another point, for ->bmap(), maybe we will need new flag to read beyond
> ->i_size? Because ->bmap() returns physical address even if > ->i_size.
Okay, I will change it as your comment.
>
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 655dcc7..12a37a9 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -61,15 +61,26 @@ static inline int __fat_get_block(struct inode *inode,
>> sector_t iblock,
>>  	struct super_block *sb = inode->i_sb;
>>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>>  	unsigned long mapped_blocks;
>> -	sector_t phys;
>> +	sector_t phys, last_block, disk_block;
>>  	int err, offset;
>> +	const unsigned long blocksize = sb->s_blocksize;
>> +	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>>
>>  	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
>>  	if (err)
>>  		return err;
>>  	if (phys) {
>> -		map_bh(bh_result, sb, phys);
>>  		*max_blocks = min(mapped_blocks, *max_blocks);
>> +		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
>> +			>> blocksize_bits;
>> +		disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>> +			>> blocksize_bits;
>> +		if (iblock >= last_block && iblock <= disk_block) {
>> +			MSDOS_I(inode)->mmu_private +=
>> +				*max_blocks << blocksize_bits;
>> +			set_buffer_new(bh_result);
>> +		}
>> +		map_bh(bh_result, sb, phys);
>>  		return 0;
>>  	}
>>  	if (!create)
>
> Let's give the name for this operation for readability, and make it
> static function. With this, I think this one much readable.
>
> static void check_fallocate_region()
> {
> 	/* code here */
> }
Okay, I will make it.
Thanks for review.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
