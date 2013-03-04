Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3CDJMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:12:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:4286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab3CDJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208485576"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 04/10] dmatest: move dmatest_channels and nr_channels to dmatest_info
Date: Mon,  4 Mar 2013 11:09:28 +0200
Message-Id: <1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to have them global and later we would like to protect access to
them as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 7f9e3cc..475a21a 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -109,6 +109,7 @@ struct dmatest_chan {
  * @timeout:		transfer timeout in msec, -1 for infinite timeout
  */
 struct dmatest_info {
+	/* Test parameters */
 	unsigned int	buf_size;
 	char		channel[20];
 	char		device[20];
@@ -118,17 +119,14 @@ struct dmatest_info {
 	unsigned int	xor_sources;
 	unsigned int	pq_sources;
 	int		timeout;
+
+	/* Internal state */
+	struct list_head	channels;
+	unsigned int		nr_channels;
 };
 
 static struct dmatest_info test_info;
 
-/*
- * These are protected by dma_list_mutex since they're only used by
- * the DMA filter function callback
- */
-static LIST_HEAD(dmatest_channels);
-static unsigned int nr_channels;
-
 static bool dmatest_match_channel(struct dmatest_info *info,
 		struct dma_chan *chan)
 {
@@ -690,8 +688,8 @@ static int dmatest_add_channel(struct dmatest_info *info,
 	pr_info("dmatest: Started %u threads using %s\n",
 		thread_count, dma_chan_name(chan));
 
-	list_add_tail(&dtc->node, &dmatest_channels);
-	nr_channels++;
+	list_add_tail(&dtc->node, &info->channels);
+	info->nr_channels++;
 
 	return 0;
 }
@@ -725,7 +723,8 @@ static int run_threaded_test(struct dmatest_info *info)
 			}
 		} else
 			break; /* no more channels available */
-		if (info->max_channels && nr_channels >= info->max_channels)
+		if (info->max_channels &&
+		    info->nr_channels >= info->max_channels)
 			break; /* we have all we need */
 	}
 	return err;
@@ -736,14 +735,15 @@ static void stop_threaded_test(struct dmatest_info *info)
 	struct dmatest_chan *dtc, *_dtc;
 	struct dma_chan *chan;
 
-	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
+	list_for_each_entry_safe(dtc, _dtc, &info->channels, node) {
 		list_del(&dtc->node);
 		chan = dtc->chan;
 		dmatest_cleanup_channel(dtc);
-		pr_debug("dmatest: dropped channel %s\n",
-			 dma_chan_name(chan));
+		pr_debug("dmatest: dropped channel %s\n", dma_chan_name(chan));
 		dma_release_channel(chan);
 	}
+
+	info->nr_channels = 0;
 }
 
 static int __init dmatest_init(void)
@@ -752,6 +752,9 @@ static int __init dmatest_init(void)
 
 	memset(info, 0, sizeof(*info));
 
+	INIT_LIST_HEAD(&info->channels);
+
+	/* Set default parameters */
 	info->buf_size = test_buf_size;
 	strlcpy(info->channel, test_channel, sizeof(info->channel));
 	strlcpy(info->device, test_device, sizeof(info->device));
-- 
1.8.2.rc0.22.gb3600c3

