Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3FHKD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:03:59 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36787 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3FHKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:03:57 -0400
Date: Sat, 8 Jun 2013 12:03:47 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130608100347.GO2566@localhost>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607180428.GB4204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607180428.GB4204@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:04:28AM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> Changes v2 - v3:
>   - fixed up comments about usb_serial_get_by_minor()
>   - fixed error case in usb_serial_get_by_minor()
>   - folded get_free_port() into get_free_serial()
>   - renamed get_free_serial() to allocate_minors()
>   - fixed console.c build breakage
>   - properly pass in minor port number to usb_serial_console_init()

> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -37,6 +37,7 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  #include <linux/kfifo.h>
> +#include <linux/idr.h>
>  #include "pl2303.h"
>  
>  #define DRIVER_AUTHOR "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
> @@ -49,72 +50,64 @@
>     drivers depend on it.
>  */
>  
> -static struct usb_serial *serial_table[SERIAL_TTY_MINORS];
> +static DEFINE_IDR(serial_minors);
>  static DEFINE_MUTEX(table_lock);
>  static LIST_HEAD(usb_serial_driver_list);
>  
>  /*
> - * Look up the serial structure.  If it is found and it hasn't been
> - * disconnected, return with its disc_mutex held and its refcount
> - * incremented.  Otherwise return NULL.
> + * Look up the serial port structure.  If it is found and it hasn't been
> + * disconnected, return with the parent usb_serial structure's disc_mutex held
> + * and its refcount incremented.  Otherwise return NULL.
>   */
> -struct usb_serial *usb_serial_get_by_index(unsigned index)
> +struct usb_serial_port *usb_serial_port_get_by_minor(unsigned minor)
>  {
> -	struct usb_serial *serial;
> +	struct usb_serial *serial = NULL;

This isn't necessary anymore.

> +	struct usb_serial_port *port;
>  
>  	mutex_lock(&table_lock);
> -	serial = serial_table[index];
> +	port = idr_find(&serial_minors, minor);
> +	if (!port)
> +		goto exit;
>  
> -	if (serial) {
> -		mutex_lock(&serial->disc_mutex);
> -		if (serial->disconnected) {
> -			mutex_unlock(&serial->disc_mutex);
> -			serial = NULL;
> -		} else {
> -			kref_get(&serial->kref);
> -		}
> +	serial = port->serial;
> +	mutex_lock(&serial->disc_mutex);
> +	if (serial->disconnected) {
> +		mutex_unlock(&serial->disc_mutex);
> +		port = NULL;
> +	} else {
> +		kref_get(&serial->kref);
>  	}
> +exit:
>  	mutex_unlock(&table_lock);
> -	return serial;
> +	return port;
>  }
>  
> -static struct usb_serial *get_free_serial(struct usb_serial *serial,
> -					int num_ports, unsigned int *minor)
> +static int allocate_minors(struct usb_serial *serial, int num_ports)
>  {
> +	struct usb_serial_port *port;
>  	unsigned int i, j;
> -	int good_spot;
> +	int minor;
>  
>  	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
>  
> -	*minor = 0;
>  	mutex_lock(&table_lock);
> -	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
> -		if (serial_table[i])
> -			continue;
> -
> -		good_spot = 1;
> -		for (j = 1; j <= num_ports-1; ++j)
> -			if ((i+j >= SERIAL_TTY_MINORS) || (serial_table[i+j])) {
> -				good_spot = 0;
> -				i += j;
> -				break;
> -			}
> -		if (good_spot == 0)
> -			continue;
> -
> -		*minor = i;
> -		j = 0;
> -		dev_dbg(&serial->interface->dev, "%s - minor base = %d\n", __func__, *minor);
> -		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i, ++j) {
> -			serial_table[i] = serial;
> -			serial->port[j]->minor = i;
> -			serial->port[j]->port_number = i - *minor;
> -		}
> -		mutex_unlock(&table_lock);
> -		return serial;
> +	for (i = 0; i < num_ports; ++i) {
> +		port = serial->port[i];
> +		minor = idr_alloc(&serial_minors, port, 0, 0, GFP_KERNEL);
> +		if (minor < 0)
> +			goto error;
> +		port->minor = minor;
> +		port->port_number = i;
>  	}
> +	serial->minors_reserved = 1;
>  	mutex_unlock(&table_lock);
> -	return NULL;
> +	return 0;
> +error:
> +	/* unwind the already allocated minors */
> +	for (j = 0; j < i; ++j)
> +		idr_remove(&serial_minors, serial->port[j]->minor);
> +	mutex_unlock(&table_lock);
> +	return minor;
>  }
>  
>  static void return_serial(struct usb_serial *serial)

Perhaps rename this one release_minors to match allocate_minors (much
better name btw)?

> @@ -123,8 +116,9 @@ static void return_serial(struct usb_ser
>  
>  	mutex_lock(&table_lock);
>  	for (i = 0; i < serial->num_ports; ++i)
> -		serial_table[serial->minor + i] = NULL;
> +		idr_remove(&serial_minors, serial->port[i]->minor);
>  	mutex_unlock(&table_lock);
> +	serial->minors_reserved = 0;

This isn't strictly needed as the serial struct release_serial is only
called once when the struct is about to be freed.

>  }
>  
>  static void destroy_serial(struct kref *kref)
> @@ -136,7 +130,7 @@ static void destroy_serial(struct kref *
>  	serial = to_usb_serial(kref);
>  
>  	/* return the minor range that this device had */
> -	if (serial->minor != SERIAL_TTY_NO_MINOR)
> +	if (serial->minors_reserved)
>  		return_serial(serial);
>  
>  	if (serial->attached && serial->type->release)

All three patches look good otherwise. The port-number disambiguation
was indeed long overdue. Feel free to add

Reviewed-by: Johan Hovold <jhovold@gmail.com>

Thanks,
Johan
