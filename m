Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaAQJPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:15:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34312 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaAQJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:15:41 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: [RFC PATCH]  fs null_blk: Null pointer deference problem in alloc_page_buffers
Date: Fri, 17 Jan 2014 14:52:10 +0530
Message-Id: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011709-3532-0000-0000-000004CFAA19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If we load the null_blk module with bs=8k we get following oops:
[ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
[ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0
[ 3819.812640] Oops: 0000 [#1] SMP
[ 3819.812772] Modules linked in: null_blk(+)

 Fix that by resetting block size to 4k if it is greater than PAGE_SIZE
 Also adding BUG_ON for null point dereference places.

Reported-by: Sumanth <sumantk2@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Please note that alloc_page_buffers can return NULL on
 (1) when we are out of memory
 (2) block size > PAGE_SIZE
 In any case create_empty_buffers function will end up in dereferencing
 null pointer.
 May be there could be some saner approach to solve this, I am adding
 BUG_ON  ( Not sure if that is good idea considering we hate that)
 
 The full oops below:
 [ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
[ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0 
[ 3819.812640] Oops: 0000 [#1] SMP 
[ 3819.812772] Modules linked in: null_blk(+)
[ 3819.812872] CPU: 8 PID: 1179 Comm: modprobe Not tainted 3.13.0-rc6+ #144
[ 3819.813008] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[ 3819.813071] task: ffff8800376add40 ti: ffff8800374c8000 task.ti: ffff8800374c8000
[ 3819.813071] RIP: 0010:[<ffffffff81170aa5>]  [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
[ 3819.813071] RSP: 0018:ffff8800374c9758  EFLAGS: 00010292
[ 3819.813071] RAX: 0000000000000000 RBX: ffffea000368e200 RCX: 000000000000000d
[ 3819.813071] RDX: 0000000000000000 RSI: 0000000000002000 RDI: ffffea000368e200
[ 3819.813071] RBP: ffff8800374c9778 R08: 0000000000000000 R09: 0000000000003012
[ 3819.813071] R10: 0000000000003012 R11: ffff8800dbad0240 R12: 0000000000000000
[ 3819.813071] R13: 0000000000000000 R14: 00000000000201d0 R15: 0000000000000000
[ 3819.813071] FS:  00007fa0f79dd700(0000) GS:ffff88011bd00000(0000) knlGS:0000000000000000
[ 3819.813071] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3819.813071] CR2: 0000000000000008 CR3: 0000000215b0e000 CR4: 00000000000407e0
[ 3819.813071] Stack:
[ 3819.813071]  0000000000003012 ffffea000368e200 ffffea000368e200 0000000000000000
[ 3819.813071]  ffff8800374c9798 ffffffff81171047 0000000000016378 ffff8800dbad0240
[ 3819.813071]  ffff8800374c9848 ffffffff81172deb 00000000000201d0 ffff8800376add40
[ 3819.813071] Call Trace:
[ 3819.813071]  [<ffffffff81171047>] create_page_buffers+0x36/0x48
[ 3819.813071]  [<ffffffff81172deb>] block_read_full_page+0x38/0x1ed
[ 3819.813071]  [<ffffffff8117520a>] ? I_BDEV+0xd/0xd
[ 3819.813071]  [<ffffffff8111580d>] ? __inc_zone_page_state+0x1e/0x20
[ 3819.813071]  [<ffffffff81108e31>] ? get_page+0x24/0x29
[ 3819.813071]  [<ffffffff81108e5a>] ? __lru_cache_add+0x24/0x44
[ 3819.813071]  [<ffffffff811759f7>] blkdev_readpage+0x18/0x1a
[ 3819.813071]  [<ffffffff810fe753>] do_read_cache_page+0x88/0x12c
[ 3819.813071]  [<ffffffff81115a33>] ? zone_statistics+0x7c/0x83
[ 3819.813071]  [<ffffffff811759df>] ? blkdev_write_begin+0x25/0x25
[ 3819.813071]  [<ffffffff810fe838>] read_cache_page_async+0x19/0x1b
[ 3819.813071]  [<ffffffff810fe848>] read_cache_page+0xe/0x18
[ 3819.813071]  [<ffffffff812b0ca5>] read_dev_sector+0x2d/0x85
[ 3819.813071]  [<ffffffff812b34cf>] read_lba+0x81/0xdd
[ 3819.813071]  [<ffffffff812b38f7>] ? find_valid_gpt+0x9a/0x51d
[ 3819.813071]  [<ffffffff812b3915>] find_valid_gpt+0xb8/0x51d
[ 3819.813071]  [<ffffffff812b3de6>] efi_partition+0x6c/0x38e
[ 3819.813071]  [<ffffffff812c9609>] ? vsnprintf+0x81/0x3d6
[ 3819.813071]  [<ffffffff812c9fe5>] ? snprintf+0x34/0x36
[ 3819.813071]  [<ffffffff812b1a3a>] check_partition+0x113/0x1cd
[ 3819.813071]  [<ffffffff812b1699>] rescan_partitions+0xc1/0x2a7
[ 3819.813071]  [<ffffffff81176607>] __blkdev_get+0x1bd/0x3e3
[ 3819.813071]  [<ffffffff81176a0c>] blkdev_get+0x1df/0x2d8
[ 3819.813071]  [<ffffffff8115d1ea>] ? unlock_new_inode+0x5c/0x61
[ 3819.813071]  [<ffffffff813a2a2f>] ? put_device+0x17/0x19
[ 3819.813071]  [<ffffffff812ae811>] ? disk_put_part+0x12/0x14
[ 3819.813071]  [<ffffffff812af717>] add_disk+0x2af/0x3f0
[ 3819.813071]  [<ffffffffa00033a4>] null_init+0x3a4/0x3e5 [null_blk]
[ 3819.813071]  [<ffffffffa0003000>] ? 0xffffffffa0002fff
[ 3819.813071]  [<ffffffff810002e3>] do_one_initcall+0xb3/0x154
[ 3819.813071]  [<ffffffff810732c9>] ? __blocking_notifier_call_chain+0x56/0x60
[ 3819.813071]  [<ffffffff810ade71>] load_module+0x1c4f/0x1f92
[ 3819.813071]  [<ffffffff810abc11>] ? show_initstate+0x47/0x47
[ 3819.813071]  [<ffffffff810ae27b>] SyS_init_module+0xc7/0xc9
[ 3819.813071]  [<ffffffff816c8a69>] system_call_fastpath+0x16/0x1b
[ 3819.813071] Code: 5f 5d c3 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 d4 ba 01 00 00 00 53 48 89 fb 41 52 e8 3b ff ff ff 49 89 c5 eb 03 48 89 d0 <48> 8b 50 08 4c 09 20 48 85 d2 75 f1 4c 89 68 08 48 8b 7b 08 4d 
[ 3819.813071] RIP  [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
[ 3819.813071]  RSP <ffff8800374c9758>
[ 3819.813071] CR2: 0000000000000008
[ 3819.837847] ---[ end trace e3c8b9f8f8af88d6 ]---

 Your suggestion/Comments welcome.

 drivers/block/null_blk.c | 5 +++++
 fs/buffer.c              | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a2e69d2..6b0e049 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -535,6 +535,11 @@ static int null_add_dev(void)
 	if (!nullb)
 		return -ENOMEM;
 
+	if (bs > PAGE_SIZE) {
+		WARN(1, "Invalid block size. Setting it to 4096\n");
+		bs = 4096;
+	}
+
 	spin_lock_init(&nullb->lock);
 
 	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..029c698 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -883,6 +883,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	struct buffer_head *bh, *head;
 	long offset;
 
+	BUG_ON(size > PAGE_SIZE);
 try_again:
 	head = NULL;
 	offset = PAGE_SIZE;
@@ -1571,6 +1572,7 @@ void create_empty_buffers(struct page *page,
 	struct buffer_head *bh, *head, *tail;
 
 	head = alloc_page_buffers(page, blocksize, 1);
+	BUG_ON(!head);
 	bh = head;
 	do {
 		bh->b_state |= b_state;
-- 
1.7.11.7

