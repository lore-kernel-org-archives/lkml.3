Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3FRMHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:07:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab3FRLoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 17/93] USB: mos7720: fix message timeouts
Date: Tue, 18 Jun 2013 12:42:25 +0100
Message-Id: <1371555821-12820-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 849513a7809175420d353625b6f651d961e99d49 upstream.

The control and bulk-message timeouts are specified in milliseconds and
should not depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7720.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 52b3342..bd42c97 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -44,7 +44,7 @@
 #define DRIVER_DESC "Moschip USB Serial Driver"
 
 /* default urb timeout */
-#define MOS_WDR_TIMEOUT	(HZ * 5)
+#define MOS_WDR_TIMEOUT	5000
 
 #define MOS_MAX_PORT	0x02
 #define MOS_WRITE	0x0E
@@ -2099,7 +2099,7 @@ static int mos7720_startup(struct usb_serial *serial)
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
 
 	/* start the interrupt urb */
 	ret_val = usb_submit_urb(serial->port[0]->interrupt_in_urb, GFP_KERNEL);
@@ -2144,7 +2144,7 @@ static void mos7720_release(struct usb_serial *serial)
 		/* wait for synchronous usb calls to return */
 		if (mos_parport->msg_pending)
 			wait_for_completion_timeout(&mos_parport->syncmsg_compl,
-						    MOS_WDR_TIMEOUT);
+					    msecs_to_jiffies(MOS_WDR_TIMEOUT));
 
 		parport_remove_port(mos_parport->pp);
 		usb_set_serial_data(serial, NULL);
-- 
1.8.1.2

