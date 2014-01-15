Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaAOTWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:22:40 -0500
Received: from nm1.bullet.mail.gq1.yahoo.com ([98.136.218.75]:40268 "EHLO
	nm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaAOTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:22:38 -0500
X-Yahoo-Newman-Id: 138747.61810.bm@smtp240.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: I_ZU5JMVM1mNiWNEyiRhsSAbhhjhDRehISuzrM5wLKo4quJ
 K0ZYceMaFMI_bSfRBvdgYb1..tx_C6vsGYnbhn52FoWFFSo1DsnJGe4KcE6v
 FXainzDm7F9PjFjaUXUa3cZcMo7eRoKvBKe4UUPcg3fek1MwjBIS5uMENoa7
 rWWj3hTauAzwgonNCw1dB8XwOhPf1mgeT8flEZtCi1SV0jEKSx7SsbhhQJuv
 lJZDMidPFYcEKbc7_b18WQo1tybsnUBhp1K4g4qgEO79pDs9bQoU1xT6yHPD
 lfr9d3zhuBJ3Ye58ARvFcjMOzhCUjLMeBHnfnLZynjtLq0Po30btiFxpFGA9
 xqPXvnq9.rO7hqEnZKBrtnyJu7CbZEWn1ctVDWStKI1XzlbGviK3qG7DeD0w
 cSYEMT5V_FgcXO8E84XqiQySC.5Sno0hp2xFIbnixmj5MxIcDR8EbQARhw2X
 PoI3ZkCm88Bf8MoOAO0EsNxpSrEIIRyXexiV0Row6_0kLmShszXkCqBtZKGD
 7ZoHxH2iliFZ_w4__tEDh1c8lMRdP0Iw9LSs-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain.com (chase.southwood@50.44.157.207 with plain [98.138.105.21])
        by smtp240.mail.gq1.yahoo.com with SMTP; 15 Jan 2014 19:22:37 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v7] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Wed, 15 Jan 2014 13:22:32 -0600
Message-Id: <1389813752-3009-1-git-send-email-chase.southwood@yahoo.com>
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

Hartley,
I sincerely apologize for the obvious mistake, I thought I had built it
but clearly I made a mistake somewhere, as your observation is exactly
correct.  It is now fixed.

Thanks,
Chase Southwood

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

4: No longer using counter variable, using jiffies instead.

5: udelay for 10u, instead of 1u.

6: Scrap udelay entirely, in favor of cpu_relax. Include asm/processor.h
in order to use cpu_relax.

7: Fix typo (msec vs msecs).

 drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..ab7a74c 100644
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
+		timeout = jiffies + msecs_to_jiffies(500);
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

