Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3BVTGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:06:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42555 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3BVTGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:06:47 -0500
Date: Fri, 22 Feb 2013 11:06:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: walter harms <wharms@bfs.de>
Cc: Kumar Amit Mehta <gmate.amit@gmail.com>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, abbotti@mev.co.uk
Subject: Re: [PATCH 2/2] staging: comedi: drivers: usbduxfast.c: fix for DMA
 buffers on stack
Message-ID: <20130222190644.GA16011@kroah.com>
References: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com>
 <5127BFDB.4010608@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127BFDB.4010608@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 07:58:35PM +0100, walter harms wrote:
> 
> 
> Am 22.02.2013 19:07, schrieb Kumar Amit Mehta:
> > fix for instances of DMA buffer on stack(being passed to usb_control_msg) for
> > the USB-DUXfast Board driver.
> > 
> > Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/usbduxfast.c |   30 ++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
> > index 4bf5dd0..1ba0e3d 100644
> > --- a/drivers/staging/comedi/drivers/usbduxfast.c
> > +++ b/drivers/staging/comedi/drivers/usbduxfast.c
> > @@ -436,10 +436,14 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
> >  static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
> >  {
> >  	int ret;
> > -	unsigned char local_transfer_buffer[16];
> > +	unsigned char *local_transfer_buffer;
> > +
> > +	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
> > +	if (!local_transfer_buffer)
> > +		return -ENOMEM;
> >  
> >  	/* 7f92 to zero */
> > -	local_transfer_buffer[0] = 0;
> > +	*local_transfer_buffer = 0;
> >  	/* bRequest, "Firmware" */
> >  	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
> >  			      USBDUXFASTSUB_FIRMWARE,
> > @@ -450,22 +454,25 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
> >  			      local_transfer_buffer,
> >  			      1,      /* Length */
> >  			      EZTIMEOUT);    /* Timeout */
> > -	if (ret < 0) {
> > +	if (ret < 0)
> >  		dev_err(&udfs->interface->dev,
> >  			"control msg failed (start)\n");
> > -		return ret;
> > -	}
> >  
> > -	return 0;
> > +	kfree(local_transfer_buffer);
> > +	return ret;
> >  }
> >  
> >  static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
> >  {
> >  	int ret;
> > -	unsigned char local_transfer_buffer[16];
> > +	unsigned char *local_transfer_buffer;
> > +
> > +	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
> > +	if (!local_transfer_buffer)
> > +		return -ENOMEM;
> >  
> >  	/* 7f92 to one */
> > -	local_transfer_buffer[0] = 1;
> > +	*local_transfer_buffer = 1;
> >  	/* bRequest, "Firmware" */
> >  	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
> >  			      USBDUXFASTSUB_FIRMWARE,
> > @@ -474,13 +481,12 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
> >  			      0x0000,	/* Index */
> >  			      local_transfer_buffer, 1,	/* Length */
> >  			      EZTIMEOUT);	/* Timeout */
> > -	if (ret < 0) {
> > +	if (ret < 0)
> >  		dev_err(&udfs->interface->dev,
> >  			"control msg failed (stop)\n");
> > -		return ret;
> > -	}
> >  
> > -	return 0;
> > +	kfree(local_transfer_buffer);
> > +	return ret;
> >  }
> >  
> >  static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
> 
> mmh, it seems a bit overheat to alloc 1 byte.
> Could one of the driver maintainers please comment
> is that realy need ?

Yes it is needed.

> or is it possible to pass one byte
> in a register ? (aka char/int) without allocating ?

Nope, the USB host controllers must be able to DMA to this memory
location, so you have to allocate it dynamically, sorry.

thanks,

greg k-h
