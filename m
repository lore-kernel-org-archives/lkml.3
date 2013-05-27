Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3E0QNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:13:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37683 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3E0QNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:13:42 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] USB: hcd: only unmap the actual completed DMA buffer
Date: Tue, 28 May 2013 00:13:07 +0800
Message-Id: <1369671187-24430-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
References: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only unmap the actual completed DMA buffer instead of
the whole transfer buffer.

It is common to see only part of DMA transfer is completed, especially
in case of DMA_FROM_DEVICE because the length of incoming traffic often
is unknown before submitting URB, so this patch may improve USB
DMA unmapping which runs in hard irq context.

The patch has been tested on ARMv7(Pandaboard), and it is observed that
at average ~25us is saved about ehci interrupt handling on below usbnet
test case:

	- Pandaboard: IP address is IP_A
	- on one x86 box, run below command:
		#ping -f -s 1472 IP_A
	- compute ehci interrupt handling time on Pandaboard during ping
	  test

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/core/hcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 53baa87..2722487 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1374,12 +1374,12 @@ void usb_hcd_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 	else if (urb->transfer_flags & URB_DMA_MAP_PAGE)
 		dma_unmap_page(hcd->self.controller,
 				urb->transfer_dma,
-				urb->transfer_buffer_length,
+				urb->actual_length,
 				dir);
 	else if (urb->transfer_flags & URB_DMA_MAP_SINGLE)
 		dma_unmap_single(hcd->self.controller,
 				urb->transfer_dma,
-				urb->transfer_buffer_length,
+				urb->actual_length,
 				dir);
 	else if (urb->transfer_flags & URB_MAP_LOCAL)
 		hcd_free_coherent(urb->dev->bus,
-- 
1.7.9.5

