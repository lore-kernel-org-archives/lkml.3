Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3EHOcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:32:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:58533 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab3EHOcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,635,1363158000"; 
   d="scan'208,223";a="299419208"
Date: Wed, 8 May 2013 14:34:36 +0100 (IST)
From: Josef Ahmad <josef.ahmad@linux.intel.com>
X-X-Sender: joey@localhost
To: Wolfram Sang <wsa@the-dreams.de>
cc: Josef Ahmad <josef.ahmad@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        Stefan Roese <sr@denx.de>, Axel Lin <axel.lin@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
In-Reply-To: <20130425174348.GA3612@the-dreams.de>
Message-ID: <alpine.DEB.2.02.1305081433430.7163@localhost>
References: <alpine.DEB.2.02.1304191859570.17829@localhost> <20130422071943.GK1283@intel.com> <53398.163.33.213.79.1366630241.squirrel@linux.intel.com> <20130422122808.GO1283@intel.com> <alpine.DEB.2.02.1304221508050.31571@localhost> <20130423163543.GB3228@the-dreams.de>
 <51465.163.33.213.85.1366739082.squirrel@linux.intel.com> <20130423182707.GA3649@the-dreams.de> <alpine.DEB.2.02.1304241110480.32505@localhost> <20130425174348.GA3612@the-dreams.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8a4773d0c0df6fe2e816ad37fde30a2d90a1ad31 Mon Sep 17 00:00:00 2001
From: Josef Ahmad <josef.ahmad@linux.intel.com>
Date: Fri, 19 Apr 2013 17:28:10 +0100
Subject: [PATCH] i2c-designware: fix RX FIFO overrun

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
---
 drivers/i2c/busses/i2c-designware-core.c |   11 ++++++++++-
 drivers/i2c/busses/i2c-designware-core.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 21fbb34..1f06c8e 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -448,8 +448,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 				cmd |= BIT(9);

 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
+
+				/* avoid rx buffer overrun */
+				if (rx_limit - dev->rx_outstanding <= 0)
+					break;
+
 				dw_writel(dev, cmd | 0x100, DW_IC_DATA_CMD);
 				rx_limit--;
+				dev->rx_outstanding++;
 			} else
 				dw_writel(dev, cmd | *buf++, DW_IC_DATA_CMD);
 			tx_limit--; buf_len--;
@@ -502,8 +508,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)

 		rx_valid = dw_readl(dev, DW_IC_RXFLR);

-		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
+		for (; len > 0 && rx_valid > 0; len--, rx_valid--) {
 			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
+			dev->rx_outstanding--;
+		}

 		if (len > 0) {
 			dev->status |= STATUS_READ_IN_PROGRESS;
@@ -561,6 +569,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
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
1.7.0.7


