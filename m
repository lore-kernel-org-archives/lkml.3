Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaAXC3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:29:20 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51255 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaAXC3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:29:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugJAIHP4VJ5LGaB/2dsb2JhbABagwyDOrQ5hVCBCxd0giUBAQEDAScTHCMFCwgDDgoJJQ8FJQMhE4d9B8cqFxaNf2sHhDgElD2DZZIZg0Eo
Date: Fri, 24 Jan 2014 13:29:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ben Myers <bpm@sgi.com>, sandeen@redhat.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: XFS lockdep spew with v3.13-4156-g90804ed
Message-ID: <20140124022903.GK27606@dastard>
References: <20140124015855.GM16455@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124015855.GM16455@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:58:56PM -0500, Josh Boyer wrote:
> Hi All,
> 
> I'm hitting an XFS lockdep error with Linus' tree today after the XFS
> merge.  I wasn't hitting this with v3.13-3995-g0dc3fd0, which seems
> to backup the "before XFS merge" claim.  Full text below:

Ugh. mmap_sem/inode lock order stupidity.

Looks like a false positive. Basically, it's complaining that a page
fault can occur in getdents() syscall on a user buffer while the
directory IO lock is held, and then complaining that a this is the
opposite lock order for a 
> 
> 
> [  132.638044] ======================================================
> [  132.638045] [ INFO: possible circular locking dependency detected ]
> [  132.638047] 3.14.0-0.rc0.git7.1.fc21.x86_64 #1 Not tainted
> [  132.638048] -------------------------------------------------------
> [  132.638049] gnome-session/1432 is trying to acquire lock:
> [  132.638050]  (&mm->mmap_sem){++++++}, at: [<ffffffff811b846f>] might_fault+0x
> 5f/0xb0
> [  132.638055] 
> but task is already holding lock:
> [  132.638056]  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa05b3c12>] xfs_
> ilock+0xf2/0x1c0 [xfs]
> [  132.638076] 
> which lock already depends on the new lock.
> 
> [  132.638077] 
> the existing dependency chain (in reverse order) is:
> [  132.638078] 
> -> #1 (&(&ip->i_lock)->mr_lock){++++..}:
> [  132.638080]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
> [  132.638083]        [<ffffffff8178312e>] _raw_spin_lock+0x3e/0x80
> [  132.638085]        [<ffffffff8123c579>] __mark_inode_dirty+0x119/0x440
> [  132.638088]        [<ffffffff812447fc>] __set_page_dirty+0x6c/0xc0
> [  132.638090]        [<ffffffff812477e1>] mark_buffer_dirty+0x61/0x180
> [  132.638092]        [<ffffffff81247a31>] __block_commit_write.isra.21+0x81/0xb0
> [  132.638094]        [<ffffffff81247be6>] block_write_end+0x36/0x70
> [  132.638096]        [<ffffffff81247c48>] generic_write_end+0x28/0x90
> [  132.638097]        [<ffffffffa0554cab>] xfs_vm_write_end+0x2b/0x70 [xfs]
> [  132.638104]        [<ffffffff8118c4f6>] generic_file_buffered_write+0x156/0x260
> [  132.638107]        [<ffffffffa05651d7>] xfs_file_buffered_aio_write+0x107/0x250 [xfs]
> [  132.638115]        [<ffffffffa05653eb>] xfs_file_aio_write+0xcb/0x130 [xfs]
> [  132.638122]        [<ffffffff8120af8a>] do_sync_write+0x5a/0x90
> [  132.638125]        [<ffffffff8120b74d>] vfs_write+0xbd/0x1f0
> [  132.638126]        [<ffffffff8120c15c>] SyS_write+0x4c/0xa0
> [  132.638128]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b

Sorry, what? That trace is taking the ip->i_vnode->i_lock
*spinlock*, not the ip->i_lock *rwsem*. And it's most definitely not
currently holding the ip->i_lock rwsem here. I think lockdep has
dumped the wrong stack trace here, because it most certainly doesn't
match the unsafe locking scenario that has been detected.

> [  132.638130] 
> -> #0 (&mm->mmap_sem){++++++}:
> [  132.638132]        [<ffffffff810de0fc>] __lock_acquire+0x18ec/0x1aa0
> [  132.638133]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
> [  132.638135]        [<ffffffff811b849c>] might_fault+0x8c/0xb0
> [  132.638136]        [<ffffffff81220a91>] filldir+0x91/0x120
> [  132.638138]        [<ffffffffa0560f7f>] xfs_dir2_sf_getdents+0x23f/0x2a0 [xfs]
> [  132.638146]        [<ffffffffa05613fb>] xfs_readdir+0x16b/0x1d0 [xfs]
> [  132.638154]        [<ffffffffa056383b>] xfs_file_readdir+0x2b/0x40 [xfs]
> [  132.638161]        [<ffffffff812208d8>] iterate_dir+0xa8/0xe0
> [  132.638163]        [<ffffffff81220d83>] SyS_getdents+0x93/0x120
> [  132.638165]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
> [  132.638166] 

Ok, that's in the path where we added the ip->i_lock rwsem being held
in read mode.

> other info that might help us debug this:
> [  132.638167]  Possible unsafe locking scenario:
> 
> [  132.638168]        CPU0                    CPU1
> [  132.638169]        ----                    ----
> [  132.638169]   lock(&(&ip->i_lock)->mr_lock);
> [  132.638171]                                lock(&mm->mmap_sem);
> [  132.638172]                                lock(&(&ip->i_lock)->mr_lock);
> [  132.638173]   lock(&mm->mmap_sem);

You can't mmap directories, and so the page fault lock order being
shown for CPU1 can't happen on a directory. False positive.

*sigh*

More complexity in setting up inode lock order instances is required
so that lockdep doesn't confuse the lock ordering semantics of
directories with regular files. As if that code to make lockdep
happy wasn't complex enough already....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
