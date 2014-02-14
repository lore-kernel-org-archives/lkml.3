Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBNHaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:30:25 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51920 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNHaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:30:24 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/6] fat: add fat_fallocate operation
References: <1387953065-2726-1-git-send-email-linkinjeon@gmail.com>
	<87mwi8x27b.fsf@devron.myhome.or.jp>
	<CAKYAXd_EYrfF0iQVw5FJRHkGCeMTUoQdx+BogV+-g9vqXeGZdw@mail.gmail.com>
	<CAKYAXd80BFUMGYrON22Ui4xSMaxNJaHD1ss8bMVgdQqC4xG48A@mail.gmail.com>
Date: Fri, 14 Feb 2014 16:30:19 +0900
In-Reply-To: <CAKYAXd80BFUMGYrON22Ui4xSMaxNJaHD1ss8bMVgdQqC4xG48A@mail.gmail.com>
	(Namjae Jeon's message of "Fri, 14 Feb 2014 13:53:26 +0900")
Message-ID: <8761oiqhh0.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> [...]
>>>
>>>> +		/* Release unwritten fallocated blocks on inode eviction. */
>>>> +		if (MSDOS_I(inode)->mmu_private < MSDOS_I(inode)->i_disksize) {
>>>> +			int err;
>>>> +			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
>>>> +			/* Fallocate results in updating the i_start/iogstart
>>>> +			 * for the zero byte file. So, make it return to
>>>> +			 * original state during evict and commit it
>>>> +			 * synchrnously to avoid any corruption on the next
>>>> +			 * access to the cluster chain for the file.
>>>> +			 */
>>>> +			err = fat_sync_inode(inode);
>>>
>>> Ah, good catch. We have to update i_size. I was forgetting about this.
>>> Well, sync inode unconditionally would not be good. Maybe, we better to
>>> use __fat_write_inode() with inode_needs_sync() or such.
>> Okay, I will change it.
> Hi OGAWA
>
> When I checked more, we should wait till inode is sync. Because in the
> eviction it will leave the inode/buffers being marked dirty.
> Not waiting for it get sync over here. It will leave cluster chain
> corrupted when remounting.
> It mean we cannot use __fat_write_inode with inode_needs_sync() conditionally.

Yeah, this situation bothers us. However, the inode is not marked as
dirty after I_FREEING. And in fatfs case, all related dirty buffers
should goes into blockdev inode buffers (i.e. metadata only), right?

So, I thought sync is not necessary.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
