Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBDGz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:55:57 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50508 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaBDGzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:55:46 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 5/6] fat: permit to return phy block number by fibmap in fallocated region
References: <1387953112-2828-1-git-send-email-linkinjeon@gmail.com>
	<87eh3kx1n6.fsf@devron.myhome.or.jp>
	<CAKYAXd9mm6KmMu6XvQoFynQtyAC8yR5rCd12SMoB_PFgojbEiw@mail.gmail.com>
	<87a9e7wq6w.fsf@devron.myhome.or.jp>
	<CAKYAXd8K9tO2zyZvHtMRA54=XvWowaA3SVa2H6_R5bnmKgG5Dg@mail.gmail.com>
Date: Tue, 04 Feb 2014 15:55:37 +0900
In-Reply-To: <CAKYAXd8K9tO2zyZvHtMRA54=XvWowaA3SVa2H6_R5bnmKgG5Dg@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 4 Feb 2014 13:03:16 +0900")
Message-ID: <8761ovwemu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2014-02-04, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>>>>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated.
>>>>> */
>>>>>  	down_read(&MSDOS_I(mapping->host)->truncate_lock);
>>>>> +	/* To get block number beyond file size in fallocated region */
>>>>> +	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 1);
>>>>>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
>>>>> +	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 0);
>>>>>  	up_read(&MSDOS_I(mapping->host)->truncate_lock);
>>>>
>>>> This is racy. While user is using bmap, kernel can allocate new blocks.
>>>> We should use another function for this.
>>> I understand that fat can map fallocated blocks in read case while
>>> user is using bmap.
>>> But I can not find the case allocate new blocks.
>>> If I am missing something, Could you please elaborate more ?
>>> Is it a case of _bmap request returning the block number for block
>>> allocated in parallel write path ?
>>
>> ->beyond_size is global for inode. So, write(2) path on same inode with
>> bmap() also can see 1 set by bmap() while another process is using bmap().
> 'create' flag  will be 1 in write(2) path. ->beyond_isize will only be
> checked when 'create' flag is 0. Is there any case to be racy by
> beyond_isize in write(2) path ?

Ah, so instead of write, it will assign physical address to buffers
beyond i_size for simple read if race?  In this case, it is still wrong.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
