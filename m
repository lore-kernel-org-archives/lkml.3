Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaC0AHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:07:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50040 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbaC0AG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:58 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 4/5] mmc: host: omap_hsmmc: switch over to new accessors
Date: Wed, 26 Mar 2014 19:04:49 -0500
Message-ID: <1395878690-9650-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the newly introduced accessor funtions will help
dealing with register access which shouldn't be
done with offset in consideration.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c | 200 ++++++++++++++++++++----------------------
 1 file changed, 96 insertions(+), 104 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e596c6a..d32f6ac 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -148,15 +148,6 @@
  */
 #define mmc_slot(host)		(host->pdata->slots[host->slot_id])
 
-/*
- * MMC Host controller read/write API's
- */
-#define OMAP_HSMMC_READ(host, reg)	\
-	__raw_readl((host)->base + OMAP_HSMMC_##reg + host->reg_offset)
-
-#define OMAP_HSMMC_WRITE(host, reg, val) \
-	__raw_writel((val), (host)->base + OMAP_HSMMC_##reg + host->reg_offset)
-
 struct omap_hsmmc_next {
 	unsigned int	dma_len;
 	s32		cookie;
@@ -529,8 +520,8 @@ static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
  */
 static void omap_hsmmc_start_clock(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host, SYSCTL,
-		OMAP_HSMMC_READ(host, SYSCTL) | CEN);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) | CEN);
 }
 
 /*
@@ -538,9 +529,9 @@ static void omap_hsmmc_start_clock(struct omap_hsmmc_host *host)
  */
 static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host, SYSCTL,
-		OMAP_HSMMC_READ(host, SYSCTL) & ~CEN);
-	if ((OMAP_HSMMC_READ(host, SYSCTL) & CEN) != 0x0)
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & ~CEN);
+	if ((omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & CEN) != 0x0)
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stopped\n");
 }
 
@@ -558,16 +549,16 @@ static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
 	if (cmd->opcode == MMC_ERASE)
 		irq_mask &= ~DTO_EN;
 
-	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
-	OMAP_HSMMC_WRITE(host, ISE, irq_mask);
-	OMAP_HSMMC_WRITE(host, IE, irq_mask);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_STAT, STAT_CLEAR);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_ISE, irq_mask);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_IE, irq_mask);
 }
 
 static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host, ISE, 0);
-	OMAP_HSMMC_WRITE(host, IE, 0);
-	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_ISE, 0);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_IE, 0);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_STAT, STAT_CLEAR);
 }
 
 /* Calculate divisor for the given clock frequency */
@@ -595,17 +586,17 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 
 	omap_hsmmc_stop_clock(host);
 
-	regval = OMAP_HSMMC_READ(host, SYSCTL);
+	regval = omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL);
 	regval = regval & ~(CLKD_MASK | DTO_MASK);
 	clkdiv = calc_divisor(host, ios);
 	regval = regval | (clkdiv << 6) | (DTO << 16);
-	OMAP_HSMMC_WRITE(host, SYSCTL, regval);
-	OMAP_HSMMC_WRITE(host, SYSCTL,
-		OMAP_HSMMC_READ(host, SYSCTL) | ICE);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL, regval);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) | ICE);
 
 	/* Wait till the ICS bit is set */
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host, SYSCTL) & ICS) != ICS
+	while ((omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & ICS) != ICS
 		&& time_before(jiffies, timeout))
 		cpu_relax();
 
@@ -620,14 +611,14 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 	 */
 	if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
 	    (ios->timing != MMC_TIMING_UHS_DDR50) &&
-	    ((OMAP_HSMMC_READ(host, CAPA) & HSS) == HSS)) {
-		regval = OMAP_HSMMC_READ(host, HCTL);
+	    ((omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA) & HSS) == HSS)) {
+		regval = omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL);
 		if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)
 			regval |= HSPE;
 		else
 			regval &= ~HSPE;
 
-		OMAP_HSMMC_WRITE(host, HCTL, regval);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL, regval);
 	}
 
 	omap_hsmmc_start_clock(host);
@@ -638,24 +629,24 @@ static void omap_hsmmc_set_bus_width(struct omap_hsmmc_host *host)
 	struct mmc_ios *ios = &host->mmc->ios;
 	u32 con;
 
-	con = OMAP_HSMMC_READ(host, CON);
+	con = omap_hsmmc_read_offset(host, OMAP_HSMMC_CON);
 	if (ios->timing == MMC_TIMING_UHS_DDR50)
 		con |= DDR;	/* configure in DDR mode */
 	else
 		con &= ~DDR;
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_8:
-		OMAP_HSMMC_WRITE(host, CON, con | DW8);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_CON, con | DW8);
 		break;
 	case MMC_BUS_WIDTH_4:
