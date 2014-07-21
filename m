Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaGULCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:02:07 -0400
Received: from smtp.ispras.ru ([83.149.199.79]:48017 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaGULCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:02:04 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2014 07:02:04 EDT
Message-ID: <53CCF1EC.30008@ispras.ru>
Date: Mon, 21 Jul 2014 14:56:44 +0400
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: f2fs: Possible use-after-free when umount filesystem
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru>
In-Reply-To: <534BC29B.3020408@ispras.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Using memory error detector reveals the following use-after-free error 
in 3.15.0:

AddressSanitizer: heap-use-after-free in f2fs_evict_inode
Read of size 8 by thread T22279:
  [<ffffffffa02d8702>] f2fs_evict_inode+0x102/0x2e0 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/f2fs.h:584
  [<ffffffff812359af>] evict+0x15f/0x290 
/home/tester/linux-sources/linux-kasan/fs/inode.c:550
  [<     inlined    >] iput+0x196/0x280 iput_final 
/home/tester/linux-sources/linux-kasan/fs/inode.c:1418
  [<ffffffff812369a6>] iput+0x196/0x280 
/home/tester/linux-sources/linux-kasan/fs/inode.c:1436
  [<ffffffffa02dc416>] f2fs_put_super+0xd6/0x170 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/super.c:434
  [<ffffffff81210095>] generic_shutdown_super+0xc5/0x1b0 
/home/tester/linux-sources/linux-kasan/fs/super.c:406
  [<ffffffff812105fd>] kill_block_super+0x4d/0xb0 
/home/tester/linux-sources/linux-kasan/fs/super.c:1019
  [<ffffffff81210a86>] deactivate_locked_super+0x66/0x80 
/home/tester/linux-sources/linux-kasan/fs/super.c:284
  [<ffffffff81211c98>] deactivate_super+0x68/0x80 
/home/tester/linux-sources/linux-kasan/fs/super.c:307
  [<ffffffff8123cc88>] mntput_no_expire+0x198/0x250 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:986 (discriminator 3)
  [<     inlined    >] SyS_umount+0xe9/0x1a0 SYSC_umount 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:1424
  [<ffffffff8123f1c9>] SyS_umount+0xe9/0x1a0 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:1392
  [<ffffffff81cc8df9>] system_call_fastpath+0x16/0x1b 
/home/tester/linux-sources/linux-kasan/arch/x86/kernel/entry_64.S:426

Freed by thread T3:
  [<ffffffffa02dc337>] f2fs_i_callback+0x27/0x30 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/super.c:408
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 __rcu_reclaim 
/home/tester/linux-sources/linux-kasan/kernel/rcu/rcu.h:114
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 rcu_do_batch 
/home/tester/linux-sources/linux-kasan/kernel/rcu/tree.c:2242
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 
invoke_rcu_callbacks 
/home/tester/linux-sources/linux-kasan/kernel/rcu/tree.c:2499
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 
__rcu_process_callbacks 
/home/tester/linux-sources/linux-kasan/kernel/rcu/tree.c:2466
  [<ffffffff810fd266>] rcu_process_callbacks+0x2d6/0x930 
/home/tester/linux-sources/linux-kasan/kernel/rcu/tree.c:2483
  [<ffffffff8107cce2>] __do_softirq+0x142/0x380 
/home/tester/linux-sources/linux-kasan/kernel/softirq.c:269
  [<ffffffff8107cf50>] run_ksoftirqd+0x30/0x50 
/home/tester/linux-sources/linux-kasan/kernel/softirq.c:658
  [<ffffffff810b2a87>] smpboot_thread_fn+0x197/0x280 
/home/tester/linux-sources/linux-kasan/kernel/smpboot.c:160
  [<ffffffff810a8238>] kthread+0x148/0x160 
/home/tester/linux-sources/linux-kasan/kernel/kthread.c:207
  [<ffffffff81cc8d4c>] ret_from_fork+0x7c/0xb0 
/home/tester/linux-sources/linux-kasan/arch/x86/kernel/entry_64.S:351

Allocated by thread T22276:
  [<ffffffffa02dc7dd>] f2fs_alloc_inode+0x2d/0x170 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/super.c:356
  [<ffffffff8123471d>] alloc_inode+0x2d/0xe0 
/home/tester/linux-sources/linux-kasan/fs/inode.c:208
  [<ffffffff81235e2a>] iget_locked+0x10a/0x230 
/home/tester/linux-sources/linux-kasan/fs/inode.c:1085
  [<ffffffffa02d7495>] f2fs_iget+0x35/0xa80 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/inode.c:129
  [<ffffffffa02e2393>] f2fs_fill_super+0xb53/0xff0 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/super.c:1021
  [<ffffffff81211bce>] mount_bdev+0x1de/0x240 
/home/tester/linux-sources/linux-kasan/fs/super.c:992
  [<ffffffffa02dbce0>] f2fs_mount+0x10/0x20 [f2fs] 
/home/tester/linux-sources/linux-kasan/fs/f2fs/super.c:1127
  [<ffffffff81212a85>] mount_fs+0x55/0x220 
/home/tester/linux-sources/linux-kasan/fs/super.c:1095
  [<ffffffff8123c026>] vfs_kern_mount+0x66/0x200 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:851
  [<     inlined    >] do_mount+0x2b4/0x1120 do_new_mount 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:2129
  [<ffffffff812400d4>] do_mount+0x2b4/0x1120 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:2453
  [<     inlined    >] SyS_mount+0xb2/0x110 SYSC_mount 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:2647
  [<ffffffff812414a2>] SyS_mount+0xb2/0x110 
/home/tester/linux-sources/linux-kasan/fs/namespace.c:2620
  [<ffffffff81cc8df9>] system_call_fastpath+0x16/0x1b 
/home/tester/linux-sources/linux-kasan/arch/x86/kernel/entry_64.S:426

The buggy address ffff8800587866c8 is located 48 bytes inside
  of 680-byte region [ffff880058786698, ffff880058786940)

Memory state around the buggy address:
  ffff880058786100: ffffffff ffffffff ffffffff ffffffff
  ffff880058786200: ffffffff ffffffff ffffffrr rrrrrrrr
  ffff880058786300: rrrrrrrr rrffffff ffffffff ffffffff
  ffff880058786400: ffffffff ffffffff ffffffff ffffffff
  ffff880058786500: ffffffff ffffffff ffffffff fffffffr
 >ffff880058786600: rrrrrrrr rrrrrrrr rrrfffff ffffffff
                                                ^
  ffff880058786700: ffffffff ffffffff ffffffff ffffffff
  ffff880058786800: ffffffff ffffffff ffffffff ffffffff
  ffff880058786900: ffffffff rrrrrrrr rrrrrrrr rrrr....
  ffff880058786a00: ........ ........ ........ ........
  ffff880058786b00: ........ ........ ........ ........
Legend:
  f - 8 freed bytes
  r - 8 redzone bytes
  . - 8 allocated bytes
  x=1..7 - x allocated bytes + (8-x) redzone bytes


Investigation shows, that f2fs_evict_inode, when called for 
'meta_inode', uses invalidate_mapping_pages() for 'node_inode'.
But 'node_inode' is deleted before 'meta_inode' in f2fs_put_super via 
iput().

It seems that in common usage scenario this use-after-free is benign, 
because 'node_inode' remains partially valid data even after 
kmem_cache_free().
But things may change if, while 'meta_inode' is evicted in one f2fs 
filesystem, another (mounted) f2fs filesystem requests inode from cache, 
and formely
'node_inode' of the first filesystem is returned.


Found by Linux File System Verification project (linuxtesting.org).


-- 
Best regards,



Andrey Tsyvarev



Linux Verification Center, ISPRAS



web:http://linuxtesting.org

