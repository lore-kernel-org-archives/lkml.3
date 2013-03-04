Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3CDJLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:11:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:4286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3CDJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208485578"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 01/10] dmatest: cancel thread immediately when asked for
Date: Mon,  4 Mar 2013 11:09:25 +0200
Message-Id: <1362388174-3435-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user have the timeout alike issues and wants to cancel the thread
immediately, the current call of wait_event_freezable_timeout is preventing to
this until timeout is expired. Thus, user will experience the unnecessary
delays.

Adding kthread_should_stop() check inside wait_event_freezable_timeout() solves
that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a2c8904..e6b4cfa 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -454,7 +454,8 @@ static int dmatest_func(void *data)
 		}
 		dma_async_issue_pending(chan);
 
-		wait_event_freezable_timeout(done_wait, done.done,
+		wait_event_freezable_timeout(done_wait,
+					     done.done || kthread_should_stop(),
 					     msecs_to_jiffies(timeout));
 
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
-- 
1.8.2.rc0.22.gb3600c3

