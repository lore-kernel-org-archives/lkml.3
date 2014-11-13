Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaKMOzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:55:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52430 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaKMOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:54:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <afenkart@gmail.com>, <nsekhar@ti.com>, <kishon@ti.com>
Subject: [RFC PATCH 2/3] mmc: omap_hsmmc: add tuning support
Date: Thu, 13 Nov 2014 20:24:17 +0530
Message-ID: <1415890458-20436-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415890458-20436-1-git-send-email-kishon@ti.com>
References: <1415890458-20436-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

MMC tuning procedure is required to support SD card
UHS1-SDR104 mode and EMMC HS200 mode.

The tuning function omap_execute_tuning() will only
be called by the MMC/SD core if the corresponding
speed modes are supported by the OMAP silicon which
is set in the mmc host "caps" field.

Signed-off-by: Viswanath Puttagunta <vishp@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
[ kishon@ti.com : Set the functional clock to 192MHz if the contoller
                  supports HS200 ]
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |  325 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 322 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 2e42ed3..675bd31d 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -22,6 +22,7 @@
 #include <linux/dmaengine.h>
 #include <linux/seq_file.h>
 #include <linux/sizes.h>
+#include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -47,6 +48,7 @@
 /* OMAP HSMMC Host Controller Registers */
 #define OMAP_HSMMC_SYSSTATUS	0x0014
 #define OMAP_HSMMC_CON		0x002C
+#define OMAP_HSMMC_DLL		0x0034
 #define OMAP_HSMMC_SDMASA	0x0100
 #define OMAP_HSMMC_BLK		0x0104
 #define OMAP_HSMMC_ARG		0x0108
@@ -100,6 +102,7 @@
 #define CLKEXTFREE		(1 << 16)
 #define CTPL			(1 << 11)
 #define DW8			(1 << 5)
+#define BRR                    (1 << 5)
 #define OD			0x1
 #define STAT_CLEAR		0xFFFFFFFF
 #define INIT_STREAM_CMD		0x00000000
@@ -129,6 +132,20 @@
 #define CERR_EN			(1 << 28)
 #define BADA_EN			(1 << 29)
 
+#define V1V8_SIGEN             (1 << 19)
+#define AC12_SCLK_SEL          (1 << 23)
+#define AC12_UHSMC_MASK                (7 << 16)
+#define AC12_UHSMC_SDR50       (2 << 16)
+#define AC12_UHSMC_SDR104      (3 << 16)
+#define DLL_LOCK               (1 << 0)
+#define DLL_CALIB              (1 << 1)
+#define DLL_UNLOCK_STICKY      (1 << 2)
+#define DLL_SWT                        (1 << 20)
+#define DLL_FORCE_SR_C_MASK    (0x7F << 13)
+#define DLL_FORCE_SR_C_SHIFT   13
+#define DLL_FORCE_VALUE                (1 << 12)
+#define DLL_RESET              (1 << 31)
+
 #define INT_EN_MASK (BADA_EN | CERR_EN | ACE_EN | DEB_EN | DCRC_EN |\
 		DTO_EN | CIE_EN | CEB_EN | CCRC_EN | CTO_EN | \
 		BRR_EN | BWR_EN | TC_EN | CC_EN)
@@ -143,18 +160,23 @@
 #define SDR50	(1 << 0)
 #define SDR104	(1 << 1)
 #define DDR50	(1 << 2)
+#define CAPA2_TSDR50           (1 << 13)
 
 #define MMC_AUTOSUSPEND_DELAY	100
 #define MMC_TIMEOUT_MS		20		/* 20 mSec */
 #define MMC_TIMEOUT_US		20000		/* 20000 micro Sec */
 #define OMAP_MMC_MIN_CLOCK	400000
 #define OMAP_MMC_MAX_CLOCK	52000000
+#define MAX_PHASE_DELAY		0x7F
 #define DRIVER_NAME		"omap_hsmmc"
 
 #define VDD_1V8			1800000		/* 180000 uV */
 #define VDD_3V0			3000000		/* 300000 uV */
 #define VDD_165_195		(ffs(MMC_VDD_165_195) - 1)
 
