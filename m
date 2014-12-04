Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaLDKFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:05:55 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:60301 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaLDKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:05:48 -0500
Message-ID: <548031F2.4030303@mentor.com>
Date: Thu, 4 Dec 2014 15:35:38 +0530
From: Bhuvanesh <bhuvanesh_surachari@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <snitzer@redhat.com>,
        <axboe@fb.com>, <harish_kandiga@mentor.com>,
        <rmk+kernel@arm.linux.org.uk>, <joe@perches.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: queue:Improve error handling during allocation of bounce
 buffers.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7ea020e32e1fbe4d05d104e31815d908af92f2a5 Mon Sep 17 00:00:00 2001
From: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
Date: Mon, 1 Dec 2014 02:23:02 -0500
Subject: [PATCH] mmc: queue:Improve error handling during allocation of
 bounce buffers.

Allocation of previous bounce buffer in mmc_init_queue when the current
bounce buffer allocation fails was leading to a crash later in
__blk_segment_map_sg. Error handling is improved by allocating previous
bounce buffer only if the current bounce buffer allocation succeeds.

Signed-off-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
---
During our rigorous testing of inserting and removing SD card we found
exception in the kernel. Please find the backtrace as below:

[ 1605.392278] Backtrace:
[ 1605.395466] [<800117c4>] (dump_backtrace+0x0/0x100) from [<803f2cf4>] (dump_stack+0x18/0x1c)
[ 1605.408679] [<803f2cdc>] (dump_stack+0x0/0x1c) from [<800b4038>] (warn_alloc_failed+0xec/0x10c)
[ 1605.423194] [<800b3f4c>] (warn_alloc_failed+0x0/0x10c) from [<800b6d10>] (__alloc_pages_nodemask+0x764/0x890)
[ 1605.439126] [<800b65ac>] (__alloc_pages_nodemask+0x0/0x890) from [<800b6e54>] (__get_free_pages+0x18/0x54)
[ 1605.453885] [<800b6e3c>] (__get_free_pages+0x0/0x54) from [<800e4504>] (kmalloc_order_trace+0x2c/0xe8)
[ 1605.470367] [<800e44d8>] (kmalloc_order_trace+0x0/0xe8) from [<800e5c4c>] (__kmalloc+0x38/0x1e4)
[ 1605.482358] [<800e5c14>] (__kmalloc+0x0/0x1e4) from [<8026ac50>] (mmc_init_queue+0x198/0x444)
[ 1605.494663] [<8026aab8>] (mmc_init_queue+0x0/0x444) from [<80268638>] (mmc_blk_alloc_req+0x184/0x354)
[ 1605.513224] [<802684b4>] (mmc_blk_alloc_req+0x0/0x354) from [<80268f54>] (mmc_blk_probe+0x7c/0x28c)
[ 1605.527459] [<80268ed8>] (mmc_blk_probe+0x0/0x28c) from [<8025e8f0>] (mmc_bus_probe+0x1c/0x20)
[ 1605.543524] [<8025e8d4>] (mmc_bus_probe+0x0/0x20) from [<802a0d2c>] (driver_probe_device+0xb4/0x204)
[ 1605.558819] [<802a0c78>] (driver_probe_device+0x0/0x204) from [<802a0eac>] (__device_attach+0x30/0x4c)
[ 1605.571747] [<802a0e7c>] (__device_attach+0x0/0x4c) from [<8029f3b4>] (bus_for_each_drv+0x80/0x94)
[ 1605.587027] [<8029f334>] (bus_for_each_drv+0x0/0x94) from [<802a0c2c>] (device_attach+0x70/0x94)
[ 1605.601680] [<802a0bbc>] (device_attach+0x0/0x94) from [<802a01e0>] (bus_probe_device+0x30/0xa0)
[ 1605.614128] [<802a01b0>] (bus_probe_device+0x0/0xa0) from [<8029e8bc>] (device_add+0x42c/0x570)
[ 1605.626933] [<8029e490>] (device_add+0x0/0x570) from [<8025eda0>] (mmc_add_card+0x188/0x1e4)
[ 1605.638880] [<8025ec18>] (mmc_add_card+0x0/0x1e4) from [<802637bc>] (mmc_attach_sd+0x188/0x210)
[ 1605.651413] [<80263634>] (mmc_attach_sd+0x0/0x210) from [<8025e508>] (mmc_rescan+0x240/0x2ac)
[ 1605.666968] [<8025e2c8>] (mmc_rescan+0x0/0x2ac) from [<8003cde0>] (process_one_work+0x2cc/0x460)
[ 1605.682229] [<8003cb14>] (process_one_work+0x0/0x460) from [<8003d240>] (worker_thread+0x298/0x3ec)
[ 1605.698223] [<8003cfa8>] (worker_thread+0x0/0x3ec) from [<80042490>] (kthread+0xb4/0xc0)
[ 1605.707312] [<800423dc>] (kthread+0x0/0xc0) from [<8000d9b8>] (ret_from_fork+0x14/0x3c)
[ 1605.846505] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[ 1605.859027] pgd = 80004000
[ 1605.862280] [00000000] *pgd=00000000
[ 1605.866415] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[ 1605.949143] CPU: 0    Not tainted  (3.8.13.27-03391-g4e6f494 #1)
[ 1605.955216] PC is at __blk_segment_map_sg+0xfc/0x140
[ 1605.955216] PC is at __blk_segment_map_sg+0xfc/0x140
[ 1605.960240] LR is at blk_rq_map_sg+0xa0/0x1d8
[ 1605.964657] pc : [<802240fc>]    lr : [<802241e0>]    psr: 60000013
[ 1605.964657] sp : 81fe5db8  ip : 81fe5df0  fp : 81fe5dec
[ 1605.976191] r10: 81fe5e04  r9 : 00000000  r8 : 00000000
[ 1605.981473] r7 : 81fe5e00  r6 : 00001000  r5 : 81fe5e04  r4 : ad1ea3c4
[ 1605.988056] r3 : 00000000  r2 : 80667000  r1 : 00000000  r0 : ac2972a0
[ 1605.994638] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 1606.002001] Control: 10c5387d  Table: 3d09004a  DAC: 00000015
[ 1606.007801] Process mmcqd/0 (pid: 13804, stack limit = 0x81fe4238)
[ 1606.014034] Stack: (0x81fe5db8 to 0x81fe6000)
[ 1606.018446] 5da0:                                                       ac274a38 00000000
[ 1606.026681] 5dc0: 00000000 ac2972a0 ad1f4af8 ad1ea380 00000001 00000000 00000000 81fe5e04
[ 1606.034917] 5de0: 81fe5e3c 81fe5df0 802241e0 8022400c 81fe5e04 81fe5e08 81fe5e0c 00000031
[ 1606.043152] 5e00: 00000000 00000000 00000000 00000001 81fe5e54 8633a030 8633a800 ad1f4af8
[ 1606.051386] 5e20: 00000008 8633a034 8633a008 8633a000 81fe5e5c 81fe5e40 8026b06c 8022414c
[ 1606.059622] 5e40: 8633a030 8633a800 ad1f4af8 00000008 81fe5e94 81fe5e60 80268c14 8026b04c
[ 1606.067857] 5e60: 803f90d8 00000000 81fe5e8c 8633a800 ad1f4af8 8633a008 ac07f000 ad1f4af8
[ 1606.076091] 5e80: 8633a000 8633a034 81fe5edc 81fe5e98 802699a8 80268994 81fe5eb4 00000000
[ 1606.084326] 5ea0: 00000000 00000000 00100100 00200200 803f7f98 ad1f4af8 8633a800 8633a008
[ 1606.092562] 5ec0: ac07f000 8633a000 81fe4000 8633a000 81fe5f24 81fe5ee0 8026a210 80269920
[ 1606.100798] 5ee0: 00000000 ad1f4af8 81fe5f0c 81fe5ef8 802204e0 120d0000 120d0000 8633a008
[ 1606.109034] 5f00: ad1f4af8 8633a010 ac2972a0 81fe4028 81fe4000 00000001 81fe5f5c 81fe5f28
[ 1606.117270] 5f20: 8026a89c 80269d4c 00000000 120d0000 8026a7bc ac23bc28 00000000 8633a008
[ 1606.125506] 5f40: 8026a7bc 00000000 00000000 00000000 81fe5fac 81fe5f60 80042490 8026a7c8
[ 1606.133742] 5f60: 803f9134 00000000 81fe5f94 8633a008 00000000 00000000 81fe5f78 81fe5f78
[ 1606.141977] 5f80: 00000000 00000000 81fe5f88 81fe5f88 ac23bc28 800423dc 00000000 00000000
[ 1606.150213] 5fa0: 00000000 81fe5fb0 8000d9b8 800423e8 00000000 00000000 00000000 00000000
[ 1606.158448] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1606.166684] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 1da1d629 0030d97d
[ 1606.174914] Backtrace:
[ 1606.177445] [<80224000>] (__blk_segment_map_sg+0x0/0x140) from [<802241e0>] (blk_rq_map_sg+0xa0/0x1d8)
[ 1606.186822] [<80224140>] (blk_rq_map_sg+0x0/0x1d8) from [<8026b06c>] (mmc_queue_map_sg+0x2c/0x94)
[ 1606.195759] [<8026b040>] (mmc_queue_map_sg+0x0/0x94) from [<80268c14>] (mmc_blk_rw_rq_prep+0x28c/0x300)
[ 1606.210939] [<80268988>] (mmc_blk_rw_rq_prep+0x0/0x300) from [<802699a8>] (mmc_blk_issue_rw_rq+0x94/0x42c)
[ 1606.220655] [<80269914>] (mmc_blk_issue_rw_rq+0x0/0x42c) from [<8026a210>] (mmc_blk_issue_rq+0x4d0/0x500)
[ 1606.230284] [<80269d40>] (mmc_blk_issue_rq+0x0/0x500) from [<8026a89c>] (mmc_queue_thread+0xe0/0x17c)
[ 1606.239571] [<8026a7bc>] (mmc_queue_thread+0x0/0x17c) from [<80042490>] (kthread+0xb4/0xc0)
[ 1606.247989] [<800423dc>] (kthread+0x0/0xc0) from [<8000d9b8>] (ret_from_fork+0x14/0x3c)
[ 1606.261771] Code: e5850000 e5953000 e5942000 e5941008 (e5930000)
[ 1606.301708] Kernel panic - not syncing: Fatal exception
[ 1606.307005] Rebooting in 1 seconds..

