Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaEXN6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:58:15 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57735 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:58:14 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Sat, 24 May 2014 15:58:12 +0200
X-ME-IP: 90.2.36.41
Message-ID: <5380A571.6000307@orange.fr>
Date: Sat, 24 May 2014 15:58:09 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Staging: dgap: Fixed iomem accesses in dgap.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed dereferences from iomem into the adequate ioread function.

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
NB:	-I didn't replace the old style ioread[bwl] by their newer
equivalents (ioread[8/16/32]). Is it worth?
	-I did this for task 16 of the eudyptula challenge.

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d7cfc45..fe16da8 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1412,8 +1412,8 @@ static int dgap_tty_init(struct board_t *brd)
 			ch->ch_dsr	= DM_DSR;
 		}

-		ch->ch_taddr = vaddr + ((ch->ch_bs->tx_seg) << 4);
-		ch->ch_raddr = vaddr + ((ch->ch_bs->rx_seg) << 4);
+		ch->ch_taddr = vaddr + (ioread16(&(ch->ch_bs->tx_seg)) << 4);
+		ch->ch_raddr = vaddr + (ioread16(&(ch->ch_bs->rx_seg)) << 4);
 		ch->ch_tx_win = 0;
 		ch->ch_rx_win = 0;
 		ch->ch_tsize = readw(&(ch->ch_bs->tx_max)) + 1;
@@ -5084,8 +5084,8 @@ static uint dgap_get_custom_baud(struct channel_t *ch)
 	 * Go get from fep mem, what the fep
 	 * believes the custom baud rate is.
 	 */
-	offset = ((((*(unsigned short __iomem *)(vaddr + ECS_SEG)) << 4) +
-		(ch->ch_portnum * 0x28) + LINE_SPEED));
+	offset = (ioread16(vaddr + ECS_SEG) << 4) + (ch->ch_portnum * 0x28)
+	       + LINE_SPEED;

 	value = readw(vaddr + offset);
 	return value;
@@ -5633,10 +5633,10 @@ static int dgap_event(struct board_t *bd)

 		event = bd->re_map_membase + tail + EVSTART;

-		port   = event[0];
-		reason = event[1];
-		modem  = event[2];
-		b1     = event[3];
+		port   = ioread8(event);
+		reason = ioread8(event + 1);
+		modem  = ioread8(event + 2);
+		b1     = ioread8(event + 3);

 		/*
 		 * Make sure the interrupt is valid.
