Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaC0AI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:08:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605AbaC0AGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/5] mmc: host: omap_hsmmc: pass host as an argument
Date: Wed, 26 Mar 2014 19:04:46 -0500
Message-ID: <1395878690-9650-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in preparation for a larger series
of cleanups on the omap_hsmmc.c driver.

In newer instances of this IP, there's a lot of
configuration details which we can grab by reading
some new registers which were prepended to the
address space.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c | 198 +++++++++++++++++++++---------------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e91ee21..a8f1e08 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -151,11 +151,11 @@
 /*
  * MMC Host controller read/write API's
  */
-#define OMAP_HSMMC_READ(base, reg)	\
-	__raw_readl((base) + OMAP_HSMMC_##reg)
+#define OMAP_HSMMC_READ(host, reg)	\
+	__raw_readl((host)->base + OMAP_HSMMC_##reg)
 
-#define OMAP_HSMMC_WRITE(base, reg, val) \
-	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
+#define OMAP_HSMMC_WRITE(host, reg, val) \
+	__raw_writel((val), (host)->base + OMAP_HSMMC_##reg)
 
 struct omap_hsmmc_next {
 	unsigned int	dma_len;
@@ -492,8 +492,8 @@ static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
  */
 static void omap_hsmmc_start_clock(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host->base, SYSCTL,
-		OMAP_HSMMC_READ(host->base, SYSCTL) | CEN);
+	OMAP_HSMMC_WRITE(host, SYSCTL,
+		OMAP_HSMMC_READ(host, SYSCTL) | CEN);
 }
 
 /*
@@ -501,9 +501,9 @@ static void omap_hsmmc_start_clock(struct omap_hsmmc_host *host)
  */
 static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host->base, SYSCTL,
-		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
-	if ((OMAP_HSMMC_READ(host->base, SYSCTL) & CEN) != 0x0)
+	OMAP_HSMMC_WRITE(host, SYSCTL,
+		OMAP_HSMMC_READ(host, SYSCTL) & ~CEN);
+	if ((OMAP_HSMMC_READ(host, SYSCTL) & CEN) != 0x0)
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stopped\n");
 }
 
@@ -521,16 +521,16 @@ static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
 	if (cmd->opcode == MMC_ERASE)
 		irq_mask &= ~DTO_EN;
 
-	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
-	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
-	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
+	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
+	OMAP_HSMMC_WRITE(host, ISE, irq_mask);
+	OMAP_HSMMC_WRITE(host, IE, irq_mask);
 }
 
 static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host->base, ISE, 0);
-	OMAP_HSMMC_WRITE(host->base, IE, 0);
-	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+	OMAP_HSMMC_WRITE(host, ISE, 0);
+	OMAP_HSMMC_WRITE(host, IE, 0);
+	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
 }
 
 /* Calculate divisor for the given clock frequency */
@@ -558,17 +558,17 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 
 	omap_hsmmc_stop_clock(host);
 
-	regval = OMAP_HSMMC_READ(host->base, SYSCTL);
+	regval = OMAP_HSMMC_READ(host, SYSCTL);
 	regval = regval & ~(CLKD_MASK | DTO_MASK);
 	clkdiv = calc_divisor(host, ios);
 	regval = regval | (clkdiv << 6) | (DTO << 16);
-	OMAP_HSMMC_WRITE(host->base, SYSCTL, regval);
-	OMAP_HSMMC_WRITE(host->base, SYSCTL,
-		OMAP_HSMMC_READ(host->base, SYSCTL) | ICE);
+	OMAP_HSMMC_WRITE(host, SYSCTL, regval);
+	OMAP_HSMMC_WRITE(host, SYSCTL,
+		OMAP_HSMMC_READ(host, SYSCTL) | ICE);
 
 	/* Wait till the ICS bit is set */
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != ICS
+	while ((OMAP_HSMMC_READ(host, SYSCTL) & ICS) != ICS
 		&& time_before(jiffies, timeout))
 		cpu_relax();
 
@@ -583,14 +583,14 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 	 */
 	if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
 	    (ios->timing != MMC_TIMING_UHS_DDR50) &&
