Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3CZWoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3CZWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Johan Hovold <jhovold@gmail.com>
Subject: [ 84/98] USB: cdc-acm: fix device unregistration
Date: Tue, 26 Mar 2013 15:43:13 -0700
Message-Id: <20130326224251.200506888@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

Acked-by: Oliver Neukum <oneukum@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -600,7 +600,6 @@ static void acm_port_destruct(struct tty
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
-	tty_unregister_device(acm_tty_driver, acm->minor);
 	acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
@@ -1418,6 +1417,8 @@ static void acm_disconnect(struct usb_in
 
 	stop_data_traffic(acm);
 
+	tty_unregister_device(acm_tty_driver, acm->minor);
+
 	usb_free_urb(acm->ctrlurb);
 	for (i = 0; i < ACM_NW; i++)
 		usb_free_urb(acm->wb[i].urb);


