Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab3GSCcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935020Ab3GSCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:23:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 18/18] drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
Date: Thu, 18 Jul 2013 19:23:33 -0700
Message-Id: <20130719021050.204528358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719021048.965829361@linuxfoundation.org>
References: <20130719021048.965829361@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pl330.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -281,10 +281,10 @@ static void pl330_free_chan_resources(st
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);
-
 	tasklet_kill(&pch->task);
 
+	spin_lock_irqsave(&pch->lock, flags);
+
 	pl330_release_channel(pch->pl330_chid);
 	pch->pl330_chid = NULL;
 


