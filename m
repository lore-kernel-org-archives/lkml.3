Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3IWNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:13:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55357 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3IWNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:13:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6] fat: additions to support fat_fallocate
References: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
	<87a9j6y5zv.fsf@devron.myhome.or.jp>
	<CAKYAXd9VCOtG52w34hgun5VY6wACfUCjo2pvgmUmSt65yOSuTA@mail.gmail.com>
Date: Mon, 23 Sep 2013 22:13:29 +0900
In-Reply-To: <CAKYAXd9VCOtG52w34hgun5VY6wACfUCjo2pvgmUmSt65yOSuTA@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 23 Sep 2013 17:13:59 +0900")
Message-ID: <87r4cfbs06.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> +	if (MSDOS_I(inode)->mmu_private > round_up(i_size, sb->s_blocksize)
>>> +			&& pos > i_size) {
>>> +		err = fat_zero_falloc_area(file, mapping, pos);
>>> +		if (err) {
>>> +			fat_msg(sb, KERN_ERR,
>>> +				"Error (%d) zeroing fallocated area", err);
>>> +			return err;
>>> +		}
>>> +	}
>>
>> Again, I'm not fan of this way.
>>
>> Normally, get_block() returns with buffer_new(). Then, caller checks
>> blockdev buffer with
>>
>> 	unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>>
>> then, zeroed buffer. Do we really don't need to check this race?
> We considered after your advice before. we reach for the conclusion
> that use this method.
> because, Cluster is already allocated in fat fallocate and
> when we write with radom offset over i_size on fallocated region, It
> will be hit by fat cache in fat_bmap of get_block, which mean buffer
> is not set to new.

Hm, how does it hit to fat cache? I think fat_alloc_clusters() and
fat_chain_add() doesn't update fat cache, right? I.e. initial write
after fallocate() should not hit fat cache over i_size?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
