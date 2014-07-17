Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaGQItY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbaGQItV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:49:21 -0400
From: Maurizio Lombardi <mlombard@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ming.lei@canonical.com, jet.chen@intel.com, axboe@kernel.dk,
        akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu
Subject: [PATCH] bio: merge_bvec_fn() must be called with the old bi_iter.bi_size value
Date: Thu, 17 Jul 2014 10:49:10 +0200
Message-Id: <1405586950-4023-1-git-send-email-mlombard@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "bio: modify __bio_add_page() to accept pages that
don't start a new segment" updates bio->bi_iter.bi_size before
calling merge_bvec_fn().

This panics the kernel because merge_bvec_fn() expects bi_size to have
the old value.

This can be reproduced by trying to create a crypto device with cryptsetup.

[   25.929846] ------------[ cut here ]------------
[   25.929873] kernel BUG at fs/direct-io.c:747!
[   25.929893] invalid opcode: 0000 [#1] PREEMPT SMP
[   25.929922] Modules linked in:
[   25.929940] CPU: 3 PID: 308 Comm: systemd-cryptse Not tainted 3.16.0-rc4-next-20140707 #247
[   25.929974] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A14 01/13/2014
[   25.930004] task: ffff880222609e50 ti: ffff8802225b4000 task.ti: ffff8802225b4000
[   25.930034] RIP: 0010:[<ffffffff8116bee5>]  [<ffffffff8116bee5>] dio_send_cur_page+0xd7/0xe3
[   25.930074] RSP: 0018:ffff8802225b7aa0  EFLAGS: 00010202
[   25.930096] RAX: 0000000000000001 RBX: ffff8802225b7c01 RCX: 0000000000000000
[   25.930126] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81d13cf0
[   25.930155] RBP: ffff8802225b7ac8 R08: 0000000000000000 R09: 0000000000000001
[   25.930184] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800c6e8dc00
[   25.930213] R13: ffff8802225b7bc0 R14: 000000000000007a R15: 000000000000007c
[   25.930243] FS:  00007f5908c49840(0000) GS:ffff88022dd80000(0000) knlGS:0000000000000000
[   25.930276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.930300] CR2: 00000000006ecf18 CR3: 0000000222bb1000 CR4: 00000000001407e0
[   25.930329] Stack:
[   25.930339]  0000000100000000 ffff8800c6e8dc00 ffffea0002ba9d68 0000000000000800
[   25.930380]  ffff8802225b7c28 ffff8802225b7b08 ffffffff8116bfa2 0000000022110780
[   25.930419]  ffff8800c6e8dc00 ffffea0002ba9d68 0000000000000800 0000000000000001
[   25.930458] Call Trace:
[   25.930473]  [<ffffffff8116bfa2>] submit_page_section+0xb1/0x114
[   25.930499]  [<ffffffff8116cad6>] do_blockdev_direct_IO+0xa28/0xd1f
[   25.930527]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930549]  [<ffffffff8116cdfc>] __blockdev_direct_IO+0x2f/0x31
[   25.930575]  [<ffffffff8116cdfc>] ? __blockdev_direct_IO+0x2f/0x31
[   25.930601]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930622]  [<ffffffff811698e2>] blkdev_direct_IO+0x2e/0x30
[   25.930647]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930669]  [<ffffffff810f314c>] generic_file_read_iter+0x93/0x5c8
[   25.930697]  [<ffffffff81169c8a>] blkdev_read_iter+0x35/0x37
[   25.930722]  [<ffffffff81139725>] new_sync_read+0x74/0x98
[   25.930746]  [<ffffffff81139e0c>] vfs_read+0xce/0x124
[   25.930768]  [<ffffffff8113a665>] SyS_read+0x4b/0x79
[   25.930791]  [<ffffffff8167ea92>] system_call_fastpath+0x16/0x1b
[   25.930816] Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 dc 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf
[   25.931060] RIP  [<ffffffff8116bee5>] dio_send_cur_page+0xd7/0xe3
[   25.931088]  RSP <ffff8802225b7aa0>
[   25.931132] ---[ end trace 5bdcfa6254e32464 ]---

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index fb12df9..40c5b12 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -795,7 +795,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		struct bvec_merge_data bvm = {
 			.bi_bdev = bio->bi_bdev,
 			.bi_sector = bio->bi_iter.bi_sector,
-			.bi_size = bio->bi_iter.bi_size,
+			.bi_size = bio->bi_iter.bi_size - len,
 			.bi_rw = bio->bi_rw,
 		};
 
-- 
Maurizio Lombardi

