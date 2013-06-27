Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3F0KGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:06:42 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47798 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:06:41 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard> <87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard> <87y59w5dye.fsf@devron.myhome.or.jp>
	<20130627063816.GD29790@dastard> <87ppv83tnn.fsf@devron.myhome.or.jp>
	<20130627094042.GZ29338@dastard>
Date: Thu, 27 Jun 2013 19:06:37 +0900
In-Reply-To: <20130627094042.GZ29338@dastard> (Dave Chinner's message of "Thu,
	27 Jun 2013 19:40:42 +1000")
Message-ID: <87mwqb3m1e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> >> > Fix the root cause of the problem - the sub-optimal VFS code.
>> >> > Hacking around it specifically for out-of-tree code is not the way
>> >> > things get done around here...
>> >> 
>> >> I'm thinking the root cause is vfs can't have knowledge of FS internal,
>> >> e.g. FS is handling data transactional way, or not.
>> >
>> > If the filesystem has transactional data/metadata that the VFS is
>> > not tracking, then that is what the ->sync_fs call is for. i.e. so
>> > the filesystem can then do what ever extra writeback/waiting it
>> > needs to do that the VFS is unaware of.
>> >
>> > We already cater for what Tux3 needs in the VFS - all you've done is
>> > found an inefficient algorithm that needs fixing.
>> 
>> write_cache_pages() is library function to be called from per-FS. So, it
>> is not under vfs control can be assume already. And it doesn't do right
>> things via write_cache_pages() for data=journal, because it handles for
>> each inodes, not at once. So, new dirty data can be inserted while
>> marking.
>
> Sure it can. But that newly dirtied data has occurred after the data
> integrity writeback call was begun, so it's not part of what the
> writeback code call needs to write back. We are quite entitled to
> ignore it for the purposes of a data integrity sync because it as
> dirtied *after* write_cache_pages() was asked to sync the range of
> the inode.
>
> IOWs, the VFS draws a line in the sand at a point in time when each
> inode is written for a data integrity sync. You have to do that
> somewhere, and there's little point in making that a global barrier
> when it is not necessary to do so.
>
> tux3 draws a different line in the sand, as does ext3/4
> data=journal.  In effect, tux3 and ext3/4 data=journal define a
> global point in time that everything is "in sync", and that's way
> above what is necessary for a sync(2) operation.  The VFS already
> has equivalent functionality - it's the state we force filesystems
> into when they are frozen. i.e. freezing a filesystem forces it down
> into a state where it is transactionally consistent on disk w.r.t
> both data and metadata.  sync(2) does not require these
> "transactionally consistent" semantics, so the VFS does not try to
> provide them.

It is what I'm calling the unnecessary wait.

> Anyway, this is a moot discussion. I've already got prototype code
> that fixes the wait_sb_inodes() problem as somebody is having
> problems with many concurrent executions of wait_sb_inodes() causing
> severe lock contention...

Sorry, but sounds like you are just saying "it doesn't need for me".

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
