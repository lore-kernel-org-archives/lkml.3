Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaDHOUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:20:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756980AbaDHOUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:20:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] sound: lx_core: Few misc cleanups
Date: Tue,  8 Apr 2014 16:15:33 +0200
Message-Id: <1396966533-505-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file had a few comments in french that are now in english, and took the
opportunity to cleanup a bunch of #if 0 .. #endif and commented out code

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 70 +++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 626ecad4dae7..002049770ff7 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -22,8 +22,7 @@
  *
  */
 
-/* #define RMH_DEBUG 1 */
-
+#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
@@ -496,15 +495,17 @@ int lx_dsp_es_check_pipeline(struct lx6464es *chip)
 	int i;
 
 	for (i = 0; i != CSES_TIMEOUT; ++i) {
-		/*
-		 * le bit CSES_UPDATE_LDSV est Ã  1 dÃ©s que le macprog
-		 * est pret. il re-passe Ã  0 lorsque le premier read a
-		 * Ã©tÃ© fait. pour l'instant on retire le test car ce bit
-		 * passe a 1 environ 200 Ã  400 ms aprÃ©s que le registre
-		 * confES Ã  Ã©tÃ© Ã©crit (kick du xilinx ES).
+		/* 
+		 * The bit CSES_UPDATE_LDSV is set to 1 as soon as the
+		 * macprog is ready. He goes back to 0 whenever the
+		 * first read has been issued.
+		 *
+		 * For now, we don't bother testing this bit because
+		 * it's set to 1 between 200 to 400ms after the confES
+		 * register has been written to (xilinx ES kick).
 		 *
-		 * On ne teste que le bit CE.
-		 * */
+		 * We only test the CE bit.
+		 */
 
 		u32 cses = lx_dsp_reg_read(chip, eReg_CSES);
 
@@ -602,8 +603,7 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 				/* free */
 				*r_needed += 1;
 		}
-
-#if 0
+#if DEBUG
 		snd_printdd(LXP "CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
 		for (i = 0; i < MAX_STREAM_BUFFER; ++i) {
@@ -1049,9 +1049,9 @@ int lx_level_peaks(struct lx6464es *chip, int is_capture, int channels,
 
 /* interrupt handling */
 #define PCX_IRQ_NONE 0
-#define IRQCS_ACTIVE_PCIDB  0x00002000L         /* Bit nÃÂ¸ 13 */
-#define IRQCS_ENABLE_PCIIRQ 0x00000100L         /* Bit nÃÂ¸ 08 */
-#define IRQCS_ENABLE_PCIDB  0x00000200L         /* Bit nÃÂ¸ 09 */
+#define IRQCS_ACTIVE_PCIDB	BIT(13)
+#define IRQCS_ENABLE_PCIIRQ	BIT(8)
+#define IRQCS_ENABLE_PCIDB	BIT(9)
 
 static u32 lx_interrupt_test_ack(struct lx6464es *chip)
 {
@@ -1108,25 +1108,21 @@ static int lx_interrupt_handle_async_events(struct lx6464es *chip, u32 irqsrc,
 	int err;
 	u32 stat[9];		/* answer from CMD_04_GET_EVENT */
 
-	/* On peut optimiser pour ne pas lire les evenements vides
-	 * les mots de rÃÂ©ponse sont dans l'ordre suivant :
-	 * Stat[0]	mot de status gÃÂ©nÃÂ©ral
-	 * Stat[1]	fin de buffer OUT pF
-	 * Stat[2]	fin de buffer OUT pf
-	 * Stat[3]	fin de buffer IN pF
-	 * Stat[4]	fin de buffer IN pf
-	 * Stat[5]	underrun poid fort
-	 * Stat[6]	underrun poid faible
-	 * Stat[7]	overrun poid fort
-	 * Stat[8]	overrun poid faible
+	/* We can optimize this to not read dumb events.
+	 * Answer words are in the following order:
+	 * Stat[0]	general status
+	 * Stat[1]	end of buffer OUT pF
+	 * Stat[2]	end of buffer OUT pf
+	 * Stat[3]	end of buffer IN pF
+	 * Stat[4]	end of buffer IN pf
+	 * Stat[5]	MSB underrun
+	 * Stat[6]	LSB underrun
+	 * Stat[7]	MSB overrun
+	 * Stat[8]	LSB overrun
 	 * */
 
 	u64 orun_mask;
 	u64 urun_mask;
-#if 0
-	int has_underrun   = (irqsrc & MASK_SYS_STATUS_URUN) ? 1 : 0;
-	int has_overrun    = (irqsrc & MASK_SYS_STATUS_ORUN) ? 1 : 0;
-#endif
 	int eb_pending_out = (irqsrc & MASK_SYS_STATUS_EOBO) ? 1 : 0;
 	int eb_pending_in  = (irqsrc & MASK_SYS_STATUS_EOBI) ? 1 : 0;
 
@@ -1272,7 +1268,7 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 	if (irqsrc & MASK_SYS_STATUS_CMD_DONE)
 		goto exit;
 
-#if 0
+#if DEBUG
 	if (irqsrc & MASK_SYS_STATUS_EOBI)
 		snd_printdd(LXP "interrupt: EOBI\n");
 
@@ -1310,18 +1306,6 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 				   "error during audio transfer\n");
 	}
 
-	if (async_escmd) {
-#if 0
-		/* backdoor for ethersound commands
-		 *
-		 * for now, we do not need this
-		 *
-		 * */
-
-		snd_printdd("lx6464es: interrupt requests escmd handling\n");
-#endif
-	}
-
 exit:
 	spin_unlock(&chip->lock);
 	return IRQ_HANDLED;	/* this device caused the interrupt */
-- 
1.9.1

