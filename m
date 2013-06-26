Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3FZN3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:29:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34916 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:29:53 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-9f-51caecb04bfd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [resend PATCH] DMA: PL330: fix locking in pl330_free_chan_resources()
Date: Wed, 26 Jun 2013 15:29:15 +0200
Message-id: <2690233.kbO94NEnCb@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAd0Nb04FGkz4pWkxZ/0aNotrK+ay
	W5xtesNucXnXHDaL9TNes1jsW5PowOaxc9Zddo8TM36zeMw7GejRt2UVo8fnTXIBrFFcNimp
	OZllqUX6dglcGSv/tzIWPJatWPflHHsD4w6pLkZODgkBE4lNl/YyQ9hiEhfurWfrYuTiEBJY
	xChxYOIMdginhUli3Y1uRpAqNgEriYntq8BsEQFtiad9FxlBipgFDjNKtM9pZwVJCAv4SfT/
	288CYrMIqEpc/vcMaAU7B6+ApsQGI5CoqIC9xLZ3b9lAbF4BQYkfk++BVTMLyEvs2z+VFcLW
	kli/8zjTBEa+WUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DB9JrWD
	cWWDxSFGAQ5GJR5eha0nA4VYE8uKK3MPMUpwMCuJ8L6ZfypQiDclsbIqtSg/vqg0J7X4EKM0
	B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA+PCz7HvZ36QPe5+ZrYB+1orWcaz53+Uz1Y/
	ePqz5aTImV6yPx7Od+a5LLL1/b8V8a+MMyr3Nt5b9XxuRvsFc3/Dl2e2nLxToDNBKi3t0sl3
	d1UixH1kpzA/nfV04T525wtqK8/K3/g6bf1CQdvrGRU75nb8Wrl5x5uo2jU7LXh21PJebzwZ
	WTA3WImlOCPRUIu5qDgRAKMINWNPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tasklet_kill() may sleep so call it before taking pch->lock.

Fixes following lockup:

[  345.470000] BUG: scheduling while atomic: cat/2383/0x00000002
[  345.470000] Modules linked in:
[  345.470000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c004d980>] (__schedule_bug+0x4c/0x58)
[  345.470000] [<c004d980>] (__schedule_bug+0x4c/0x58) from [<c0360b6c>] (__schedule+0x690/0x6e0)
[  345.470000] [<c0360b6c>] (__schedule+0x690/0x6e0) from [<c004f2b4>] (sys_sched_yield+0x70/0x78)
[  345.470000] [<c004f2b4>] (sys_sched_yield+0x70/0x78) from [<c002acec>] (tasklet_kill+0x34/0x8c)
[  345.470000] [<c002acec>] (tasklet_kill+0x34/0x8c) from [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88)
[  345.470000] [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88) from [<c01d81f4>] (dma_chan_put+0x4c/0x50)
[  345.470000] [<c01d81f4>] (dma_chan_put+0x4c/0x50) from [<c01d82c0>] (dma_release_channel+0x28/0x98)
[...]
[  368.335000] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
[  368.340000]  lock: 0xe52aa04c, .magic: dead4ead, .owner: cat/2383, .owner_cpu: 1
[  368.350000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c01b3d78>] (do_raw_spin_lock+0x194/0x204)
[  368.360000] [<c01b3d78>] (do_raw_spin_lock+0x194/0x204) from [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28)
[  368.365000] [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28) from [<c01da80c>] (pl330_tasklet+0x2c/0x5a8)
[  368.375000] [<c01da80c>] (pl330_tasklet+0x2c/0x5a8) from [<c002ac04>] (tasklet_action+0xfc/0x114)
[  368.385000] [<c002ac04>] (tasklet_action+0xfc/0x114) from [<c002b204>] (__do_softirq+0xe4/0x19c)
[  368.395000] [<c002b204>] (__do_softirq+0xe4/0x19c) from [<c002b398>] (irq_exit+0x98/0x9c)
[  368.405000] [<c002b398>] (irq_exit+0x98/0x9c) from [<c0013ebc>] (handle_IPI+0x124/0x16c)
[  368.410000] [<c0013ebc>] (handle_IPI+0x124/0x16c) from [<c000857c>] (gic_handle_irq+0x64/0x68)
[  368.420000] [<c000857c>] (gic_handle_irq+0x64/0x68) from [<c000e740>] (__irq_svc+0x40/0x70)
[  368.430000] Exception stack(0xc04a3f00 to 0xc04a3f48)
[  368.435000] 3f00: c04a3f48 00000000 6f9e23e8 00000050 c07492c8 c04a3f48 00000000 c04ccc88
[  368.440000] 3f20: 6f9dbac3 00000050 6f9e23e8 00000050 3b9aca00 c04a3f48 c005cfa4 c02946d4
[  368.450000] 3f40: 60000013 ffffffff
[  368.455000] [<c000e740>] (__irq_svc+0x40/0x70) from [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0)
[  368.460000] [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c02940dc>] (cpuidle_enter_state+0x18/0x68)
[  368.470000] [<c02940dc>] (cpuidle_enter_state+0x18/0x68) from [<c02948e0>] (cpuidle_idle_call+0xac/0xe0)
[  368.480000] [<c02948e0>] (cpuidle_idle_call+0xac/0xe0) from [<c00102f8>] (cpu_idle+0xac/0xf0)
[  368.490000] [<c00102f8>] (cpu_idle+0xac/0xf0) from [<c04796a0>] (start_kernel+0x28c/0x294)

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
previous submission:
https://lkml.org/lkml/2012/10/29/153

 drivers/dma/pl330.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/dma/pl330.c
===================================================================
--- a/drivers/dma/pl330.c	2012-10-23 15:28:11.848009972 +0200
+++ b/drivers/dma/pl330.c	2012-10-23 15:43:40.620425996 +0200
@@ -2459,10 +2459,10 @@ static void pl330_free_chan_resources(st
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);
-
 	tasklet_kill(&pch->task);
 
+	spin_lock_irqsave(&pch->lock, flags);
+
 	pl330_release_channel(pch->pl330_chid);
 	pch->pl330_chid = NULL;
 

