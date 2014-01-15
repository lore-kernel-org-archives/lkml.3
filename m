Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaAOFPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:15:25 -0500
Received: from nm4-vm4.bullet.mail.gq1.yahoo.com ([98.136.218.163]:27071 "EHLO
	nm4-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbaAOFPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:15:22 -0500
X-Yahoo-Newman-Id: 690616.7871.bm@smtp233.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jcU2ea4VM1llTTI1B9mMa6KhDGi9xXSWj7GE9ARszueYZfB
 xQ7f.7C_72.4TJIyCt4netS9HiOOk4jcjFlNcFpoK_pHDC0GxkDTlxCYEjC6
 deCyHBAlIRhgL6B9Ot2K5PpcV0B9Ngm3DoYxsGIRoHiO4wN4HK2dLU2c12yR
 VR5rb7mbRnoXk1qp89ymjZhYVIwsG.weaOuZFfLAREepPnK1Q_cDxSaR4RWf
 qe8o5ajY9R6ClK8x31FpkF_gjvOxLP5ISF8fiWSD8A8i0scI.DdpgaEHIyIx
 PpXUIbrDZEcpADUzjvN0YdxgyLQqk8_FHIFizI8WYzWE9BzIVzo.g44F7tIm
 x5eaqM7YnP8YzBq.qbxVkbbxaAiZz2lTdifLcFfsWU.NqEefFzAtH6JdDTgU
 Vo.VSG9Ukkonyie9YmZ_PIZYY_WMJcNym2X9R55G7.TQLjjiK.Zd6jfG3ppw
 brRR9LmInclmGrZW0YubSwc3OdqxZ_SEifMfDbqSECSP1tWq82MiTUn4R666
 .cAtXpn5YaUDttArUsJxOkJsCJXf1Xg--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp233.mail.gq1.yahoo.com with SMTP; 15 Jan 2014 05:15:21 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v5] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Tue, 14 Jan 2014 23:15:17 -0600
Message-Id: <1389762917-3134-1-git-send-email-chase.southwood@yahoo.com>
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

All right, I think this guy's ready to go now!  Thanks for all the help!
Chase

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

4: No longer using counter variable, using jiffies instead.

5: udelay for 10u, instead of 1u.

 drivers/staging/comedi/drivers/ni_mio_common.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..07e9777 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -687,12 +687,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
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
+			udelay(10);
+		}
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

