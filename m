Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3GKO0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3GKO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/98] drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
Date: Thu, 11 Jul 2013 15:24:03 +0100
Message-Id: <1373552708-15235-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

commit da331ba8e9c5de72a27e50f71105395bba6eebe0 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/pl330.c | 4 ++--
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
1.8.1.2

