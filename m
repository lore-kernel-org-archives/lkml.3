Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbbAIRWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:22:41 -0500
Received: from sauhun.de ([89.238.76.85]:49604 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbbAIRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:30 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 11/11] i2c: pmcmsp: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:41 +0100
Message-Id: <1420824103-24169-12-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-pmcmsp.c | 42 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 44f03eed00dd..e06efee9fa70 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -463,14 +463,6 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_xfer_cmd(
 		return -EINVAL;
 	}
 
-	if (cmd->read_len > MSP_MAX_BYTES_PER_RW ||
-	    cmd->write_len > MSP_MAX_BYTES_PER_RW) {
-		dev_err(&pmcmsptwi_adapter.dev,
-			"%s: Cannot transfer more than %d bytes\n",
-			__func__, MSP_MAX_BYTES_PER_RW);
-		return -EINVAL;
-	}
-
 	mutex_lock(&data->lock);
 	dev_dbg(&pmcmsptwi_adapter.dev,
 		"Setting address to 0x%04x\n", cmd->addr);
@@ -527,25 +519,14 @@ static int pmcmsptwi_master_xfer(struct i2c_adapter *adap,
 	struct pmcmsptwi_cfg oldcfg, newcfg;
 	int ret;
 
-	if (num > 2) {
-		dev_dbg(&adap->dev, "%d messages unsupported\n", num);
-		return -EINVAL;
-	} else if (num == 2) {
-		/* Check for a dual write-then-read command */
+	if (num == 2) {
 		struct i2c_msg *nextmsg = msg + 1;
-		if (!(msg->flags & I2C_M_RD) &&
-		    (nextmsg->flags & I2C_M_RD) &&
-		    msg->addr == nextmsg->addr) {
-			cmd.type = MSP_TWI_CMD_WRITE_READ;
-			cmd.write_len = msg->len;
-			cmd.write_data = msg->buf;
-			cmd.read_len = nextmsg->len;
-			cmd.read_data = nextmsg->buf;
-		} else {
-			dev_dbg(&adap->dev,
-				"Non write-read dual messages unsupported\n");
-			return -EINVAL;
-		}
+
+		cmd.type = MSP_TWI_CMD_WRITE_READ;
+		cmd.write_len = msg->len;
+		cmd.write_data = msg->buf;
+		cmd.read_len = nextmsg->len;
+		cmd.read_data = nextmsg->buf;
 	} else if (msg->flags & I2C_M_RD) {
 		cmd.type = MSP_TWI_CMD_READ;
 		cmd.read_len = msg->len;
@@ -605,6 +586,14 @@ static u32 pmcmsptwi_i2c_func(struct i2c_adapter *adapter)
 		I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_PROC_CALL;
 }
 
+static struct i2c_adapter_quirks pmcmsptwi_i2c_quirks = {
+	.flags = I2C_ADAPTER_QUIRK_COMB_WRITE_THEN_READ,
+	.max_write_len = MSP_MAX_BYTES_PER_RW,
+	.max_read_len = MSP_MAX_BYTES_PER_RW,
+	.max_comb_write_len = MSP_MAX_BYTES_PER_RW,
+	.max_comb_read_len = MSP_MAX_BYTES_PER_RW,
+};
+
 /* -- Initialization -- */
 
 static struct i2c_algorithm pmcmsptwi_algo = {
@@ -616,6 +605,7 @@ static struct i2c_adapter pmcmsptwi_adapter = {
 	.owner		= THIS_MODULE,
 	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
 	.algo		= &pmcmsptwi_algo,
+	.quirks		= &pmcmsptwi_i2c_quirks,
 	.name		= DRV_NAME,
 };
 
-- 
2.1.3

