Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaAORwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:52:00 -0500
Received: from nm27-vm6.bullet.mail.gq1.yahoo.com ([98.136.216.149]:32246 "EHLO
	nm27-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbaAORv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:51:58 -0500
X-Yahoo-Newman-Id: 620522.3330.bm@smtp201.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EriH8O8VM1kruMJ_KlCItNJFBQ1HjQLKaWBo0OwRv8gnjxX
 S1mqCyMzWbyEsNos65xaIMDhd.o8icxzuJM.4dVGgwThkNGDbQqaxGlAe0ZB
 kv1FvlBPw9K4WIEMFJd3NLykOWB6ASj_Xe2cTORWqFPIpyLtFHMUh4en9LwY
 t.Eh5Yimpfwu4IS.1_Mgql1W1uqlU0ixTJi7o1jEn2ZG_XxQy3BzvXFDI.06
 wWBOyom0bqVRhwt1sHSJ3de.xF.sWFX3DeUHpU.MMDGYL.n5Z_iAwnG4KwPI
 Fj2lPKX9Z4d8PN1OF9aYnptBtC0.ItJxW1AaBcJYhWEF7z6Mi5PrD5CeS.3n
 r0xUxoQpyeowMqolbPWjAAY6iZ.l.YYTAOGen4CkujnaAKVkzdxjYAkMH1.a
 RVpK2D_oRXTB_.kftVtuvEajWhRGhxPebetOylLFuYVkSwMD_5Pz9ba4XDWQ
 327lnCAHdTknGcAE2srn1H4li4aczLE3OWk4K.PhZIpEydaDIwCS_O0HO0aE
 uBb07rzaUCRBfUSO90pWh8iPMLRiLaPbJ0xs-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [63.250.193.228])
        by smtp201.mail.gq1.yahoo.com with SMTP; 15 Jan 2014 17:51:57 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v6] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Wed, 15 Jan 2014 11:51:51 -0600
Message-Id: <1389808311-4511-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for ni_mio_common.c changes out a while loop for a timeout,
which is preferred.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

4: No longer using counter variable, using jiffies instead.

5: udelay for 10u, instead of 1u.

6: Scrap udelay entirely, in favor of cpu_relax.  Include asm/processor.h
in order to use cpu_relax.

 drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..fe2f434 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -55,6 +55,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
+#include <asm/processor.h>
 #include "8255.h"
 #include "mite.h"
 #include "comedi_fc.h"
@@ -687,12 +688,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
 {
 	const struct ni_board_struct *board = comedi_board(dev);
 	struct ni_private *devpriv = dev->private;
+	unsigned long timeout;
 
 	if (board->reg_type == ni_reg_6143) {
 		/*  Flush the 6143 data FIFO */
 		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
 		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
-		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
+		/*  Wait for complete */
+		timeout = jiffies + msec_to_jiffies(500);
+		while (ni_readl(AIFIFO_Status_6143) & 0x10) {
+			if (time_after(jiffies, timeout)) {
+				comedi_error(dev, "FIFO flush timeout.");
+				break;
+			}
+			cpu_relax();
+		}
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