On analysis i found that error handling in mmc_init_queue during
allocation of bounce buffers is incomplete. In the exception case the
allocation of current bounce buffer fails and the previous bounce
buffer allocation succeeds. This later leads to exception in,
__blk_segment_map_sg while trying to access the bounce buffer.

The below patch improves the error handling during allocation of
bounce buffers. The previous bounce buffer is allocated only if the
allocation of current bounce buffer succeeds.

---
 drivers/mmc/card/queue.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index cfa6110..236d194 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -232,13 +232,15 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 			if (!mqrq_cur->bounce_buf) {
 				pr_warn("%s: unable to allocate bounce cur buffer\n",
 					mmc_card_name(card));
-			}
-			mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
-			if (!mqrq_prev->bounce_buf) {
-				pr_warn("%s: unable to allocate bounce prev buffer\n",
-					mmc_card_name(card));
-				kfree(mqrq_cur->bounce_buf);
-				mqrq_cur->bounce_buf = NULL;
+			} else {
+				mqrq_prev->bounce_buf =
+						kmalloc(bouncesz, GFP_KERNEL);
+				if (!mqrq_prev->bounce_buf) {
+					pr_warn("%s: unable to allocate bounce prev buffer\n",
+						mmc_card_name(card));
+					kfree(mqrq_cur->bounce_buf);
+					mqrq_cur->bounce_buf = NULL;
+				}
 			}
 		}
 
-- 
1.7.9.5

