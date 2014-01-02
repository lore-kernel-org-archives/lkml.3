Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaABTWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:22:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57958 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751755AbaABTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:22:21 -0500
Date: Thu, 2 Jan 2014 14:22:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A31B4E@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1401021417030.892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Du, ChangbinX wrote:

> I can reproduce issue by adding a delay just after usb_set_intfdata(intf, NULL)
>  (echo -1 > bConfigurationValue to trigger hub_dissconnect())without your patch.
> 
> After patch applied, cannot reproduce and didn't found any other issue. Patch works well.
> 
> Alan, need I update patch to v2 or you will do it?

Changbin, after looking more closely I realized there was a second 
aspect to this race: recursively_mark_NOTATTACHED uses hub->ports[i] 
while hub_disconnect removes the port devices.  You ought to be 
able to cause an oops by inserting a delay just after the loop where 
usb_hub_remove_port_device is called.

The updated patch below should fix both problems.  Can you test it?

Alan Stern



Index: usb-3.13/drivers/usb/core/hub.c
===================================================================
--- usb-3.13.orig/drivers/usb/core/hub.c
+++ usb-3.13/drivers/usb/core/hub.c
@@ -1607,7 +1607,7 @@ static void hub_disconnect(struct usb_in
 {
 	struct usb_hub *hub = usb_get_intfdata(intf);
 	struct usb_device *hdev = interface_to_usbdev(intf);
-	int i;
+	int port1;
 
 	/* Take the hub off the event list and don't let it be added again */
 	spin_lock_irq(&hub_event_lock);
@@ -1622,11 +1622,15 @@ static void hub_disconnect(struct usb_in
 	hub->error = 0;
 	hub_quiesce(hub, HUB_DISCONNECT);
 
-	usb_set_intfdata (intf, NULL);
+	/* Avoid races with recursively_mark_NOTATTACHED() */
+	spin_lock_irq(&device_state_lock);
+	port1 = hdev->maxchild;
+	hdev->maxchild = 0;
+	usb_set_intfdata(intf, NULL);
+	spin_unlock_irq(&device_state_lock);
 
-	for (i = 0; i < hdev->maxchild; i++)
-		usb_hub_remove_port_device(hub, i + 1);
-	hub->hdev->maxchild = 0;
+	for (; port1 > 0; --port1)
+		usb_hub_remove_port_device(hub, port1);
 
 	if (hub->hdev->speed == USB_SPEED_HIGH)
 		highspeed_hubs--;

