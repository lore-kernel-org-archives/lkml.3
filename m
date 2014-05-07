Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaEGPlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:41:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaEGPlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:41:46 -0400
Date: Wed, 7 May 2014 17:41:44 +0200
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: blktrace: NULL ptr deref in sysfs_blk_trace_attr_store
Message-ID: <20140507154144.GE12433@quack.suse.cz>
References: <53699E3F.4020105@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53699E3F.4020105@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 06-05-14 22:45:19, Sasha Levin wrote:
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 6230.740626] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 6230.740626] IP: __list_del_entry (lib/list_debug.c:57)
> [ 6230.740626] PGD 44d661067 PUD 44d660067 PMD 0
> [ 6230.740626] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 6230.740626] Dumping ftrace buffer:
> [ 6230.740626]    (ftrace buffer empty)
> [ 6230.740626] Modules linked in:
> [ 6230.740626] CPU: 2 PID: 23998 Comm: trinity-c257 Not tainted 3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
> [ 6230.740626] task: ffff8804716db000 ti: ffff88044ca9e000 task.ti: ffff88044ca9e000
> [ 6230.740626] RIP: __list_del_entry (lib/list_debug.c:57)
> [ 6230.740626] RSP: 0018:ffff88044ca9fdd8  EFLAGS: 00010007
> [ 6230.740626] RAX: 0000000000000000 RBX: ffff88005a455948 RCX: dead000000200200
> [ 6230.740626] RDX: 0000000000000000 RSI: ffffffff938fdf78 RDI: ffff88005a455948
> [ 6230.740626] RBP: ffff88044ca9fdd8 R08: 0000000000000001 R09: ffff8804716dbdd0
> [ 6230.740626] R10: ffff8804716db000 R11: 0000000000000000 R12: 00000000000007f5
> [ 6230.740626] R13: ffff88017b880000 R14: ffff88005a4558f0 R15: ffff88036a188758
> [ 6230.740626] FS:  00007fec10273700(0000) GS:ffff8800a6c00000(0000) knlGS:0000000000000000
> [ 6230.740626] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6230.740626] CR2: 0000000000000000 CR3: 000000044d662000 CR4: 00000000000006a0
> [ 6230.740626] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6230.740626] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 6230.740626] Stack:
> [ 6230.740626]  ffff88044ca9fdf8 ffffffff8fb40441 ffff88036a188740 ffff88036a188740
> [ 6230.740626]  ffff88044ca9fe68 ffffffff8f25d75d 0000000000000000 ffff8804716db000
> [ 6230.740626]  0000000000000286 ffff880333f61330 0000000000000000 0000000000000286
> [ 6230.740626] Call Trace:
> [ 6230.740626] list_del (lib/list_debug.c:78)
> [ 6230.740626] sysfs_blk_trace_attr_store (include/linux/spinlock.h:353 kernel/trace/blktrace.c:1498 kernel/trace/blktrace.c:1740)
> [ 6230.740626] dev_attr_store (drivers/base/core.c:138)
> [ 6230.740626] sysfs_kf_write (fs/sysfs/file.c:114)
> [ 6230.740626] kernfs_fop_write (fs/kernfs/file.c:295)
> [ 6230.740626] vfs_write (fs/read_write.c:532)
> [ 6230.740626] SyS_write (fs/read_write.c:584 fs/read_write.c:576)
> [ 6230.740626] ia32_do_call (arch/x86/ia32/ia32entry.S:430)
> [ 6230.740626] Code: 7d 93 be 3e 00 00 00 48 c7 c7 d2 46 7d 93 31 c0 e8 6f fb 61 ff eb 2c 0f 1f 44 00 00 48 b9 00 02 20 00 00 00 ad de 48 39 c8 74 8c <4c> 8b 00 4c 39 c7 75 a6 4c 8b 42 08 4c 39 c7 75 bc 48 89 42 08
> [ 6230.740626] RIP __list_del_entry (lib/list_debug.c:57)
> [ 6230.740626]  RSP <ffff88044ca9fdd8>
> [ 6230.740626] CR2: 0000000000000000
  Hum, interesting. So it seems that blk_trace_remove_queue() got struct
blk_trace which isn't healthy - list_head has been zeroed out and since
this is the first thing we touch in the structure we don't really know what
else is in there. But I don't see how such structure could get there since
all places that modify q->blk_trace seem to hold bdev->bd_mutex.

OTOH the code in blk_trace_setup_queue() does:
        old_bt = xchg(&q->blk_trace, bt);
        if (old_bt != NULL) {
                (void)xchg(&q->blk_trace, old_bt);
                ret = -EBUSY;
                goto free_bt;
        }

Which looks somewhat strange if modifications of q->blk_trace are really
guarded by bd_mutex. Jens?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
