Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3FKUVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:21:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3FKUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 26/79] USB: mos7720: fix message timeouts
Date: Tue, 11 Jun 2013 13:02:52 -0700
Message-Id: <20130611195315.937501773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 849513a7809175420d353625b6f651d961e99d49 upstream.

The control and bulk-message timeouts are specified in milliseconds and
should not depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -40,7 +40,7 @@
 #define DRIVER_DESC "Moschip USB Serial Driver"
 
 /* default urb timeout */
-#define MOS_WDR_TIMEOUT	(HZ * 5)
+#define MOS_WDR_TIMEOUT	5000
 
 #define MOS_MAX_PORT	0x02
 #define MOS_WRITE	0x0E
@@ -2003,7 +2003,7 @@ static int mos7720_startup(struct usb_se
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
 
 	/* start the interrupt urb */
 	ret_val = usb_submit_urb(serial->port[0]->interrupt_in_urb, GFP_KERNEL);
@@ -2046,7 +2046,7 @@ static void mos7720_release(struct usb_s
 		/* wait for synchronous usb calls to return */
 		if (mos_parport->msg_pending)
 			wait_for_completion_timeout(&mos_parport->syncmsg_compl,
-						    MOS_WDR_TIMEOUT);
+					    msecs_to_jiffies(MOS_WDR_TIMEOUT));
 
 		parport_remove_port(mos_parport->pp);
 		usb_set_serial_data(serial, NULL);


