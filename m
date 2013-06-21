Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3FUHJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:09:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:53672 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab3FUHJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,911,1363158000"; 
   d="scan'208";a="258139086"
From: Chew Chiau Ee <chiaue.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-designware: Manually set RESTART bit between messages
Date: Fri, 21 Jun 2013 15:05:28 +0800
Message-Id: <1371798328-31931-1-git-send-email-chiaue.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

If both IC_EMPTYFIFO_HOLD_MASTER_EN and IC_RESTART_EN are set to 1, the
Designware I2C controller doesn't generate RESTART unless user specifically
requests it by setting RESTART bit in IC_DATA_CMD register.

Since IC_EMPTYFIFO_HOLD_MASTER_EN setting can't be detected from hardware
register, we must always manually set the restart bit between messages.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3de5494..9348439 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -403,6 +403,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	u32 addr = msgs[dev->msg_write_idx].addr;
 	u32 buf_len = dev->tx_buf_len;
 	u8 *buf = dev->tx_buf;
+	bool need_restart = false;
 
 	intr_mask = DW_IC_INTR_DEFAULT_MASK;
 
@@ -430,6 +431,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 			/* new i2c_msg */
 			buf = msgs[dev->msg_write_idx].buf;
 			buf_len = msgs[dev->msg_write_idx].len;
+
+			/* If both IC_EMPTYFIFO_HOLD_MASTER_EN and
+			 * IC_RESTART_EN are set, we must manually
+			 * set restart bit between messages.
+			 */
+			if ((dev->master_cfg & DW_IC_CON_RESTART_EN) &&
+					(dev->msg_write_idx > 0))
+				need_restart = true;
 		}
 
 		tx_limit = dev->tx_fifo_depth - dw_readl(dev, DW_IC_TXFLR);
@@ -448,6 +457,11 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 			    buf_len == 1)
 				cmd |= BIT(9);
 
+			if (need_restart) {
+				cmd |= BIT(10);
+				need_restart = false;
+			}
+
 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
 
 				/* avoid rx buffer overrun */
-- 
1.7.4.4

