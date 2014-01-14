Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaANVbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:31:12 -0500
Received: from nm49-vm4.bullet.mail.gq1.yahoo.com ([67.195.87.234]:33735 "EHLO
	nm49-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaANVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:31:08 -0500
X-Yahoo-Newman-Id: 703086.11225.bm@smtp227.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wY3wZXcVM1lwxPZC_spSJGmNb6rDPqRa.NJpe87pDnjn.0y
 yax5Kt6V2r1k0uBLfUML._VwLObaZXyZ_usqLnIez_AN9i7kM7GqUtBGsLVF
 Yazfkw6lGFyH98cO_T8v09lQFYmFukP3_HU3P317Th2hSaSoA9JnaHhfV_Et
 wXWMYuOHEnaQI_p42t1QK8nU0asEXhB3WWi1SUOWl_oNAlaGOKymcl.UPNuj
 jWsd6rnMeeB2x8_kALSKGw5TuTeUcIgkf3ebICEfXOapmnAl9W43wb4slSQX
 V01AneBTJ_SRTuDTq.rVsbRxxihsP9vmpKMThBYP8eeVZjpWwUkCFDH8YYaS
 SC51poucgXDiozv67_xLD9dd8jcsBryrL0WeQ6xWYTA74zBILq_LCkNKydbk
 H8SJM8aTfEgvHM8V73Q1V8e1SzjKiq963eVT7yZkzDukx6KIEGfODf9fSz5M
 _yP8ljHPH9K1VmyrI6426CqvzX4iYOc6zNERFAGHwpyEV9WX8Zsv7C8Bnjxq
 GkumlNyDECImvxQvxXl2m9pIpKZjBZnVcw5E-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp227.mail.gq1.yahoo.com with SMTP; 14 Jan 2014 21:31:07 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Tue, 14 Jan 2014 15:31:01 -0600
Message-Id: <1389735061-24626-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to ni_mio_common.c changes a simple while loop to a timeout,
which is preferred.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

I removed the extra counter variable this time.  Greg, you mentioned that I could just look at the time that has expired to far, and exit and error out if that exceeds a limit.  Right now I'm just tracking how many times udelay is called, since that seems to conform more to other timeouts in this file, but did you instead want me to use some time function to keep track of actual real time that expires?

Thanks,
Chase Southwood

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

 drivers/staging/comedi/drivers/ni_mio_common.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..143b8b8 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -687,12 +687,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
 {
 	const struct ni_board_struct *board = comedi_board(dev);
 	struct ni_private *devpriv = dev->private;
+	int timeout = 0;
 
 	if (board->reg_type == ni_reg_6143) {
 		/*  Flush the 6143 data FIFO */
 		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
 		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
-		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
+		/*  Wait for complete */
+		while (timeout < 10000) {
+			if (!(ni_readl(AIFIFO_Status_6143) & 0x10))
+				break;
+			udelay(1);
+			timeout++;
+		}
+		if (timeout == 10000)
+			comedi_error(dev, "FIFO flush timeout.");
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

