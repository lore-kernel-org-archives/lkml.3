Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaFBUHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:07:31 -0400
Received: from mail.phunq.net ([184.71.0.62]:57835 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaFBUH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:07:28 -0400
Message-ID: <538CD97E.8020201@phunq.net>
Date: Mon, 02 Jun 2014 13:07:26 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 2/2] tux3: Use writeback hook to remove duplicated
 core code
References: <538B9DEE.20800@phunq.net> <538B9E58.4000108@phunq.net> <20140602033047.GT14410@dastard>
In-Reply-To: <20140602033047.GT14410@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/01/2014 08:30 PM, Dave Chinner wrote:
> I get very worried whenever I see locks inside inode->i_lock. In
> general, i_lock is supposed to be the innermost lock that is taken,
> and there are very few exceptions to that - the inode LRU list is
> one of the few.

I generally trust Hirofumi to ensure that our locking is sane, but please point out any specific
issue. We are well aware of the need to get out of our critical section fast, as is apparent in
tux3_clear_dirty_inode_nolock. Hogging our own i_locks would mainly hurt our own benchmarks.

For what it is worth, the proposed writeback API improves our SMP situation with respect to other
filesystems by moving tux3_clear_dirty_inode_nolock outside the wb list lock.

> I don't know what the tuxnode->lock is, but I found this:
>
>  *     inode->i_lock
>  *         tuxnode->lock (to protect tuxnode data)
>  *             tuxnode->dirty_inodes_lock (for i_ddc->dirty_inodes,
>  *                                         Note: timestamp can be updated
>  *                                         outside inode->i_mutex)
>
> and this:
>
>  *     inode->i_lock
>  *         tuxnode->lock
>  *         sb->dirty_inodes_lock
>
> Which indicates that you take a filesystem global lock a couple of
> layers underneath the VFS per-inode i_lock. I'd suggest you want to
> separate the use of the vfs inode ilock from the locking heirarchy
> of the tux3 inode....
>

Our nested locks synchronize VFS state with Tux3 state, which is not optional. Alternatively, we
could rely on i_lock alone, which would increase contention.

The sb->dirty_inodes_lock is held briefly, which you can see in tux3_dirty_inode and
tux3_clear_dirty_inode_nolock. If it shows up in a profile we could break it up.

Regards,

Daniel
