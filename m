Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaGYECO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:02:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11658 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaGYECH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:02:07 -0400
X-AuditID: cbfee61a-f79e46d00000134f-41-53d1d6bd72ed
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: tsyvarev@ispras.ru, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: avoid use invalid mapping of node_inode
 when evict meta inode
Date: Fri, 25 Jul 2014 12:00:57 +0800
Message-id: <002b01cfa7bd$32774ad0$9765e070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+nt+S69A8M0j6EQGqfTBgbMph3EQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQd291y4GG6xdo2lxbV8jk8Xz9gPM
	Fk/Wz2K2uLTI3eLyrjlsFssvxzmwefw/OInZY8a/qYwem1Z1snnsXvCZyaNvyypGj8+b5ALY
	orhsUlJzMstSi/TtErgyzi9ewV5wRb1i3d73LA2MnYpdjJwcEgImEruOL2GDsMUkLtxbD2Rz
	cQgJTGeUOL/wD5Tzg1Fi4qWtzCBVbAIqEss7/jOB2CICXhKT9p9gASliFmhilLjdfgwsISyQ
	IjHn708WEJtFQFVixvkdQJM4OHgFLCVartaDhHkFBCV+TL4HVsIsoCWxfudxJghbXmLzmrfM
	EBcpSOw4+5oRYpeexLHv59kgasQlNh65xTKBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEh/4zqR2MKxssDjEKcDAq8fB21F8MFmJNLCuuzD3EKMHBrCTC
	e+swUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVANj2oy/
	qxYy8c5KTNmjZmJn/Ox9sbnO7mMHDTXrT3Aumf3Z8c/xG669aft8FOvdP7J61n8VSnqS/dzM
	7Qf/8m08qXpbMnhWf97Vf/DlpLZDjqevF8Uzl0m3fes7K/n/pqBDtdH5rdnXzcvULY44xkel
	/ymTE+GerahhsZBrjq+k2y+v7G/MEjxKLMUZiYZazEXFiQCEFV/IeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Tsyvarev reported:
"Using memory error detector reveals the following use-after-free error 
in 3.15.0:

AddressSanitizer: heap-use-after-free in f2fs_evict_inode
Read of size 8 by thread T22279:
  [<ffffffffa02d8702>] f2fs_evict_inode+0x102/0x2e0 [f2fs] 
  [<ffffffff812359af>] evict+0x15f/0x290 
  [<     inlined    >] iput+0x196/0x280 iput_final 
  [<ffffffff812369a6>] iput+0x196/0x280 
  [<ffffffffa02dc416>] f2fs_put_super+0xd6/0x170 [f2fs] 
  [<ffffffff81210095>] generic_shutdown_super+0xc5/0x1b0 
  [<ffffffff812105fd>] kill_block_super+0x4d/0xb0 
  [<ffffffff81210a86>] deactivate_locked_super+0x66/0x80 
  [<ffffffff81211c98>] deactivate_super+0x68/0x80 
  [<ffffffff8123cc88>] mntput_no_expire+0x198/0x250 
  [<     inlined    >] SyS_umount+0xe9/0x1a0 SYSC_umount 
  [<ffffffff8123f1c9>] SyS_umount+0xe9/0x1a0 
  [<ffffffff81cc8df9>] system_call_fastpath+0x16/0x1b 

Freed by thread T3:
  [<ffffffffa02dc337>] f2fs_i_callback+0x27/0x30 [f2fs] 
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 __rcu_reclaim 
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 rcu_do_batch 
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 invoke_rcu_callbacks 
  [<     inlined    >] rcu_process_callbacks+0x2d6/0x930 __rcu_process_callbacks
  [<ffffffff810fd266>] rcu_process_callbacks+0x2d6/0x930 
  [<ffffffff8107cce2>] __do_softirq+0x142/0x380 
  [<ffffffff8107cf50>] run_ksoftirqd+0x30/0x50 
  [<ffffffff810b2a87>] smpboot_thread_fn+0x197/0x280 
  [<ffffffff810a8238>] kthread+0x148/0x160 
  [<ffffffff81cc8d4c>] ret_from_fork+0x7c/0xb0 

Allocated by thread T22276:
  [<ffffffffa02dc7dd>] f2fs_alloc_inode+0x2d/0x170 [f2fs] 
  [<ffffffff81235e2a>] iget_locked+0x10a/0x230 
  [<ffffffffa02d7495>] f2fs_iget+0x35/0xa80 [f2fs] 
  [<ffffffffa02e2393>] f2fs_fill_super+0xb53/0xff0 [f2fs] 
  [<ffffffff81211bce>] mount_bdev+0x1de/0x240 
  [<ffffffffa02dbce0>] f2fs_mount+0x10/0x20 [f2fs] 
  [<ffffffff81212a85>] mount_fs+0x55/0x220 
  [<ffffffff8123c026>] vfs_kern_mount+0x66/0x200 
  [<     inlined    >] do_mount+0x2b4/0x1120 do_new_mount 
  [<ffffffff812400d4>] do_mount+0x2b4/0x1120 
  [<     inlined    >] SyS_mount+0xb2/0x110 SYSC_mount 
  [<ffffffff812414a2>] SyS_mount+0xb2/0x110 
  [<ffffffff81cc8df9>] system_call_fastpath+0x16/0x1b 

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
'node_inode' of the first filesystem is returned."

Nids for both meta_inode and node_inode are reservation, so it's not necessary
for us to invalidate pages which will never be allocated.
To fix this issue, let's skipping needlessly invalidating pages for
{meta,node}_inode in f2fs_evict_inode.

Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
Tested-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2cf6962..cafba3c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -273,7 +273,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
-		goto no_delete;
+		goto out_clear;
 
 	f2fs_bug_on(get_dirty_dents(inode));
 	remove_dirty_dir_inode(inode);
@@ -295,6 +295,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	sb_end_intwrite(inode->i_sb);
 no_delete:
-	clear_inode(inode);
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
+out_clear:
+	clear_inode(inode);
 }
-- 
2.0.1.474.g72c7794


