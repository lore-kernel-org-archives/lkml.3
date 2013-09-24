Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750761Ab3IXEMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:12:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36227 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3IXEMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <87r4cfbs06.fsf@devron.myhome.or.jp>
References: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
	<87a9j6y5zv.fsf@devron.myhome.or.jp>
	<CAKYAXd9VCOtG52w34hgun5VY6wACfUCjo2pvgmUmSt65yOSuTA@mail.gmail.com>
	<87r4cfbs06.fsf@devron.myhome.or.jp>
Date: Tue, 24 Sep 2013 13:12:39 +0900
Message-ID: <CAKYAXd_-W_K4=cRDevd8f4WcixT6sQTwbRmHq3brdZzmAVYzRw@mail.gmail.com>
Subject: Re: [PATCH v6] fat: additions to support fat_fallocate
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

2013/9/23, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> +	if (MSDOS_I(inode)->mmu_private > round_up(i_size, sb->s_blocksize)
>>>> +			&& pos > i_size) {
>>>> +		err = fat_zero_falloc_area(file, mapping, pos);
>>>> +		if (err) {
>>>> +			fat_msg(sb, KERN_ERR,
>>>> +				"Error (%d) zeroing fallocated area", err);
>>>> +			return err;
>>>> +		}
>>>> +	}
>>>
>>> Again, I'm not fan of this way.
>>>
>>> Normally, get_block() returns with buffer_new(). Then, caller checks
>>> blockdev buffer with
>>>
>>> 	unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>>>
>>> then, zeroed buffer. Do we really don't need to check this race?
>> We considered after your advice before. we reach for the conclusion
>> that use this method.
>> because, Cluster is already allocated in fat fallocate and
>> when we write with radom offset over i_size on fallocated region, It
>> will be hit by fat cache in fat_bmap of get_block, which mean buffer
>> is not set to new.
>
> Hm, how does it hit to fat cache? I think fat_alloc_clusters() and
> fat_chain_add() doesn't update fat cache, right? I.e. initial write
> after fallocate() should not hit fat cache over i_size?

Ah.. Sorry for wrong reply. old memory make me confusing.
By allocating cluster in fat fallocate, when write, fat_bmap of
get_block return physical sector number.
So buffer is not set to new in _fat_get_block.

When we fallocate with keep size on -> only clusters are added to the
fat chain calling fat_get_cluster(),and add the cluster to cluster
chain.
This doesn’t call fat_get_block() .

Now when we try to write in the fallocated region in the
fat_write_begin() when it is called first time it checks that the
mismatch is present between the mmu_private and mmu_actual (i.e., the
file has pre-allocated blocks), and hence zero out the region ;
Since buffer_new() is not set for fallocated region by fat_get_block()
, we explicitly  zero out the lseek'ed region using
“fat_zero_falloc_area” and normal write occurs beyond that,and i_size
is updated accordingly.

Thanks :)
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
