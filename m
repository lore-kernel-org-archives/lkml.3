Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaKBN5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 08:57:50 -0500
Received: from sauhun.de ([89.238.76.85]:35856 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaKBN53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 08:57:29 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Balbir Singh <bsingharora@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 1/2] i2c: account completions as iowait
Date: Sun,  2 Nov 2014 14:58:08 +0100
Message-Id: <1414936689-2707-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are waiting for IO, so it should be accounted as such.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-axxia.c           | 4 ++--
 drivers/i2c/busses/i2c-bcm-kona.c        | 8 ++++----
 drivers/i2c/busses/i2c-bcm2835.c         | 2 +-
 drivers/i2c/busses/i2c-bfin-twi.c        | 4 ++--
 drivers/i2c/busses/i2c-cadence.c         | 2 +-
 drivers/i2c/busses/i2c-davinci.c         | 2 +-
 drivers/i2c/busses/i2c-designware-core.c | 2 +-
 drivers/i2c/busses/i2c-efm32.c           | 2 +-
 drivers/i2c/busses/i2c-exynos5.c         | 2 +-
 drivers/i2c/busses/i2c-highlander.c      | 2 +-
 drivers/i2c/busses/i2c-hix5hd2.c         | 2 +-
 drivers/i2c/busses/i2c-ismt.c            | 2 +-
 drivers/i2c/busses/i2c-mxs.c             | 2 +-
 drivers/i2c/busses/i2c-nomadik.c         | 4 ++--
 drivers/i2c/busses/i2c-omap.c            | 2 +-
 drivers/i2c/busses/i2c-pmcmsp.c          | 2 +-
 drivers/i2c/busses/i2c-pnx.c             | 2 +-
 drivers/i2c/busses/i2c-qup.c             | 4 ++--
 drivers/i2c/busses/i2c-riic.c            | 2 +-
 drivers/i2c/busses/i2c-sh7760.c          | 2 +-
 drivers/i2c/busses/i2c-sirf.c            | 2 +-
 drivers/i2c/busses/i2c-st.c              | 2 +-
 drivers/i2c/busses/i2c-sun6i-p2wi.c      | 2 +-
 drivers/i2c/busses/i2c-tegra.c           | 2 +-
 drivers/i2c/busses/i2c-wmt.c             | 4 ++--
 25 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/i2c/busses/i2c-axxia.c b/drivers/i2c/busses/i2c-axxia.c
index 768a598d8d03..5e4f85b052be 100644
--- a/drivers/i2c/busses/i2c-axxia.c
+++ b/drivers/i2c/busses/i2c-axxia.c
@@ -388,7 +388,7 @@ static int axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
 
 	i2c_int_enable(idev, int_mask);
 
