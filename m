Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3F0FSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:18:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47703 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3F0FSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:18:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard> <87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard>
Date: Thu, 27 Jun 2013 14:18:17 +0900
In-Reply-To: <20130627044705.GB29790@dastard> (Dave Chinner's message of "Thu,
	27 Jun 2013 14:47:05 +1000")
Message-ID: <87y59w5dye.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> Optimizing wait_sb_inodes() might help lock contention, but it doesn't
>> help unnecessary wait/check.
>
> You have your own wait code, that doesn't make what the VFS does
> unnecesary. Quite frankly, I don't trust individual filesystems to
> get it right - there's a long history of filesystem specific data
> sync problems (including in XFS), and the best way to avoid that is
> to ensure the VFS gets it right for you.
>
> Indeed, we've gone from having sooper special secret sauce data sync
> code in XFS to using the VFS over the past few years, and the result
> is that it is now more reliable and faster than when we were trying
> to be smart and do it all ourselves. We got to where we are by
> fixing the problems in the VFS rather than continuing to try to work
> around them.

I guess you are assuming FS which is using data=writeback or such.

>> Since some FSes know about current
>> in-flight I/O already in those internal, so I think, those FSes can be
>> done it here, or are already doing in ->sync_fs().
>
> Sure, do your internal checks in ->sync_fs(), but if
> wait_sb_inodes() does not have any lock contention and very little
> overhead, then why do you need to avoid it? This wait has to be done
> somewhere between sync_inodes_sb() dispatching all the IO and
> ->sync_fs completing, so what's the problem with hving the VFS do
> that *for everyone* efficiently?

Are you saying the vfs should track all in-flight I/O with some sort of
transactional way?

Otherwise, vfs can't know the data is whether after sync point or before
sync point, and have to wait or not. FS is using the behavior like
data=journal has tracking of those already, and can reuse it.

> Fix the root cause of the problem - the sub-optimal VFS code.
> Hacking around it specifically for out-of-tree code is not the way
> things get done around here...

I'm thinking the root cause is vfs can't have knowledge of FS internal,
e.g. FS is handling data transactional way, or not.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