+#define EMMC_HSDDR_SD_SDR25_MAX	52000000
+#define SD_SDR50_MAX_FREQ	104000000
+
 /*
  * One controller can have multiple slots, like on some omap boards using
  * omap.c controller driver. Luckily this is not currently done on any known
@@ -198,6 +220,7 @@ struct omap_hsmmc_host {
 	void	__iomem		*base;
 	resource_size_t		mapbase;
 	spinlock_t		irq_lock; /* Prevent races with irq handler */
+	struct completion	buf_ready;
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
 	unsigned char		bus_mode;
@@ -224,6 +247,13 @@ struct omap_hsmmc_host {
 #define AUTO_CMD23		(1 << 0)        /* Auto CMD23 support */
 #define HSMMC_SDIO_IRQ_ENABLED	(1 << 1)        /* SDIO irq enabled */
 #define HSMMC_WAKE_IRQ_ENABLED	(1 << 2)
+
+	u32			*tuning_data;
+	int			tuning_size;
+	int			tuning_done;
+	int			tuning_fsrc;
+	u32			tuning_uhsmc;
+	u32			tuning_opcode;
 	struct omap_hsmmc_next	next_data;
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -233,6 +263,48 @@ struct omap_mmc_of_data {
 	u8 controller_flags;
 };
 
+static const u32 ref_tuning_4bits[] = {
+	0x00FF0FFF, 0xCCC3CCFF, 0xFFCC3CC3, 0xEFFEFFFE,
+	0xDDFFDFFF, 0xFBFFFBFF, 0xFF7FFFBF, 0xEFBDF777,
+	0xF0FFF0FF, 0x3CCCFC0F, 0xCFCC33CC, 0xEEFFEFFF,
+	0xFDFFFDFF, 0xFFBFFFDF, 0xFFF7FFBB, 0xDE7B7FF7
+};
+
+static const u32 ref_tuning_8bits[] = {
+	0xFF00FFFF, 0x0000FFFF, 0xCCCCFFFF, 0xCCCC33CC,
+	0xCC3333CC, 0xFFFFCCCC, 0xFFFFEEFF, 0xFFEEEEFF,
+	0xFFDDFFFF, 0xDDDDFFFF, 0xBBFFFFFF, 0xBBFFFFFF,
+	0xFFFFFFBB, 0XFFFFFF77, 0x77FF7777, 0xFFEEDDBB,
+	0x00FFFFFF, 0x00FFFFFF, 0xCCFFFF00, 0xCC33CCCC,
+	0x3333CCCC, 0xFFCCCCCC, 0xFFEEFFFF, 0xEEEEFFFF,
+	0xDDFFFFFF, 0xDDFFFFFF, 0xFFFFFFDD, 0XFFFFFFBB,
+	0xFFFFBBBB, 0xFFFF77FF, 0xFF7777FF, 0xEEDDBB77
+};
+
+static inline int omap_hsmmc_set_dll(struct omap_hsmmc_host *host, int count)
+{
+	int i;
+	u32 dll;
+
+	dll = OMAP_HSMMC_READ(host->base, DLL);
+	dll &= ~(DLL_FORCE_SR_C_MASK);
+	dll &= ~DLL_CALIB;
+	dll |= (count << DLL_FORCE_SR_C_SHIFT);
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+	dll |= DLL_FORCE_VALUE;
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+	dll |= DLL_CALIB;
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+	for (i = 0; i < 1000; i++) {
+		if (OMAP_HSMMC_READ(host->base, DLL) & DLL_CALIB)
+			break;
+	}
+	dll &= ~DLL_CALIB;
+	dll = OMAP_HSMMC_READ(host->base, DLL);
+
+	return 0;
+}
+
 static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host);
 
 static int omap_hsmmc_card_detect(struct device *dev, int slot)
@@ -531,7 +603,10 @@ static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
 	u32 irq_mask = INT_EN_MASK;
 	unsigned long flags;
 
-	if (host->use_dma)
+	if ((cmd->opcode == MMC_SEND_TUNING_BLOCK) ||
+	    (cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200))
+		irq_mask |= BRR_EN;
+	else if (host->use_dma)
 		irq_mask &= ~(BRR_EN | BWR_EN);
 
 	/* Disable timeout for erases */
