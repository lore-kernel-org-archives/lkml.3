Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3JVVII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:8001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3JVVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,550,1378882800"; 
   d="scan'208";a="415395723"
Subject: [PATCH v2 01/13] dmatest: make driver unmap also source buffers by
 itself
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: dave.jiang@intel.com, b.zolnierkie@samsung.com, vinod.koul@intel.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        andriy.shevchenko@linux.intel.com
Date: Tue, 22 Oct 2013 14:08:01 -0700
Message-ID: <20131022210801.31111.58095.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-2-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-2-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Make the driver DMA unmap also source buffers by itself
(currently it DMA unmaps only destination buffers) as
a preparation for introducing generic 'ummap' data.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 drivers/dma/dmatest.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 92f796cdc6ab..f4a2a25fae31 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -597,11 +597,10 @@ static int dmatest_func(void *data)
 	set_user_nice(current, 10);
 
 	/*
-	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
-	 * dst buffers are freed by ourselves below
+	 * src and dst buffers are freed by ourselves below
 	 */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
-	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
+		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 
 	while (!kthread_should_stop()
 	       && !(params->iterations && total_tests >= params->iterations)) {
@@ -750,7 +749,8 @@ static int dmatest_func(void *data)
 			continue;
 		}
 
-		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
+		/* Unmap by myself */
+		unmap_src(dev->dev, dma_srcs, len, src_cnt);
 		unmap_dst(dev->dev, dma_dsts, params->buf_size, dst_cnt);
 
 		error_count = 0;

