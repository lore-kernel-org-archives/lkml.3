Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaEDPrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:47:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaEDPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        supriya karanth <supriya.karanth@stericsson.com>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        ian coolidge <iancoolidge@gmail.com>
Subject: [PATCH 3.4 30/43] usb: musb: set TXMAXP and AUTOSET for full speed bulk in device mode
Date: Sun,  4 May 2014 11:42:24 -0400
Message-Id: <20140504154228.358905762@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: supriya karanth <supriya.karanth@stericsson.com>

commit bb3a2ef2eb8cfaea335dcb3426350df7f3d48069 upstream.

The TXMAXP register is not set correctly for full speed bulk case
when the can_bulk_split() is used. Without this PIO transfers will
not take place correctly

The "mult" factor needs to be updated correctly for the
can_bulk_split() case

The AUTOSET bit in the TXCSR is not being set if the "mult"
factor is greater than 0 for the High Bandwidth ISO case.
But the "mult" factor is also greater than 0 in case of Full speed
bulk transfers with the packet splitting in TXMAXP register

Without the AUTOSET the DMA transfers will not progress in mode1

[ balbi@ti.com : add braces to both branches ]

Signed-off-by: supriya karanth <supriya.karanth@stericsson.com>
Signed-off-by: Praveena NADAHALLY <praveen.nadahally@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: ian coolidge <iancoolidge@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_gadget.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -401,7 +401,19 @@ static void txstate(struct musb *musb, s
 					csr |= (MUSB_TXCSR_DMAENAB
 							| MUSB_TXCSR_DMAMODE
 							| MUSB_TXCSR_MODE);
-					if (!musb_ep->hb_mult)
+					/*
+					 * Enable Autoset according to table
+					 * below
+					 * bulk_split hb_mult	Autoset_Enable
+					 *	0	0	Yes(Normal)
+					 *	0	>0	No(High BW ISO)
+					 *	1	0	Yes(HS bulk)
+					 *	1	>0	Yes(FS bulk)
+					 */
+					if (!musb_ep->hb_mult ||
+						(musb_ep->hb_mult &&
+						 can_bulk_split(musb,
+						    musb_ep->type)))
 						csr |= MUSB_TXCSR_AUTOSET;
 				}
 				csr &= ~MUSB_TXCSR_P_UNDERRUN;
@@ -1100,11 +1112,15 @@ static int musb_gadget_enable(struct usb
 		/* Set TXMAXP with the FIFO size of the endpoint
 		 * to disable double buffering mode.
 		 */
-		if (musb->double_buffer_not_ok)
+		if (musb->double_buffer_not_ok) {
 			musb_writew(regs, MUSB_TXMAXP, hw_ep->max_packet_sz_tx);
-		else
+		} else {
+			if (can_bulk_split(musb, musb_ep->type))
+				musb_ep->hb_mult = (hw_ep->max_packet_sz_tx /
+							musb_ep->packet_sz) - 1;
 			musb_writew(regs, MUSB_TXMAXP, musb_ep->packet_sz
 					| (musb_ep->hb_mult << 11));
+		}
 
 		csr = MUSB_TXCSR_MODE | MUSB_TXCSR_CLRDATATOG;
 		if (musb_readw(regs, MUSB_TXCSR)


