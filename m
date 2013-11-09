Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3KIGwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:52:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab3KIGvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.11 30/94] can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX
Date: Fri,  8 Nov 2013 22:51:36 -0800
Message-Id: <20131109065206.355737459@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d5a7b406c529e4595ce03dc8f6dcf7fa36f106fa upstream.

In patch

    0d1862e can: flexcan: fix flexcan_chip_start() on imx6

the loop in flexcan_chip_start() that iterates over all mailboxes after the
soft reset of the CAN core was removed. This loop put all mailboxes (even the
ones marked as reserved 1...7) into EMPTY/INACTIVE mode. On mailboxes 8...63,
this aborts any pending TX messages.

After a cold boot there is random garbage in the mailboxes, which leads to
spontaneous transmit of CAN frames during first activation. Further if the
interface was disabled with a pending message (usually due to an error
condition on the CAN bus), this message is retransmitted after enabling the
interface again.

This patch fixes the regression by:
1) Limiting the maximum number of used mailboxes to 8, 0...7 are used by the RX
FIFO, 8 is used by TX.
2) Marking the TX mailbox as EMPTY/INACTIVE, so that any pending TX of that
mailbox is aborted.

Cc: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -62,7 +62,7 @@
 #define FLEXCAN_MCR_BCC			BIT(16)
 #define FLEXCAN_MCR_LPRIO_EN		BIT(13)
 #define FLEXCAN_MCR_AEN			BIT(12)
-#define FLEXCAN_MCR_MAXMB(x)		((x) & 0xf)
+#define FLEXCAN_MCR_MAXMB(x)		((x) & 0x1f)
 #define FLEXCAN_MCR_IDAM_A		(0 << 8)
 #define FLEXCAN_MCR_IDAM_B		(1 << 8)
 #define FLEXCAN_MCR_IDAM_C		(2 << 8)
@@ -736,9 +736,11 @@ static int flexcan_chip_start(struct net
 	 *
 	 */
 	reg_mcr = flexcan_read(&regs->mcr);
+	reg_mcr &= ~FLEXCAN_MCR_MAXMB(0xff);
 	reg_mcr |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_FEN | FLEXCAN_MCR_HALT |
 		FLEXCAN_MCR_SUPV | FLEXCAN_MCR_WRN_EN |
-		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS;
+		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS |
+		FLEXCAN_MCR_MAXMB(FLEXCAN_TX_BUF_ID);
 	netdev_dbg(dev, "%s: writing mcr=0x%08x", __func__, reg_mcr);
 	flexcan_write(reg_mcr, &regs->mcr);
 
@@ -783,6 +785,10 @@ static int flexcan_chip_start(struct net
 			&regs->cantxfg[i].can_ctrl);
 	}
 
+	/* Abort any pending TX, mark Mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
+
 	/* acceptance mask/acceptance code (accept everything) */
 	flexcan_write(0x0, &regs->rxgmask);
 	flexcan_write(0x0, &regs->rx14mask);


