Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3CKJw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:52:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3CKJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <87sj44ac82.fsf@devron.myhome.or.jp>
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
	<87sj44ac82.fsf@devron.myhome.or.jp>
Date: Mon, 11 Mar 2013 18:52:25 +0900
Message-ID: <CAKYAXd_E8ZzutRVX6bCpzuosVLqsCDk0VzPYeXtcG8K+4wwBvQ@mail.gmail.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/9, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>  static int fat_file_release(struct inode *inode, struct file *filp)
>>  {
>> +	struct super_block *sb = inode->i_sb;
>> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
>> +				    ~(sb->s_blocksize-1);
>> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>> +	    filp->f_dentry->d_count == 1)
>> +		fat_truncate_blocks(inode, inode->i_size);
>
Hi OGAWA.
> Without locking, truncate is racy.
I will check for races and provide locking.
>
> This choose ->release(). BTW, we would also be able to do this only
> ->evict_inode(), although I'm not thinking yet which one is better.
>
> If you had conclusion, it would be nice to explain it.
evict_inode() will be called only when we unlink the file or if inode
is evicted from cache.
As we discussed with you before, We considered preallocated blocks is
discarded on all close file cases(unlink and muliple openning file).
So we think it would be better to do this in ->release().
>
>> +static long fat_fallocate(struct file *file, int mode,
>> +				loff_t offset, loff_t len)
>> +{
>>
>> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
>> +		fat_msg(sb, KERN_ERR,
>> +			"fat_fallocate():Blocks already allocated");
>> +		return -EINVAL;
>> +	}
>
> Also this looks like totally racy.
Okay, I will fix it.

>
>>  static int fat_write_begin(struct file *file, struct address_space
>> *mapping,
>>  			loff_t pos, unsigned len, unsigned flags,
>>  			struct page **pagep, void **fsdata)
>>  {
>>  	int err;
>> +	struct inode *inode = mapping->host;
>> +	struct super_block *sb = inode->i_sb;
>> +	loff_t mmu_private_actual = MSDOS_I(inode)->mmu_private;
>> +	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
>> +					 ~(sb->s_blocksize-1);
>> +
>> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > inode->i_size))
>> {
>> +		err = fat_zero_falloc_area(file, mapping, pos);
>> +		if (err)
>> +			fat_msg(sb, KERN_ERR, "error zeroing fallocated area");
>> +	}
>>
>>  	*pagep = NULL;
>>  	err = cont_write_begin(file, mapping, pos, len, flags,
>
> Hm, only write_begin is enough to handle mmap, truncate, and etc.?
We had not checked these use cases.  We will check these.

Thanks for review!

> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
