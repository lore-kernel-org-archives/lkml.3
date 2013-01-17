Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3AQKaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:30:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:49714 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab3AQKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="248240258"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] i2c-designware: always set the STOP bit after last byte
Date: Thu, 17 Jan 2013 12:31:05 +0200
Message-Id: <1358418667-4533-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If IC_EMPTYFIFO_HOLD_MASTER_EN is set to one, the DesignWare I2C controller
doesn't generate STOP on the bus when the FIFO is empty. This violates the
rules of Linux I2C stack as it requires that the STOP is issued once the
i2c_transfer() is finished.

However, there is no way to detect this from the hardware registers, so we
must make sure that the STOP bit is always set once the last byte of the
last message is transferred.

This patch is based on the work of Dirk Brandewie.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index f5258c2..94fd818 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -413,11 +413,23 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 		rx_limit = dev->rx_fifo_depth - dw_readl(dev, DW_IC_RXFLR);
 
 		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
+			u32 cmd = 0;
+
+			/*
+			 * If IC_EMPTYFIFO_HOLD_MASTER_EN is set we must
+			 * manually set the stop bit. However, it cannot be
+			 * detected from the registers so we set it always
+			 * when writing/reading the last byte.
+			 */
+			if (dev->msg_write_idx == dev->msgs_num - 1 &&
+			    buf_len == 1)
+				cmd |= BIT(9);
+
 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
-				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
+				dw_writel(dev, cmd | 0x100, DW_IC_DATA_CMD);
 				rx_limit--;
 			} else
-				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
+				dw_writel(dev, cmd | *buf++, DW_IC_DATA_CMD);
 			tx_limit--; buf_len--;
 		}
 
-- 
1.7.10.4

