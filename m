Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3FMRX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:23:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:16907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab3FMRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,860,1363158000"; 
   d="scan'208";a="316584763"
Date: Thu, 13 Jun 2013 10:24:20 -0700
From: Jubin Mehta <jubin.mehta@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Subject: [PATCH] dmatest: masking tests for channel capabilities
Message-ID: <20130613172408.GA5561@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current dmatest module tests all the hardware capabilities (MEMCPY, XOR
and PQ) supported by a particular DMA channel and these tests are performed
concurrently by default. This patch allows the user to enable or disable the
test performed for any particular capability. The mask bits for enabling the
tests are set using the debugfs.

Signed-off-by: Jubin Mehta <jubin.mehta@intel.com>
---
 Documentation/dmatest.txt |   32 ++++++++++++++++++++++++++++++++
 drivers/dma/dmatest.c     |   41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
index 132a094..e5fd29c 100644
--- a/Documentation/dmatest.txt
+++ b/Documentation/dmatest.txt
@@ -79,3 +79,35 @@ Comparison between buffers is stored to the dedicated structure.
 
 Note that the verify result is now accessible only via file 'results' in the
 debugfs.
+
+	Part 5 - Masking tests for channel capabilities
+
+By default, the dmatest module concurrently tests all the hardware capabilities
+(MEMCPY, XOR and PQ) supported by a particular DMA channel. In order to disable
+any capability/capabilities from being tested, the user needs to modify the
+file 'cap_mask' in debugfs.
+
+Method to enable the capabilities:
+
+PATH = /sys/kernel/debug/dmatest/cap_mask
+(DEFAULT) echo 0x07 > $PATH     // Set Bits 0,1,2 for MEMCPY, XOR and PQ
+          echo 0x01 > $PATH     // Set bit 0 to enable MEMCPY
+          echo 0x02 > $PATH     // Set bit 1 to enable XOR
+          echo 0x04 > $PATH     // Set bit 2 to enable PQ
+
+Example to perform only MEMCPY and PQ mode tests (0x01 | 0x04 = 0x05):
+
+        % modprobe dmatest
+        % echo dma0chan0 > /sys/kernel/debug/dmatest/channel
+        % echo 5  > /sys/kernel/debug/dmatest/cap_mask
+        % echo 1 > /sys/kernel/debug/dmatest/iterations
+        % echo 1 > /sys/kernel/debug/dmatest/run
+
+	Output:
+	% cat /sys/kernel/debug/dmatest/results
+
+        dma0chan0-copy0: #1: No errors with src_off=0xXX dst_off=0xXX len=0xXX
+        dma0chan0-pq0: #1: No errors with src_off=0xXX dst_off=0xXX len=0xXX
+
+Note that the result is available only for the enabled capabilities of
+particular channel.
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e88ded2..5420fc7 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -24,6 +24,21 @@
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 
+/*
+ * Capability Mask Bits.The bits in the cap_mask denote the masking of
+ * the hardware capabilities of the dma channel.
+ *
+ * DMA_CAP_MEMCPY:  Bit 0 for enabling DMA_MEMCPY capability
+ * DMA_CAP_XOR:     Bit 1 for enabling DMA_XOR capabilit
+ * DMA_CAP_PQ:      Bit 2 for enabling DMA_PQ capability
+ * DMA_CAP_ALL:     Enable all the capabilities of the channel
+ */
+#define DMA_CAP_MEMCPY		(1 << 0)
+#define DMA_CAP_XOR		(1 << 1)
+#define DMA_CAP_PQ		(1 << 2)
+
+#define DMA_CAP_ALL		(DMA_CAP_MEMCPY | DMA_CAP_XOR | DMA_CAP_PQ)
+
 static unsigned int test_buf_size = 16384;
 module_param(test_buf_size, uint, S_IRUGO);
 MODULE_PARM_DESC(test_buf_size, "Size of the memcpy test buffer");
@@ -66,6 +81,11 @@ module_param(timeout, uint, S_IRUGO);
 MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
 		 "Pass -1 for infinite timeout");
 
+static unsigned int cap_mask = DMA_CAP_ALL;
+module_param(cap_mask, uint, S_IRUGO);
+MODULE_PARM_DESC(cap_mask,
+		"Mask bits for different capability test (default: 0x07)");
+
 /* Maximum amount of mismatched bytes in buffer to print */
 #define MAX_ERROR_COUNT		32
 
@@ -164,6 +184,7 @@ struct dmatest_chan {
  * @xor_sources:	number of xor source buffers
  * @pq_sources:		number of p+q source buffers
  * @timeout:		transfer timeout in msec, -1 for infinite timeout
+ * @cap_mask:		mask for different hardware capabilities tests
  */
 struct dmatest_params {
 	unsigned int	buf_size;
@@ -175,6 +196,7 @@ struct dmatest_params {
 	unsigned int	xor_sources;
 	unsigned int	pq_sources;
 	int		timeout;
+	unsigned int	cap_mask;
 };
 
 /**
@@ -887,6 +909,7 @@ static int dmatest_add_channel(struct dmatest_info *info,
 {
 	struct dmatest_chan	*dtc;
 	struct dma_device	*dma_dev = chan->device;
+	struct dmatest_params	*params;
 	unsigned int		thread_count = 0;
 	int cnt;
 
@@ -898,16 +921,21 @@ static int dmatest_add_channel(struct dmatest_info *info,
 
 	dtc->chan = chan;
 	INIT_LIST_HEAD(&dtc->threads);
+	params = &info->params;
 
-	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
+	/* Run dmatest threads for the supported and enabled capabilities */
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) &&
+	    params->cap_mask & DMA_CAP_MEMCPY) {
 		cnt = dmatest_add_threads(info, dtc, DMA_MEMCPY);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
-	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) &&
+	    params->cap_mask & DMA_CAP_XOR) {
 		cnt = dmatest_add_threads(info, dtc, DMA_XOR);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
-	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask) &&
+	    params->cap_mask & DMA_CAP_PQ) {
 		cnt = dmatest_add_threads(info, dtc, DMA_PQ);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
@@ -1248,6 +1276,12 @@ static int dmatest_register_dbgfs(struct dmatest_info *info)
 	if (IS_ERR_OR_NULL(d))
 		goto err_node;
 
+	/* Mask bits for hardware capabilities tests */
+	d = debugfs_create_u32("cap_mask", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->cap_mask);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
 	/* Run or stop threaded test */
 	d = debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root,
 				info, &dtf_run_fops);
@@ -1293,6 +1327,7 @@ static int __init dmatest_init(void)
 	params->xor_sources = xor_sources;
 	params->pq_sources = pq_sources;
 	params->timeout = timeout;
+	params->cap_mask = cap_mask;
 
 	ret = dmatest_register_dbgfs(info);
 	if (ret)
-- 
1.7.9.5