-		OMAP_HSMMC_WRITE(host, CON, con & ~DW8);
-		OMAP_HSMMC_WRITE(host, HCTL,
-			OMAP_HSMMC_READ(host, HCTL) | FOUR_BIT);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_CON, con & ~DW8);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) | FOUR_BIT);
 		break;
 	case MMC_BUS_WIDTH_1:
-		OMAP_HSMMC_WRITE(host, CON, con & ~DW8);
-		OMAP_HSMMC_WRITE(host, HCTL,
-			OMAP_HSMMC_READ(host, HCTL) & ~FOUR_BIT);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_CON, con & ~DW8);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & ~FOUR_BIT);
 		break;
 	}
 }
@@ -665,11 +656,11 @@ static void omap_hsmmc_set_bus_mode(struct omap_hsmmc_host *host)
 	struct mmc_ios *ios = &host->mmc->ios;
 	u32 con;
 
-	con = OMAP_HSMMC_READ(host, CON);
+	con = omap_hsmmc_read_offset(host, OMAP_HSMMC_CON);
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
-		OMAP_HSMMC_WRITE(host, CON, con | OD);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_CON, con | OD);
 	else
-		OMAP_HSMMC_WRITE(host, CON, con & ~OD);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_CON, con & ~OD);
 }
 
 #ifdef CONFIG_PM
@@ -684,10 +675,10 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 	u32 hctl, capa;
 	unsigned long timeout;
 
-	if (host->con == OMAP_HSMMC_READ(host, CON) &&
-	    host->hctl == OMAP_HSMMC_READ(host, HCTL) &&
-	    host->sysctl == OMAP_HSMMC_READ(host, SYSCTL) &&
-	    host->capa == OMAP_HSMMC_READ(host, CAPA))
+	if (host->con == omap_hsmmc_read_offset(host, OMAP_HSMMC_CON) &&
+	    host->hctl == omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) &&
+	    host->sysctl == omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) &&
+	    host->capa == omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA))
 		return 0;
 
 	host->context_loss++;
@@ -704,17 +695,17 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 		capa = VS18;
 	}
 
-	OMAP_HSMMC_WRITE(host, HCTL,
-			OMAP_HSMMC_READ(host, HCTL) | hctl);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) | hctl);
 
-	OMAP_HSMMC_WRITE(host, CAPA,
-			OMAP_HSMMC_READ(host, CAPA) | capa);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CAPA,
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA) | capa);
 
-	OMAP_HSMMC_WRITE(host, HCTL,
-			OMAP_HSMMC_READ(host, HCTL) | SDBP);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) | SDBP);
 
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host, HCTL) & SDBP) != SDBP
+	while ((omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & SDBP) != SDBP
 		&& time_before(jiffies, timeout))
 		;
 
@@ -741,10 +732,10 @@ out:
  */
 static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
-	host->con =  OMAP_HSMMC_READ(host, CON);
-	host->hctl = OMAP_HSMMC_READ(host, HCTL);
-	host->sysctl =  OMAP_HSMMC_READ(host, SYSCTL);
-	host->capa = OMAP_HSMMC_READ(host, CAPA);
+	host->con =  omap_hsmmc_read_offset(host, OMAP_HSMMC_CON);
+	host->hctl = omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL);
+	host->sysctl =  omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL);
+	host->capa = omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA);
 }
 
 #else
@@ -774,20 +765,20 @@ static void send_init_stream(struct omap_hsmmc_host *host)
 
 	disable_irq(host->irq);
 
-	OMAP_HSMMC_WRITE(host, IE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host, CON,
-		OMAP_HSMMC_READ(host, CON) | INIT_STREAM);
-	OMAP_HSMMC_WRITE(host, CMD, INIT_STREAM_CMD);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_IE, INT_EN_MASK);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CON,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_CON) | INIT_STREAM);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CMD, INIT_STREAM_CMD);
 
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
 	while ((reg != CC_EN) && time_before(jiffies, timeout))
-		reg = OMAP_HSMMC_READ(host, STAT) & CC_EN;
+		reg = omap_hsmmc_read_offset(host, OMAP_HSMMC_STAT) & CC_EN;
 
-	OMAP_HSMMC_WRITE(host, CON,
-		OMAP_HSMMC_READ(host, CON) & ~INIT_STREAM);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CON,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_CON) & ~INIT_STREAM);
 
-	OMAP_HSMMC_WRITE(host, STAT, STAT_CLEAR);
-	OMAP_HSMMC_READ(host, STAT);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_STAT, STAT_CLEAR);
+	omap_hsmmc_read_offset(host, OMAP_HSMMC_STAT);
 
 	enable_irq(host->irq);
 }
