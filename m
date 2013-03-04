Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3CDJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:09:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:64910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab3CDJJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="270536359"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 02/10] dmatest: allocate memory for pq_coefs from heap
Date: Mon,  4 Mar 2013 11:09:26 +0200
Message-Id: <1362388174-3435-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help in future to hide a global variable usage.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e6b4cfa..e3955be 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -278,7 +278,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
-	u8			pq_coefs[pq_sources + 1];
+	u8			*pq_coefs = NULL;
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -302,10 +302,15 @@ static int dmatest_func(void *data)
 		/* force odd to ensure dst = src */
 		src_cnt = min_odd(pq_sources | 1, dma_maxpq(dev, 0));
 		dst_cnt = 2;
+
+		pq_coefs = kmalloc(pq_sources+1, GFP_KERNEL);
+		if (!pq_coefs)
+			goto err_thread_type;
+
 		for (i = 0; i < src_cnt; i++)
 			pq_coefs[i] = 1;
 	} else
-		goto err_srcs;
+		goto err_thread_type;
 
 	thread->srcs = kcalloc(src_cnt+1, sizeof(u8 *), GFP_KERNEL);
 	if (!thread->srcs)
@@ -533,6 +538,8 @@ err_dsts:
 err_srcbuf:
 	kfree(thread->srcs);
 err_srcs:
+	kfree(pq_coefs);
+err_thread_type:
 	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
 			thread_name, total_tests, failed_tests, ret);
 
-- 
1.8.2.rc0.22.gb3600c3

