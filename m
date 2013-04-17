Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966709Ab3DQSrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:47:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54580 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966678Ab3DQSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:47:34 -0400
Date: Wed, 17 Apr 2013 14:47:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
In-Reply-To: <1366219045.28609.50.camel@joe-AO722>
Message-ID: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Joe Perches wrote:

> > > Perhaps a good patch would be to convert US_DEBUGP
> > > calls where a struct us_data * is available to
> > > to us_stor_dbg(struct us_data *, const char *fmt, ...)
> > 
> > That would be an excellent start.
> 
> Hey Alan, care to try this?
> 
> o Convert uses of US_DEBUGP to usb_stor_dbg
> o Add "struct us_data *" to usb_stor_dbg uses when
>   available and NULL when not.
> o usb_stor_dbg now uses struct device */dev_vprint_emit
>   when available
> o Removed embedded function names
> o Coalesce formats
> o Remove trailing whitespace
> o Remove useless OOM messages
> o Remove useless function entry/exit logging
> 
> Compiles but completely untested.
> 
> This won't apply against Greg's latest usb tree
> as he's just taken the previous patch.

Wow, that's an impressive amount of work in a short time!  I have only
a few comments.

I'm not very concerned about the subdrivers.  In fact, for testing
purposes it would probably be better to start by changing just the
"core" part of usb-storage (that is, the parts that actually get built
into the usb-storage.o file) and then do each subdriver separately, one
patch for each.

There are a few places where things could be improved...

> +int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +
> +	if (us && us->pusb_dev) {
> +		r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);

Isn't there a symbolic constant you can use instead of "7"?

> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c

> @@ -349,8 +347,6 @@ static int command_abort(struct scsi_cmnd *srb)
>  {
>  	struct us_data *us = host_to_us(srb->device->host);
>  
> -	US_DEBUGP("%s called\n", __func__);
> -
>  	/* us->srb together with the TIMED_OUT, RESETTING, and ABORTING
>  	 * bits are protected by the host lock. */
>  	scsi_lock(us_to_host(us));
> @@ -386,8 +382,6 @@ static int device_reset(struct scsi_cmnd *srb)
>  	struct us_data *us = host_to_us(srb->device->host);
>  	int result;
>  
> -	US_DEBUGP("%s called\n", __func__);
> -
>  	/* lock the device pointers and do the reset */
>  	mutex_lock(&(us->dev_mutex));
>  	result = us->transport_reset(us);
> @@ -402,7 +396,6 @@ static int bus_reset(struct scsi_cmnd *srb)
>  	struct us_data *us = host_to_us(srb->device->host);
>  	int result;
>  
> -	US_DEBUGP("%s called\n", __func__);
>  	result = usb_stor_port_reset(us);
>  	return result < 0 ? FAILED : SUCCESS;
>  }

These three functions get called only in unusual circumstances, and for
debugging we do want to know when they get called.  So these statements
should remain.

> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c

> @@ -918,7 +902,7 @@ int usb_stor_probe1(struct us_data **pus,
>  	struct us_data *us;
>  	int result;
>  
> -	US_DEBUGP("USB Mass Storage device detected\n");
> +	usb_stor_dbg(NULL, "USB Mass Storage device detected\n");
>  
>  	/*
>  	 * Ask the SCSI layer to allocate a host structure, with extra

Even though "us" isn't available here, intf is.  This line can be a
regular dev_dbg(&intf->dev, ...).  Or even dev_info(&intf->dev, ...);  
this looks like the sort of thing one sees all the time in kernel logs.

> @@ -1075,9 +1058,8 @@ static int storage_probe(struct usb_interface *intf,
>  	} else {
>  		unusual_dev = &for_dynamic_ids;
>  
> -		US_DEBUGP("%s %s 0x%04x 0x%04x\n", "Use Bulk-Only transport",
> -			"with the Transparent SCSI protocol for dynamic id:",
> -			id->idVendor, id->idProduct);
> +		usb_stor_dbg(us, "Use Bulk-Only transport with the Transparent SCSI protocol for dynamic id: 0x%04x 0x%04x\n",
> +			     id->idVendor, id->idProduct);
>  	}
>  
>  	result = usb_stor_probe1(&us, intf, id, unusual_dev);

And here "us" hasn't been set yet (it gets set in usb_stor_probe1), so
it shouldn't be used.  This can become another dev_dbg(&intf->dev, ...)
line.

Alan Stern

