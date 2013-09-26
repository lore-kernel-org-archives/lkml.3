Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3IZL2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:28:25 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43909 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab3IZL2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <87mwn2bkx3.fsf@devron.myhome.or.jp>
References: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
	<87a9j6y5zv.fsf@devron.myhome.or.jp>
	<CAKYAXd9VCOtG52w34hgun5VY6wACfUCjo2pvgmUmSt65yOSuTA@mail.gmail.com>
	<87r4cfbs06.fsf@devron.myhome.or.jp>
	<CAKYAXd_-W_K4=cRDevd8f4WcixT6sQTwbRmHq3brdZzmAVYzRw@mail.gmail.com>
	<87mwn2bkx3.fsf@devron.myhome.or.jp>
Date: Thu, 26 Sep 2013 20:28:23 +0900
Message-ID: <CAKYAXd8J9fQi+Jn2ekUsmy4ppth4nP072_dMAFGfUYr7-MNVmQ@mail.gmail.com>
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

2013/9/24, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> We considered after your advice before. we reach for the conclusion
>>>> that use this method.
>>>> because, Cluster is already allocated in fat fallocate and
>>>> when we write with radom offset over i_size on fallocated region, It
>>>> will be hit by fat cache in fat_bmap of get_block, which mean buffer
>>>> is not set to new.
>>>
>>> Hm, how does it hit to fat cache? I think fat_alloc_clusters() and
>>> fat_chain_add() doesn't update fat cache, right? I.e. initial write
>>> after fallocate() should not hit fat cache over i_size?
>>
>> Ah.. Sorry for wrong reply. old memory make me confusing.
>> By allocating cluster in fat fallocate, when write, fat_bmap of
>> get_block return physical sector number.
>> So buffer is not set to new in _fat_get_block.
>>
>> When we fallocate with keep size on -> only clusters are added to the
>> fat chain calling fat_get_cluster(),and add the cluster to cluster
>> chain.
>> This doesn’t call fat_get_block() .
>
> Right.
>
>> Now when we try to write in the fallocated region in the
>> fat_write_begin() when it is called first time it checks that the
>> mismatch is present between the mmu_private and mmu_actual (i.e., the
>> file has pre-allocated blocks), and hence zero out the region ;
>> Since buffer_new() is not set for fallocated region by fat_get_block()
>> , we explicitly  zero out the lseek'ed region using
>> “fat_zero_falloc_area” and normal write occurs beyond that,and i_size
>> is updated accordingly.
>
> Yes. So I'm saying fixing fat_get_block() would not be hard.
>
> For example, add new size the disk_size, totally 3 sizes - 1) i_size 2)
> mmu_private (aka, initialized size) 3) disk_size (aka, uninitialized
> size).
>
> When called fat_get_block(), it checks the region between mmu_private
> and disk_size. If block hits that region, block is uninitialized area,
> so return as buffer_new().
>
> Like this, I think it is not hard. Please consider like above example
> too.
Yes, I checked after change as your suggestion. it work fine.
I will post the updated patch soon.

Thanks. OGAWA.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
