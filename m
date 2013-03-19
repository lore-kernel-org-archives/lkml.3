Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3CSLM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:12:26 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3160 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab3CSLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:12:11 -0400
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <Radovan.Lekanovic@sonymobile.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [RFC PATCHv2 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev can be null
Date: Tue, 19 Mar 2013 12:11:43 +0100
Message-ID: <1363691503-15581-2-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1363691503-15581-1-git-send-email-oskar.andero@sonymobile.com>
References: <1363691503-15581-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Truls Bengtsson <truls.bengtsson@sonymobile.com>

The udc_irq service runs the isr_tr_complete_handler which in turn
"nukes" the endpoints, including a call to rndis_response_complete,
if appropriate. If the rndis_msg_parser fails here, an error will
be printed using a dev_err call (through the ERROR() macro).

However, if the usb cable was just disconnected the device (cdev)
might not be available and will be null. Since the dev_err macro will
dereference the cdev pointer we get a null pointer exception.

Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 drivers/usb/gadget/f_rndis.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 71beeb8..cc9c49c 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -447,14 +447,13 @@ static void rndis_response_complete(struct usb_ep *ep, struct usb_request *req)
 static void rndis_command_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_rndis			*rndis = req->context;
-	struct usb_composite_dev	*cdev = rndis->port.func.config->cdev;
 	int				status;
 
 	/* received RNDIS command from USB_CDC_SEND_ENCAPSULATED_COMMAND */
 //	spin_lock(&dev->lock);
 	status = rndis_msg_parser(rndis->config, (u8 *) req->buf);
 	if (status < 0)
-		ERROR(cdev, "RNDIS command error %d, %d/%d\n",
+		pr_err("RNDIS command error %d, %d/%d\n",
 			status, req->actual, req->length);
 //	spin_unlock(&dev->lock);
 }
-- 
1.7.8.6