@@ -578,6 +653,33 @@ static u16 calc_divisor(struct omap_hsmmc_host *host, struct mmc_ios *ios)
 	return dsor;
 }
 
+static inline int omap_hsmmc_restore_dll(struct omap_hsmmc_host *host)
+{
+	u32 ac12;
+	u32 dll;
+
+	ac12 = OMAP_HSMMC_READ(host->base, AC12);
+	ac12 |= host->tuning_uhsmc;
+	OMAP_HSMMC_WRITE(host->base, AC12, ac12);
+
+	dll = OMAP_HSMMC_READ(host->base, DLL);
+	dll |= DLL_FORCE_VALUE;
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+
+	if (omap_hsmmc_set_dll(host, host->tuning_fsrc))
+		return -EIO;
+	return 0;
+}
+
+static inline void omap_hsmmc_save_dll(struct omap_hsmmc_host *host)
+{
+	u32 ac12;
+
+	ac12 = OMAP_HSMMC_READ(host->base, AC12);
+	ac12 &= ~AC12_UHSMC_MASK;
+	OMAP_HSMMC_WRITE(host->base, AC12, ac12);
+}
+
 static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
@@ -589,6 +691,9 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 
 	omap_hsmmc_stop_clock(host);
 
+	if (host->mmc->caps2 & MMC_CAP2_HS200)
+		clk_set_rate(host->fclk, 192000000);
+
 	regval = OMAP_HSMMC_READ(host->base, SYSCTL);
 	regval = regval & ~(CLKD_MASK | DTO_MASK);
 	clkdiv = calc_divisor(host, ios);
@@ -667,7 +772,6 @@ static void omap_hsmmc_set_bus_mode(struct omap_hsmmc_host *host)
 }
 
 #ifdef CONFIG_PM
-
 /*
  * Restore the MMC host context, if it was lost as result of a
  * power state change.
@@ -878,6 +982,12 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	if (host->use_dma)
 		cmdreg |= DMAE;
 
+	/* Tuning command is special. Data Present Select should be set */
+	if ((cmd->opcode == MMC_SEND_TUNING_BLOCK) ||
+	    (cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200)) {
+		cmdreg = (cmd->opcode << 24) | (resptype << 16) |
+			(cmdtype << 22) | DP_SELECT | DDIR;
+	}
 	host->req_in_progress = 1;
 
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
@@ -965,6 +1075,9 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 		return;
 	}
 
+	if (host->cmd->opcode == MMC_SEND_TUNING_BLOCK)
+		return;
+
 	host->cmd = NULL;
 
 	if (cmd->flags & MMC_RSP_PRESENT) {
@@ -1104,6 +1217,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0;
 	int error = 0;
+	int i = 0;
 
 	data = host->data;
 	dev_vdbg(mmc_dev(host->mmc), "IRQ Status is %x\n", status);
@@ -1139,6 +1253,15 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 	}
 
 	OMAP_HSMMC_WRITE(host->base, STAT, status);
+
+	if (status & BRR_EN) {
+		for (i = 0; i < host->tuning_size/4; i++)
+			host->tuning_data[i] =
+				OMAP_HSMMC_READ(host->base, DATA);
+		complete(&host->buf_ready);
+		return;
+	}
+
 	if (end_cmd || ((status & CC_EN) && host->cmd))
 		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC_EN)) && host->mrq)
@@ -1844,6 +1967,189 @@ static int omap_hsmmc_multi_io_quirk(struct mmc_card *card,
 	return blk_size;
 }
 
