Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3LYPHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 10:07:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:42618 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752048Ab3LYPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 10:07:33 -0500
Date: Wed, 25 Dec 2013 10:07:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
In-Reply-To: <Pine.LNX.4.44L0.1312241623390.337-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1312251002020.9215-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013, Alan Stern wrote:

> > This is my analysis, how do you think?
> 
> There is another reason why usb_hub_to_struct_hub() could return NULL: 
> if usb_get_intfdata(hdev->actconfig->interface[0]) is NULL.  This could 
> happen if recursively_mark_NOTATTACHED() is called _while_ 
> hub_disconnect() is running.
> 
> There should be locking to prevent this, but there isn't.  That's what 
> we need to fix.  It's not an easy problem.  Can you figure out a 
> correct solution?

I think this will fix it.  Take a close look and do some careful
testing.

Alan Stern



Index: usb-3.13/drivers/usb/core/hub.c
===================================================================
--- usb-3.13.orig/drivers/usb/core/hub.c
+++ usb-3.13/drivers/usb/core/hub.c
@@ -1622,11 +1622,14 @@ static void hub_disconnect(struct usb_in
 	hub->error = 0;
 	hub_quiesce(hub, HUB_DISCONNECT);
 
-	usb_set_intfdata (intf, NULL);
-
 	for (i = 0; i < hdev->maxchild; i++)
 		usb_hub_remove_port_device(hub, i + 1);
+
+	/* Avoid races with recursively_mark_NOTATTACHED() */
+	spin_lock_irq(&device_state_lock);
 	hub->hdev->maxchild = 0;
+	usb_set_intfdata(intf, NULL);
+	spin_unlock_irq(&device_state_lock);
 
 	if (hub->hdev->speed == USB_SPEED_HIGH)
 		highspeed_hubs--;


