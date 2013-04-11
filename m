Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936041Ab3DKUtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:49:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935916Ab3DKUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:35 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HJsK954hcq4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=--CCzisJlQ4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202556.897802193@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 065/171 ] USB: cdc-acm: fix device unregistration
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0065-USB-cdc-acm-fix-device-unregistration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit cb25505fc604292c70fc02143fc102f54c8595f0 ]

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

Cc: stable <stable@vger.kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 89c752a..d0d8f1c 100644
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
1.7.10.4


