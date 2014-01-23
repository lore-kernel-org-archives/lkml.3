Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaAWJ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:56:41 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64636 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaAWJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:56:39 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nicolin Chen <b42378@freescale.com>, Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] lib/genalloc.c: add check gen_pool_dma_alloc() if dma pointer is not NULL
Date: Thu, 23 Jan 2014 15:26:30 +0530
Message-Id: <1390470990-16065-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

In the gen_pool_dma_alloc() the dma pointer can be NULL
and while assigning gen_pool_virt_to_phys(pool, vaddr) to
dma caused the following crash on da850 evm,

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc1-00001-g0609e45-dirty #5
task: c4830000 ti: c4832000 task.ti: c4832000
PC is at gen_pool_dma_alloc+0x30/0x3c
LR is at gen_pool_virt_to_phys+0x74/0x80
pc : [<c01a73b8>]    lr : [<c01a6ff8>]    psr: 60000013
sp : c4833e38  ip : 00000000  fp : 00000000
r10: c0428928  r9 : c0430e1c  r8 : c0444b70
r7 : c04436f0  r6 : c5840000  r5 : 00000000  r4 : c4802fe0
r3 : 80000000  r2 : c4833e18  r1 : c4832018  r0 : 80000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: c0004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc48321c0)
Stack: (0xc4833e38 to 0xc4834000)
3e20:                                                       c0443700 c0461668
3e40: c0017df4 c0413f00 c0208b14 c0443700 c0444b5c c0485910 00000000 c0208b30
3e60: c0208b14 c0443700 00000001 c02072e0 c0443700 c0444b70 c0443734 00000000
3e80: 0000004f c0207500 c0444b70 c0207474 c4833e98 c0205cc4 c4822258 c48c9150
3ea0: 00000000 c0444b70 c4b2d780 c0459270 c4822200 c020644c c03a30d4 c019547c
3ec0: c0444b70 c0444b70 00000000 c040f01c c040c5c0 c0207a90 00000000 c0444b5c
3ee0: 00000001 c0208a90 c4832000 00000000 c040f01c c041298c c4832000 c040f038
3f00: 00000000 c0008848 c485ca80 c0468954 c4833f44 c4833f78 00000000 c0102b00
3f20: 00000000 c485ca20 00000000 c052c52c c03f1160 c00346c8 00000003 60000013
3f40: c039e7e8 00000000 00000007 00000007 c0445ca0 c0428924 c0428924 00000008
3f60: c04612e0 c040c5c0 0000004f c0428928 00000000 c040c4f8 00000007 00000007
3f80: c040c5c0 c003f3b0 00000000 c03021f8 00000000 00000000 00000000 00000000
3fa0: 00000000 c0302200 00000000 c0009710 00000000 00000000 00000000 00000000
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000001 00000000
[<c01a73b8>] (gen_pool_dma_alloc+0x30/0x3c) from [<c0413f00>] (davinci_pm_probe+0x40/0xa8)
[<c0413f00>] (davinci_pm_probe+0x40/0xa8) from [<c0208b30>] (platform_drv_probe+0x1c/0x4c)
[<c0208b30>] (platform_drv_probe+0x1c/0x4c) from [<c02072e0>] (driver_probe_device+0x98/0x22c)
[<c02072e0>] (driver_probe_device+0x98/0x22c) from [<c0207500>] (__driver_attach+0x8c/0x90)
[<c0207500>] (__driver_attach+0x8c/0x90) from [<c0205cc4>] (bus_for_each_dev+0x6c/0x8c)
[<c0205cc4>] (bus_for_each_dev+0x6c/0x8c) from [<c020644c>] (bus_add_driver+0x124/0x1d4)
[<c020644c>] (bus_add_driver+0x124/0x1d4) from [<c0207a90>] (driver_register+0x78/0xf8)
[<c0207a90>] (driver_register+0x78/0xf8) from [<c0208a90>] (platform_driver_probe+0x20/0xa4)
[<c0208a90>] (platform_driver_probe+0x20/0xa4) from [<c041298c>] (davinci_init_late+0xc/0x14)
[<c041298c>] (davinci_init_late+0xc/0x14) from [<c040f038>] (init_machine_late+0x1c/0x28)
[<c040f038>] (init_machine_late+0x1c/0x28) from [<c0008848>] (do_one_initcall+0x34/0x15c)
[<c0008848>] (do_one_initcall+0x34/0x15c) from [<c040c4f8>] (kernel_init_freeable+0xe4/0x1ac)
[<c040c4f8>] (kernel_init_freeable+0xe4/0x1ac) from [<c0302200>] (kernel_init+0x8/0xec)
[<c0302200>] (kernel_init+0x8/0xec) from [<c0009710>] (ret_from_fork+0x14/0x24)
Code: 0afffffa e1a00004 e1a01006 ebfffef2 (e5850000)
---[ end trace 24fd42a15d1cdd7d ]---

This patch fixes the above.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index dda3116..f48163f 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -334,7 +334,8 @@ void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
 	if (!vaddr)
 		return NULL;
 
-	*dma = gen_pool_virt_to_phys(pool, vaddr);
+	if (dma)
+		*dma = gen_pool_virt_to_phys(pool, vaddr);
 
 	return (void *)vaddr;
 }
-- 
1.7.9.5

