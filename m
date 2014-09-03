Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935781AbaICXWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:22:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaICWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3.16 010/125] usbcore: dont log on consecutive debounce failures of the same port
Date: Wed,  3 Sep 2014 15:06:07 -0700
Message-Id: <20140903220623.977401474@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 5ee0f803cc3a0738a63288e4a2f453c85889fbda upstream.

Some laptops have an internal port for a BT device which picks
up noise when the kill switch is used, but not enough to trigger
printk_rlimit(). So we shouldn't log consecutive faults of this kind.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4550,6 +4550,7 @@ static void hub_port_connect(struct usb_
 	struct usb_hcd *hcd = bus_to_hcd(hdev->bus);
 	struct usb_port *port_dev = hub->ports[port1 - 1];
 	struct usb_device *udev = port_dev->child;
+	static int unreliable_port = -1;
 
 	/* Disconnect any existing devices under this port */
 	if (udev) {
@@ -4570,10 +4571,14 @@ static void hub_port_connect(struct usb_
 				USB_PORT_STAT_C_ENABLE)) {
 		status = hub_port_debounce_be_stable(hub, port1);
 		if (status < 0) {
-			if (status != -ENODEV && printk_ratelimit())
-				dev_err(&port_dev->dev,
-						"connect-debounce failed\n");
+			if (status != -ENODEV &&
+				port1 != unreliable_port &&
+				printk_ratelimit())
+				dev_err(&udev->dev, "connect-debounce failed, port %d disabled\n",
+					port1);
+
 			portstatus &= ~USB_PORT_STAT_CONNECTION;
+			unreliable_port = port1;
 		} else {
 			portstatus = status;
 		}


