Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbaIEPEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:04:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10955 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaIEPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:04:41 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-20-5409d1052335
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] dmaengine: pl330: Fix NULL pointer dereference on probe
 failure
Date: Fri, 05 Sep 2014 17:04:25 +0200
Message-id: <1409929466-29506-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
References: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xy7qsFzlDDD4f17XYOGM9q8Xrf9NZ
	LKZPvcBosXrqXyD3haHF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsFiw8RGjxcu+/SwOPB6L
	97xk8ljy5hCrx8ent1g8+rasYvT4vEnOY+/n3ywBbFFcNimpOZllqUX6dglcGdtmnWErOK9c
	MeuqdAPjLLkuRk4OCQETiclfn7JA2GISF+6tZ+ti5OIQEljKKNG47RYLhNPHJNG4ewUjSBWb
	gLHE5uVLwKpEBFqZJC6umw5WxSxwl1Gi+e57sCphgTCJp98OsYLYLAKqEvfvP2AHsXkF3CV+
	nFkOtU9O4uSxyWA1nAIeEs8mP2AGsYWAahZ03GebwMi7gJFhFaNoamlyQXFSeq6RXnFibnFp
	Xrpecn7uJkZIQH7dwbj0mNUhRgEORiUe3g5NzhAh1sSy4srcQ4wSHMxKIry2u4FCvCmJlVWp
	RfnxRaU5qcWHGJk4OKUaGHewFLLuP71kfnXbJ4HHzV7z7mpe/T69UX3m2mgzc71P+mem5/1/
	uXjGOo3j/1Mubr/8kCs/xHLh/Vbmu/kSTe2NQWYrt+0V3+no58Jz8drfP9cOT4y7O/XtqTeu
	LlOfH1pVtqNoXoS6T9PVfNOT3U/3PdfuNa872H1aqahx6hyFkk2HLFTqFSWUWIozEg21mIuK
	EwGjWlOKJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dma_async_device_register() returns error and probe should clean up
and return error, a NULL pointer exception happens because of
dereference of not allocated channel thread:

Dmesg log (from early printk):
dma-pl330 12680000.pdma: unable to register DMAC
DMA pl330_control: removing pch: eeac4000, chan: eeac4014, thread:   (null)
Unable to handle kernel NULL pointer dereference at virtual address 0000000c
pgd = c0004000
[0000000c] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc3-next-20140904-00005-g6cc4c1937d90-dirty #427
task: ee80a800 ti: ee888000 task.ti: ee888000
PC is at _stop+0x8/0x2c8
LR is at pl330_control+0x70/0x2e8
pc : [<c0205dc8>]    lr : [<c020623c>]    psr: 60000193
sp : ee889df8  ip : 00000002  fp : 00000000
r10: eeac4014  r9 : ee0e62bc  r8 : 00000000
r7 : eeac405c  r6 : 60000113  r5 : ee0e6210  r4 : eeac4000
r3 : 00000002  r2 : 00000002  r1 : 00010000  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 4000404a  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xee888240)
Stack: (0xee889df8 to 0xee88a000)
9de0:                                                       00000002 eeac4000
9e00: ee0e6210 eeac4000 ee0e6210 60000113 eeac405c c020623c 00000000 c020725c
9e20: ee889e20 ee889e20 ee0e6210 eeac4080 00200200 00100100 eeac4014 00000020
9e40: ee0e6218 c0208374 00000000 ee9bb340 ee0e6210 00000000 00000000 c0605cd8
9e60: ee970000 c0605c84 ee9700f8 00000000 c05c4270 00000000 00000000 c0203b3c
9e80: ee970000 c06624a8 00000000 c0605c84 00000000 c023f890 ee970000 c0605c84
9ea0: ee970034 00000000 c05b23d0 c023fa3c 00000000 c0605c84 c023f9b0 c023e0d4
9ec0: ee947e78 ee9b9440 c0605c84 eea1e780 c0605acc c023f094 c0513b50 c0605c84
9ee0: c05ecbd8 c0605c84 c05ecbd8 ee11ba40 c0626500 c0240064 00000000 c05ecbd8
9f00: c05ecbd8 c0008964 c040f13c 0000009f c0626500 c057465c ee80a800 60000113
9f20: 00000000 c05efdb0 60000113 00000000 ef7fc89d c0421168 0000008f c003787c
9f40: c0573d6c 00000006 ef7fc8bb 00000006 c05efd50 ef7fc800 c05dfbc4 00000006
9f60: c05c4264 c0626500 0000008f c05c4270 c059b518 c059bcb4 00000006 00000006
9f80: c059b518 c003c08c 00000000 c040091c 00000000 00000000 00000000 00000000
9fa0: 00000000 c0400924 00000000 c000e7b8 00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 c0c0c0c0 c0c0c0c0
[<c0205dc8>] (_stop) from [<c020623c>] (pl330_control+0x70/0x2e8)
[<c020623c>] (pl330_control) from [<c0208374>] (pl330_probe+0x594/0x75c)
[<c0208374>] (pl330_probe) from [<c0203b3c>] (amba_probe+0xb8/0x120)
[<c0203b3c>] (amba_probe) from [<c023f890>] (driver_probe_device+0x10c/0x22c)
[<c023f890>] (driver_probe_device) from [<c023fa3c>] (__driver_attach+0x8c/0x90)
[<c023fa3c>] (__driver_attach) from [<c023e0d4>] (bus_for_each_dev+0x54/0x88)
[<c023e0d4>] (bus_for_each_dev) from [<c023f094>] (bus_add_driver+0xd4/0x1d0)
[<c023f094>] (bus_add_driver) from [<c0240064>] (driver_register+0x78/0xf4)
[<c0240064>] (driver_register) from [<c0008964>] (do_one_initcall+0x80/0x1d0)
[<c0008964>] (do_one_initcall) from [<c059bcb4>] (kernel_init_freeable+0x108/0x1d4)
[<c059bcb4>] (kernel_init_freeable) from [<c0400924>] (kernel_init+0x8/0xec)
[<c0400924>] (kernel_init) from [<c000e7b8>] (ret_from_fork+0x14/0x3c)
Code: e5813010 e12fff1e e92d40f0 e24dd00c (e590200c)
---[ end trace c94b2f4f38dff3bf ]---

This happens because the necessary resources were not yet allocated - no
call to pl330_alloc_chan_resources().

Terminate the thread and free channel resource only if channel thread is not NULL.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 0b94c5771705 ("DMA: PL330: Add check if device tree compatible")
---
 drivers/dma/pl330.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 47d82070848d..04c2f39227f1 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2756,8 +2756,10 @@ probe_err3:
 		list_del(&pch->chan.device_node);
 
 		/* Flush the channel */
-		pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
-		pl330_free_chan_resources(&pch->chan);
+		if (pch->thread) {
+			pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
+			pl330_free_chan_resources(&pch->chan);
+		}
 	}
 probe_err2:
 	pl330_del(pl330);
-- 
1.9.1

