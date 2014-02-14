Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBNKQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:16:14 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36962 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaBNKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <8761oiqhh0.fsf@devron.myhome.or.jp>
References: <1387953065-2726-1-git-send-email-linkinjeon@gmail.com>
	<87mwi8x27b.fsf@devron.myhome.or.jp>
	<CAKYAXd_EYrfF0iQVw5FJRHkGCeMTUoQdx+BogV+-g9vqXeGZdw@mail.gmail.com>
	<CAKYAXd80BFUMGYrON22Ui4xSMaxNJaHD1ss8bMVgdQqC4xG48A@mail.gmail.com>
	<8761oiqhh0.fsf@devron.myhome.or.jp>
Date: Fri, 14 Feb 2014 19:16:11 +0900
Message-ID: <CAKYAXd951bjgSkzFKOKigPx7Ut+=DPCUFQLdH-3DS-0mhp+f+Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] fat: add fat_fallocate operation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-14 16:30 GMT+09:00, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> [...]
>>>>
>>>>> +		/* Release unwritten fallocated blocks on inode eviction. */
>>>>> +		if (MSDOS_I(inode)->mmu_private < MSDOS_I(inode)->i_disksize) {
>>>>> +			int err;
>>>>> +			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
>>>>> +			/* Fallocate results in updating the i_start/iogstart
>>>>> +			 * for the zero byte file. So, make it return to
>>>>> +			 * original state during evict and commit it
>>>>> +			 * synchrnously to avoid any corruption on the next
>>>>> +			 * access to the cluster chain for the file.
>>>>> +			 */
>>>>> +			err = fat_sync_inode(inode);
>>>>
>>>> Ah, good catch. We have to update i_size. I was forgetting about this.
>>>> Well, sync inode unconditionally would not be good. Maybe, we better to
>>>> use __fat_write_inode() with inode_needs_sync() or such.
>>> Okay, I will change it.
>> Hi OGAWA
>>
>> When I checked more, we should wait till inode is sync. Because in the
>> eviction it will leave the inode/buffers being marked dirty.
>> Not waiting for it get sync over here. It will leave cluster chain
>> corrupted when remounting.
>> It mean we cannot use __fat_write_inode with inode_needs_sync()
>> conditionally.
>
> Yeah, this situation bothers us. However, the inode is not marked as
> dirty after I_FREEING. And in fatfs case, all related dirty buffers
> should goes into blockdev inode buffers (i.e. metadata only), right?
Right.
>
> So, I thought sync is not necessary.
Yes, I will add it as you pointed.

Thanks for review!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
