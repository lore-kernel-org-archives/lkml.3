Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3KEWwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:52:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58007 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3KEWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:52:33 -0500
Date: Tue, 5 Nov 2013 14:52:29 -0800
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Cristian Gafton <gafton@amazon.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.13
Message-ID: <20131105225229.GB21473@u109add4315675089e695.ant.amazon.com>
References: <20131105165908.GA405@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105165908.GA405@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:59:08AM -0500, Konrad Rzeszutek Wilk wrote:
> 
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.13
> 
> 
> which has a fix to the Xen block frontend driver. For the backends that
> don't support persistent grants, we don't want to use the logic that would
> use copying (needed for persistent grants). That logic existed there initially
> but with the persistent grants code added in - it was removed (so in 3.10
> time-frame). This adds part of it back.

I just tested this patch as part of a backported series on top of a
3.4.68 base. When this patch is included and a domU boots on a system
that does not support persistent grants the kernel panics on boot with
the trace below. Full boot log: http://paste.ubuntu.com/6367329/

It's possible we missed something in the backport series. I'll test
this patch on top of 3.11.4 to see how it fares.

 general protection fault: 0000 [#1] SMP 
 CPU 14 
 Modules linked in: aesni_intel cryptd aes_x86_64 aes_generic dm_mirror dm_region_hash dm_log dm_mod
 
 Pid: 2192, comm: blkid Not tainted 3.4.68-3.8.amzn1.x86_64 #1 Xen HVM domU
 RIP: 0010:[<ffffffff812dda71>]  [<ffffffff812dda71>] get_grant+0x51/0x110
 RSP: 0018:ffff881d07b5d978  EFLAGS: 00010006
 RAX: 025c68fd93b116ed RBX: ffff880e72fc6b50 RCX: 0000000000000000
 RDX: 1e8134cf7b38b76c RSI: 0000000001d1a05f RDI: ffff881d07b5da64
 RBP: ffff881d07b5d998 R08: e200000000000000 R09: dead000000100100
 R10: dead000000200200 R11: ffff8b9207578571 R12: 0000000001d1a05f
 R13: ffff880e72efc000 R14: ffff881d07b5da64 R15: ffff881d1822b0b0
 FS:  00007fe197073760(0000) GS:ffff881d5bcc0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fe196c4a3b0 CR3: 0000001d079c6000 CR4: 00000000000407e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process blkid (pid: 2192, threadinfo ffff881d07b5c000, task ffff881d07ae1690)
 Stack:
  0000000000000246 ffff880e72963400 0000000000000000 ffff881d1822b0b0
  ffff881d07b5da98 ffffffff812ddf60 0000000000000001 0000000000002000
  00ff881d07b5d9e8 ffff881d07b5dfd8 ffff881d1822b000 ffff880e72d560b0
 Call Trace:
  [<ffffffff812ddf60>] do_blkif_request+0x410/0x7c0
  [<ffffffff811882b7>] ? submit_bh+0xf7/0x120
  [<ffffffff81212026>] queue_unplugged+0x56/0xf0
  [<ffffffff81216573>] blk_flush_plug_list+0x1c3/0x220
  [<ffffffff812165e8>] blk_finish_plug+0x18/0x50
  [<ffffffff8110ec11>] __do_page_cache_readahead+0x1c1/0x250
  [<ffffffff8110efb1>] force_page_cache_readahead+0x71/0xa0
  [<ffffffff8110f333>] page_cache_sync_readahead+0x43/0x50
  [<ffffffff81104f58>] generic_file_aio_read+0x4d8/0x760
  [<ffffffff811673e0>] ? do_last+0x470/0x8c0
  [<ffffffff8118ed98>] blkdev_aio_read+0x58/0x80
  [<ffffffff81158e1a>] do_sync_read+0xda/0x120
  [<ffffffff811e22f3>] ? security_file_permission+0x93/0xb0
  [<ffffffff811592a1>] ? rw_verify_area+0x61/0xf0
  [<ffffffff81159780>] vfs_read+0xb0/0x180
  [<ffffffff8115989a>] sys_read+0x4a/0x90
  [<ffffffff813f0979>] system_call_fastpath+0x16/0x1b
 Code: 48 8d 82 b0 12 00 00 48 39 c3 0f 84 ca 00 00 00 49 b9 00 01 10 00 00 00 ad de 48 8b 13 49 ba 00 02 20 00 00 00 ad de 48 8b 43 08 <48> 89 42 08 48 89 10 44 8b 5b f0 4c 89 0b 4c 89 53 08 45 85 db 
 RIP  [<ffffffff812dda71>] get_grant+0x51/0x110
  RSP <ffff881d07b5d978>
 ---[ end trace 3eba56aed2b98597 ]---

--msw

> Please pull!
> 
> P.S.
> Sorry for the late pull!
> 
>  drivers/block/xen-blkfront.c | 125 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 100 insertions(+), 25 deletions(-)
> 
> Roger Pau Monne (1):
>       xen-blkfront: restore the non-persistent data path
> 


