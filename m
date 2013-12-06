Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab3LFQR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:17:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3LFQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:17:56 -0500
Date: Fri, 6 Dec 2013 09:17:48 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix memory leaks on unplugging block device
Message-ID: <20131206161748.GB5051@kernel.dk>
References: <1386306401-17405-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386306401-17405-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06 2013, Andrey Vagin wrote:
> All objects, which are allocated in blk_mq_register_disk, must be
> released in blk_mq_unregister_disk.
> 
> I use a KVM virtual machine and virtio disk to reproduce this issue.
> 
> kmemleak: 18 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> $ cat /sys/kernel/debug/kmemleak | head -n 30
> unreferenced object 0xffff8800b6636150 (size 8):
>   comm "kworker/0:2", pid 65, jiffies 4294809903 (age 86.358s)
>   hex dump (first 8 bytes):
>     76 69 72 74 69 6f 34 00                          virtio4.
>   backtrace:
>     [<ffffffff8165d41e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff8118cfc5>] __kmalloc_track_caller+0xf5/0x260
>     [<ffffffff81155b11>] kstrdup+0x31/0x60
>     [<ffffffff812242be>] sysfs_new_dirent+0x2e/0x140
>     [<ffffffff81224678>] create_dir+0x38/0xe0
>     [<ffffffff812249e3>] sysfs_create_dir_ns+0x73/0xc0
>     [<ffffffff8130dfa9>] kobject_add_internal+0xc9/0x340
>     [<ffffffff8130e535>] kobject_add+0x65/0xb0
>     [<ffffffff813f34f8>] device_add+0x128/0x660
>     [<ffffffff813f3a4a>] device_register+0x1a/0x20
>     [<ffffffff813ae6f8>] register_virtio_device+0x98/0xe0
>     [<ffffffff813b0cce>] virtio_pci_probe+0x12e/0x1c0
>     [<ffffffff81340675>] local_pci_probe+0x45/0xa0
>     [<ffffffff81341a51>] pci_device_probe+0x121/0x130
>     [<ffffffff813f67f7>] driver_probe_device+0x87/0x390
>     [<ffffffff813f6b3b>] __device_attach+0x3b/0x40
> unreferenced object 0xffff8800b65aa1d8 (size 144):

Huh, I thought they would recursively kill items. I guess not! Thanks
for the patch.

-- 
Jens Axboe

