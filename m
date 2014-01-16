Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaAPS1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:27:38 -0500
Received: from nm32-vm4.bullet.mail.gq1.yahoo.com ([98.136.216.227]:27046 "EHLO
	nm32-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaAPS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:27:35 -0500
X-Yahoo-Newman-Id: 133386.94785.bm@smtp229.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tuEdK_UVM1k2XKxCamWg5UVbJP_7xqpDaTrUphTGkWIKH5g
 iX8hHr4xox3z8muTqrRFZxDX.dNhM_U_HaVXQpb_mWAqu0oubumEdvYQiU.J
 VFdH5E_6aOvBIgJ5ibgDHeW7jxoWXUL3VKJCfk3Teb9aPXIiMPjwjEGJAX5I
 3T_LMretraGnf4d0racmOLh0I53F7EfUAa8nCk0N5HpcUJm7zVegA5stWMhO
 Uu_dCVzAp2i6V8xNOF4LyzYlgd9iS7ODqo1sotTA9eKEnH7s4RrYEcObacxB
 PwMFg_Ou1TAw.DEDzsocPDZLcfLB.bngGCslAHPQkLTaeiytrSgjSjU6VqWy
 7FZStPXODVyszBaCTBIAQTNZxRQb4Bj75PyC2FJEqfdUsU2dTUo9qwuaGXjB
 sZcGPS1mIDOh.bh4uusQ2UilGhQYm3..KGk4l.VmpUghb687RkNZnq7H79qn
 zlC_GEasw4pzJj3FBWXn_NpRWZBBt0uOEuzdkid2uNafBuRHzy7en6hG.osP
 9QfhyJYV0m5cWqmbYnqU-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp229.mail.gq1.yahoo.com with SMTP; 16 Jan 2014 18:27:35 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v8] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Thu, 16 Jan 2014 12:27:29 -0600
Message-Id: <1389896849-3186-1-git-send-email-chase.southwood@yahoo.com>
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

Okay, back to v2, basically.  I fixed the checkpatch warning from v2,
and added the error checking that was from v3, but otherwise it is the
same.  Of note, I have used a udelay of 1 here (Greg had suggested to
use 10, but Ian prefers 1 so I have gone with that, and I assume that
cpu_relax is no longer an option.).

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

4: No longer using counter variable, using jiffies instead.

5: udelay for 10u, instead of 1u.

6: Scrap udelay entirely, in favor of cpu_relax. Include asm/processor.h
in order to use cpu_relax.

7: Fix typo (msec vs msecs).

8: Revert back to v2, with some small changes (see above).

 drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..10c27cb 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -687,12 +687,22 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
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
+			if (!(ni_readl(AIFIFO_Status_6143) & 0x10))
+				break;
+			udelay(1);
+		}
+		if (i == timeout) {
+			comedi_error(dev, "FIFO flush timeout.");
+		}
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

