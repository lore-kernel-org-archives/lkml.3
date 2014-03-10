Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaCJLNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:13:10 -0400
Received: from atl4mhfb03.myregisteredsite.com ([209.17.115.61]:45939 "EHLO
	atl4mhfb03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbaCJLNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:13:08 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: git@xilinx.com, wsa@the-dreams.de, linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
Date: Mon, 10 Mar 2014 12:12:34 +0100
Message-Id: <1394449954-10797-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pressing CTRL-C while communicating with an I2C device leads to erratic
behaviour. The cause is that the controller will interrupt the I2C transfer
in progress, and leave the client device in an undefined state. Many
drivers do not handle error return codes on I2C transfers. The calling driver
has no way of telling how much of the transfer has actually completed, so
it cannot reliably determine the device's state.

The best solution here is to not handle signals in the I2C bus driver at all,
but always complete a transaction before returning control.

See for a related patch and discussion on this topic:
http://lkml.org/lkml/2014/1/9/246
---
 drivers/i2c/busses/i2c-cadence.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 86713d6..32ce2ee 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -452,16 +452,12 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 			cdns_i2c_msend(id);
 
 		/* Wait for the signal of completion */
-		ret = wait_for_completion_interruptible_timeout(
-							&id->xfer_done, HZ);
-		if (ret < 1) {
+		ret = wait_for_completion_timeout(&id->xfer_done, HZ);
+		if (ret == 0) {
 			cdns_i2c_master_reset(adap);
-			if (!ret) {
-				dev_err(id->adap.dev.parent,
+			dev_err(id->adap.dev.parent,
 					"timeout waiting on completion\n");
-				return -ETIMEDOUT;
-			}
-			return ret;
+			return -ETIMEDOUT;
 		}
 		cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK,
 				  CDNS_I2C_IDR_OFFSET);
-- 
1.7.9.5

