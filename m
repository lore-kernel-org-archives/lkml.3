Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3JJDP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:15:28 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52482 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab3JJDPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:15:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkIAGAaVlJ5LFuj/2dsb2JhbABagweDSrkahT+BHBd0giUBAQQBJxMcIwULCAMYCSUPBSUDIROIAAW5ThaPLweEIwOYApICgWaBUig
Date: Thu, 10 Oct 2013 14:15:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
 pointer dereference at 00000003
Message-ID: <20131010031515.GT4446@dastard>
References: <20131009073910.GA387@localhost>
 <20131010005900.GE2025@devil.localdomain>
 <20131010011640.GA5726@localhost>
 <20131010014117.GA6017@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010014117.GA6017@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:41:17AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 09:16:40AM +0800, Fengguang Wu wrote:
> > On Thu, Oct 10, 2013 at 11:59:00AM +1100, Dave Chinner wrote:
> > > [add xfs@oss.sgi.com to cc]
> > 
> > Thanks.
> > 
> > To help debug the problem, I searched XFS in my tests' oops database
> > and find one kernel that failed 4 times (out of 12 total boots) with
> > basically the same error:
> > 
> >       4 BUG: sleeping function called from invalid context at kernel/workqueue.c:2810
> >       1 WARNING: CPU: 1 PID: 372 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> >       1 WARNING: CPU: 1 PID: 360 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> >       1 WARNING: CPU: 0 PID: 381 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> >       1 WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> 

Fenguang, I'll having real trouble associating these with the XFS
code path that is seeing the problems. These look like a use after
free or a double free, but that isn't possible in the XFS code paths
that are showing up in the traces.

> And some other messages in an older kernel:
> 
> [   39.004416] F2FS-fs (nbd2): unable to read second superblock
> [   39.005088] XFS: Assertion failed: read && bp->b_ops, file: fs/xfs/xfs_buf.c, line: 1036

This can not possibily occur on the superblock read path, as
bp->b_ops in that case is *always* initialised, as is XBF_READ.

So this implies something else has modified the struct xfs_buf.

> [   41.550471] ------------[ cut here ]------------
> [   41.550476] WARNING: CPU: 1 PID: 878 at lib/list_debug.c:33 __list_add+0xac/0xc0()
> [   41.550478] list_add corruption. prev->next should be next (ffff88000f3d7360), but was           (null). (prev=ffff880008786a30).

And this is a smoking gun - list corruption...

> [   41.550481] CPU: 1 PID: 878 Comm: mount Not tainted 3.11.0-rc1-00667-gf70eb07 #64
> [   41.550482] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   41.550485]  0000000000000009 ffff880007d6fb08 ffffffff824044a1 ffff880007d6fb50
> [   41.550488]  ffff880007d6fb40 ffffffff8109a0a8 ffff880007c6b530 ffff88000f3d7360
> [   41.550491]  ffff880008786a30 0000000000000007 0000000000000000 ffff880007d6fba0
> [   41.550491] Call Trace:
> [   41.550499]  [<ffffffff824044a1>] dump_stack+0x4e/0x82
> [   41.550503]  [<ffffffff8109a0a8>] warn_slowpath_common+0x78/0xa0
> [   41.550505]  [<ffffffff8109a14c>] warn_slowpath_fmt+0x4c/0x50
> [   41.550509]  [<ffffffff81101359>] ? get_lock_stats+0x19/0x60
> [   41.550511]  [<ffffffff8163434c>] __list_add+0xac/0xc0
> [   41.550515]  [<ffffffff810ba453>] insert_work+0x43/0xa0
> [   41.550518]  [<ffffffff810bb22b>] __queue_work+0x11b/0x510
> [   41.550520]  [<ffffffff810bb936>] queue_work_on+0x96/0xa0
> [   41.550526]  [<ffffffff813d2096>] ? _xfs_buf_ioend.constprop.15+0x26/0x30
> [   41.550529]  [<ffffffff813d1f6c>] xfs_buf_ioend+0x15c/0x260

... in the workqueue code on a work item in the the struct xfs_buf .....

> [   41.550531]  [<ffffffff813d2f92>] ? xfsbdstrat+0x22/0x170
> [   41.550534]  [<ffffffff813d2096>] _xfs_buf_ioend.constprop.15+0x26/0x30
> [   41.550537]  [<ffffffff813d2873>] xfs_buf_iorequest+0x73/0x1a0
> [   41.550539]  [<ffffffff813d2f92>] xfsbdstrat+0x22/0x170
> [   41.550542]  [<ffffffff813d3832>] xfs_buf_read_uncached+0x72/0xa0
> [   41.550546]  [<ffffffff81445846>] xfs_readsb+0x176/0x250

... in the very context that we allocated the struct xfs_buf. It's
not a use after free or memory corruption caused by XFS you are
seeing here.

I note that you have CONFIG_SLUB=y, which means that the cache slabs
are shared with objects of other types. That means that the memory
corruption problem is likely to be caused by one of the other
filesystems that is probing the block device(s), not XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