@@ -866,7 +857,7 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	if ((host->flags & AUTO_CMD23) && mmc_op_multi(cmd->opcode) &&
 	    host->mrq->sbc) {
 		cmdreg |= ACEN_ACMD23;
-		OMAP_HSMMC_WRITE(host, SDMASA, host->mrq->sbc->arg);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_SDMASA, host->mrq->sbc->arg);
 	}
 	if (data) {
 		cmdreg |= DP_SELECT | MSBS | BCE;
@@ -881,8 +872,8 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 
 	host->req_in_progress = 1;
 
-	OMAP_HSMMC_WRITE(host, ARG, cmd->arg);
-	OMAP_HSMMC_WRITE(host, CMD, cmdreg);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_ARG, cmd->arg);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CMD, cmdreg);
 }
 
 static int
@@ -970,13 +961,13 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
 			/* response type 2 */
-			cmd->resp[3] = OMAP_HSMMC_READ(host, RSP10);
-			cmd->resp[2] = OMAP_HSMMC_READ(host, RSP32);
-			cmd->resp[1] = OMAP_HSMMC_READ(host, RSP54);
-			cmd->resp[0] = OMAP_HSMMC_READ(host, RSP76);
+			cmd->resp[3] = omap_hsmmc_read_offset(host, OMAP_HSMMC_RSP10);
+			cmd->resp[2] = omap_hsmmc_read_offset(host, OMAP_HSMMC_RSP32);
+			cmd->resp[1] = omap_hsmmc_read_offset(host, OMAP_HSMMC_RSP54);
+			cmd->resp[0] = omap_hsmmc_read_offset(host, OMAP_HSMMC_RSP76);
 		} else {
 			/* response types 1, 1b, 3, 4, 5, 6 */
-			cmd->resp[0] = OMAP_HSMMC_READ(host, RSP10);
+			cmd->resp[0] = omap_hsmmc_read_offset(host, OMAP_HSMMC_RSP10);
 		}
 	}
 	if ((host->data == NULL && !host->response_busy) || cmd->error)
@@ -1059,25 +1050,25 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
 	unsigned long i = 0;
 	unsigned long limit = MMC_TIMEOUT_US;
 
-	OMAP_HSMMC_WRITE(host, SYSCTL,
-			 OMAP_HSMMC_READ(host, SYSCTL) | bit);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL,
+			 omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) | bit);
 
 	/*
 	 * OMAP4 ES2 and greater has an updated reset logic.
 	 * Monitor a 0->1 transition first
 	 */
 	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
-		while ((!(OMAP_HSMMC_READ(host, SYSCTL) & bit))
+		while ((!(omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & bit))
 					&& (i++ < limit))
 			udelay(1);
 	}
 	i = 0;
 
-	while ((OMAP_HSMMC_READ(host, SYSCTL) & bit) &&
+	while ((omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & bit) &&
 		(i++ < limit))
 		udelay(1);
 
-	if (OMAP_HSMMC_READ(host, SYSCTL) & bit)
+	if (omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL) & bit)
 		dev_err(mmc_dev(host->mmc),
 			"Timeout waiting on controller reset in %s\n",
 			__func__);
@@ -1120,7 +1111,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 
 		if (status & ACE_EN) {
 			u32 ac12;
-			ac12 = OMAP_HSMMC_READ(host, AC12);
+			ac12 = omap_hsmmc_read_offset(host, OMAP_HSMMC_AC12);
 			if (!(ac12 & ACNE) && host->mrq->sbc) {
 				end_cmd = 1;
 				if (ac12 & ACTO)
@@ -1138,7 +1129,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 		}
 	}
 
-	OMAP_HSMMC_WRITE(host, STAT, status);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_STAT, status);
 	if (end_cmd || ((status & CC_EN) && host->cmd))
 		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC_EN)) && host->mrq)
@@ -1153,12 +1144,12 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 	struct omap_hsmmc_host *host = dev_id;
 	int status;
 
-	status = OMAP_HSMMC_READ(host, STAT);
+	status = omap_hsmmc_read_offset(host, OMAP_HSMMC_STAT);
 	while (status & INT_EN_MASK && host->req_in_progress) {
 		omap_hsmmc_do_irq(host, status);
 
 		/* Flush posted write */
-		status = OMAP_HSMMC_READ(host, STAT);
+		status = omap_hsmmc_read_offset(host, OMAP_HSMMC_STAT);
 	}
 
 	return IRQ_HANDLED;
@@ -1168,10 +1159,10 @@ static void set_sd_bus_power(struct omap_hsmmc_host *host)
 {
 	unsigned long i;
 
-	OMAP_HSMMC_WRITE(host, HCTL,
-			 OMAP_HSMMC_READ(host, HCTL) | SDBP);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+			 omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) | SDBP);
 	for (i = 0; i < loops_per_jiffy; i++) {
-		if (OMAP_HSMMC_READ(host, HCTL) & SDBP)
+		if (omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & SDBP)
 			break;
 		cpu_relax();
 	}
