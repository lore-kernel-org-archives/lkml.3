Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3EBGM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:12:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36760 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3EBGMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <87vc722cdu.fsf@devron.myhome.or.jp>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	<87vc722cdu.fsf@devron.myhome.or.jp>
Date: Thu, 2 May 2013 15:12:55 +0900
Message-ID: <CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/2, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>>> Hm, why d_count == 1 check is needed? Feel strange and racy.
>>>> Since, fat_file_release() is called on every close for the file.
>>>
>>> What is wrong? IIRC, it is what you choose (i.e. for each last close for
>>> the file descriptor).
>> Yes, this is what we had chosen after discussion. Freeing reserved
>> space point being the file release path.
>> But if there are multiple accessors for the file then file_release
>> will be called by each process.
>> Freeing the space in first call will result in wrong file attributes
>> for the other points. So, we needed a differentiation of last close
>> for the file.
>> Am I missing something ?
>
> Then, per-file discard fallocate space sounds like wrong. fallocate
> space probably is inode attribute.
Since, our preallocation will not be persistent after umount. So, we
need to free up the space at some point.
If we consider for normal pre-allocation in ext4, in that case also
the blocks are removed in ext4_release_file when the last writer
closes the file.

ext4_release_file()
{
...
/* if we are the last writer on the inode, drop the block reservation */
	if ((filp->f_mode & FMODE_WRITE) &&
			(atomic_read(&inode->i_writecount) == 1) &&
		        !EXT4_I(inode)->i_reserved_data_blocks)
	{
		down_write(&EXT4_I(inode)->i_data_sem);
		ext4_discard_preallocations(inode);
		up_write(&EXT4_I(inode)->i_data_sem);
	}

So, we will need to have this per file . May be the condition for
checking is wrong which can be correct but the correctness points
should be same. We can give a thought on using "i_writecount" for
controlling the parallel write in FAT also.
how do you think ?

>
>>> I know. Question is, why do we need to initialize twice.
>>>
>>> 1) zeroed for uninitialized area, 2) then copy user data area. We need
>>> only either, right? This seems to be doing both for all fallocated area.
>> We did not initialize twice. We are using the ‘pos’ as the attribute
>> to define zeroing length in case of pre-allocation.
>> Zeroing out occurs till the ‘pos’ while actual write occur after ‘pos’.
>> If we file size is 100KB and we pre-allocated till 1MB. Next if we try
>> to write at 500KB,
>> Then zeroing out will occur only for 100KB->500KB, after that there
>> will be normal write. There is no duplication for the same space.
>
> Ah. Then write_begin() really initialize after i_size until page cache
> boudary for append write? I wonder if this patch works correctly for
> mmap.
Since you already provided me review comments to check truncate and
mmap, we checked all points for those cases.

Thanks~
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
