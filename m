Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3FASDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:03:08 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:35162 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FASDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:03:01 -0400
From: Emil Goode <emilgoode@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] usb: musb: use the new %pa format specifier for dma_addr_t
Date: Sat,  1 Jun 2013 20:02:27 +0200
Message-Id: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of the new format specifier %pa that was introduced
by the following commit.

7d7992108d02aa92ad4c77e5d9ce14088c942e75
("lib/vsprintf.c: add %pa format specifier for phys_addr_t types")

The addition of urb->transfer_dma and urb->actual_length is also done a
few lines below. I have moved this code up and pass the variable buf to
dev_dbg.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
I also added braces to the else statement for consistency.
(Didn't want to send a separate patch for that)

 drivers/usb/musb/musb_host.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index a9695f5..701f668 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1756,12 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			dma_addr_t		buf;
 
 			rx_count = musb_readw(epio, MUSB_RXCOUNT);
+			buf = urb->transfer_dma + urb->actual_length;
 
-			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
+			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%pa len %d/%d\n",
 					epnum, rx_count,
-					(unsigned long long) urb->transfer_dma
-					+ urb->actual_length,
-					qh->offset,
+					&buf, qh->offset,
 					urb->transfer_buffer_length);
 
 			c = musb->dma_controller;
@@ -1785,14 +1784,13 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 					    rx_count, d->length);
 
 					length = d->length;
-				} else
+				} else {
 					length = rx_count;
+				}
 				d->status = d_status;
 				buf = urb->transfer_dma + d->offset;
 			} else {
 				length = rx_count;
-				buf = urb->transfer_dma +
-						urb->actual_length;
 			}
 
 			dma->desired_mode = 0;
-- 
1.7.10.4

