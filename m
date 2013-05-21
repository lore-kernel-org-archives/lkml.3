Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3EUMdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:33:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:16463 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab3EUMdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="337585073"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, "djbw @ fb . com" <djbw@fb.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel @ lists . infradead . org" 
	<linux-arm-kernel@lists.infradead.org>,
        viresh.kumar@linaro.org, Will Deacon <will.deacon@arm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dmatest: abort transfers immediately when asked for
Date: Tue, 21 May 2013 15:33:17 +0300
Message-Id: <1369139597-24446-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <20130516153553.GI11706@mudshark.cambridge.arm.com>
References: <20130516153553.GI11706@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When thread is going to be stopped we have to unconditionally terminate all
ongoing transfers. Otherwise it would be possible that callback function will
be called on the next interrupt and will try to access to already freed
structures.

The patch introduces specific error message for this, though it doesn't
increase the counter of the failed tests.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Will Deacon <will.deacon@arm.com>
---
 drivers/dma/dmatest.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index d8ce4ec..f61bd55 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -92,6 +92,7 @@ enum dmatest_error_type {
 	DMATEST_ET_MAP_DST,
 	DMATEST_ET_PREP,
 	DMATEST_ET_SUBMIT,
+	DMATEST_ET_ABORT,
 	DMATEST_ET_TIMEOUT,
 	DMATEST_ET_DMA_ERROR,
 	DMATEST_ET_DMA_IN_PROGRESS,
@@ -366,6 +367,7 @@ static char *thread_result_get(const char *name,
 		[DMATEST_ET_MAP_DST]		= "dst mapping error",
 		[DMATEST_ET_PREP]		= "prep error",
 		[DMATEST_ET_SUBMIT]		= "submit error",
+		[DMATEST_ET_ABORT]		= "transfer aborted",
 		[DMATEST_ET_TIMEOUT]		= "test timed out",
 		[DMATEST_ET_DMA_ERROR]		=
 			"got completion callback (DMA_ERROR)",
@@ -720,6 +722,15 @@ static int dmatest_func(void *data)
 					     done.done || kthread_should_stop(),
 					     msecs_to_jiffies(params->timeout));
 
+		/* terminate all transfers on specified channel if needed */
+		if (kthread_should_stop()) {
+			dmaengine_terminate_all(chan);
+			thread_result_add(info, result, DMATEST_ET_ABORT,
+					  total_tests, src_off, dst_off,
+					  len, 0);
+			break;
+		}
+
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
 		if (!done.done) {
-- 
1.8.2.rc0.22.gb3600c3

