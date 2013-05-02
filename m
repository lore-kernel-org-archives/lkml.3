Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3EBHg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:36:28 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:46700 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3EBHg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:36:26 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	<87vc722cdu.fsf@devron.myhome.or.jp>
	<CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
Date: Thu, 02 May 2013 16:36:22 +0900
In-Reply-To: <CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 2 May 2013 15:12:55 +0900")
Message-ID: <87r4hp3kax.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> Then, per-file discard fallocate space sounds like wrong. fallocate
>> space probably is inode attribute.
> Since, our preallocation will not be persistent after umount. So, we
> need to free up the space at some point.
> If we consider for normal pre-allocation in ext4, in that case also
> the blocks are removed in ext4_release_file when the last writer
> closes the file.
>
> ext4_release_file()
> {
> ...
> /* if we are the last writer on the inode, drop the block reservation */
> 	if ((filp->f_mode & FMODE_WRITE) &&
> 			(atomic_read(&inode->i_writecount) == 1) &&
> 		        !EXT4_I(inode)->i_reserved_data_blocks)
> 	{
> 		down_write(&EXT4_I(inode)->i_data_sem);
> 		ext4_discard_preallocations(inode);
> 		up_write(&EXT4_I(inode)->i_data_sem);
> 	}
>
> So, we will need to have this per file . May be the condition for
> checking is wrong which can be correct but the correctness points
> should be same. We can give a thought on using "i_writecount" for
> controlling the parallel write in FAT also.
> how do you think ?

AFAIK, preallocation != fallocate. ext*'s preallocation was there at
before fallocation to optimize block allocation for user data blocks.

>>>> I know. Question is, why do we need to initialize twice.
>>>>
>>>> 1) zeroed for uninitialized area, 2) then copy user data area. We need
>>>> only either, right? This seems to be doing both for all fallocated area.
>>> We did not initialize twice. We are using the ‘pos’ as the attribute
>>> to define zeroing length in case of pre-allocation.
>>> Zeroing out occurs till the ‘pos’ while actual write occur after ‘pos’.
>>> If we file size is 100KB and we pre-allocated till 1MB. Next if we try
>>> to write at 500KB,
>>> Then zeroing out will occur only for 100KB->500KB, after that there
>>> will be normal write. There is no duplication for the same space.
>>
>> Ah. Then write_begin() really initialize after i_size until page cache
>> boudary for append write? I wonder if this patch works correctly for
>> mmap.
> Since you already provided me review comments to check truncate and
> mmap, we checked all points for those cases.

cluster size == 512b

1) create new file
2) fallocate 100MB
3) write(2) data for each 512b

With this, write_begin() will be called for each 512b data. When we
allocates new page for this file, write_begin() writes data 0-512. Then,
we have to initialize 512-4096 by zero. Because mmap read maps 0-4096,
even if i_size == 512.

Who is initializing area for 512-4096?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
