Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbbAJBUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbbAJBUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:20:44 -0500
Date: Sat, 10 Jan 2015 09:20:36 +0800
From: Fam Zheng <famz@redhat.com>
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Eduardo Otubo <eduardo.otubo@profitbricks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: blk-mq v3.18: Oops during virtio_blk hot-unplug
Message-ID: <20150110012036.GC8570@fam-t430.nay.redhat.com>
References: <54AFE664.6010002@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFE664.6010002@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01/09 15:32, Sebastian Parschauer wrote:
> Hi Jens,
> 
> my colleague Eduardo is sporadically seeing an Oops in blk-mq while
> running continuous virtio_blk hot-plug/hot-unplug tests with I/O to the
> device within an x86_64 QEMU/KVM 2.0 Debian Wheezy VM.
> 
> Please find the call trace attached and the full log here:
> http://paste.ubuntu.com/9691873/
> 
> The kernel image has been taken from here and is the mainline kernel
> from tag v3.18:
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18-vivid/
> 
> Is there still an issue with block queue freezing?

This one?

commit 45a9c9d909b24c6ad0e28a7946e7486e73010319
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Tue Dec 9 16:57:48 2014 +0100

    blk-mq: Fix a use-after-free

Fam

> 
> We are seeing a similar issue with v3.16 but more often as some block
> queue freezing fixes have been added in v3.17.
> 
> All kernels without blk-mq used by virtio_blk (< v3.13) work fine.
> 
> Cheers,
> Sebastian

> [  165.630508] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  165.631027] IP: [<ffffffff817b1035>] __mutex_lock_slowpath+0x75/0x100
> [  165.631219] PGD 368a2067 PUD 797d3067 PMD 0 
> [  165.631454] Oops: 0002 [#1] SMP 
> [  165.631632] Modules linked in: parport_pc 8250_fintek pvpanic parport snd_pcm snd_timer snd soundcore i2c_piix4 joydev pcspkr psmouse serio_raw evbug mac_hid hid_generic usbhid hid floppy
> [  165.632010] CPU: 0 PID: 22838 Comm: dd Not tainted 3.18.0-031800-generic #201412071935
> [  165.632010] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [  165.633045] task: ffff8800685b6400 ti: ffff88007afc0000 task.ti: ffff88007afc0000
> [  165.633045] RIP: 0010:[<ffffffff817b1035>]  [<ffffffff817b1035>] __mutex_lock_slowpath+0x75/0x100
> [  165.633045] RSP: 0018:ffff88007afc3c38  EFLAGS: 00010297
> [  165.633045] RAX: 0000000000000000 RBX: ffff880036b1fa08 RCX: 00000000c0000100
> [  165.633045] RDX: ffff88007afc3c40 RSI: ffff8800685b6400 RDI: ffff880036b1fa0c
> [  165.633045] RBP: ffff88007afc3c88 R08: ffff88007afc0000 R09: 0000000000000000
> [  165.633045] R10: 0000000000000001 R11: 0000000000000246 R12: ffff8800685b6400
> [  165.633045] R13: ffff880036b1fa0c R14: 00000000ffffffff R15: ffff880036b1fa10
> [  165.633045] FS:  00007fce39352700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
> [  165.633045] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  165.633045] CR2: 0000000000000000 CR3: 000000007ae5b000 CR4: 00000000000406f0
> [  165.633045] Stack:
> [  165.633045]  ffff880036d552d8 ffff880036b1fa10 0000000000000000 ffff88007b5cf0c0
> [  165.633045]  ffff88007afc3c98 ffff880036b1fa08 ffff880036d552d8 ffff880036b1f9d0
> [  165.633045]  ffff8800795f3000 ffff88007b5cf0c0 ffff88007afc3ca8 ffffffff817b10e3
> [  165.633045] Call Trace:
> [  165.633045]  [<ffffffff817b10e3>] mutex_lock+0x23/0x37
> [  165.633045]  [<ffffffff81379706>] blk_mq_free_queue+0x26/0x1a0
> [  165.633045]  [<ffffffff8136fe22>] blk_release_queue+0xa2/0x100
> [  165.633045]  [<ffffffff8139f8a2>] kobject_cleanup+0x82/0x1c0
> [  165.633045]  [<ffffffff8139f730>] kobject_put+0x30/0x70
> [  165.633045]  [<ffffffff81369495>] blk_put_queue+0x15/0x20
> [  165.633045]  [<ffffffff8137e033>] disk_release+0x93/0xd0
> [  165.633045]  [<ffffffff814d27de>] device_release+0x3e/0xc0
> [  165.633045]  [<ffffffff8139f8a2>] kobject_cleanup+0x82/0x1c0
> [  165.633045]  [<ffffffff8139f730>] kobject_put+0x30/0x70
> [  165.633045]  [<ffffffff8137c797>] put_disk+0x17/0x20
> [  165.633045]  [<ffffffff812278a5>] __blkdev_put+0x125/0x1b0
> [  165.633045]  [<ffffffff8122798b>] blkdev_put+0x5b/0x160
> [  165.633045]  [<ffffffff81227ab5>] blkdev_close+0x25/0x30
> [  165.633045]  [<ffffffff811f129d>] __fput+0xbd/0x250
> [  165.633045]  [<ffffffff811f147e>] ____fput+0xe/0x10
> [  165.633045]  [<ffffffff81091bc7>] task_work_run+0xa7/0xe0
> [  165.633045]  [<ffffffff81014077>] do_notify_resume+0xc7/0xd0
> [  165.633045]  [<ffffffff817b354f>] int_signal+0x12/0x17
> [  165.633045] Code: 00 00 8b 03 83 f8 01 0f 84 99 00 00 00 48 8b 43 10 48 8d 55 b8 4c 8d 7b 08 41 be ff ff ff ff 48 89 53 10 4c 89 7d b8 48 89 45 c0 <48> 89 10 4c 89 65 c8 eb 1f 66 90 4c 89 ef 49 c7 04 24 02 00 00 
> [  165.633045] RIP  [<ffffffff817b1035>] __mutex_lock_slowpath+0x75/0x100
> [  165.633045]  RSP <ffff88007afc3c38>
> [  165.633045] CR2: 0000000000000000

