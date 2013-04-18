Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936069Ab3DRASm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:18:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42273 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935682Ab3DRASl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:18:41 -0400
Message-ID: <1366244319.28609.57.camel@joe-AO722>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 17 Apr 2013 17:18:39 -0700
In-Reply-To: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 14:47 -0400, Alan Stern wrote:
> On Wed, 17 Apr 2013, Joe Perches wrote:
[]
> > +int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
> > +{
> > +     struct va_format vaf;
> > +     va_list args;
> > +     int r;
> > +
> > +     va_start(args, fmt);
> > +
> > +     if (us && us->pusb_dev) {
> > +             r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
> 
> Isn't there a symbolic constant you can use instead of "7"?

Nope.
lib/dynamic_debug:__dynamic_dev_dbg() does the same thing.

> > --- a/drivers/usb/storage/scsiglue.c
> > +++ b/drivers/usb/storage/scsiglue.c
> 
> > @@ -349,8 +347,6 @@ static int command_abort(struct scsi_cmnd *srb)
[]
> > -     US_DEBUGP("%s called\n", __func__);
[]
> > @@ -386,8 +382,6 @@ static int device_reset(struct scsi_cmnd *srb)
[]
> > -     US_DEBUGP("%s called\n", __func__);
[]
> > @@ -402,7 +396,6 @@ static int bus_reset(struct scsi_cmnd *srb)
[]
> > -     US_DEBUGP("%s called\n", __func__);

> These three functions get called only in unusual circumstances, and for
> debugging we do want to know when they get called.  So these statements
> should remain.

I'll put 'em back and resubmit the whole schmear against
what Greg has in his tree now later.  I do think that
the function tracer does all that though and more.

Look at Documentation/trace/ftrace.txt

> > --- a/drivers/usb/storage/usb.c
[]
> > @@ -918,7 +902,7 @@ int usb_stor_probe1(struct us_data **pus,
[]
> > -     US_DEBUGP("USB Mass Storage device detected\n");
> > +     usb_stor_dbg(NULL, "USB Mass Storage device detected\n");
[]
> Even though "us" isn't available here, intf is.  This line can be a
> regular dev_dbg(&intf->dev, ...).  Or even dev_info(&intf->dev, ...);  
> this looks like the sort of thing one sees all the time in kernel logs.

I'll make it dev_info

> > @@ -1075,9 +1058,8 @@ static int storage_probe(struct usb_interface *intf,
[]
> > +             usb_stor_dbg(us, "Use Bulk-Only transport with the Transparent SCSI protocol for dynamic id: 0x%04x 0x%04x\n",
> > +                          id->idVendor, id->idProduct);

> And here "us" hasn't been set yet (it gets set in usb_stor_probe1), so
> it shouldn't be used.  This can become another dev_dbg(&intf->dev, ...)
> line.

OK.