@@ -1208,9 +1199,9 @@ static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 	if (ret != 0)
 		goto err;
 
-	OMAP_HSMMC_WRITE(host, HCTL,
-		OMAP_HSMMC_READ(host, HCTL) & SDVSCLR);
-	reg_val = OMAP_HSMMC_READ(host, HCTL);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+		omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & SDVSCLR);
+	reg_val = omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL);
 
 	/*
 	 * If a MMC dual voltage card is detected, the set_ios fn calls
@@ -1232,7 +1223,7 @@ static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 	else
 		reg_val |= SDVS30;
 
-	OMAP_HSMMC_WRITE(host, HCTL, reg_val);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL, reg_val);
 	set_sd_bus_power(host);
 
 	return 0;
@@ -1433,7 +1424,7 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 	unsigned int timeout, cycle_ns;
 	uint32_t reg, clkd, dto = 0;
 
-	reg = OMAP_HSMMC_READ(host, SYSCTL);
+	reg = omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL);
 	clkd = (reg & CLKD_MASK) >> CLKD_SHIFT;
 	if (clkd == 0)
 		clkd = 1;
@@ -1460,7 +1451,7 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 
 	reg &= ~DTO_MASK;
 	reg |= dto << DTO_SHIFT;
-	OMAP_HSMMC_WRITE(host, SYSCTL, reg);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_SYSCTL, reg);
 }
 
 static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host)
@@ -1470,7 +1461,7 @@ static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host)
 
 	if (!req->data)
 		return;
-	OMAP_HSMMC_WRITE(host, BLK, (req->data->blksz)
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_BLK, (req->data->blksz)
 				| (req->data->blocks << 16));
 	set_data_timeout(host, req->data->timeout_ns,
 				req->data->timeout_clks);
@@ -1488,7 +1479,7 @@ omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 	host->data = req->data;
 
 	if (req->data == NULL) {
-		OMAP_HSMMC_WRITE(host, BLK, 0);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_BLK, 0);
 		/*
 		 * Set an arbitrary 100ms data timeout for commands with
 		 * busy signal.
@@ -1625,7 +1616,7 @@ static void omap_hsmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		/* Only MMC1 can interface at 3V without some flavor
 		 * of external transceiver; but they all handle 1.8V.
 		 */
-		if ((OMAP_HSMMC_READ(host, HCTL) & SDVSDET) &&
+		if ((omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & SDVSDET) &&
 			(ios->vdd == DUAL_VOLT_OCR_BIT)) {
 				/*
 				 * The mmc_select_voltage fn of the core does
@@ -1688,11 +1679,11 @@ static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 		capa = VS18;
 	}
 
-	value = OMAP_HSMMC_READ(host, HCTL) & ~SDVS_MASK;
-	OMAP_HSMMC_WRITE(host, HCTL, value | hctl);
+	value = omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL) & ~SDVS_MASK;
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL, value | hctl);
 
-	value = OMAP_HSMMC_READ(host, CAPA);
-	OMAP_HSMMC_WRITE(host, CAPA, value | capa);
+	value = omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA);
+	omap_hsmmc_write_offset(host, OMAP_HSMMC_CAPA, value | capa);
 
 	/* Set SD bus power bit */
 	set_sd_bus_power(host);
@@ -1743,17 +1734,17 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 	pm_runtime_get_sync(host->dev);
 
 	seq_printf(s, "CON:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, CON));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_CON));
 	seq_printf(s, "HCTL:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, HCTL));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL));
 	seq_printf(s, "SYSCTL:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, SYSCTL));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_SYSCTL));
 	seq_printf(s, "IE:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, IE));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_IE));
 	seq_printf(s, "ISE:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, ISE));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_ISE));
 	seq_printf(s, "CAPA:\t\t0x%08x\n",
-			OMAP_HSMMC_READ(host, CAPA));
+			omap_hsmmc_read_offset(host, OMAP_HSMMC_CAPA));
 
 	pm_runtime_mark_last_busy(host->dev);
 	pm_runtime_put_autosuspend(host->dev);
@@ -2230,8 +2221,9 @@ static int omap_hsmmc_suspend(struct device *dev)
 
 	if (!(host->mmc->pm_flags & MMC_PM_KEEP_POWER)) {
 		omap_hsmmc_disable_irq(host);
-		OMAP_HSMMC_WRITE(host, HCTL,
-				OMAP_HSMMC_READ(host, HCTL) & ~SDBP);
+		omap_hsmmc_write_offset(host, OMAP_HSMMC_HCTL,
+				omap_hsmmc_read_offset(host, OMAP_HSMMC_HCTL)
+				& ~SDBP);
 	}
 
 	if (host->dbclk)
-- 
1.9.1.286.g5172cb3

