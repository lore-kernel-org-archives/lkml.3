Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3FZXMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:12:23 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32637 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab3FZXMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:12:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQPACJ1y1F5LKwQ/2dsb2JhbABbgwmDF7c5hSkEAYEEF3SCIwEBBAE6HCMFCwgDGAklDwUlAyETiAgFuhUWjhiBHQeDAmEDl0SKH4cngyMq
Date: Thu, 27 Jun 2013 09:11:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130626231143.GC28426@dastard>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehbpntuk.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 05:45:23PM +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> On the following stress, sync(2) became top of cpu load.
> 
> 	fsstress -s 1 -n 50000 -p 3 -d `pwd`
> 
> After profile by perf, cpu load was lock contention of inode_sb_list_lock.
> 
> sync(2) is data integrity operation, so it has to make sure all dirty
> data was written before sync(2) point. The bdi flusher flushes current
> dirty data and wait those. But, if there is in-flight I/O before
> sync_inodes_sb(), sync_inodes_sb() can be done before prior in-flight I/O.
> 
> So, wait_sb_inodes() is walking the all inodes on sb to make sure
> in-flight I/O was done too. When it is walking inodes,
> inode_sb_list_lock is contending with other operations like
> create(2). This is the cause of cpu load.

Sure, but avoiding wait_sb_inodes() doesn't address the fast-path
lock contention inode_sb_list_lock has which is in the create and
evict paths. The problems caused by wait_sb_inodes() are background
noise compared to contention multiple CPUs can put on this lock just
walking large directory structures in parallel.  Hence hacking
around wait_sb_inodes() doesn't address the underlying lock
contention problem.

> On another view, wait_sb_inodes() would (arguably) be necessary for
> legacy FSes. But, for example, if data=journal on ext*, wait_sb_inodes()
> would be more than useless, because ext* can be done it by own
> transaction list (and more efficient way).
> 
> Likewise, on tux3, the state is same with data=journal.
> 
> Also, even if data=ordered, ext* might be able to check in-flight I/O by
> ordered data list (with some new additional check, I'm not sure).

Why would you bother solving this problem differently in every
single filesystem? It's solvable at the VFS by tracking inodes that
are no longer dirty but still under writeback on the BDI. Then
converting wait_sb_inodes() to walk all the dirty and writeback
inodes would be sufficient for data integrity purposes, and it would
be done under the bdi writeback lock, not the inode_sb_list_lock....

Alternatively, splitting up the inode sb list and lock (say via the
per-node list_lru structures in -mm and -next that are being added
for exactly this purpose) would also significantly reduce lock
contention on both the create/evict fast paths and the
wait_sb_inodes() walk that is currently done....

So I think that you should address the problem properly at the VFS
level so everyone benefits, not push interfaces that allow
filesystem specific hacks to work around VFS level deficiencies...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
