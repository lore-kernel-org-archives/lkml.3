Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaLBKHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:07:11 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:50110 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaLBKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:07:06 -0500
From: Harini Katakam <harinik@xilinx.com>
To: wsa@the-dreams.de, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        harinik@xilinx.com, vishnum@xilinx.com
Subject: [PATCH 4/4] i2c: cadence: Defeature repeated start based on devicetree property
Date: Tue,  2 Dec 2014 15:35:49 +0530
Message-Id: <1417514749-24319-5-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vishnu Motghare <vishnum@xilinx.com>

This patch defeatures repeated start in the driver if
"defeature-repeated-start" property is present in the devicetree.

This defeature is proposed due to a few bugs in the controller
- completion indication is not given to the driver at the end of
a read/receive transfer with HOLD bit set.
- Invalid read transaction are generated on the bus when HW timeout
condition occurs with HOLD bit set.

Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
Signed-off-by: Harini Katakam <harinik@xilinx.com>
---
 drivers/i2c/busses/i2c-cadence.c |   44 +++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 8065205..89335f7 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -135,6 +135,7 @@
  * @bus_hold_flag:	Flag used in repeated start for clearing HOLD bit
  * @clk:		Pointer to struct clk
  * @clk_rate_change_nb:	Notifier block for clock rate changes
+ * @defeature_repeated_start:	Flag to de feature repeated start
  */
 struct cdns_i2c {
 	void __iomem *membase;
@@ -154,6 +155,7 @@ struct cdns_i2c {
 	unsigned int bus_hold_flag;
 	struct clk *clk;
 	struct notifier_block clk_rate_change_nb;
+	unsigned int defeature_repeated_start;
 };
 
 #define to_cdns_i2c(_nb)	container_of(_nb, struct cdns_i2c, \
@@ -246,7 +248,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 		}
 
 		if ((isr_status & CDNS_I2C_IXR_COMP) && !id->recv_count) {
-			if (!id->bus_hold_flag)
+			if (id->defeature_repeated_start || !id->bus_hold_flag)
 				cdns_i2c_clear_bus_hold(id);
 			done_flag = 1;
 		}
@@ -283,7 +285,8 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 			 */
 			done_flag = 1;
 		}
-		if (!id->send_count && !id->bus_hold_flag)
+		if ((id->defeature_repeated_start && !id->send_count) ||
+		    (!id->send_count && !id->bus_hold_flag))
 			cdns_i2c_clear_bus_hold(id);
 
 		status = IRQ_HANDLED;
@@ -347,10 +350,15 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	} else
 		cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
 	/* Clear the bus hold flag if bytes to receive is less than FIFO size */
-	if (!id->bus_hold_flag &&
-		((id->p_msg->flags & I2C_M_RECV_LEN) != I2C_M_RECV_LEN) &&
-		(id->recv_count <= CDNS_I2C_FIFO_DEPTH))
-			cdns_i2c_clear_bus_hold(id);
+	if (id->defeature_repeated_start &&
+	    (((id->p_msg->flags & I2C_M_RECV_LEN) != I2C_M_RECV_LEN) &&
+	     (id->recv_count <= CDNS_I2C_FIFO_DEPTH)))
+		cdns_i2c_clear_bus_hold(id);
+	else if (!id->bus_hold_flag &&
+		 ((id->p_msg->flags & I2C_M_RECV_LEN) != I2C_M_RECV_LEN) &&
+		 (id->recv_count <= CDNS_I2C_FIFO_DEPTH))
+		cdns_i2c_clear_bus_hold(id);
+
 	/* Set the slave address in address register - triggers operation */
 	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
 						CDNS_I2C_ADDR_OFFSET);
@@ -411,8 +419,10 @@ static void cdns_i2c_msend(struct cdns_i2c *id)
 	 * Clear the bus hold flag if there is no more data
 	 * and if it is the last message.
 	 */
-	if (!id->bus_hold_flag && !id->send_count)
+	 if ((id->defeature_repeated_start && !id->send_count) ||
+	     (!id->send_count && !id->bus_hold_flag))
 		cdns_i2c_clear_bus_hold(id);
+
 	/* Set the slave address in address register - triggers operation. */
 	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
 						CDNS_I2C_ADDR_OFFSET);
@@ -520,19 +530,25 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	/*
 	 * Set the flag to one when multiple messages are to be
 	 * processed with a repeated start.
+	 * De feature repeated start when defeature_repeated_start flag is set
 	 */
-	if (num > 1) {
-		id->bus_hold_flag = 1;
-		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
-		reg |= CDNS_I2C_CR_HOLD;
-		cdns_i2c_writereg(reg, CDNS_I2C_CR_OFFSET);
+	if (!id->defeature_repeated_start && num > 1) {
+			for (count = 0; count < num-1; count++) {
+				if (msgs[count].flags & I2C_M_RD)
+					return -EINVAL;
+			}
+			id->bus_hold_flag = 1;
+			reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+			reg |= CDNS_I2C_CR_HOLD;
+			cdns_i2c_writereg(reg, CDNS_I2C_CR_OFFSET);
 	} else {
 		id->bus_hold_flag = 0;
 	}
 
 	/* Process the msg one by one */
 	for (count = 0; count < num; count++, msgs++) {
-		if (count == (num - 1))
+		if (!id->defeature_repeated_start &&
+		    (count == (num - 1)))
 			id->bus_hold_flag = 0;
 
 		ret = cdns_i2c_process_msg(id, msgs, adap);
@@ -840,6 +856,8 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	cdns_i2c_writereg(CDNS_I2C_CR_ACK_EN | CDNS_I2C_CR_NEA | CDNS_I2C_CR_MS,
 			  CDNS_I2C_CR_OFFSET);
 
+	of_property_read_u32(pdev->dev.of_node,	"defeature-repeated-start",
+			     &id->defeature_repeated_start);
 	ret = cdns_i2c_setclk(id->input_clk, id);
 	if (ret) {
 		dev_err(&pdev->dev, "invalid SCL clock: %u Hz\n", id->i2c_clk);
-- 
1.7.9.5

