Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab3GSIYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:24:52 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:37963 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759893Ab3GSIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:24:49 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
        horoshilov@ispras.ru, paulkf@microgate.com
Cc: linux-kernel@vger.kernel.org, Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] pcmcia: synclink_cs: replace sum of bitmasks with OR operation.
Date: Fri, 19 Jul 2013 11:24:03 +0300
Message-Id: <1374222243-9221-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by coccinelle and manually verified.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/char/pcmcia/synclink_cs.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 5c5cc00..d39cca6 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -1182,14 +1182,14 @@ static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 		}
 		count++;
 
-		if (gis & (BIT1 + BIT0)) {
+		if (gis & (BIT1 | BIT0)) {
 			isr = read_reg16(info, CHB + ISR);
 			if (isr & IRQ_DCD)
 				dcd_change(info, tty);
 			if (isr & IRQ_CTS)
 				cts_change(info, tty);
 		}
-		if (gis & (BIT3 + BIT2))
+		if (gis & (BIT3 | BIT2))
 		{
 			isr = read_reg16(info, CHA + ISR);
 			if (isr & IRQ_TIMER) {
@@ -1210,7 +1210,7 @@ static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 			if (isr & IRQ_RXTIME) {
 				issue_command(info, CHA, CMD_RXFIFO_READ);
 			}
-			if (isr & (IRQ_RXEOM + IRQ_RXFIFO)) {
+			if (isr & (IRQ_RXEOM | IRQ_RXFIFO)) {
 				if (info->params.mode == MGSL_MODE_HDLC)
 					rx_ready_hdlc(info, isr & IRQ_RXEOM);
 				else
@@ -3031,11 +3031,11 @@ static void loopback_enable(MGSLPC_INFO *info)
 	unsigned char val;
 
 	/* CCR1:02..00  CM[2..0] Clock Mode = 111 (clock mode 7) */
-	val = read_reg(info, CHA + CCR1) | (BIT2 + BIT1 + BIT0);
+	val = read_reg(info, CHA + CCR1) | (BIT2 | BIT1 | BIT0);
 	write_reg(info, CHA + CCR1, val);
 
 	/* CCR2:04 SSEL Clock source select, 1=submode b */
-	val = read_reg(info, CHA + CCR2) | (BIT4 + BIT5);
+	val = read_reg(info, CHA + CCR2) | (BIT4 | BIT5);
 	write_reg(info, CHA + CCR2, val);
 
 	/* set LinkSpeed if available, otherwise default to 2Mbps */
@@ -3125,10 +3125,10 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		val |= BIT4;
 		break;		// FM0
 	case HDLC_ENCODING_BIPHASE_MARK:
-		val |= BIT4 + BIT2;
+		val |= BIT4 | BIT2;
 		break;		// FM1
 	case HDLC_ENCODING_BIPHASE_LEVEL:
-		val |= BIT4 + BIT3;
+		val |= BIT4 | BIT3;
 		break;		// Manchester
 	}
 	write_reg(info, CHA + CCR0, val);
@@ -3185,7 +3185,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 */
 	val = 0x00;
 	if (info->params.crc_type == HDLC_CRC_NONE)
-		val |= BIT2 + BIT1;
+		val |= BIT2 | BIT1;
 	if (info->params.preamble != HDLC_PREAMBLE_PATTERN_NONE)
 		val |= BIT5;
 	switch (info->params.preamble_length)
@@ -3197,7 +3197,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		val |= BIT6;
 		break;
 	case HDLC_PREAMBLE_LENGTH_64BITS:
-		val |= BIT7 + BIT6;
+		val |= BIT7 | BIT6;
 		break;
 	}
 	write_reg(info, CHA + CCR3, val);
@@ -3264,8 +3264,8 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		clear_reg_bits(info, CHA + PVR, BIT3);
 
 	irq_enable(info, CHA,
-			 IRQ_RXEOM + IRQ_RXFIFO + IRQ_ALLSENT +
-			 IRQ_UNDERRUN + IRQ_TXFIFO);
+			 IRQ_RXEOM | IRQ_RXFIFO | IRQ_ALLSENT |
+			 IRQ_UNDERRUN | IRQ_TXFIFO);
 	issue_command(info, CHA, CMD_TXRESET + CMD_RXRESET);
 	wait_command_complete(info, CHA);
 	read_reg16(info, CHA + ISR);	/* clear pending IRQs */
@@ -3582,8 +3582,8 @@ static void async_mode(MGSLPC_INFO *info)
 	} else
 		clear_reg_bits(info, CHA + PVR, BIT3);
 	irq_enable(info, CHA,
-			  IRQ_RXEOM + IRQ_RXFIFO + IRQ_BREAK_ON + IRQ_RXTIME +
-			  IRQ_ALLSENT + IRQ_TXFIFO);
+			  IRQ_RXEOM | IRQ_RXFIFO | IRQ_BREAK_ON | IRQ_RXTIME |
+			  IRQ_ALLSENT | IRQ_TXFIFO);
 	issue_command(info, CHA, CMD_TXRESET + CMD_RXRESET);
 	wait_command_complete(info, CHA);
 	read_reg16(info, CHA + ISR);	/* clear pending IRQs */
-- 
1.8.1.2

