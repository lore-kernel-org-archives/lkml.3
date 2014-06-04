Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaFDOUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:20:12 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51027 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaFDOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:20:09 -0400
Date: Wed, 4 Jun 2014 16:19:37 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mike Remski <mremski@mutualink.net>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
Message-ID: <20140604141937.GA11160@localhost>
References: <20140602143347.GA1902@localhost>
 <538C953B.9020304@mutualink.net>
 <20140602154036.GA8662@localhost>
 <538CA020.4070204@mutualink.net>
 <20140602162027.GB13790@localhost>
 <538CA54C.4040803@mutualink.net>
 <20140602164957.GC13790@localhost>
 <538CB049.9020805@mutualink.net>
 <20140602174630.GD13790@localhost>
 <538DA0BD.5080208@mutualink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DA0BD.5080208@mutualink.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:17:33AM -0400, Mike Remski wrote:
> On 06/02/2014 01:46 PM, Johan Hovold wrote:
> > On Mon, Jun 02, 2014 at 01:11:37PM -0400, Mike Remski wrote:
> >> On 06/02/2014 12:49 PM, Johan Hovold wrote:
> >>> On Mon, Jun 02, 2014 at 12:24:44PM -0400, Mike Remski wrote:
> >>>> On 06/02/2014 12:20 PM, Johan Hovold wrote:
> >>>>> On Mon, Jun 02, 2014 at 12:02:40PM -0400, Mike Remski wrote:
> >>>>>> On 06/02/2014 11:40 AM, Johan Hovold wrote:
> >>>>>>> [ Please avoid top-posting. ]
> >>>>>>>
> >>>>>>> On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:
> >>>>> The third interface lacks endpoints and crashes the ftdi_sio driver.
> >>>>> This shouldn't happen (even if you're forcing the wrong driver to bind),
> >>>>> so I'll fix it up if still broken in v3.15-rc.
> >>>>>
> >>>> Johan,
> >>>> Thanks again.  Yes, the device does indeed have an FTDI embedded in it;
> >>>> they've programmed in their own ids.  They supply a Windows driver for
> >>>> it, but that doesn't do me any good.  :)
> >>> Not just their own ID's it seems.
> >>>
> >>> Have you tried just using the cdc-acm driver? The ports should up as
> >>> /dev/ttyACMx instead of ttyUSBx.
> >>>
> >> Not yet, next on the list.
> > You really should try this before anything else. :)

How did it go with cdc-acm?

You probably need the following commit (depending how well-supported your
old kernel is):

	5b239f0aebd4d ("USB: cdc-acm: Add pseudo modem without AT
	command capabilities")

in order for the device to bind.

> >> I'm suspecting that bNumEndpoints == 0 is causing endpoint[1].desc to
> >> stay at NULL (line 1567 in 3.1.4.5 source), so by the time it gets used
> >> later on, I'm hitting the NULL dereference.
> > Yeah, the code is obviously broken (also in v3.15-rc). It should
> > probably work to just return from ftdi_set_max_packet_size if
> > num_endpoints is 0 if you want to try that (or you can use your ?:
> > construct), but I should be able to fix this up properly on Wednesday.
> >
> > Thanks,
> > Johan
> Johan,
> I had a chance to play around with code over in ftdi_sio.c;   adding this:
> 
>          if (!num_endpoints) {
>                  return;
>          }
>   after the "Number of endpoints" message gets rid of the crash, 
> everything looks to be working correctly.

Good. Care to try the patch below so I can add a formal Tested-by tag as
well?

Thanks,
Johan


>From 4ddea3a573b8c15beefb67bc35c440850063d79d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 4 Jun 2014 14:09:43 +0200
Subject: [PATCH 1/5] USB: ftdi_sio: fix null deref at port probe

Fix NULL-pointer dereference when probing an interface with no
endpoints.

These devices have two bulk endpoints per interface, but this avoids
crashing the kernel if a user forces a non-FTDI device to be probed.

Note that the iterator variable was made unsigned in order to avoid
a maybe-uninitialized compiler warning for ep_desc after the loop.

Fixes: 895f28badce9 ("USB: ftdi_sio: fix hi-speed device packet size
calculation")

Reported-by: Mike Remski <mremski@mutualink.net>
Cc: <stable@vger.kernel.org>	# 2.3.61
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7c6e1dedeb06..3019141397eb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1564,14 +1564,17 @@ static void ftdi_set_max_packet_size(struct usb_serial_port *port)
 	struct usb_device *udev = serial->dev;
 
 	struct usb_interface *interface = serial->interface;
-	struct usb_endpoint_descriptor *ep_desc = &interface->cur_altsetting->endpoint[1].desc;
+	struct usb_endpoint_descriptor *ep_desc;
 
 	unsigned num_endpoints;
-	int i;
+	unsigned i;
 
 	num_endpoints = interface->cur_altsetting->desc.bNumEndpoints;
 	dev_info(&udev->dev, "Number of endpoints %d\n", num_endpoints);
 
+	if (!num_endpoints)
+		return;
+
 	/* NOTE: some customers have programmed FT232R/FT245R devices
 	 * with an endpoint size of 0 - not good.  In this case, we
 	 * want to override the endpoint descriptor setting and use a
-- 
1.8.5.5
