Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3FQRlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:41:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3FQRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 22/84] USB: mos7720: fix message timeouts
Date: Mon, 17 Jun 2013 10:30:26 -0700
Message-Id: <1371490288-23167-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 849513a7809175420d353625b6f651d961e99d49 upstream.

The control and bulk-message timeouts are specified in milliseconds and
should not depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7720.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 1b2bcdc..d9da2d4 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -40,7 +40,7 @@
 #define DRIVER_DESC "Moschip USB Serial Driver"
 
 /* default urb timeout */
-#define MOS_WDR_TIMEOUT	(HZ * 5)
+#define MOS_WDR_TIMEOUT	5000
 
 #define MOS_MAX_PORT	0x02
 #define MOS_WRITE	0x0E
@@ -2006,7 +2006,7 @@ static int mos7720_startup(struct usb_serial *serial)
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
 
 	/* start the interrupt urb */
 	ret_val = usb_submit_urb(serial->port[0]->interrupt_in_urb, GFP_KERNEL);
@@ -2049,7 +2049,7 @@ static void mos7720_release(struct usb_serial *serial)
 		/* wait for synchronous usb calls to return */
 		if (mos_parport->msg_pending)
 			wait_for_completion_timeout(&mos_parport->syncmsg_compl,
-						    MOS_WDR_TIMEOUT);
+					    msecs_to_jiffies(MOS_WDR_TIMEOUT));
 
 		parport_remove_port(mos_parport->pp);
 		usb_set_serial_data(serial, NULL);
-- 
1.8.1.2

