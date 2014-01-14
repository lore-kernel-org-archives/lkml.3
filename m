Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaANTji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:39:38 -0500
Received: from nm12-vm7.bullet.mail.gq1.yahoo.com ([98.136.218.206]:36726 "EHLO
	nm12-vm7.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaANTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:39:36 -0500
X-Yahoo-Newman-Id: 127610.53910.bm@smtp215.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: q46JbK8VM1mATfynfBgPXs2L8pejLrWkVvqYkxaRktU_VMz
 sSN9KmZ.0w1zCEI9SyOV4pLqLeDH_AZMueFN2P0SWuozES0Q6tVkMCCrDitC
 DiEz5wehOwQOhLgOdQeLXJnodg5BNSuA_EDJNC3iyothBcQ7mpDl6MoQLyA.
 lH1iHDw6PUxW56QxdOO2vjSbnCt08pd_Pc30Hyp3Reeukpx7HDxwyKnrADRN
 pzAZvSz6bmayl4zNLyD.L1dXNc4mBKTSMnSmHVV_DeMemZ.gSyzyIuwPZViV
 FX5Q1QxVTTzZAIfw59Y9IBAZRHd8JpD07IGwkWrRmnsCinLR_jfFY2FzZzqZ
 xNG2FPPREULZIpyptS9R9MKzizwNqann_OYExMQqldNcTPWT5_V1ahX07yK0
 VU7rqOTCXVUQvRBAuok6Z3kbvVus6h_t6KQU2PNyBfQaoSKa_RrCx06HuT90
 zC1LID6Hn8tidgPmzhhJlM4yNYzZvdquSW.NiY8s1g8zmQyy1o7c9G1DkhxY
 DKlHTqgoHagELAwFsSA0-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [63.250.193.228])
        by smtp215.mail.gq1.yahoo.com with SMTP; 14 Jan 2014 11:39:35 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2] Staging: comedi: convert while loop to timeout in ni_mio_common.c.
Date: Tue, 14 Jan 2014 13:38:46 -0600
Message-Id: <1389728326-23387-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to ni_mio_common.c changes a while loop to a timeout for
loop, which is preferred.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

I know Mr. Abbott mentioned that he wouldn't expect clean-up patches to have to deal with this sort of thing, but I thought I'd at least give the timeout thing a try.  Feel free to disregard this and take v1 of this patch instead if you would just like the simple clean-up.  That being said, I used 10000 iterations at the suggestion of Mr. Abbott, and a short delay as well.  Let me know if these values seem incorrect.  Also, at some (but not all) locations in this file that currently use timeouts, contain a check for i == timeout, with a call to either printk or comedi_error if the operation actually times out.  Would something like that be required here?

Sorry for all of the questions, but I'm sort of new around here and I'd like to help out with more than just clean-ups and this seemed like a good opportunity to at least try!

2: Changed from simple clean-up to swapping a timeout in for a while loop.

 drivers/staging/comedi/drivers/ni_mio_common.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..05cd5ed 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -687,12 +687,19 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
 {
 	const struct ni_board_struct *board = comedi_board(dev);
 	struct ni_private *devpriv = dev->private;
+	static const int timeout = 10000;
+	int i;
 
 	if (board->reg_type == ni_reg_6143) {
 		/*  Flush the 6143 data FIFO */
 		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
 		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
-		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
+		/*  Wait for complete */
+		for (i = 0; i < timeout; i++) {
+			if(!(ni_readl(AIFIFO_Status_6143) & 0x10))
+				break;
+			udelay(1);
+		}
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