-	    ((OMAP_HSMMC_READ(host->base, CAPA) & HSS) == HSS)) {
-		regval = OMAP_HSMMC_READ(host->base, HCTL);
+	    ((OMAP_HSMMC_READ(host, CAPA) & HSS) == HSS)) {
+		regval = OMAP_HSMMC_READ(host, HCTL);
 		if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)
 			regval |= HSPE;
 		else
 			regval &= ~HSPE;
 
-		OMAP_HSMMC_WRITE(host->base, HCTL, regval);
+		OMAP_HSMMC_WRITE(host, HCTL, regval);
 	}
 
 	omap_hsmmc_start_clock(host);
@@ -601,24 +601,24 @@ static void omap_hsmmc_set_bus_width(struct omap_hsmmc_host *host)
 	struct mmc_ios *ios = &host->mmc->ios;
 	u32 con;
 
-	con = OMAP_HSMMC_READ(host->base, CON);
+	con = OMAP_HSMMC_READ(host, CON);
 	if (ios->timing == MMC_TIMING_UHS_DDR50)
 		con |= DDR;	/* configure in DDR mode */
 	else
 		con &= ~DDR;
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_8:
-		OMAP_HSMMC_WRITE(host->base, CON, con | DW8);
+		OMAP_HSMMC_WRITE(host, CON, con | DW8);
 		break;
 	case MMC_BUS_WIDTH_4:
-		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
-		OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) | FOUR_BIT);
+		OMAP_HSMMC_WRITE(host, CON, con & ~DW8);
+		OMAP_HSMMC_WRITE(host, HCTL,
+			OMAP_HSMMC_READ(host, HCTL) | FOUR_BIT);
 		break;
 	case MMC_BUS_WIDTH_1:
-		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
-		OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) & ~FOUR_BIT);
+		OMAP_HSMMC_WRITE(host, CON, con & ~DW8);
+		OMAP_HSMMC_WRITE(host, HCTL,
+			OMAP_HSMMC_READ(host, HCTL) & ~FOUR_BIT);
 		break;
 	}
 }
@@ -628,11 +628,11 @@ static void omap_hsmmc_set_bus_mode(struct omap_hsmmc_host *host)
 	struct mmc_ios *ios = &host->mmc->ios;
 	u32 con;
 
-	con = OMAP_HSMMC_READ(host->base, CON);
+	con = OMAP_HSMMC_READ(host, CON);
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
-		OMAP_HSMMC_WRITE(host->base, CON, con | OD);
+		OMAP_HSMMC_WRITE(host, CON, con | OD);
 	else
-		OMAP_HSMMC_WRITE(host->base, CON, con & ~OD);
+		OMAP_HSMMC_WRITE(host, CON, con & ~OD);
 }
 
 #ifdef CONFIG_PM
@@ -647,10 +647,10 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 	u32 hctl, capa;
 	unsigned long timeout;
 
-	if (host->con == OMAP_HSMMC_READ(host->base, CON) &&
-	    host->hctl == OMAP_HSMMC_READ(host->base, HCTL) &&
-	    host->sysctl == OMAP_HSMMC_READ(host->base, SYSCTL) &&
-	    host->capa == OMAP_HSMMC_READ(host->base, CAPA))
+	if (host->con == OMAP_HSMMC_READ(host, CON) &&
+	    host->hctl == OMAP_HSMMC_READ(host, HCTL) &&
+	    host->sysctl == OMAP_HSMMC_READ(host, SYSCTL) &&
+	    host->capa == OMAP_HSMMC_READ(host, CAPA))
 		return 0;
 
 	host->context_loss++;
@@ -667,17 +667,17 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 		capa = VS18;
 	}
 
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) | hctl);
+	OMAP_HSMMC_WRITE(host, HCTL,
+			OMAP_HSMMC_READ(host, HCTL) | hctl);
 
-	OMAP_HSMMC_WRITE(host->base, CAPA,
-			OMAP_HSMMC_READ(host->base, CAPA) | capa);
+	OMAP_HSMMC_WRITE(host, CAPA,
+			OMAP_HSMMC_READ(host, CAPA) | capa);
 
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+	OMAP_HSMMC_WRITE(host, HCTL,
+			OMAP_HSMMC_READ(host, HCTL) | SDBP);
 
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP
+	while ((OMAP_HSMMC_READ(host, HCTL) & SDBP) != SDBP
 		&& time_before(jiffies, timeout))
 		;
 
