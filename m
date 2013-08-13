Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab3HMQjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:39:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab3HMQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:45 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Fp6U9LUT-VEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=q70m8iuvxNcA:10 a=hD80L64hAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=v3rLFGiuRE8A:10 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155837.486980920@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [86/88] drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0086-drivers-dma-pl330.c-fix-locking-in-pl330_free_chan_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

[ Upstream commit da331ba8e9c5de72a27e50f71105395bba6eebe0 ]

tasklet_kill() may sleep so call it before taking pch->lock.

Fixes following lockup:

  BUG: scheduling while atomic: cat/2383/0x00000002
  Modules linked in:
    unwind_backtrace+0x0/0xfc
    __schedule_bug+0x4c/0x58
    __schedule+0x690/0x6e0
    sys_sched_yield+0x70/0x78
    tasklet_kill+0x34/0x8c
    pl330_free_chan_resources+0x24/0x88
    dma_chan_put+0x4c/0x50
  [...]
  BUG: spinlock lockup suspected on CPU#0, swapper/0/0
   lock: 0xe52aa04c, .magic: dead4ead, .owner: cat/2383, .owner_cpu: 1
    unwind_backtrace+0x0/0xfc
    do_raw_spin_lock+0x194/0x204
    _raw_spin_lock_irqsave+0x20/0x28
    pl330_tasklet+0x2c/0x5a8
    tasklet_action+0xfc/0x114
    __do_softirq+0xe4/0x19c
    irq_exit+0x98/0x9c
    handle_IPI+0x124/0x16c
    gic_handle_irq+0x64/0x68
    __irq_svc+0x40/0x70
    cpuidle_wrap_enter+0x4c/0xa0
    cpuidle_enter_state+0x18/0x68
    cpuidle_idle_call+0xac/0xe0
    cpu_idle+0xac/0xf0

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/dma/pl330.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index f5843bc..de4ec1a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2462,10 +2462,10 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);
-
 	tasklet_kill(&pch->task);
 
+	spin_lock_irqsave(&pch->lock, flags);
+
 	pl330_release_channel(pch->pl330_chid);
 	pch->pl330_chid = NULL;
 
-- 
1.7.10.4


