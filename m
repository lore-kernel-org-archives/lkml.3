Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3FAQWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 12:22:31 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:37091 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3FAQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:22:15 -0400
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] Fix SD card detection and use correct transfer interval.
Date: Sat,  1 Jun 2013 18:22:11 +0200
Message-Id: <1370103731-5667-2-git-send-email-marcus.overhagen@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370103731-5667-1-git-send-email-marcus.overhagen@gmail.com>
References: <1370103731-5667-1-git-send-email-marcus.overhagen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increasing the timeout when polling for card status to 100ms
as used at other places in this driver fixes SD card detection.

Also use correct interval when doing the interrupt transfer,
this fixes the "xhci_queue_intr_tx: 74 callbacks suppressed"
spamming to syslog that was occuring when this driver is used.

Signed-off-by: Marcus Overhagen <marcus.overhagen@gmail.com>
---
 drivers/staging/rts5139/rts51x_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index 89e4d80..c172f4a 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -635,12 +635,12 @@ int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
 	ep = chip->usb->pusb_dev->ep_in[usb_pipeendpoint(pipe)];
 
 	/* fill and submit the URB */
-	/* We set interval to 1 here, so the polling interval is controlled
-	 * by our polling thread */
+	/* Set interval to 10 here to match the endpoint descriptor,
+	 * the polling interval is controlled by the polling thread */
 	usb_fill_int_urb(chip->usb->intr_urb, chip->usb->pusb_dev, pipe,
-			 status, 2, urb_done_completion, &urb_done, 1);
+			 status, 2, urb_done_completion, &urb_done, 10);
 
-	result = rts51x_msg_common(chip, chip->usb->intr_urb, 50);
+	result = rts51x_msg_common(chip, chip->usb->intr_urb, 100);
 
 	return interpret_urb_result(chip, pipe, 2, result,
 				    chip->usb->intr_urb->actual_length);
-- 
1.8.1.2