-	ret = wait_for_completion_timeout(&idev->msg_complete,
+	ret = wait_for_completion_io_timeout(&idev->msg_complete,
 					  I2C_XFER_TIMEOUT);
 
 	i2c_int_disable(idev, int_mask);
@@ -415,7 +415,7 @@ static int axxia_i2c_stop(struct axxia_i2c_dev *idev)
 	/* Issue stop */
 	writel(0xb, idev->base + MST_COMMAND);
 	i2c_int_enable(idev, int_mask);
-	ret = wait_for_completion_timeout(&idev->msg_complete,
+	ret = wait_for_completion_io_timeout(&idev->msg_complete,
 					  I2C_STOP_TIMEOUT);
 	i2c_int_disable(idev, int_mask);
 	if (ret == 0)
diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index 18a74a6751a9..ae0b630be9ac 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -270,7 +270,7 @@ static int bcm_kona_send_i2c_cmd(struct bcm_kona_i2c_dev *dev,
 	bcm_kona_i2c_send_cmd_to_ctrl(dev, cmd);
 
 	/* Wait for transaction to finish or timeout */
-	time_left = wait_for_completion_timeout(&dev->done, time_left);
+	time_left = wait_for_completion_io_timeout(&dev->done, time_left);
 
 	/* Mask all interrupts */
 	writel(0, dev->base + IER_OFFSET);
@@ -305,7 +305,7 @@ static int bcm_kona_i2c_read_fifo_single(struct bcm_kona_i2c_dev *dev,
 		dev->base + RXFCR_OFFSET);
 
 	/* Wait for FIFO read to complete */
-	time_left = wait_for_completion_timeout(&dev->done, time_left);
+	time_left = wait_for_completion_io_timeout(&dev->done, time_left);
 
 	/* Mask all interrupts */
 	writel(0, dev->base + IER_OFFSET);
@@ -377,7 +377,7 @@ static int bcm_kona_i2c_write_byte(struct bcm_kona_i2c_dev *dev, uint8_t data,
 	writel(data, dev->base + DAT_OFFSET);
 
 	/* Wait for byte to be written */
-	time_left = wait_for_completion_timeout(&dev->done, time_left);
+	time_left = wait_for_completion_io_timeout(&dev->done, time_left);
 
 	/* Mask all interrupts */
 	writel(0, dev->base + IER_OFFSET);
@@ -424,7 +424,7 @@ static int bcm_kona_i2c_write_fifo_single(struct bcm_kona_i2c_dev *dev,
 
 	/* Wait for FIFO to empty */
 	do {
-		time_left = wait_for_completion_timeout(&dev->done, time_left);
+		time_left = wait_for_completion_io_timeout(&dev->done, time_left);
 		fifo_status = readl(dev->base + FIFO_STATUS_OFFSET);
 	} while (time_left && !(fifo_status & FIFO_STATUS_TXFIFO_EMPTY_MASK));
 
diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index 4b8ecd0b3661..3f9516e323aa 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -167,7 +167,7 @@ static int bcm2835_i2c_xfer_msg(struct bcm2835_i2c_dev *i2c_dev,
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_DLEN, msg->len);
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, c);
 
-	time_left = wait_for_completion_timeout(&i2c_dev->completion,
+	time_left = wait_for_completion_io_timeout(&i2c_dev->completion,
 						BCM2835_I2C_TIMEOUT);
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, BCM2835_I2C_C_CLEAR);
 	if (!time_left) {
diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 067c1615e968..638b9fa24d53 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -325,7 +325,7 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 
 	while (!iface->result) {
-		if (!wait_for_completion_timeout(&iface->complete,
+		if (!wait_for_completion_io_timeout(&iface->complete,
 			adap->timeout)) {
 			iface->result = -1;
 			dev_err(&adap->dev, "master transfer timeout\n");
@@ -529,7 +529,7 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	}
 
 	while (!iface->result) {
-		if (!wait_for_completion_timeout(&iface->complete,
+		if (!wait_for_completion_io_timeout(&iface->complete,
 			adap->timeout)) {
 			iface->result = -1;
 			dev_err(&adap->dev, "smbus transfer timeout\n");
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 63f3f03ecc9b..156ac641e45f 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -470,7 +470,7 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 		cdns_i2c_msend(id);
 
 	/* Wait for the signal of completion */
-	ret = wait_for_completion_timeout(&id->xfer_done, adap->timeout);
+	ret = wait_for_completion_io_timeout(&id->xfer_done, adap->timeout);
 	if (!ret) {
 		cdns_i2c_master_reset(adap);
 		dev_err(id->adap.dev.parent,
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 4d9614719128..4874f4b585e9 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -591,7 +591,7 @@ static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
 
 	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
 	if (val == CPUFREQ_PRECHANGE) {
-		wait_for_completion(&dev->xfr_complete);
+		wait_for_completion_io(&dev->xfr_complete);
 		davinci_i2c_reset_ctrl(dev, 0);
 	} else if (val == CPUFREQ_POSTCHANGE) {
 		i2c_davinci_calc_clk_dividers(dev);
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3c20e4bd6dd1..42096f1ed8fc 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -639,7 +639,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	i2c_dw_xfer_init(dev);
 
 	/* wait for tx to complete */
-	ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);
+	ret = wait_for_completion_io_timeout(&dev->cmd_complete, HZ);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		/* i2c_dw_init implicitly disables the adapter */
diff --git a/drivers/i2c/busses/i2c-efm32.c b/drivers/i2c/busses/i2c-efm32.c
index 10b8323b08d4..a2472b192457 100644
--- a/drivers/i2c/busses/i2c-efm32.c
+++ b/drivers/i2c/busses/i2c-efm32.c
@@ -278,7 +278,7 @@ static int efm32_i2c_master_xfer(struct i2c_adapter *adap,
 
 	efm32_i2c_send_next_msg(ddata);
 
-	wait_for_completion(&ddata->done);
+	wait_for_completion_io(&ddata->done);
 
 	if (ddata->current_msg >= ddata->num_msgs)
 		ret = ddata->num_msgs;
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 81e6263cd7da..28d81697bbd3 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -635,7 +635,7 @@ static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
 
 	exynos5_i2c_message_start(i2c, stop);
 
-	timeout = wait_for_completion_timeout(&i2c->msg_complete,
+	timeout = wait_for_completion_io_timeout(&i2c->msg_complete,
 					      EXYNOS5_I2C_TIMEOUT);
 	if (timeout == 0)
 		ret = -ETIMEDOUT;
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 512fcfabc18e..188cbdc11726 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -200,7 +200,7 @@ static void highlander_i2c_poll(struct highlander_i2c_dev *dev)
 static inline int highlander_i2c_wait_xfer_done(struct highlander_i2c_dev *dev)
 {
 	if (dev->irq)
-		wait_for_completion_timeout(&dev->cmd_complete,
+		wait_for_completion_io_timeout(&dev->cmd_complete,
 					  msecs_to_jiffies(iic_timeout));
 	else
 		/* busy looping, the IRQ of champions */
diff --git a/drivers/i2c/busses/i2c-hix5hd2.c b/drivers/i2c/busses/i2c-hix5hd2.c
index 9490d0f4255c..621c4f211a27 100644
--- a/drivers/i2c/busses/i2c-hix5hd2.c
+++ b/drivers/i2c/busses/i2c-hix5hd2.c
@@ -338,7 +338,7 @@ static int hix5hd2_i2c_xfer_msg(struct hix5hd2_i2c_priv *priv,
 	reinit_completion(&priv->msg_complete);
 	hix5hd2_i2c_message_start(priv, stop);
 
-	timeout = wait_for_completion_timeout(&priv->msg_complete,
+	timeout = wait_for_completion_io_timeout(&priv->msg_complete,
 					      priv->adap.timeout);
 	if (timeout == 0) {
 		priv->state = HIX5I2C_STAT_RW_ERR;
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index 3f6ecbfb9a56..64354d0d9513 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -582,7 +582,7 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 	ismt_submit_desc(priv);
 
 	/* Now we wait for interrupt completion, 1s */
-	ret = wait_for_completion_timeout(&priv->cmp, HZ*1);
+	ret = wait_for_completion_io_timeout(&priv->cmp, HZ*1);
 
 	/* unmap the data buffer */
 	if (dma_size != 0)
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 07e1be6f8992..528ddab7d1d6 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -599,7 +599,7 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 		if (ret)
 			return ret;
 
-		ret = wait_for_completion_timeout(&i2c->cmd_complete,
+		ret = wait_for_completion_io_timeout(&i2c->cmd_complete,
 						msecs_to_jiffies(1000));
 		if (ret == 0)
 			goto timeout;
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 9ad038d223c4..daf34297a9f3 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -476,7 +476,7 @@ static int read_i2c(struct nmk_i2c_dev *dev, u16 flags)
 	writel(readl(dev->virtbase + I2C_IMSCR) | irq_mask,
 			dev->virtbase + I2C_IMSCR);
 
-	timeout = wait_for_completion_timeout(
+	timeout = wait_for_completion_io_timeout(
 		&dev->xfer_complete, dev->adap.timeout);
 
 	if (timeout == 0) {
@@ -556,7 +556,7 @@ static int write_i2c(struct nmk_i2c_dev *dev, u16 flags)
 	writel(readl(dev->virtbase + I2C_IMSCR) | irq_mask,
 			dev->virtbase + I2C_IMSCR);
 
-	timeout = wait_for_completion_timeout(
+	timeout = wait_for_completion_io_timeout(
 		&dev->xfer_complete, dev->adap.timeout);
 
 	if (timeout == 0) {
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 0dffb0e62c3b..6f133c6c8390 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -591,7 +591,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	 * REVISIT: We should abort the transfer on signals, but the bus goes
 	 * into arbitration and we're currently unable to recover from it.
 	 */
-	timeout = wait_for_completion_timeout(&dev->cmd_complete,
+	timeout = wait_for_completion_io_timeout(&dev->cmd_complete,
 						OMAP_I2C_TIMEOUT);
 	if (timeout == 0) {
 		dev_err(dev->dev, "controller timed out\n");
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 8564768fee32..a8f61a4677b8 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -424,7 +424,7 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_do_xfer(
 	dev_dbg(&pmcmsptwi_adapter.dev, "Writing cmd reg 0x%08x\n", reg);
 	pmcmsptwi_writel(reg, data->iobase + MSP_TWI_CMD_REG_OFFSET);
 	if (data->irq) {
-		unsigned long timeleft = wait_for_completion_timeout(
+		unsigned long timeleft = wait_for_completion_io_timeout(
 						&data->wait, MSP_IRQ_TIMEOUT);
 		if (timeleft == 0) {
 			dev_dbg(&pmcmsptwi_adapter.dev,
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index dc7ff829ad78..636080865fe6 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -546,7 +546,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			break;
 
 		/* Wait for completion */
-		wait_for_completion(&alg_data->mif.complete);
+		wait_for_completion_io(&alg_data->mif.complete);
 
 		if (!(rc = alg_data->mif.ret))
 			completed++;
diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 092d89bd3224..9977e9be3229 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -331,7 +331,7 @@ static int qup_i2c_write_one(struct qup_i2c_dev *qup, struct i2c_msg *msg)
 		if (ret)
 			goto err;
 
-		left = wait_for_completion_timeout(&qup->xfer, HZ);
+		left = wait_for_completion_io_timeout(&qup->xfer, HZ);
 		if (!left) {
 			writel(1, qup->base + QUP_SW_RESET);
 			ret = -ETIMEDOUT;
@@ -447,7 +447,7 @@ static int qup_i2c_read_one(struct qup_i2c_dev *qup, struct i2c_msg *msg)
 		goto err;
 
 	do {
-		left = wait_for_completion_timeout(&qup->xfer, HZ);
+		left = wait_for_completion_io_timeout(&qup->xfer, HZ);
 		if (!left) {
 			writel(1, qup->base + QUP_SW_RESET);
 			ret = -ETIMEDOUT;
diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index af3b3d032a9f..d5bfc2b4806f 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -146,7 +146,7 @@ static int riic_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 
 		writeb(start_bit, riic->base + RIIC_ICCR2);
 
-		time_left = wait_for_completion_timeout(&riic->msg_done, riic->adapter.timeout);
+		time_left = wait_for_completion_io_timeout(&riic->msg_done, riic->adapter.timeout);
 		if (time_left == 0)
 			riic->err = -ETIMEDOUT;
 
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index d76f3d9737ec..1b9bab551e4d 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -326,7 +326,7 @@ retry:
 		else
 			sh7760_i2c_msend(id);
 
-		wait_for_completion(&id->xfer_done);
+		wait_for_completion_io(&id->xfer_done);
 
 		if (id->status == 0) {
 			num = -EIO;
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index b1336d5f0531..9afe2d1cfd85 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -213,7 +213,7 @@ static int i2c_sirfsoc_xfer_msg(struct sirfsoc_i2c *siic, struct i2c_msg *msg)
 		siic->base + SIRFSOC_I2C_CTRL);
 	i2c_sirfsoc_queue_cmd(siic);
 
-	if (wait_for_completion_timeout(&siic->done, timeout) == 0) {
+	if (wait_for_completion_io_timeout(&siic->done, timeout) == 0) {
 		siic->err_status = SIRFSOC_I2C_ERR_TIMEOUT;
 		dev_err(&siic->adapter.dev, "Transfer timeout\n");
 	}
diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 2e4eccd6599a..9b0583a2c6b9 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -649,7 +649,7 @@ static int st_i2c_xfer_msg(struct st_i2c_dev *i2c_dev, struct i2c_msg *msg,
 		st_i2c_set_bits(i2c_dev->base + SSC_I2C, SSC_I2C_STRTG);
 	}
 
-	timeout = wait_for_completion_timeout(&i2c_dev->complete,
+	timeout = wait_for_completion_io_timeout(&i2c_dev->complete,
 			i2c_dev->adap.timeout);
 	ret = c->result;
 
diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c-sun6i-p2wi.c
index 4d75d4759709..565b2ed732be 100644
--- a/drivers/i2c/busses/i2c-sun6i-p2wi.c
+++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
@@ -151,7 +151,7 @@ static int p2wi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	writel(P2WI_CTRL_START_TRANS | P2WI_CTRL_GLOBAL_INT_ENB,
 	       p2wi->regs + P2WI_CTRL);
 
-	wait_for_completion(&p2wi->complete);
+	wait_for_completion_io(&p2wi->complete);
 
 	if (p2wi->status & P2WI_INTS_LOAD_BSY) {
 		dev_err(&adap->dev, "P2WI bus busy\n");
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index efba1ebe16ba..e109542776d6 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -583,7 +583,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	dev_dbg(i2c_dev->dev, "unmasked irq: %02x\n",
 		i2c_readl(i2c_dev, I2C_INT_MASK));
 
-	ret = wait_for_completion_timeout(&i2c_dev->msg_complete, TEGRA_I2C_TIMEOUT);
+	ret = wait_for_completion_io_timeout(&i2c_dev->msg_complete, TEGRA_I2C_TIMEOUT);
 	tegra_i2c_mask_irq(i2c_dev, int_mask);
 
 	if (ret == 0) {
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index f80a38c2072c..f370bac8b9de 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -176,7 +176,7 @@ static int wmt_i2c_write(struct i2c_adapter *adap, struct i2c_msg *pmsg,
 	}
 
 	while (xfer_len < pmsg->len) {
-		wait_result = wait_for_completion_timeout(&i2c_dev->complete,
+		wait_result = wait_for_completion_io_timeout(&i2c_dev->complete,
 							  500 * HZ / 1000);
 
 		if (wait_result == 0)
@@ -265,7 +265,7 @@ static int wmt_i2c_read(struct i2c_adapter *adap, struct i2c_msg *pmsg,
 	}
 
 	while (xfer_len < pmsg->len) {
-		wait_result = wait_for_completion_timeout(&i2c_dev->complete,
+		wait_result = wait_for_completion_io_timeout(&i2c_dev->complete,
 							  500 * HZ / 1000);
 
 		if (!wait_result)
-- 
2.1.1

