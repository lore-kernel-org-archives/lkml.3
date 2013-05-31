Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3EaUXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:23:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51289 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:23:14 -0400
From: Emil Goode <emilgoode@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] usb: musb: Fix format specifier warning
Date: Fri, 31 May 2013 22:22:58 +0200
Message-Id: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a format specifier warning. dma_addr_t can be either
u32 or u64 so we should cast to the largest type and change the format
specifier to %llx.
The addition of urb->transfer_dma and urb->actual_length is also done a
few lines below. I have moved this code up and pass the variable buf to
dev_dbg.

Sparse output:
drivers/usb/musb/musb_host.c:1761:4: warning:
	format ‘%x’ expects argument of type ‘unsigned int’,
	but argument 6 has type ‘dma_addr_t’ [-Wformat]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/usb/musb/musb_host.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 094cf80..d647ccb 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1756,11 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			dma_addr_t		buf;
 
 			rx_count = musb_readw(epio, MUSB_RXCOUNT);
+			buf = urb->transfer_dma + urb->actual_length;
 
-			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%x len %d/%d\n",
+			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
 					epnum, rx_count,
-					urb->transfer_dma
-						+ urb->actual_length,
+					(unsigned long long)buf,
 					qh->offset,
 					urb->transfer_buffer_length);
 
@@ -1789,11 +1789,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 					length = rx_count;
 				d->status = d_status;
 				buf = urb->transfer_dma + d->offset;
-			} else {
+			} else
 				length = rx_count;
-				buf = urb->transfer_dma +
-						urb->actual_length;
-			}
 
 			dma->desired_mode = 0;
 #ifdef USE_MODE1
-- 
1.7.10.4

