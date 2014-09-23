Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaIWNdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:33:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:48228 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaIWNdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:33:15 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: WARNING at fs/nfs/write.c:743 nfs_inode_remove_request with -rc6
From: Weston Andros Adamson <dros@primarydata.com>
In-Reply-To: <20140923130352.GK26472@arm.com>
Date: Tue, 23 Sep 2014 09:33:06 -0400
Cc: Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs list <linux-nfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2A327753-3E60-46AC-8220-3FF0FF61F08F@primarydata.com>
References: <20140923130352.GK26472@arm.com>
To: Will Deacon <will.deacon@arm.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 23, 2014, at 9:03 AM, Will Deacon <will.deacon@arm.com> wrote:

> Hi all,
> 
> I've been running into the following warning on an arm64 system running
> 3.17-rc6 with 64k pages. I've been unable to reproduce with a smaller page
> size (4k).
> 
> I don't yet have a concrete reproducer, but I've seen it hit a few times
> today just running a machine with an NFS root filesystem and using ssh.
> The warning seems to happen in parallel on the two CPUs, but I'm pretty
> confident that our test_and_clear_bit implementation has the relevant
> atomic instructions and memory barriers.
> 
> Any ideas?
> 
> Will

So it looks like we’re either calling nfs_inode_remove_request twice on a request,
or somehow not grabbing the inode reference for some request that is in the async
write path. It’s interesting that these come in pairs - that has to mean something!

Any more info on how to reproduce this would be really great. Unfortunately I don’t
have access to an arm64 system.

If it’s possible, could we get a packet trace around when this happens? This is pure
speculation, but this might have something to do the resend path - a commit fails
and all the requests on the commit list have to be resent.

Have you noticed any side effects from this? That WARN_ON_ONCE was added
to sanity test the new page group code and we need to fix this, but I’m wondering
if anything “bad” happens…

-dros

> 
> --->8
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1023 at fs/nfs/write.c:743 nfs_inode_remove_request+0xe4/0xf0()
> Modules linked in:
> CPU: 1 PID: 1023 Comm: kworker/1:2 Not tainted 3.17.0-rc6 #1
> Workqueue: nfsiod rpc_async_release
> Call trace:
> [<fffffe0000096410>] dump_backtrace+0x0/0x130
> [<fffffe0000096550>] show_stack+0x10/0x1c
> [<fffffe00004cda94>] dump_stack+0x74/0xbc
> [<fffffe00000b4d20>] warn_slowpath_common+0x8c/0xb4
> [<fffffe00000b4e0c>] warn_slowpath_null+0x14/0x20
> [<fffffe000027a6a8>] nfs_inode_remove_request+0xe0/0xf0
> [<fffffe000027b704>] nfs_write_completion+0xb4/0x150
> [<fffffe0000276ef4>] nfs_pgio_release+0x34/0x44
> [<fffffe00004ac2d0>] rpc_free_task+0x24/0x4c
> [<fffffe00004ac5c0>] rpc_async_release+0xc/0x18
> [<fffffe00000c89e8>] process_one_work+0x140/0x32c
> [<fffffe00000c9338>] worker_thread+0x13c/0x470
> [<fffffe00000cd9e4>] kthread+0xd0/0xe8
> ---[ end trace 6f044efb83f0811b ]---
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 621 at fs/nfs/write.c:743 nfs_inode_remove_request+0xe4/0xf0()
> CPU: 0 PID: 621 Comm: kworker/0:2 Tainted: G        W      3.17.0-rc6 #1
> Workqueue: nfsiod rpc_async_release
> Call trace:
> [<fffffe0000096410>] dump_backtrace+0x0/0x130
> [<fffffe0000096550>] show_stack+0x10/0x1c
> [<fffffe00004cda94>] dump_stack+0x74/0xbc
> [<fffffe00000b4d20>] warn_slowpath_common+0x8c/0xb4
> [<fffffe00000b4e0c>] warn_slowpath_null+0x14/0x20
> [<fffffe000027a6a8>] nfs_inode_remove_request+0xe0/0xf0
> [<fffffe000027b704>] nfs_write_completion+0xb4/0x150
> [<fffffe0000276ef4>] nfs_pgio_release+0x34/0x44
> [<fffffe00004ac2d0>] rpc_free_task+0x24/0x4c
> [<fffffe00004ac5c0>] rpc_async_release+0xc/0x18
> [<fffffe00000c89e8>] process_one_work+0x140/0x32c
> [<fffffe00000c9338>] worker_thread+0x13c/0x470
> [<fffffe00000cd9e4>] kthread+0xd0/0xe8
> ---[ end trace 6f044efb83f0811c ]---

