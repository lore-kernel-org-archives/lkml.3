Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab3FCWai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:30:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617Ab3FCWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:09 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=I6pDyOqm2H0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9iIL5vr-jqAA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=kKYT5eKs3oqT1hgg5nIA:9 a=Ku4giSwJSw0A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=UcRY56jwkfhuJuQi:21 a=NONVn2tE7BDOZwT4:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.861570598@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josef Ahmad <josef.ahmad@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, <stable@kernel.org>
Subject: [62/65] i2c: designware: fix RX FIFO overrun
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0062-i2c-designware-fix-RX-FIFO-overrun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Ahmad <josef.ahmad@linux.intel.com>

[ Upstream commit e6f34cea56f5b95498070eaa9f4aa3ba4a9e4f62 ]

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
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/i2c/busses/i2c-designware-core.c |   11 ++++++++++-
 drivers/i2c/busses/i2c-designware-core.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 7b8ebbe..37b1221 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -413,8 +413,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 
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
@@ -467,8 +473,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 
 		rx_valid = dw_readl(dev, DW_IC_RXFLR);
 
-		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
+		for (; len > 0 && rx_valid > 0; len--, rx_valid--) {
 			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
+			dev->rx_outstanding--;
+		}
 
 		if (len > 0) {
 			dev->status |= STATUS_READ_IN_PROGRESS;
@@ -526,6 +534,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
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
1.7.10.4


