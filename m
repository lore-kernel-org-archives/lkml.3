Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaAILPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:15:30 -0500
Received: from atl4mhfb01.myregisteredsite.com ([209.17.115.55]:54177 "EHLO
	atl4mhfb01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbaAILMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:05 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com, khilman@deeprootsystems.com,
        wsa@the-dreams.de, davinci-linux-open-source@linux.davincidsp.com,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] i2c-davinci: Handle signals gracefully
Date: Thu,  9 Jan 2014 12:11:25 +0100
Message-Id: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a signal is caught while the i2c-davinci bus driver is transferring,
the drive just "abandons" the transfer and leaves the controller to fend
for itself. The next I2C transaction will find the controller in an
undefined state and often results in a stream of "initiating i2c bus recovery"
messages until the controller arrives in a defined state. This behaviour
also sends out "half" or possibly even mixed messages to I2C client
devices which may put them in an undesired state as well.

This patch fixes this issue by always attempting to finish the current
transaction, and then check on a pending signal. It either reports
success if all data has been transferred, or it returns failure when
the transaction was aborted. This keeps the controller in a defined
state, and is also much friendlier towards client devices, because
it will only send complete messages.

Before this patch, reading an I2C device in a loop and interrupting it
often resulted in a "initiating i2c bus recovery" storm and not being
able to communicate via I2C for several seconds. With this patch, the
userspace call simply returns EINTR and the next I2C transaction
succeeds without errors.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/i2c/busses/i2c-davinci.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 132369f..102673b 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -372,9 +372,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 		flag |= DAVINCI_I2C_MDR_STP;
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
 
-	r = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
+	r = wait_for_completion_timeout(&dev->cmd_complete,
 						      dev->adapter.timeout);
-	if (r == 0) {
+	if (unlikely(r == 0)) {
 		dev_err(dev->dev, "controller timed out\n");
 		davinci_i2c_recover_bus(dev);
 		i2c_davinci_init(dev);
@@ -384,7 +384,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 	if (dev->buf_len) {
 		/* This should be 0 if all bytes were transferred
 		 * or dev->cmd_err denotes an error.
-		 * A signal may have aborted the transfer.
 		 */
 		if (r >= 0) {
 			dev_err(dev->dev, "abnormal termination buf_len=%i\n",
@@ -436,22 +435,30 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = i2c_davinci_wait_bus_not_busy(dev, 1);
 	if (ret < 0) {
 		dev_warn(dev->dev, "timeout waiting for bus ready\n");
-		return ret;
+		goto error;
 	}
 
 	for (i = 0; i < num; i++) {
+		if (signal_pending(current)) {
+			dev_dbg(dev->dev, "%s [%d/%d] %#x ERESTARTSYS\n",
+					__func__, i + 1, num, msgs[i].addr);
+			ret = -ERESTARTSYS;
+			goto error;
+		}
 		ret = i2c_davinci_xfer_msg(adap, &msgs[i], (i == (num - 1)));
-		dev_dbg(dev->dev, "%s [%d/%d] ret: %d\n", __func__, i + 1, num,
-			ret);
+		dev_dbg(dev->dev, "%s [%d/%d] %#x ret: %d\n", __func__, i + 1,
+				num, msgs[i].addr, ret);
 		if (ret < 0)
-			return ret;
+			goto error;
 	}
+	ret = num;
 
+error:
 #ifdef CONFIG_CPU_FREQ
 	complete(&dev->xfr_complete);
 #endif
 
-	return num;
+	return ret;
 }
 
 static u32 i2c_davinci_func(struct i2c_adapter *adap)
-- 
1.7.9.5

