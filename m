Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3JELTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 07:19:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56182 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3JELT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 07:19:26 -0400
From: Andreas Fenkart <afenkart@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v3 1/4] mmc: omap_hsmmc: Fix context save and restore for DT
Date: Sat,  5 Oct 2013 13:17:07 +0200
Message-Id: <1380971830-21492-2-git-send-email-afenkart@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

We want to get rid of the omap specific platform init code
callbacks as they don't play nice with device tree.

Let's convert the context loss check to be based on a
register state detection instead.

Cc: Andreas Fenkart <afenkart@gmail.com>
Cc: Balaji T K <balajitk@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 260cdb4..94d6dc8 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -198,19 +198,19 @@ struct omap_hsmmc_host {
 	unsigned char		bus_mode;
 	unsigned char		power_mode;
 	int			suspended;
+	u32			hctl;
+	u32			capa;
 	int			irq;
 	int			use_dma, dma_ch;
 	struct dma_chan		*tx_chan;
 	struct dma_chan		*rx_chan;
 	int			slot_id;
 	int			response_busy;
-	int			context_loss;
 	int			protect_card;
 	int			reqs_blocked;
 	int			use_reg;
 	int			req_in_progress;
 	struct omap_hsmmc_next	next_data;
-
 	struct	omap_mmc_platform_data	*pdata;
 };
 
@@ -624,25 +624,16 @@ static void omap_hsmmc_set_bus_mode(struct omap_hsmmc_host *host)
 static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
-	struct omap_mmc_platform_data *pdata = host->pdata;
-	int context_loss = 0;
 	u32 hctl, capa;
 	unsigned long timeout;
 
-	if (pdata->get_context_loss_count) {
-		context_loss = pdata->get_context_loss_count(host->dev);
-		if (context_loss < 0)
-			return 1;
-	}
-
-	dev_dbg(mmc_dev(host->mmc), "context was %slost\n",
-		context_loss == host->context_loss ? "not " : "");
-	if (host->context_loss == context_loss)
-		return 1;
-
 	if (!OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE)
 		return 1;
 
+	if (host->hctl == OMAP_HSMMC_READ(host->base, HCTL) &&
+	    host->capa == OMAP_HSMMC_READ(host->base, CAPA))
+		return 0;
+
 	if (host->pdata->controller_flags & OMAP_HSMMC_SUPPORTS_DUAL_VOLT) {
 		if (host->power_mode != MMC_POWER_OFF &&
 		    (1 << ios->vdd) <= MMC_VDD_23_24)
@@ -682,8 +673,6 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 	omap_hsmmc_set_bus_mode(host);
 
 out:
-	host->context_loss = context_loss;
-
 	dev_dbg(mmc_dev(host->mmc), "context is restored\n");
 	return 0;
 }
@@ -693,15 +682,8 @@ out:
  */
 static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
-	struct omap_mmc_platform_data *pdata = host->pdata;
-	int context_loss;
-
-	if (pdata->get_context_loss_count) {
-		context_loss = pdata->get_context_loss_count(host->dev);
-		if (context_loss < 0)
-			return;
-		host->context_loss = context_loss;
-	}
+	host->hctl = OMAP_HSMMC_READ(host->base, HCTL);
+	host->capa = OMAP_HSMMC_READ(host->base, CAPA);
 }
 
 #else
@@ -1662,13 +1644,6 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 {
 	struct mmc_host *mmc = s->private;
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
-	int context_loss = 0;
-
-	if (host->pdata->get_context_loss_count)
-		context_loss = host->pdata->get_context_loss_count(host->dev);
-
-	seq_printf(s, "mmc%d:\n ctx_loss:\t%d:%d\n\nregs:\n",
-			mmc->index, host->context_loss, context_loss);
 
 	if (host->suspended) {
 		seq_printf(s, "host suspended, can't read registers\n");
-- 
1.7.10.4

