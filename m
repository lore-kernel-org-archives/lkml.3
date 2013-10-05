Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3JELUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 07:20:01 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64431 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3JELT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 07:19:58 -0400
From: Andreas Fenkart <afenkart@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v3 4/4] mmc: omap_hsmmc: debugfs entries for SDIO IRQ detection and GPIO remuxing.
Date: Sat,  5 Oct 2013 13:17:10 +0200
Message-Id: <1380971830-21492-5-git-send-email-afenkart@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the debugfs related code for the SDIO IRQ support.
Note that PSTATE shows current state of data lines, incl.
SDIO IRQ pending

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index a8894ee..f7fe06f 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -81,6 +81,7 @@ static void apply_clk_hack(struct device *dev)
 #define OMAP_HSMMC_RSP54	0x0118
 #define OMAP_HSMMC_RSP76	0x011C
 #define OMAP_HSMMC_DATA		0x0120
+#define OMAP_HSMMC_PSTATE	0x0124
 #define OMAP_HSMMC_HCTL		0x0128
 #define OMAP_HSMMC_SYSCTL	0x012C
 #define OMAP_HSMMC_STAT		0x0130
@@ -1812,6 +1813,22 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 {
 	struct mmc_host *mmc = s->private;
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->irq_lock, flags);
+	seq_puts(s, "\n");
+	seq_printf(s, "sdio irq\t%s\n", ((host->flags & HSMMC_SDIO_IRQ_ENABLED)
+					 ? "enabled" : "disabled"));
+	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
+		seq_printf(s, "pinmux config\t%s\n", ((host->flags &
+						       HSMMC_RUNTIME_SUSPENDED)
+						      ?  "gpio" : "sdio"));
+		if (host->flags & HSMMC_RUNTIME_SUSPENDED)
+			seq_printf(s, "sdio irq pin\t%s\n",
+				   gpio_get_value(mmc_slot(host).gpio_cirq) ?
+				   "high" : "low");
+	}
+	spin_unlock_irqrestore(&host->irq_lock, flags);
 
 	if (host->suspended) {
 		seq_printf(s, "host suspended, can't read registers\n");
@@ -1819,9 +1836,11 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 	}
 
 	pm_runtime_get_sync(host->dev);
-
+	seq_puts(s, "\nregs:\n");
 	seq_printf(s, "CON:\t\t0x%08x\n",
 			OMAP_HSMMC_READ(host->base, CON));
+	seq_printf(s, "PSTATE:\t\t0x%08x\n",
+		   OMAP_HSMMC_READ(host->base, PSTATE));
 	seq_printf(s, "HCTL:\t\t0x%08x\n",
 			OMAP_HSMMC_READ(host->base, HCTL));
 	seq_printf(s, "SYSCTL:\t\t0x%08x\n",
-- 
1.7.10.4