+static int omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
+{
+	struct omap_hsmmc_host *host;
+	struct mmc_ios *ios = &mmc->ios;
+	const u32 *tuning_ref;
+	int phase_delay = 0;
+	int err = 0;
+	int count = 0;
+	int length = 0;
+	int note_index = 0xFF;
+	int max_index = 0;
+	int max_window = 0;
+	bool previous_match = false;
+	bool current_match;
+	u32 ac12, capa2, dll = 0;
+
+	host  = mmc_priv(mmc);
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_8:
+		tuning_ref = ref_tuning_8bits;
+		host->tuning_size = sizeof(ref_tuning_8bits);
+		break;
+	case MMC_BUS_WIDTH_4:
+		tuning_ref = ref_tuning_4bits;
+		host->tuning_size = sizeof(ref_tuning_4bits);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	host->tuning_data = kzalloc(host->tuning_size, GFP_KERNEL);
+	if (!host->tuning_data)
+		return -ENOMEM;
+
+	host->tuning_done = 0;
+	/* clock tuning is not needed for upto 52MHz */
+	if (ios->clock <= EMMC_HSDDR_SD_SDR25_MAX)
+		return 0;
+
+	omap_hsmmc_stop_clock(host);
+
+	ac12 = OMAP_HSMMC_READ(host->base, AC12);
+	capa2 = OMAP_HSMMC_READ(host->base, CAPA2);
+
+	ac12 &= ~AC12_UHSMC_MASK;
+	OMAP_HSMMC_WRITE(host->base, AC12, ac12);
+
+	/*
+	 * Host Controller needs tuning only in case of SDR104 mode
+	 * and for SDR50 mode when Use Tuning for SDR50 is set in
+	 * Capabilities register.
+	 */
+	if (ios->clock <= SD_SDR50_MAX_FREQ) {
+		if (!(capa2 & CAPA2_TSDR50))
+			return 0;
+		ac12 |= AC12_UHSMC_SDR50;
+	} else {
+		ac12 |= AC12_UHSMC_SDR104;
+	}
+
+	ac12 |= AC12_UHSMC_SDR104;
+	ac12 |= V1V8_SIGEN;
+
+	/* Enable SDR50/SDR104 mode */
+	OMAP_HSMMC_WRITE(host->base, AC12, ac12);
+	omap_hsmmc_start_clock(host);
+
+	/* Start software tuning Procedure */
+	dll |= DLL_SWT;
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+
+	while (phase_delay < MAX_PHASE_DELAY) {
+		struct mmc_command cmd = {0};
+		struct mmc_request mrq = {0};
+
+		if (phase_delay > MAX_PHASE_DELAY)
+			break;
+
+		omap_hsmmc_set_dll(host, phase_delay);
+
+		cmd.opcode = opcode;
+		cmd.arg = 0;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_ADTC;
+		cmd.retries = 0;
+		cmd.data = NULL;
+		cmd.error = 0;
+
+		mrq.cmd = &cmd;
+		host->mrq = &mrq;
+
+		OMAP_HSMMC_WRITE(host->base, BLK, host->tuning_size);
+		set_data_timeout(host, 50000000, 0);
+		omap_hsmmc_start_command(host, &cmd, NULL);
+
+		host->cmd = NULL;
+		host->mrq = NULL;
+
+		/* Wait for Buffer Read Ready interrupt */
+		err = wait_for_completion_timeout(&host->buf_ready,
+				msecs_to_jiffies(5000));
+		omap_hsmmc_disable_irq(host);
+		host->req_in_progress = 0;
+
+		if (err == 0) {
+			dev_err(mmc_dev(host->mmc),
+				"Tuning BRR timeout. phase_delay=%x",
+				phase_delay);
+			err = -ETIMEDOUT;
+			goto tuning_error;
+		}
+
+		current_match = true;
+		if (memcmp(host->tuning_data, tuning_ref, host->tuning_size))
+			current_match = false;
+		else
+			current_match = true;
+
+		if (current_match == true) {
+			if (previous_match == false) {
+				/* new window */
+				note_index = count;
+				length = 1;
+			} else {
+				length++;
+			}
+			previous_match = true;
+			if (length > max_window) {
+				max_index = note_index;
+				max_window = length;
+			}
+		} else {
+			previous_match = false;
+		}
+		phase_delay += 4;
+		count++;
+	}
+
+	if (!max_window) {
+		dev_err(mmc_dev(host->mmc), "Unable to find match\n");
+		err = -EIO;
+		goto tuning_error;
+	}
+
+	ac12 = OMAP_HSMMC_READ(host->base, AC12);
+	if (!(ac12 & AC12_SCLK_SEL)) {
+		err = -EIO;
+		goto tuning_error;
+	}
+
+	dll = OMAP_HSMMC_READ(host->base, DLL);
+	dll &= ~DLL_SWT;
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+	count = 4 * (max_index + (max_window >> 1));
+	if (omap_hsmmc_set_dll(host, count)) {
+		err = -EIO;
+		goto tuning_error;
+	}
+	host->tuning_fsrc = count;
+	host->tuning_uhsmc = (OMAP_HSMMC_READ(host->base, AC12)
+			      & AC12_UHSMC_MASK);
+	host->tuning_opcode = opcode;
+	host->tuning_done = 1;
+	omap_hsmmc_reset_controller_fsm(host, SRD);
+	omap_hsmmc_reset_controller_fsm(host, SRC);
+
+	return 0;
+
+tuning_error:
+	dev_err(mmc_dev(host->mmc),
+		"Tuning failed. Using fixed sampling clock\n");
+	ac12 = OMAP_HSMMC_READ(host->base, AC12);
+	ac12 &= ~(AC12_UHSMC_MASK | AC12_SCLK_SEL);
+	OMAP_HSMMC_WRITE(host->base, AC12, ac12);
+
+	dll = OMAP_HSMMC_READ(host->base, DLL);
+	dll &= ~(DLL_FORCE_VALUE | DLL_SWT);
+	OMAP_HSMMC_WRITE(host->base, DLL, dll);
+
+	omap_hsmmc_reset_controller_fsm(host, SRD);
+	omap_hsmmc_reset_controller_fsm(host, SRC);
+	return err;
+}
+
 static struct mmc_host_ops omap_hsmmc_ops = {
 	.enable = omap_hsmmc_enable_fclk,
 	.disable = omap_hsmmc_disable_fclk,
@@ -1855,6 +2161,7 @@ static struct mmc_host_ops omap_hsmmc_ops = {
 	.get_ro = omap_hsmmc_get_ro,
 	.init_card = omap_hsmmc_init_card,
 	.enable_sdio_irq = omap_hsmmc_enable_sdio_irq,
+	.execute_tuning = omap_execute_tuning,
 };
 
 #ifdef CONFIG_DEBUG_FS
@@ -2107,6 +2414,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		mmc->f_max = OMAP_MMC_MAX_CLOCK;
 
 	spin_lock_init(&host->irq_lock);
+	init_completion(&host->buf_ready);
 
 	host->fclk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(host->fclk)) {
@@ -2159,7 +2467,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	mmc->pm_caps = mmc_slot(host).pm_caps;
 
-	reg = OMAP_HSMMC_READ(host->base, OMAP_HSMMC_CAPA2);
+	reg = OMAP_HSMMC_READ(host->base, CAPA2);
 
 	if (reg & SDR50)
 		mmc->caps |= MMC_CAP_UHS_DDR50;
@@ -2172,6 +2480,9 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (reg & DDR50)
 		mmc->caps |= MMC_CAP_UHS_DDR50;
 
+	mmc->caps |= MMC_CAP_DRIVER_TYPE_A | MMC_CAP_DRIVER_TYPE_C |
+			MMC_CAP_DRIVER_TYPE_D;
+
 	omap_hsmmc_conf_bus_power(host);
 
 	if (!pdev->dev.of_node) {
@@ -2380,6 +2691,7 @@ static int omap_hsmmc_suspend(struct device *dev)
 		OMAP_HSMMC_WRITE(host->base, HCTL,
 				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 	}
+	host->tuning_done = 0;
 
 	/* do not wake up due to sdio irq */
 	if ((host->mmc->caps & MMC_CAP_SDIO_IRQ) &&
@@ -2434,6 +2746,9 @@ static int omap_hsmmc_runtime_suspend(struct device *dev)
 	int ret = 0;
 
 	host = platform_get_drvdata(to_platform_device(dev));
+	if (host->tuning_done)
+		omap_hsmmc_restore_dll(host);
+
 	omap_hsmmc_context_save(host);
 	dev_dbg(dev, "disabled\n");
 
@@ -2480,6 +2795,10 @@ static int omap_hsmmc_runtime_resume(struct device *dev)
 
 	host = platform_get_drvdata(to_platform_device(dev));
 	omap_hsmmc_context_restore(host);
+
+	if (host->tuning_done)
+		omap_hsmmc_restore_dll(host);
+
 	dev_dbg(dev, "enabled\n");
 
 	spin_lock_irqsave(&host->irq_lock, flags);
-- 
1.7.9.5

