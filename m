Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3FGR65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:58:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3FGR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:58:56 -0400
Date: Fri, 7 Jun 2013 10:58:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130607175855.GA4204@kroah.com>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607094025.GK2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607094025.GK2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:40:25AM +0200, Johan Hovold wrote:
> On Thu, Jun 06, 2013 at 10:31:21AM -0700, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [...]
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
> > @@ -49,72 +50,75 @@
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
> > + * Look up the serial port structure.  If it is found and it hasn't been
> >   * disconnected, return with its disc_mutex held and its refcount
> 
> Second sentence needs to be updated as well as it is the disc_mutex and
> refcount of the owning usb_serial struct we're referring to.

Good point, now updated.

> >   * incremented.  Otherwise return NULL.
> >   */
> > -struct usb_serial *usb_serial_get_by_index(unsigned index)
> > +struct usb_serial_port *usb_serial_port_get_by_minor(unsigned minor)
> >  {
> > -	struct usb_serial *serial;
> > +	struct usb_serial *serial = NULL;
> > +	struct usb_serial_port *port;
> >  
> >  	mutex_lock(&table_lock);
> > -	serial = serial_table[index];
> > +	port = idr_find(&serial_minors, minor);
> > +	if (!port)
> > +		goto exit;
> >  
> > -	if (serial) {
> > -		mutex_lock(&serial->disc_mutex);
> > -		if (serial->disconnected) {
> > -			mutex_unlock(&serial->disc_mutex);
> > -			serial = NULL;
> > -		} else {
> > -			kref_get(&serial->kref);
> > -		}
> > +	serial = port->serial;
> > +	mutex_lock(&serial->disc_mutex);
> > +	if (serial->disconnected) {
> > +		mutex_unlock(&serial->disc_mutex);
> > +		serial = NULL;
> 
> You want to set port rather than serial to NULL here now.

Good eye, now fixed.

> > +	} else {
> > +		kref_get(&serial->kref);
> >  	}
> > +exit:
> >  	mutex_unlock(&table_lock);
> > -	return serial;
> > +	return port;
> >  }
> >  
> > -static struct usb_serial *get_free_serial(struct usb_serial *serial,
> > -					int num_ports, unsigned int *minor)
> > +static int get_free_port(struct usb_serial_port *port)
> >  {
> > -	unsigned int i, j;
> > -	int good_spot;
> > -
> > -	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
> > +	int i;
> >  
> > -	*minor = 0;
> >  	mutex_lock(&table_lock);
> > -	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
> > -		if (serial_table[i])
> > -			continue;
> > +	i = idr_alloc(&serial_minors, port, 0, 0, GFP_KERNEL);
> > +	if (i < 0)
> > +		goto exit;
> > +	port->minor = i;
> > +exit:
> > +	mutex_unlock(&table_lock);
> > +	return i;
> > +}
> >  
> > -		good_spot = 1;
> > -		for (j = 1; j <= num_ports-1; ++j)
> > -			if ((i+j >= SERIAL_TTY_MINORS) || (serial_table[i+j])) {
> > -				good_spot = 0;
> > -				i += j;
> > -				break;
> > -			}
> > -		if (good_spot == 0)
> > -			continue;
> > +static int get_free_serial(struct usb_serial *serial, int num_ports)
> > +{
> > +	unsigned int i;
> > +	unsigned int j;
> > +	int x;
> >  
> > -		*minor = i;
> > -		j = 0;
> > -		dev_dbg(&serial->interface->dev, "%s - minor base = %d\n", __func__, *minor);
> > -		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i, ++j) {
> > -			serial_table[i] = serial;
> > -			serial->port[j]->minor = i;
> > -			serial->port[j]->port_number = i - *minor;
> > -		}
> > -		mutex_unlock(&table_lock);
> > -		return serial;
> > +	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
> > +
> > +	for (i = 0; i < num_ports; ++i) {
> > +		x = get_free_port(serial->port[i]);
> > +		if (x < 0)
> > +			goto error;
> > +		serial->port[i]->port_number = i;
> >  	}
> 
> What do you think about removing get_free_port altogether and simply
> call idr_alloc directly in the loop above instead? This would have the
> benefit of only acquiring the table_lock once per device, which would
> also prevent the possibility of higher port numbers receiving smaller
> minors (e.g. due to a parallel disconnect).

That's a good idea.  I've also renamed this function to "allocate_minors"
as that's what it really is doing.

thanks,

greg k-h
