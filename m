Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3CHMxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:53:55 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16334 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757160Ab3CHMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:53:50 -0500
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [RFC PATCH 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev can be null
Date: Fri, 8 Mar 2013 13:53:40 +0100
Message-ID: <1362747220-2204-2-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com>
References: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com>
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
 drivers/usb/gadget/f_rndis.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 71beeb8..41b5ebd 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2008 Nokia Corporation
  * Copyright (C) 2009 Samsung Electronics
  *                    Author: Michal Nazarewicz (mina86@mina86.com)
+ * Copyright (C) 2013 Sony Mobile Communications AB.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -447,14 +448,13 @@ static void rndis_response_complete(struct usb_ep *ep, struct usb_request *req)
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

