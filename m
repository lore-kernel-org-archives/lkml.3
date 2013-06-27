Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3F0HWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:22:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47738 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3F0HWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:22:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard> <87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard> <87y59w5dye.fsf@devron.myhome.or.jp>
	<20130627063816.GD29790@dastard>
Date: Thu, 27 Jun 2013 16:22:04 +0900
In-Reply-To: <20130627063816.GD29790@dastard> (Dave Chinner's message of "Thu,
	27 Jun 2013 16:38:16 +1000")
Message-ID: <87ppv83tnn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> Otherwise, vfs can't know the data is whether after sync point or before
>> sync point, and have to wait or not. FS is using the behavior like
>> data=journal has tracking of those already, and can reuse it.
>
> The VFS writeback code already differentiates between data written
> during a sync operation and that dirtied after a sync operation.
> Perhaps you should look at the tagging for WB_SYNC_ALL writeback
> that write_cache_pages does....
>
> But, anyway, we don't have to do that on the waiting side of things.
> All we need to do is add the inode to a "under IO" list on the bdi
> when the mapping is initially tagged with pages under writeback,
> and remove it from that list during IO completion when the mapping
> is no longer tagged as having pages under writeback.
>
> wait_sb_inodes() just needs to walk that list and wait on each inode
> to complete IO. It doesn't require *any awareness* of the underlying
> filesystem implementation or how the IO is actually issued - if
> there's IO in progress at the time wait_sb_inodes() is called, then
> it waits for it.
>
>> > Fix the root cause of the problem - the sub-optimal VFS code.
>> > Hacking around it specifically for out-of-tree code is not the way
>> > things get done around here...
>> 
>> I'm thinking the root cause is vfs can't have knowledge of FS internal,
>> e.g. FS is handling data transactional way, or not.
>
> If the filesystem has transactional data/metadata that the VFS is
> not tracking, then that is what the ->sync_fs call is for. i.e. so
> the filesystem can then do what ever extra writeback/waiting it
> needs to do that the VFS is unaware of.
>
> We already cater for what Tux3 needs in the VFS - all you've done is
> found an inefficient algorithm that needs fixing.

write_cache_pages() is library function to be called from per-FS. So, it
is not under vfs control can be assume already. And it doesn't do right
things via write_cache_pages() for data=journal, because it handles for
each inodes, not at once. So, new dirty data can be inserted while
marking.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
