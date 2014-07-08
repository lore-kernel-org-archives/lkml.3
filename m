Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaGHTgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:36:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856AbaGHTe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.491512896@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 037/125] USB: cdc-acm: fix runtime PM for control messages
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit bae3f4c53585e9a170da9436e0f06919874bda9a upstream.

Fix runtime PM handling of control messages by adding the required PM
counter operations.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -72,13 +72,23 @@ static const struct tty_port_operations
 static int acm_ctrl_msg(struct acm *acm, int request, int value,
 							void *buf, int len)
 {
-	int retval = usb_control_msg(acm->dev, usb_sndctrlpipe(acm->dev, 0),
+	int retval;
+
+	retval = usb_autopm_get_interface(acm->control);
+	if (retval)
+		return retval;
+
+	retval = usb_control_msg(acm->dev, usb_sndctrlpipe(acm->dev, 0),
 		request, USB_RT_ACM, value,
 		acm->control->altsetting[0].desc.bInterfaceNumber,
 		buf, len, 5000);
+
 	dev_dbg(&acm->control->dev,
 			"%s - rq 0x%02x, val %#x, len %#x, result %d\n",
 			__func__, request, value, len, retval);
+
+	usb_autopm_put_interface(acm->control);
+
 	return retval < 0 ? retval : 0;
 }
 

