Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaAOAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:23:15 -0500
Received: from nm28-vm3.bullet.mail.gq1.yahoo.com ([98.136.216.162]:22992 "EHLO
	nm28-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbaAOAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:23:12 -0500
X-Yahoo-Newman-Id: 290395.18084.bm@smtp208.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DUzO2UUVM1m8J05RFYxwmPXFV8hySs3dt59J4O54nnt4bT9
 FJWR2rPtgkG_rm2mEJYAe0F4vs3GQ5gjoaSi815RGRaHTPzLhfJIMdVRlQMz
 wdwox53mRYqJhWl5sM9LtWCEBV4lMEv6JNGADqmIeQ4EnlecUnp65PGMjEL.
 6dMw7pgrrGR7aI8C92c9s6kk9t.pdq6CVXonWUZ_yiOE7BnXnHBw7pcEk2FU
 2ntOYuf11SJUE6zLkeTf_nPgntvkAqj7r4qtay6VAex72OegpDrqvKL0Omwb
 OFZDEPeQYQCUKIyoHdtGzGOXAeQDxiQwUr35GwLNDscrRv2ASvGzno6Qo.KD
 eJeL4RihMizCPFOknXdY7e65kPGH_zmbEjWbuTovBqlWOJHbHBrz24B0woAb
 56HLatIxwkVzY8KPkxVpy8lpZ_Sq0jhf6E7q178Gj58tBEVK2N7s9l7g0JBx
 ZAW9XnML26ntb4GA9ZcPmO3R5wvZVAbthdVJlsgAymPAXuPmG7.fSzwqKxaL
 Ue42ur0D8XjMw23d4crVvCgtoX45i6BplATyy
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [63.250.193.228])
        by smtp208.mail.gq1.yahoo.com with SMTP; 14 Jan 2014 16:23:11 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v4] Staging: comedi: convert while loop to timeout in ni_mio_common.c
Date: Tue, 14 Jan 2014 18:23:05 -0600
Message-Id: <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com>
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

OK, here's another go at it.  Hopefully everything looks more correct
this time.  Greg, I've followed the pattern you gave me, and I really
appreciate all of the tips!  As always, just let me know if there are
still things that need adjusting (especially length of timeout, udelay,
etc.).

Thanks,
Chase Southwood

2: Changed from simple clean-up to swapping a timeout in for a while loop.

3: Removed extra counter variable, and added error checking.

4: No longer using counter variable, using jiffies instead.

 drivers/staging/comedi/drivers/ni_mio_common.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..882b249 100644
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
+		timeout = jiffies + msec_to_jiffies(100);
+		while (ni_readl(AIFIFO_Status_6143) & 0x10) {
+			if (time_after(jiffies, timeout)) {
+				comedi_error(dev, "FIFO flush timeout.");
+				break;
+			}
+			udelay(1);
+		}
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

