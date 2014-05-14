Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaENPCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:02:23 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49433 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaENPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:02:21 -0400
From: Emil Goode <emilgoode@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Freddy Xin <freddy@asix.com.tw>,
        Eric Dumazet <edumazet@google.com>, David Chang <dchang@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>, Gerry Demaret <gerry@tigron.be>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ax88179_178a: don't send commands to detached device
Date: Wed, 14 May 2014 17:02:10 +0200
Message-Id: <1400079730-22424-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .stop and .unbind callbacks of struct driver_info are
called even after a DETACH hot-plug event. In the case of
the ax88179_178a minidriver we need to make sure we are not
trying to send commands to a device that has been detached.
This leads to failure messages like below.

ax88179_178a 1-1.3:1.0 (unregistered net_device):
	Failed to write reg index 0x0001: -19

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/net/usb/ax88179_178a.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 054e59c..fe20ca8 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1074,6 +1074,9 @@ static void ax88179_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	u16 tmp16;
 
+	if (dev->udev->state == USB_STATE_NOTATTACHED)
+		return;
+
 	/* Configure RX control register => stop operation */
 	tmp16 = AX_RX_CTL_STOP;
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
@@ -1352,6 +1355,9 @@ static int ax88179_stop(struct usbnet *dev)
 {
 	u16 tmp16;
 
+	if (dev->udev->state == USB_STATE_NOTATTACHED)
+		return 0;
+
 	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			 2, 2, &tmp16);
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
-- 
1.7.10.4

