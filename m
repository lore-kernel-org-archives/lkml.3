Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3GAIkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:40:22 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43534 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3GAIkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:18 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/13] sound: atmel_ssc_dai: PM: actually stopping clock on suspend/resume
Date: Mon,  1 Jul 2013 10:39:35 +0200
Message-Id: <1372667978-4718-11-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Stop SSC clock on suspend/resume cycle checking if the controller is actually
initialized. This will save power while sleeping.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 sound/soc/atmel/atmel_ssc_dai.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index f3fdfa0..14da27a 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -659,12 +659,10 @@ static int atmel_ssc_prepare(struct snd_pcm_substream *substream,
 #ifdef CONFIG_PM
 static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 {
-	struct atmel_ssc_info *ssc_p;
+	struct atmel_ssc_info *ssc_p = &ssc_info[cpu_dai->id];
 
 	if (!cpu_dai->active)
-		return 0;
-
-	ssc_p = &ssc_info[cpu_dai->id];
+		goto out;
 
 	/* Save the status register before disabling transmit and receive */
 	ssc_p->ssc_state.ssc_sr = ssc_readl(ssc_p->ssc->regs, SR);
@@ -680,6 +678,11 @@ static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 	ssc_p->ssc_state.ssc_tcmr = ssc_readl(ssc_p->ssc->regs, TCMR);
 	ssc_p->ssc_state.ssc_tfmr = ssc_readl(ssc_p->ssc->regs, TFMR);
 
+out:
+	if (ssc_p->initialized) {
+		pr_debug("atmel_ssc_dai: suspend - stop clock\n");
+		clk_disable(ssc_p->ssc->clk);
+	}
 	return 0;
 }
 
@@ -687,14 +690,17 @@ static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 
 static int atmel_ssc_resume(struct snd_soc_dai *cpu_dai)
 {
-	struct atmel_ssc_info *ssc_p;
+	struct atmel_ssc_info *ssc_p = &ssc_info[cpu_dai->id];
 	u32 cr;
 
+	if (ssc_p->initialized) {
+		pr_debug("atmel_ssc_dai: resume - restart clock\n");
+		clk_enable(ssc_p->ssc->clk);
+	}
+
 	if (!cpu_dai->active)
 		return 0;
 
-	ssc_p = &ssc_info[cpu_dai->id];
-
 	/* restore SSC register settings */
 	ssc_writel(ssc_p->ssc->regs, TFMR, ssc_p->ssc_state.ssc_tfmr);
 	ssc_writel(ssc_p->ssc->regs, TCMR, ssc_p->ssc_state.ssc_tcmr);
-- 
1.7.10.4

