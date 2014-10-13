Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaJMQ21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:28:27 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:36822 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbaJMQ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:28:25 -0400
X-Greylist: delayed 995 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 12:28:24 EDT
From: Thomas Gessler <Thomas.Gessler@exp2.physik.uni-giessen.de>
To: wsa@the-dreams.de
Cc: michal.simek@xilinx.com, appana.durga.rao@xilinx.com, khali@linux-fr.org,
        sachin.kamat@linaro.org, paul.gortmaker@windriver.com,
        Thomas.Gessler@exp2.physik.uni-giessen.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: i2c-xiic: Fix big-endian register access
Date: Mon, 13 Oct 2014 18:08:47 +0200
Message-Id: <1413216527-11933-1-git-send-email-Thomas.Gessler@exp2.physik.uni-giessen.de>
X-Mailer: git-send-email 2.1.2
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: thomas.gessler@exp2.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver tried to access device registers with the (little-endian)
iowrite/ioread functions. While this worked on little-endian machines
(e.g. Microblaze with AXI bus), it made the driver unusable on
big-endian machines (e.g. PPC405 with PLB).

During the probe function, the driver tried to write a 32-bit reset mask
into the reset register. This caused an error interrupt on big-endian
systems, because the device detected an invalid (byte-swapped) reset
mask. The result was an Oops.

The patch implements an endianness detection similar to the one used in
other Xilinx drivers like drivers/spi/spi-xilinx.c. It was tested on a
PPC405/PLB system.

Signed-off-by: Thomas Gessler <Thomas.Gessler@exp2.physik.uni-giessen.de>
---
 drivers/i2c/busses/i2c-xiic.c | 58 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index ade9223..9842660 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -50,6 +50,11 @@ enum xilinx_i2c_state {
 	STATE_START
 };
 
+enum xiic_endian {
+	LITTLE,
+	BIG
+};
+
 /**
  * struct xiic_i2c - Internal representation of the XIIC I2C bus
  * @base:	Memory base of the HW registers
@@ -74,6 +79,7 @@ struct xiic_i2c {
 	enum xilinx_i2c_state	state;
 	struct i2c_msg		*rx_msg;
 	int			rx_pos;
+	enum xiic_endian	endianness;
 };
 
 
@@ -174,29 +180,58 @@ struct xiic_i2c {
 static void xiic_start_xfer(struct xiic_i2c *i2c);
 static void __xiic_start_xfer(struct xiic_i2c *i2c);
 
+/*
+ * For the register read and write functions, a little-endian and big-endian
+ * version are necessary. Endianness is detected during the probe function.
+ * Only the least significant byte [doublet] of the register are ever
+ * accessed. This requires an offset of 3 [2] from the base address for
+ * big-endian systems.
+ */
+
 static inline void xiic_setreg8(struct xiic_i2c *i2c, int reg, u8 value)
 {
-	iowrite8(value, i2c->base + reg);
+	if (i2c->endianness == LITTLE)
+		iowrite8(value, i2c->base + reg);
+	else
+		iowrite8(value, i2c->base + reg + 3);
 }
 
 static inline u8 xiic_getreg8(struct xiic_i2c *i2c, int reg)
 {
-	return ioread8(i2c->base + reg);
+	u8 ret;
+
+	if (i2c->endianness == LITTLE)
+		ret = ioread8(i2c->base + reg);
+	else
+		ret = ioread8(i2c->base + reg + 3);
+	return ret;
 }
 
 static inline void xiic_setreg16(struct xiic_i2c *i2c, int reg, u16 value)
 {
-	iowrite16(value, i2c->base + reg);
+	if (i2c->endianness == LITTLE)
+		iowrite16(value, i2c->base + reg);
+	else
+		iowrite16be(value, i2c->base + reg + 2);
 }
 
 static inline void xiic_setreg32(struct xiic_i2c *i2c, int reg, int value)
 {
-	iowrite32(value, i2c->base + reg);
+	if (i2c->endianness == LITTLE)
+		iowrite32(value, i2c->base + reg);
+	else
+		iowrite32be(value, i2c->base + reg);
 }
 
 static inline int xiic_getreg32(struct xiic_i2c *i2c, int reg)
 {
-	return ioread32(i2c->base + reg);
+	u32 ret;
+
+	if (i2c->endianness == LITTLE)
+		ret = ioread32(i2c->base + reg);
+	else
+		ret = ioread32be(i2c->base + reg);
+	return ret;
 }
 
 static inline void xiic_irq_dis(struct xiic_i2c *i2c, u32 mask)
@@ -696,6 +731,7 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 	u8 i;
+	u32 sr;
 
 	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
 	if (!i2c)
@@ -728,6 +764,18 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/*
+	 * Detect endianness
+	 * Try to reset the TX FIFO. Then check the EMPTY flag. If it is not
+	 * set, assume that the endianness was wrong and swap.
+	 */
+	i2c->endianness = LITTLE;
+	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);
+	/* Reset is cleared in xiic_reinit */
+	sr = xiic_getreg32(i2c, XIIC_SR_REG_OFFSET);
+	if (!(sr & XIIC_SR_TX_FIFO_EMPTY_MASK))
+		i2c->endianness = BIG;
+
 	xiic_reinit(i2c);
 
 	/* add i2c adapter to i2c tree */
-- 
2.1.2

