Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3IXJ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:58:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58890 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3IXJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:58:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6] fat: additions to support fat_fallocate
References: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
	<87a9j6y5zv.fsf@devron.myhome.or.jp>
	<CAKYAXd9VCOtG52w34hgun5VY6wACfUCjo2pvgmUmSt65yOSuTA@mail.gmail.com>
	<87r4cfbs06.fsf@devron.myhome.or.jp>
	<CAKYAXd_-W_K4=cRDevd8f4WcixT6sQTwbRmHq3brdZzmAVYzRw@mail.gmail.com>
Date: Tue, 24 Sep 2013 18:58:48 +0900
In-Reply-To: <CAKYAXd_-W_K4=cRDevd8f4WcixT6sQTwbRmHq3brdZzmAVYzRw@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 24 Sep 2013 13:12:39 +0900")
Message-ID: <87mwn2bkx3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> We considered after your advice before. we reach for the conclusion
>>> that use this method.
>>> because, Cluster is already allocated in fat fallocate and
>>> when we write with radom offset over i_size on fallocated region, It
>>> will be hit by fat cache in fat_bmap of get_block, which mean buffer
>>> is not set to new.
>>
>> Hm, how does it hit to fat cache? I think fat_alloc_clusters() and
>> fat_chain_add() doesn't update fat cache, right? I.e. initial write
>> after fallocate() should not hit fat cache over i_size?
>
> Ah.. Sorry for wrong reply. old memory make me confusing.
> By allocating cluster in fat fallocate, when write, fat_bmap of
> get_block return physical sector number.
> So buffer is not set to new in _fat_get_block.
>
> When we fallocate with keep size on -> only clusters are added to the
> fat chain calling fat_get_cluster(),and add the cluster to cluster
> chain.
> This doesn’t call fat_get_block() .

Right.

> Now when we try to write in the fallocated region in the
> fat_write_begin() when it is called first time it checks that the
> mismatch is present between the mmu_private and mmu_actual (i.e., the
> file has pre-allocated blocks), and hence zero out the region ;
> Since buffer_new() is not set for fallocated region by fat_get_block()
> , we explicitly  zero out the lseek'ed region using
> “fat_zero_falloc_area” and normal write occurs beyond that,and i_size
> is updated accordingly.

Yes. So I'm saying fixing fat_get_block() would not be hard.

For example, add new size the disk_size, totally 3 sizes - 1) i_size 2)
mmu_private (aka, initialized size) 3) disk_size (aka, uninitialized
size).

When called fat_get_block(), it checks the region between mmu_private
and disk_size. If block hits that region, block is uninitialized area,
so return as buffer_new().

Like this, I think it is not hard. Please consider like above example
too.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
