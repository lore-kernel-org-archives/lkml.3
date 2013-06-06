Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3FFQhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:37:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3FFQhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:37:01 -0400
Date: Thu, 6 Jun 2013 09:37:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB: serial: ports: add minor and port number
Message-ID: <20130606163700.GB24144@kroah.com>
References: <20130605175426.GA13461@kroah.com>
 <20130605175539.GD13461@kroah.com>
 <20130606113106.GI2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606113106.GI2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:31:06PM +0200, Johan Hovold wrote:
> On Wed, Jun 05, 2013 at 10:55:39AM -0700, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > The usb_serial_port structure had the number field, which was the minor
> > number for the port, which almost no one really cared about.  They
> > really wanted the number of the port within the device, which you had to
> > subtract from the minor of the parent usb_serial_device structure.  To
> > clean this up, provide the real minor number of the port, and the number
> > of the port within the serial device separately, as these numbers might
> > not be related in the future.
> > 
> > Bonus is that this cleans up a lot of logic in the drivers, and saves
> > lines overall.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > --- a/drivers/usb/serial/io_edgeport.c
> > +++ b/drivers/usb/serial/io_edgeport.c
> 
> > @@ -2302,7 +2293,7 @@ static int send_cmd_write_baud_rate(stru
> >  
> >  	/* Restore original value to disable access to divisor latch */
> >  	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen, number, LCR,
> > -						edge_port->shadowLCR);
> > +			   edge_port->shadowLCR);
> 
> Unintended indentation change?

Yeah, due to a previous change I made to this line, I'll go remove this,
thanks.

> >  	status = write_cmd_usb(edge_port, cmdBuffer, cmdLen);
> >  	if (status) {
> 
> > --- a/drivers/usb/serial/whiteheat.c
> > +++ b/drivers/usb/serial/whiteheat.c
> 
> > @@ -649,7 +649,7 @@ static void firm_setup_port(struct tty_s
> >  	struct whiteheat_port_settings port_settings;
> >  	unsigned int cflag = tty->termios.c_cflag;
> >  
> > -	port_settings.port = port->number + 1;
> > +	port_settings.port = port->port_number + 1;
> 
> This is a bug that should be fixed separately and backported, as it
> prevents port configuration (e.g. set_termios) for ports with minor
> number greater than 0.
> 
> I took the liberty to prepare a separate patch for v3.10, which you
> could rebase the series on.

Ah, I missed that, thanks, I've queued up your patch and rebased this
series on it now.

> > --- a/include/linux/usb/serial.h
> > +++ b/include/linux/usb/serial.h
> > @@ -37,7 +37,8 @@
> >   * @serial: pointer back to the struct usb_serial owner of this port.
> >   * @port: pointer to the corresponding tty_port for this port.
> >   * @lock: spinlock to grab when updating portions of this structure.
> > - * @number: the number of the port (the minor number).
> > + * @minor: the minor number of the port
> > + * @port_number: the port number of this struct usb_serial_device (starts at 0)
> 
> Maybe 
> 
> 	@port_number: the struct usb_serial port number of this port (starts at 0)
> 
> or something similar, would be more clear?

Yeah, much better, thanks.

greg k-h
