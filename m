Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3JELTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 07:19:38 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55814 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3JELTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 07:19:35 -0400
From: Andreas Fenkart <afenkart@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v3 2/4] mmc: omap_hsmmc: Enable SDIO IRQ.
Date: Sat,  5 Oct 2013 13:17:08 +0200
Message-Id: <1380971830-21492-3-git-send-email-afenkart@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, only support SDIO interrupt if we are booted with
DT. This is because some platforms need special quirks. And
we don't want to add new legacy mux platform init code
callbacks any longer as we are moving to DT based booting
anyways.

Broken hardware, missing the swakueup line, should fallback
to polling, by setting 'ti,quirk-swakup-missing' in the
device tree. Otherwise pending SDIO IRQ are not detected
while in suspend. This affects am33xx processors.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index ed271fc..1136e6b 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -20,6 +20,24 @@ ti,dual-volt: boolean, supports dual voltage cards
 ti,non-removable: non-removable slot (like eMMC)
 ti,needs-special-reset: Requires a special softreset sequence
 ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
+ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
+SDIO irq while in suspend. Fallback to polling. Affected chips are
+am335x,
+
+                            ------
+                            | PRCM |
+                             ------
+                              ^ |
+                      swakeup | | fclk
+                              | v
+      ------                -------               -----
+     | card | -- CIRQ -->  | hsmmc | -- IRQ -->  | CPU |
+      ------                -------               -----
+
+In suspend the fclk is off and the module is disfunctional. Even
+register reads will fail. A small logic in the host will request fclk
+restore, when an external event is detected. Once the clock is
+restored, the host detects the event normally.
 
 Example:
 	mmc1: mmc@0x4809c000 {
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 94d6dc8..53beac4 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -130,6 +130,7 @@ static void apply_clk_hack(struct device *dev)
 #define TC_EN			(1 << 1)
 #define BWR_EN			(1 << 4)
 #define BRR_EN			(1 << 5)
+#define CIRQ_EN			(1 << 8)
 #define ERR_EN			(1 << 15)
 #define CTO_EN			(1 << 16)
 #define CCRC_EN			(1 << 17)
@@ -210,6 +211,10 @@ struct omap_hsmmc_host {
 	int			reqs_blocked;
 	int			use_reg;
 	int			req_in_progress;
+	int                     flags;
+#define HSMMC_RUNTIME_SUSPENDED	(1 << 0)        /* Runtime suspended */
+#define HSMMC_SDIO_IRQ_ENABLED	(1 << 1)        /* SDIO irq enabled */
+
 	struct omap_hsmmc_next	next_data;
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -490,27 +495,40 @@ static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
 				  struct mmc_command *cmd)
 {
-	unsigned int irq_mask;
+	u32 irq_mask = INT_EN_MASK;
+	unsigned long flags;
 
 	if (host->use_dma)
-		irq_mask = INT_EN_MASK & ~(BRR_EN | BWR_EN);
-	else
-		irq_mask = INT_EN_MASK;
+		irq_mask &= ~(BRR_EN | BWR_EN);
 
 	/* Disable timeout for erases */
 	if (cmd->opcode == MMC_ERASE)
 		irq_mask &= ~DTO_EN;
 
+	spin_lock_irqsave(&host->irq_lock, flags);
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
+
+	/* latch pending CIRQ, but don't signal */
+	if (host->flags & HSMMC_SDIO_IRQ_ENABLED)
+		irq_mask |= CIRQ_EN;
 	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
+	spin_unlock_irqrestore(&host->irq_lock, flags);
 }
 
 static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
 {
-	OMAP_HSMMC_WRITE(host->base, ISE, 0);
-	OMAP_HSMMC_WRITE(host->base, IE, 0);
+	u32 irq_mask = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->irq_lock, flags);
+	/* no transfer running, need to signal cirq if */
+	if (host->flags & HSMMC_SDIO_IRQ_ENABLED)
+		irq_mask |= CIRQ_EN;
+	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
+	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+	spin_unlock_irqrestore(&host->irq_lock, flags);
 }
 
 /* Calculate divisor for the given clock frequency */
@@ -1067,8 +1085,12 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 	int status;
 
 	status = OMAP_HSMMC_READ(host->base, STAT);
-	while (status & INT_EN_MASK && host->req_in_progress) {
-		omap_hsmmc_do_irq(host, status);
+	while (status & (INT_EN_MASK | CIRQ_EN)) {
+		if (host->req_in_progress)
+			omap_hsmmc_do_irq(host, status);
+
+		if (status & CIRQ_EN)
+			mmc_signal_sdio_irq(host->mmc);
 
 		/* Flush posted write */
 		status = OMAP_HSMMC_READ(host->base, STAT);
@@ -1583,6 +1605,42 @@ static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
 		mmc_slot(host).init_card(card);
 }
 
+static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
+	u32 irq_mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->irq_lock, flags);
+
+	if (enable)
+		host->flags |= HSMMC_SDIO_IRQ_ENABLED;
+	else
+		host->flags &= ~HSMMC_SDIO_IRQ_ENABLED;
+
+	/* if statement here with followup patch */
+	{
+		irq_mask = OMAP_HSMMC_READ(host->base, ISE);
+		if (enable)
+			irq_mask |= CIRQ_EN;
+		else
+			irq_mask &= ~CIRQ_EN;
+		OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
+
+		/*
+		 * if enable, piggy back on current request
+		 * but always disable
+		 */
+		if (!host->req_in_progress || !enable)
+			OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
+
+		/* flush posted write */
+		OMAP_HSMMC_READ(host->base, IE);
+	}
+
+	spin_unlock_irqrestore(&host->irq_lock, flags);
+}
+
 static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 {
 	u32 hctl, capa, value;
@@ -1635,7 +1693,7 @@ static const struct mmc_host_ops omap_hsmmc_ops = {
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
 	.init_card = omap_hsmmc_init_card,
-	/* NYET -- enable_sdio_irq */
+	.enable_sdio_irq = omap_hsmmc_enable_sdio_irq,
 };
 
 #ifdef CONFIG_DEBUG_FS
@@ -1833,6 +1891,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	host->dma_ch	= -1;
 	host->irq	= irq;
 	host->slot_id	= 0;
+	host->flags	= 0;
 	host->mapbase	= res->start + pdata->reg_offset;
 	host->base	= ioremap(host->mapbase, SZ_4K);
 	host->power_mode = MMC_POWER_OFF;
@@ -2023,6 +2082,22 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev,
 			"pins are not configured from the driver\n");
 
+	/*
+	 * For now, only support SDIO interrupt if we are booted with
+	 * DT. This is because some platforms need special quirks. And
+	 * we don't want to add new legacy mux platform init code
+	 * callbacks any longer as we are moving to DT based booting
+	 * anyways.
+	 */
+	if (match) {
+		mmc->caps |= MMC_CAP_SDIO_IRQ;
+		if (of_find_property(host->dev->of_node,
+				     "ti,quirk-swakeup-missing", NULL)) {
+			/* no wakeup from deeper power states, use polling */
+			mmc->caps &= ~MMC_CAP_SDIO_IRQ;
+		}
+	}
+
 	omap_hsmmc_protect_card(host);
 
 	mmc_add_host(mmc);
-- 
1.7.10.4