@@ -704,10 +704,10 @@ out:
  */
 static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
-	host->con =  OMAP_HSMMC_READ(host->base, CON);
-	host->hctl = OMAP_HSMMC_READ(host->base, HCTL);
-	host->sysctl =  OMAP_HSMMC_READ(host->base, SYSCTL);
-	host->capa = OMAP_HSMMC_READ(host->base, CAPA);
+	host->con =  OMAP_HSMMC_READ(host, CON);
+	host->hctl = OMAP_HSMMC_READ(host, HCTL);
+	host->sysctl =  OMAP_HSMMC_READ(host, SYSCTL);
+	host->capa = OMAP_HSMMC_READ(host, CAPA);
 }
 
 #else
@@ -737,20 +737,20 @@ static void send_init_stream(struct omap_hsmmc_host *host)
 
 	disable_irq(host->irq);
 
-	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host->base, CON,
-		OMAP_HSMMC_READ(host->base, CON) | INIT_STREAM);
-	OMAP_HSMMC_WRITE(host->base, CMD, INIT_STREAM_CMD);
+	OMAP_HSMMC_WRITE(host, IE, INT_EN_MASK);
+	OMAP_HSMMC_WRITE(host, CON,
+		OMAP_HSMMC_READ(host, CON) | INIT_STREAM);
+	OMAP_HSMMC_WRITE(host, CMD, INIT_STREAM_CMD);
 
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
 	while ((reg != CC_EN) && time_before(jiffies, timeout))
-		reg = OMAP_HSMMC_READ(host->base, STAT) & CC_EN;
+		reg = OMAP_HSMMC_READ(host, STAT) & CC_EN;
 
-	OMAP_HSMMC_WRITE(host->base, CON,
-		OMAP_HSMMC_READ(host->base, CON) & ~INIT_STREAM);
+	OMAP_HSMMC_WRITE(host, CON,
+		OMAP_HSMMC_READ(host, CON) & ~INIT_STREAM);
 
-	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
-	OMAP_HSMMC_READ(host->base, STAT);
+	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
+	OMAP_HSMMC_READ(host, STAT);
 
 	enable_irq(host->irq);
 }
@@ -829,7 +829,7 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	if ((host->flags & AUTO_CMD23) && mmc_op_multi(cmd->opcode) &&
 	    host->mrq->sbc) {
 		cmdreg |= ACEN_ACMD23;
-		OMAP_HSMMC_WRITE(host->base, SDMASA, host->mrq->sbc->arg);
+		OMAP_HSMMC_WRITE(host, SDMASA, host->mrq->sbc->arg);
 	}
 	if (data) {
 		cmdreg |= DP_SELECT | MSBS | BCE;
@@ -844,8 +844,8 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 
 	host->req_in_progress = 1;
 
-	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
-	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
+	OMAP_HSMMC_WRITE(host, ARG, cmd->arg);
+	OMAP_HSMMC_WRITE(host, CMD, cmdreg);
 }
 
 static int
@@ -933,13 +933,13 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
 			/* response type 2 */
-			cmd->resp[3] = OMAP_HSMMC_READ(host->base, RSP10);
-			cmd->resp[2] = OMAP_HSMMC_READ(host->base, RSP32);
-			cmd->resp[1] = OMAP_HSMMC_READ(host->base, RSP54);
-			cmd->resp[0] = OMAP_HSMMC_READ(host->base, RSP76);
+			cmd->resp[3] = OMAP_HSMMC_READ(host, RSP10);
+			cmd->resp[2] = OMAP_HSMMC_READ(host, RSP32);
+			cmd->resp[1] = OMAP_HSMMC_READ(host, RSP54);
+			cmd->resp[0] = OMAP_HSMMC_READ(host, RSP76);
 		} else {
 			/* response types 1, 1b, 3, 4, 5, 6 */
-			cmd->resp[0] = OMAP_HSMMC_READ(host->base, RSP10);
+			cmd->resp[0] = OMAP_HSMMC_READ(host, RSP10);
 		}
 	}
 	if ((host->data == NULL && !host->response_busy) || cmd->error)
