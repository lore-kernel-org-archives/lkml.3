Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3FDRBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:01:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3FDRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Ahmad <josef.ahmad@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 24/75] i2c: designware: fix RX FIFO overrun
Date: Tue,  4 Jun 2013 09:55:08 -0700
Message-Id: <1370364959-9475-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Ahmad <josef.ahmad@linux.intel.com>

commit e6f34cea56f5b95498070eaa9f4aa3ba4a9e4f62 upstream.

i2c_dw_xfer_msg() pushes a number of bytes to transmit/receive
to/from the bus into the TX FIFO.
For master-rx transactions, the maximum amount of data that can be
received is calculated depending solely on TX and RX FIFO load.

This is racy - TX FIFO may contain master-rx data yet to be
processed, which will eventually land into the RX FIFO. This
data is not taken into account and the function may request more
data than the controller is actually capable of storing.

This patch ensures the driver takes into account the outstanding
master-rx data in TX FIFO to prevent RX FIFO overrun.

Signed-off-by: Josef Ahmad <josef.ahmad@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-designware-core.c | 11 ++++++++++-
 drivers/i2c/busses/i2c-designware-core.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index f5258c2..9a6aad8 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -414,8 +414,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 
 		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
+
+				/* avoid rx buffer overrun */
+				if (rx_limit - dev->rx_outstanding <= 0)
+					break;
+
 				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
 				rx_limit--;
+				dev->rx_outstanding++;
 			} else
 				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
 			tx_limit--; buf_len--;
@@ -468,8 +474,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 
 		rx_valid = dw_readl(dev, DW_IC_RXFLR);
 
-		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
+		for (; len > 0 && rx_valid > 0; len--, rx_valid--) {
 			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
+			dev->rx_outstanding--;
+		}
 
 		if (len > 0) {
 			dev->status |= STATUS_READ_IN_PROGRESS;
@@ -527,6 +535,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	dev->msg_err = 0;
 	dev->status = STATUS_IDLE;
 	dev->abort_source = 0;
+	dev->rx_outstanding = 0;
 
 	ret = i2c_dw_wait_bus_not_busy(dev);
 	if (ret < 0)
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 9c1840e..e761ad1 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -60,6 +60,7 @@
  * @adapter: i2c subsystem adapter node
  * @tx_fifo_depth: depth of the hardware tx fifo
  * @rx_fifo_depth: depth of the hardware rx fifo
+ * @rx_outstanding: current master-rx elements in tx fifo
  */
 struct dw_i2c_dev {
 	struct device		*dev;
@@ -88,6 +89,7 @@ struct dw_i2c_dev {
 	u32			master_cfg;
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
+	int			rx_outstanding;
 };
 
 #define ACCESS_SWAP		0x00000001
-- 
1.8.1.2

