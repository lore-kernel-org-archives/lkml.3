Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3LEOUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:20:21 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:54092 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3LEOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <87wqjod97k.fsf@devron.myhome.or.jp>
References: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com>
	<87wqjod97k.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:20:19 +0900
Message-ID: <CAKYAXd8NS56AYO-EGs4SM9jVn7AfsQbKznxXP2t7Xf2qDXUo1g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] fat: permit to return phy block number by fibmap
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

2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
>> index c56bd7e..7777822 100644
>> --- a/fs/fat/cache.c
>> +++ b/fs/fat/cache.c
>> @@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector_t sector,
>> sector_t *phys,
>>  	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>>  	sector_t last_block;
>>  	int cluster, offset;
>> +	loff_t i_size = i_size_read(inode);
>>
>>  	*phys = 0;
>>  	*mapped_blocks = 0;
>> @@ -323,10 +324,20 @@ int fat_bmap(struct inode *inode, sector_t sector,
>> sector_t *phys,
>>  		return 0;
>>  	}
>>
>> -	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
>> +	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
>>  	if (sector >= last_block) {
>> -		if (!create)
>> +		if (!create) {
>> +			/*
>> +			 * to map cluster in case of read request
>> +			 * for a block in fallocated region
>> +			 */
>> +			if (MSDOS_I(inode)->i_disksize >
>> +			    round_up(i_size, sb->s_blocksize)) {
>> +				goto out_map_cluster;
>> +			}
>
> Said on another reply though, we will have to add new flag for
> this. Because normal read get_block() operation should not return
> mapping beyond ->i_size.
Okay.
>
>>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
>> -	down_read(&MSDOS_I(mapping->host)->truncate_lock);
>> +	mutex_lock(&mapping->host->i_mutex);
>>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
>> -	up_read(&MSDOS_I(mapping->host)->truncate_lock);
>> +	mutex_unlock(&mapping->host->i_mutex);
>>
>>  	return blocknr;
>>  }
>
> ->i_mutex doesn't work for swapfile.
Sorry, Actually, I don't understand why it is related with swapfile.
Could you elaborate more ?

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
