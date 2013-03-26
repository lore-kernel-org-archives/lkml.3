Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3CZWmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:42:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:14105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3CZWmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349379"
Subject: [PATCH 02/10] ioatdma: Add 64bit chansts register read for ioat
 v3.3.
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:42:41 -0700
Message-ID: <20130326224241.15072.88757.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channel status register for v3.3 is now 64bit. Use readq if available
on v3.3 platforms.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma.h |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 95ae7b3..9285caa 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -201,7 +201,7 @@ ioat_chan_by_index(struct ioatdma_device *device, int index)
 	return device->idx[index];
 }
 
-static inline u64 ioat_chansts(struct ioat_chan_common *chan)
+static inline u64 ioat_chansts_32(struct ioat_chan_common *chan)
 {
 	u8 ver = chan->device->version;
 	u64 status;
@@ -218,6 +218,26 @@ static inline u64 ioat_chansts(struct ioat_chan_common *chan)
 	return status;
 }
 
+#if BITS_PER_LONG == 64
+
+static inline u64 ioat_chansts(struct ioat_chan_common *chan)
+{
+	u8 ver = chan->device->version;
+	u64 status;
+
+	 /* With IOAT v3.3 the status register is 64bit.  */
+	if (ver >= IOAT_VER_3_3)
+		status = readq(chan->reg_base + IOAT_CHANSTS_OFFSET(ver));
+	else
+		status = ioat_chansts_32(chan);
+
+	return status;
+}
+
+#else
+#define ioat_chansts ioat_chansts_32
+#endif
+
 static inline void ioat_start(struct ioat_chan_common *chan)
 {
 	u8 ver = chan->device->version;

