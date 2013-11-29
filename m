Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3K2M3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:29:01 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:58459 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3K2MTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:19:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 03/36] mtd: st_spi_fsm: Initialise and configure the FSM for normal working conditions
Date: Fri, 29 Nov 2013 12:18:52 +0000
Message-Id: <1385727565-25794-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses default values to initialise a connected flash chip. This
includes; a device soft reset, setting of a safe working frequency, a
switch into Fast Sequencing Mode, configuring of timing data and a purge
of the FIFO.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 116 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |  11 ++++
 2 files changed, 127 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 1e3abde..fe96b47 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -25,11 +25,121 @@
 
 #include "st_spi_fsm.h"
 
+static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
+{
+	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
+}
+
+static void stfsm_clear_fifo(struct stfsm *fsm)
+{
+	uint32_t avail;
+
+	for (;;) {
+		avail = stfsm_fifo_available(fsm);
+		if (!avail)
+			break;
+
+		while (avail) {
+			readl(fsm->base + SPI_FAST_SEQ_DATA_REG);
+			avail--;
+		}
+	}
+}
+
+static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
+{
+	int ret, timeout = 10;
+
+	/* Wait for controller to accept mode change */
+	while(--timeout) {
+		ret = readl(fsm->base + SPI_STA_MODE_CHANGE);
+		if (ret & 0x1)
+			break;
+		udelay(1);
+	}
+
+	if (!timeout)
+		return -EBUSY;
+
+	writel(mode, fsm->base + SPI_MODESELECT);
+
+	return 0;
+}
+
+static void stfsm_set_freq(struct stfsm *fsm, uint32_t spi_freq)
+{
+	uint32_t emi_freq;
+	uint32_t clk_div;
+
+	/* TODO: Make this dynamic */
+	emi_freq = STFSM_DEFAULT_EMI_FREQ;
+
+	/*
+	 * Calculate clk_div - values between 2 and 128
+	 * Multiple of 2, rounded up
+	 */
+	clk_div = 2*((emi_freq + (2*spi_freq - 1))/(2*spi_freq));
+	if (clk_div < 2)
+		clk_div = 2;
+	else if (clk_div > 128)
+		clk_div = 128;
+
+	/*
+	 * Determine a suitable delay for the IP to complete a change of
+	 * direction of the FIFO. The required delay is related to the clock
+	 * divider used. The following heuristics are based on empirical tests,
+	 * using a 100MHz EMI clock.
+	 */
+	if (clk_div <= 4)
+		fsm->fifo_dir_delay = 0;
+	else if (clk_div <= 10)
+		fsm->fifo_dir_delay = 1;
+	else
+		fsm->fifo_dir_delay = (clk_div + 9) / 10;
+
+	dev_dbg(fsm->dev, "emi_clk = %uHZ, spi_freq = %uHZ, clk_div = %u\n",
+		emi_freq, spi_freq, clk_div);
+
+	writel(clk_div, fsm->base + SPI_CLOCKDIV);
+}
+
+static int stfsm_init(struct stfsm *fsm)
+{
+	int ret;
+
+	/* Perform a soft reset of the FSM controller */
+	writel(SEQ_CFG_SWRESET, fsm->base + SPI_FAST_SEQ_CFG);
+	udelay(1);
+	writel(0, fsm->base + SPI_FAST_SEQ_CFG);
+
+	/* Set clock to 'safe' frequency initially */
+	stfsm_set_freq(fsm, STFSM_FLASH_SAFE_FREQ);
+
+	/* Switch to FSM */
+	ret = stfsm_set_mode(fsm, SPI_MODESELECT_FSM);
+	if (ret)
+		return ret;
+
+	/* Set timing parameters */
+	writel(SPI_CFG_DEVICE_ST            |
+	       SPI_CFG_DEFAULT_MIN_CS_HIGH  |
+	       SPI_CFG_DEFAULT_CS_SETUPHOLD |
+	       SPI_CFG_DEFAULT_DATA_HOLD,
+	       fsm->base + SPI_CONFIGDATA);
+	writel(STFSM_DEFAULT_WR_TIME, fsm->base + SPI_STATUS_WR_TIME_REG);
+
+	/* Clear FIFO, just in case */
+	stfsm_clear_fifo(fsm);
+
+	return 0;
+}
+
 static int stfsm_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct resource *res;
 	struct stfsm *fsm;
+	int ret;
 
 	if (!np) {
 		dev_err(&pdev->dev, "No DT found\n");
@@ -66,6 +176,12 @@ static int stfsm_probe(struct platform_device *pdev)
 
 	mutex_init(&fsm->lock);
 
+	ret = stfsm_init(fsm);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialise FSM Controller\n");
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, fsm);
 
 	fsm->mtd.dev.parent	= &pdev->dev;
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index b420a43..4e92e58 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -69,6 +69,10 @@
 #define SPI_CFG_CS_SETUPHOLD(x)		(((x) & 0xff) << 16)
 #define SPI_CFG_DATA_HOLD(x)		(((x) & 0xff) << 24)
 
+#define SPI_CFG_DEFAULT_MIN_CS_HIGH	SPI_CFG_MIN_CS_HIGH(0x0AA)
+#define SPI_CFG_DEFAULT_CS_SETUPHOLD	SPI_CFG_CS_SETUPHOLD(0xA0)
+#define SPI_CFG_DEFAULT_DATA_HOLD	SPI_CFG_DATA_HOLD(0x00)
+
 /*
  * Register: SPI_FAST_SEQ_TRANSFER_SIZE
  */
@@ -180,12 +184,19 @@
 #define STFSM_INST_WAIT			STFSM_INSTR(STFSM_OPC_WAIT,	0)
 #define STFSM_INST_STOP			STFSM_INSTR(STFSM_OPC_STOP,	0)
 
+#define STFSM_DEFAULT_EMI_FREQ	100000000UL                        /* 100 MHz */
+#define STFSM_DEFAULT_WR_TIME	STFSM_DEFAULT_EMI_FREQ * (15/1000) /* 15ms */
+
+#define STFSM_FLASH_SAFE_FREQ	10000000UL                         /* 10 MHz */
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
 	struct resource		*region;
 	struct mtd_info		mtd;
 	struct mutex		lock;
+
+	uint32_t		fifo_dir_delay;
 };
 
 #endif	/* ST_SPI_FSM_H */
-- 
1.8.3.2