@@ -1022,25 +1022,25 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
 	unsigned long i = 0;
 	unsigned long limit = MMC_TIMEOUT_US;
 
-	OMAP_HSMMC_WRITE(host->base, SYSCTL,
-			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
+	OMAP_HSMMC_WRITE(host, SYSCTL,
+			 OMAP_HSMMC_READ(host, SYSCTL) | bit);
 
 	/*
 	 * OMAP4 ES2 and greater has an updated reset logic.
 	 * Monitor a 0->1 transition first
 	 */
 	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
-		while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
+		while ((!(OMAP_HSMMC_READ(host, SYSCTL) & bit))
 					&& (i++ < limit))
 			udelay(1);
 	}
 	i = 0;
 
-	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
+	while ((OMAP_HSMMC_READ(host, SYSCTL) & bit) &&
 		(i++ < limit))
 		udelay(1);
 
-	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
+	if (OMAP_HSMMC_READ(host, SYSCTL) & bit)
 		dev_err(mmc_dev(host->mmc),
 			"Timeout waiting on controller reset in %s\n",
 			__func__);
@@ -1083,7 +1083,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 
 		if (status & ACE_EN) {
 			u32 ac12;
-			ac12 = OMAP_HSMMC_READ(host->base, AC12);
+			ac12 = OMAP_HSMMC_READ(host, AC12);
 			if (!(ac12 & ACNE) && host->mrq->sbc) {
 				end_cmd = 1;
 				if (ac12 & ACTO)
@@ -1101,7 +1101,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 		}
 	}
 
-	OMAP_HSMMC_WRITE(host->base, STAT, status);
+	OMAP_HSMMC_WRITE(host, STAT, status);
 	if (end_cmd || ((status & CC_EN) && host->cmd))
 		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC_EN)) && host->mrq)
@@ -1116,12 +1116,12 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 	struct omap_hsmmc_host *host = dev_id;
 	int status;
 
-	status = OMAP_HSMMC_READ(host->base, STAT);
+	status = OMAP_HSMMC_READ(host, STAT);
 	while (status & INT_EN_MASK && host->req_in_progress) {
 		omap_hsmmc_do_irq(host, status);
 
 		/* Flush posted write */
-		status = OMAP_HSMMC_READ(host->base, STAT);
+		status = OMAP_HSMMC_READ(host, STAT);
 	}
 
 	return IRQ_HANDLED;
@@ -1131,10 +1131,10 @@ static void set_sd_bus_power(struct omap_hsmmc_host *host)
 {
 	unsigned long i;
 
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+	OMAP_HSMMC_WRITE(host, HCTL,
+			 OMAP_HSMMC_READ(host, HCTL) | SDBP);
 	for (i = 0; i < loops_per_jiffy; i++) {
-		if (OMAP_HSMMC_READ(host->base, HCTL) & SDBP)
+		if (OMAP_HSMMC_READ(host, HCTL) & SDBP)
 			break;
 		cpu_relax();
 	}
@@ -1171,9 +1171,9 @@ static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 	if (ret != 0)
 		goto err;
 
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-		OMAP_HSMMC_READ(host->base, HCTL) & SDVSCLR);
-	reg_val = OMAP_HSMMC_READ(host->base, HCTL);
+	OMAP_HSMMC_WRITE(host, HCTL,
+		OMAP_HSMMC_READ(host, HCTL) & SDVSCLR);
+	reg_val = OMAP_HSMMC_READ(host, HCTL);
 
 	/*
 	 * If a MMC dual voltage card is detected, the set_ios fn calls
@@ -1195,7 +1195,7 @@ static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 	else
 		reg_val |= SDVS30;
 
-	OMAP_HSMMC_WRITE(host->base, HCTL, reg_val);
+	OMAP_HSMMC_WRITE(host, HCTL, reg_val);
 	set_sd_bus_power(host);
 
 	return 0;
@@ -1396,7 +1396,7 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 	unsigned int timeout, cycle_ns;
 	uint32_t reg, clkd, dto = 0;
 
-	reg = OMAP_HSMMC_READ(host->base, SYSCTL);
+	reg = OMAP_HSMMC_READ(host, SYSCTL);
 	clkd = (reg & CLKD_MASK) >> CLKD_SHIFT;
 	if (clkd == 0)
 		clkd = 1;
@@ -1423,7 +1423,7 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 
 	reg &= ~DTO_MASK;
 	reg |= dto << DTO_SHIFT;
-	OMAP_HSMMC_WRITE(host->base, SYSCTL, reg);
+	OMAP_HSMMC_WRITE(host, SYSCTL, reg);
 }
 
 static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host)
@@ -1433,7 +1433,7 @@ static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host)
 
 	if (!req->data)
 		return;
-	OMAP_HSMMC_WRITE(host->base, BLK, (req->data->blksz)
+	OMAP_HSMMC_WRITE(host, BLK, (req->data->blksz)
 				| (req->data->blocks << 16));
 	set_data_timeout(host, req->data->timeout_ns,
 				req->data->timeout_clks);
@@ -1451,7 +1451,7 @@ omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 	host->data = req->data;
 
 	if (req->data == NULL) {
-		OMAP_HSMMC_WRITE(host->base, BLK, 0);
+		OMAP_HSMMC_WRITE(host, BLK, 0);
 		/*
 		 * Set an arbitrary 100ms data timeout for commands with
 		 * busy signal.
@@ -1588,7 +1588,7 @@ static void omap_hsmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		/* Only MMC1 can interface at 3V without some flavor
 		 * of external transceiver; but they all handle 1.8V.
 		 */
