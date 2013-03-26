Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562Ab3CZPnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:43:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208Ab3CZPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 094/150] USB: cdc-acm: fix device unregistration
Date: Tue, 26 Mar 2013 15:19:53 +0000
Message-Id: <1364311249-14454-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit cb25505fc604292c70fc02143fc102f54c8595f0 upstream.

Unregister tty device in disconnect as is required by the USB stack.

By deferring unregistration to when the last tty reference is dropped,
the parent interface device can get unregistered before the child
resulting in broken hotplug events being generated when the tty is
finally closed:

KERNEL[2290.798128] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:3.1 (usb)
KERNEL[2290.804589] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-1 (usb)
KERNEL[2294.554799] remove   /2-1:3.1/tty/ttyACM0 (tty)

The driver must deal with tty callbacks after disconnect by checking the
disconnected flag. Specifically, further opens must be prevented and
this is already implemented.

Cc: Oliver Neukum <oneukum@suse.de>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ec2bba6..07a9f9c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -601,7 +601,6 @@ static void acm_port_destruct(struct tty_port *port)
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
-	tty_unregister_device(acm_tty_driver, acm->minor);
 	acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
@@ -1418,6 +1417,8 @@ static void acm_disconnect(struct usb_interface *intf)
 
 	stop_data_traffic(acm);
 
+	tty_unregister_device(acm_tty_driver, acm->minor);
+
 	usb_free_urb(acm->ctrlurb);
 	for (i = 0; i < ACM_NW; i++)
 		usb_free_urb(acm->wb[i].urb);
-- 
1.8.1.2

