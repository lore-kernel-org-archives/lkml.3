Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3LXVxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 16:53:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40268 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750985Ab3LXVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 16:53:19 -0500
Date: Tue, 24 Dec 2013 16:53:18 -0500 (EST)
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
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A2FCD9@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1312241623390.337-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013, Du, ChangbinX wrote:

> > > usb_hub_to_struct_hub() can return NULL if the hub without active
> > > configuration. So the result must be checked.
> > >
> > > BUG: unable to handle kernel NULL pointer dereference at 0000015c
> 
> > How did you manage to trigger this BUG?  If hub is NULL then
> > udev->maxchild should be 0.  See the code in hub_disconnect().
> >
> > Alan Stern
> 
> Hello, Alan. The hub also should be null if actconfig is null. You can see it in function
> usb_hub_to_struct_hub().

Yes, I know.  But if actconfig is NULL then udev->maxchild should be 0.

> udev->maxchild will be set to 0 in hub_disconnect(). 

Note that hub_disconnect() runs _before_ actconfig is set to NULL.

>  But before that,
> recursively_mark_NOTATTACHED may be called when calling usb_disconnect().

If this happens before hub_disconnect() has run then actconfig cannot 
be NULL, because hub_disconnect() runs _before_ actconfig is set to 
NULL.

>  So this issue
> will happen when usb_disconnect a hub that not have a configuration yet.

No, it won't.  You can test this easily.  Plug in a hub, write 0 to its
/sys/bus/usb/devices/.../bConfigurationValue, and then unplug the hub.

> It happened once here when unplugging otg cable from DUT(will cause hcd removed) with
> tiers of hub and devices. But it's not easy to reproduce it.
> This is my analysis, how do you think?

There is another reason why usb_hub_to_struct_hub() could return NULL: 
if usb_get_intfdata(hdev->actconfig->interface[0]) is NULL.  This could 
happen if recursively_mark_NOTATTACHED() is called _while_ 
hub_disconnect() is running.

There should be locking to prevent this, but there isn't.  That's what 
we need to fix.  It's not an easy problem.  Can you figure out a 
correct solution?

Alan Stern