-		if ((OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET) &&
+		if ((OMAP_HSMMC_READ(host, HCTL) & SDVSDET) &&
 			(ios->vdd == DUAL_VOLT_OCR_BIT)) {
 				/*
 				 * The mmc_select_voltage fn of the core does
@@ -1651,11 +1651,11 @@ static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 		capa = VS18;
 	}
 
-	value = OMAP_HSMMC_READ(host->base, HCTL) & ~SDVS_MASK;
-	OMAP_HSMMC_WRITE(host->base, HCTL, value | hctl);
+	value = OMAP_HSMMC_READ(host, HCTL) & ~SDVS_MASK;
+	OMAP_HSMMC_WRITE(host, HCTL, value | hctl);
 
-	value = OMAP_HSMMC_READ(host->base, CAPA);
-	OMAP_HSMMC_WRITE(host->base, CAPA, value | capa);
+	value = OMAP_HSMMC_READ(host, CAPA);
+	OMAP_HSMMC_WRITE(host, CAPA, value | capa);
 
 	/* Set SD bus power bit */
 	set_sd_bus_power(host);
@@ -1706,17 +1706,17 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 	pm_runtime_get_sync(host->dev);
 
 	seq_printf(s, "CON:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, CON));
+			OMAP_HSMMC_READ(host, CON));
 	seq_printf(s, "HCTL:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, HCTL));
+			OMAP_HSMMC_READ(host, HCTL));
 	seq_printf(s, "SYSCTL:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, SYSCTL));
+			OMAP_HSMMC_READ(host, SYSCTL));
 	seq_printf(s, "IE:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, IE));
+			OMAP_HSMMC_READ(host, IE));
 	seq_printf(s, "ISE:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, ISE));
+			OMAP_HSMMC_READ(host, ISE));
 	seq_printf(s, "CAPA:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host->base, CAPA));
+			OMAP_HSMMC_READ(host, CAPA));
 
 	pm_runtime_mark_last_busy(host->dev);
 	pm_runtime_put_autosuspend(host->dev);
@@ -2192,8 +2192,8 @@ static int omap_hsmmc_suspend(struct device *dev)
 
 	if (!(host->mmc->pm_flags & MMC_PM_KEEP_POWER)) {
 		omap_hsmmc_disable_irq(host);
-		OMAP_HSMMC_WRITE(host->base, HCTL,
-				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+		OMAP_HSMMC_WRITE(host, HCTL,
+				OMAP_HSMMC_READ(host, HCTL) & ~SDBP);
 	}
 
 	if (host->dbclk)
-- 
1.9.1.286.g5172cb3

