Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaCAXST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 18:18:19 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51913 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302AbaCAXSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 18:18:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As54AGRqElN5LJYePGdsb2JhbABagwaDQ4UMtAmFWYESFwMBAQEBHxkNKIIlAQEEAScTHCMFCwgDGAklDwUlAwcaE4dxB8tDFxaOQweEOASUUYNqilWLGCiBLiQ
Date: Sun, 2 Mar 2014 10:18:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs: possible deadlock between of->mutex and mmap_sem
Message-ID: <20140301231813.GP30131@dastard>
References: <53113485.2090407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53113485.2090407@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 08:14:45PM -0500, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on the following while fuzzing with trinity inside a
> KVM tools running the latest -next kernel.
> 
> We deal with files that have an mmap op by giving them a different
> locking class than the files which don't due to mmap_sem nesting
> being different for those files.
> 
> We assume that for mmap supporting files, of->mutex will be nested
> inside mm->mmap_sem. However, this is not always the case. Consider
> the following:
> 
> 	kernfs_fop_write()
> 		copy_from_user()
> 			might_fault()
> 
> might_fault() suggests that we may lock mm->mmap_sem, which causes a
> reverse lock nesting of mm->mmap_sem inside of of->mutex.

Yup, all filesystems have to deal with this. It's a long standing
problem caused by a very rarely seen corner case that drives us
completely batty because it prevents us from being able to serialise
filesystem IO operations against page fault driven IO...

> I'll send a patch to fix it some time next week unless someone beats me to it :)
> 
> 
> [ 1182.846501] ======================================================
> [ 1182.847256] [ INFO: possible circular locking dependency detected ]
> [ 1182.848111] 3.14.0-rc4-next-20140228-sasha-00011-g4077c67-dirty #26 Tainted: G        W
> [ 1182.849088] -------------------------------------------------------
> [ 1182.849927] trinity-c236/10658 is trying to acquire lock:
> [ 1182.850094]  (&of->mutex#2){+.+.+.}, at: [<fs/kernfs/file.c:487>] kernfs_fop_mmap+0x54/0x120
> [ 1182.850094]
> [ 1182.850094] but task is already holding lock:
> [ 1182.850094]  (&mm->mmap_sem){++++++}, at: [<mm/util.c:397>] vm_mmap_pgoff+0x6e/0xe0
> [ 1182.850094]
> [ 1182.850094] which lock already depends on the new lock.
> [ 1182.850094]
> [ 1182.850094]
> [ 1182.850094] the existing dependency chain (in reverse order) is:
> [ 1182.850094]
> -> #1 (&mm->mmap_sem){++++++}:
> [ 1182.856968]        [<kernel/locking/lockdep.c:1945
> kernel/locking/lockdep.c:2131>] validate_chain+0x6c5/0x7b0
> [ 1182.856968]        [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4cd/0x5a0
> [ 1182.856968]        [<arch/x86/include/asm/current.h:14
> kernel/locking/lockdep.c:3602>] lock_acquire+0x182/0x1d0
> [ 1182.856968]        [<mm/memory.c:4188>] might_fault+0x7e/0xb0
> [ 1182.860975]        [<arch/x86/include/asm/uaccess.h:713
> fs/kernfs/file.c:291>] kernfs_fop_write+0xd8/0x190
> [ 1182.860975]        [<fs/read_write.c:473>] vfs_write+0xe3/0x1d0
> [ 1182.860975]        [<fs/read_write.c:523 fs/read_write.c:515>] SyS_write+0x5d/0xa0
> [ 1182.860975]        [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2

Those stack traces are an unreadable mess.  If you're going to add
extra metadata to the stack, please put it *after* the
stack functions so the stack itself is easy to read.

i.e. the stack trace is far more important than line numbers, so the
stack itself should be optimised for readability. IOWs, the stack
functions go first and are neatly aligned, everything else can make
a mess after that....

Oh, and when pasting stack traces - turn off line wrapping ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
