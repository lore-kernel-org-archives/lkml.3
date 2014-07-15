Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaGOKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:33:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55540 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758678AbaGOKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:32:34 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6 RESEND] mfd: arizona: Only free the CTRLIF_ERR IRQ if we requested it
Date: Tue, 15 Jul 2014 11:21:50 +0100
Message-Id: <1405419710-14789-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only request the control interface error IRQ if we set ctrlif_error,
as such we should only free it in that situation. Otherwise we will
attempt to free an IRQ we never requested and get a warning from the IRQ
core.

This patch moves the ctrlif_error variable into the arizona structure
and checks it in all cases we free the control interface error IRQ.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c        |   19 ++++++++++++-------
 include/linux/mfd/arizona/core.h |    2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index e780bc4..d420dbc 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -188,16 +188,17 @@ int arizona_irq_init(struct arizona *arizona)
 	int flags = IRQF_ONESHOT;
 	int ret, i;
 	const struct regmap_irq_chip *aod, *irq;
-	bool ctrlif_error = true;
 	struct irq_data *irq_data;
 
+	arizona->ctrlif_error = true;
+
 	switch (arizona->type) {
 #ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		aod = &wm5102_aod;
 		irq = &wm5102_irq;
 
-		ctrlif_error = false;
+		arizona->ctrlif_error = false;
 		break;
 #endif
 #ifdef CONFIG_MFD_WM5110
@@ -213,7 +214,7 @@ int arizona_irq_init(struct arizona *arizona)
 			break;
 		}
 
-		ctrlif_error = false;
+		arizona->ctrlif_error = false;
 		break;
 #endif
 #ifdef CONFIG_MFD_WM8997
@@ -221,7 +222,7 @@ int arizona_irq_init(struct arizona *arizona)
 		aod = &wm8997_aod;
 		irq = &wm8997_irq;
 
-		ctrlif_error = false;
+		arizona->ctrlif_error = false;
 		break;
 #endif
 	default:
@@ -308,7 +309,7 @@ int arizona_irq_init(struct arizona *arizona)
 	}
 
 	/* Handle control interface errors in the core */
-	if (ctrlif_error) {
+	if (arizona->ctrlif_error) {
 		i = arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR);
 		ret = request_threaded_irq(i, NULL, arizona_ctrlif_err,
 					   IRQF_ONESHOT,
@@ -353,7 +354,9 @@ int arizona_irq_init(struct arizona *arizona)
 	return 0;
 
 err_main_irq:
-	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR), arizona);
+	if (arizona->ctrlif_error)
+		free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR),
+			 arizona);
 err_ctrlif:
 	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_BOOT_DONE), arizona);
 err_boot_done:
@@ -369,7 +372,9 @@ err:
 
 int arizona_irq_exit(struct arizona *arizona)
 {
-	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR), arizona);
+	if (arizona->ctrlif_error)
+		free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR),
+			 arizona);
 	free_irq(arizona_map_irq(arizona, ARIZONA_IRQ_BOOT_DONE), arizona);
 	regmap_del_irq_chip(irq_create_mapping(arizona->virq, 1),
 			    arizona->irq_chip);
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 8bc7601..fdd8b7b 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -132,6 +132,8 @@ struct arizona {
 	struct mutex clk_lock;
 	int clk32k_ref;
 
+	bool ctrlif_error;
+
 	struct snd_soc_dapm_context *dapm;
 };
 
-- 
1.7.2.5

