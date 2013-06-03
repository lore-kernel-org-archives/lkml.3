Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab3FCSOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:14:16 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48116 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab3FCSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:14:08 -0400
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: rts5139: Use correct USB transfer interval to fix syslog spamming
Date: Mon,  3 Jun 2013 20:14:02 +0200
Message-Id: <1370283242-24434-3-git-send-email-marcus.overhagen@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com>
References: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using correct transfer interval as specified by the USB endpoint
when doing the interrupt transfer fixes the warning printed by
xhci USB core on every transfer that resulted in spamming
"xhci_queue_intr_tx: 74 callbacks suppressed" to syslog
every 5 seconds.

Signed-off-by: Marcus Overhagen <marcus.overhagen@gmail.com>
---
 drivers/staging/rts5139/rts51x_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index c573618..c172f4a 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -635,10 +635,10 @@ int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
 	ep = chip->usb->pusb_dev->ep_in[usb_pipeendpoint(pipe)];
 
 	/* fill and submit the URB */
-	/* We set interval to 1 here, so the polling interval is controlled
-	 * by our polling thread */
+	/* Set interval to 10 here to match the endpoint descriptor,
+	 * the polling interval is controlled by the polling thread */
 	usb_fill_int_urb(chip->usb->intr_urb, chip->usb->pusb_dev, pipe,
-			 status, 2, urb_done_completion, &urb_done, 1);
+			 status, 2, urb_done_completion, &urb_done, 10);
 
 	result = rts51x_msg_common(chip, chip->usb->intr_urb, 100);
 
-- 
1.8.1.2

