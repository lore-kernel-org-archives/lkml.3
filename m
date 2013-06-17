Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3FQUQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:16:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3FQUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:16:34 -0400
Date: Mon, 17 Jun 2013 13:16:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130617201633.GA3903@kroah.com>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607180428.GB4204@kroah.com>
 <20130608100347.GO2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130608100347.GO2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 12:03:47PM +0200, Johan Hovold wrote:
> On Fri, Jun 07, 2013 at 11:04:28AM -0700, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > Changes v2 - v3:
> >   - fixed up comments about usb_serial_get_by_minor()
> >   - fixed error case in usb_serial_get_by_minor()
> >   - folded get_free_port() into get_free_serial()
> >   - renamed get_free_serial() to allocate_minors()
> >   - fixed console.c build breakage
> >   - properly pass in minor port number to usb_serial_console_init()
> 
> > --- a/drivers/usb/serial/usb-serial.c
> > +++ b/drivers/usb/serial/usb-serial.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/usb.h>
> >  #include <linux/usb/serial.h>
> >  #include <linux/kfifo.h>
> > +#include <linux/idr.h>
> >  #include "pl2303.h"
> >  
> >  #define DRIVER_AUTHOR "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
> > @@ -49,72 +50,64 @@
> >     drivers depend on it.
> >  */
> >  
> > -static struct usb_serial *serial_table[SERIAL_TTY_MINORS];
> > +static DEFINE_IDR(serial_minors);
> >  static DEFINE_MUTEX(table_lock);
> >  static LIST_HEAD(usb_serial_driver_list);
> >  
> >  /*
> > - * Look up the serial structure.  If it is found and it hasn't been
> > - * disconnected, return with its disc_mutex held and its refcount
> > - * incremented.  Otherwise return NULL.
> > + * Look up the serial port structure.  If it is found and it hasn't been
> > + * disconnected, return with the parent usb_serial structure's disc_mutex held
> > + * and its refcount incremented.  Otherwise return NULL.
> >   */
> > -struct usb_serial *usb_serial_get_by_index(unsigned index)
> > +struct usb_serial_port *usb_serial_port_get_by_minor(unsigned minor)
> >  {
> > -	struct usb_serial *serial;
> > +	struct usb_serial *serial = NULL;
> 
> This isn't necessary anymore.

Now fixed, thanks.

> >  static void return_serial(struct usb_serial *serial)
> 
> Perhaps rename this one release_minors to match allocate_minors (much
> better name btw)?

Good idea, now done.

> 
> > @@ -123,8 +116,9 @@ static void return_serial(struct usb_ser
> >  
> >  	mutex_lock(&table_lock);
> >  	for (i = 0; i < serial->num_ports; ++i)
> > -		serial_table[serial->minor + i] = NULL;
> > +		idr_remove(&serial_minors, serial->port[i]->minor);
> >  	mutex_unlock(&table_lock);
> > +	serial->minors_reserved = 0;
> 
> This isn't strictly needed as the serial struct release_serial is only
> called once when the struct is about to be freed.

Really?  Why were we doing this type of thing before with the "not
allocated" flag?  It seems that we were protecting some path that I
can't remember at the moment.  So to be safe, I'll leave it for now...

> All three patches look good otherwise. The port-number disambiguation
> was indeed long overdue. Feel free to add
> 
> Reviewed-by: Johan Hovold <jhovold@gmail.com>

Thanks so much for the review, I'll go make these changes and apply them
now.

greg k-h
