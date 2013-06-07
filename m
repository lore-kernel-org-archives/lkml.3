Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3FGJkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:40:36 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61052 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3FGJke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:40:34 -0400
Date: Fri, 7 Jun 2013 11:40:25 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130607094025.GK2566@localhost>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606173121.GA1866@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:31:21AM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[...]

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
> @@ -49,72 +50,75 @@
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
> + * Look up the serial port structure.  If it is found and it hasn't been
>   * disconnected, return with its disc_mutex held and its refcount

Second sentence needs to be updated as well as it is the disc_mutex and
refcount of the owning usb_serial struct we're referring to.

>   * incremented.  Otherwise return NULL.
>   */
> -struct usb_serial *usb_serial_get_by_index(unsigned index)
> +struct usb_serial_port *usb_serial_port_get_by_minor(unsigned minor)
>  {
> -	struct usb_serial *serial;
> +	struct usb_serial *serial = NULL;
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
> +		serial = NULL;

You want to set port rather than serial to NULL here now.

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
> +static int get_free_port(struct usb_serial_port *port)
>  {
> -	unsigned int i, j;
> -	int good_spot;
> -
> -	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
> +	int i;
>  
> -	*minor = 0;
>  	mutex_lock(&table_lock);
> -	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
> -		if (serial_table[i])
> -			continue;
> +	i = idr_alloc(&serial_minors, port, 0, 0, GFP_KERNEL);
> +	if (i < 0)
> +		goto exit;
> +	port->minor = i;
> +exit:
> +	mutex_unlock(&table_lock);
> +	return i;
> +}
>  
> -		good_spot = 1;
> -		for (j = 1; j <= num_ports-1; ++j)
> -			if ((i+j >= SERIAL_TTY_MINORS) || (serial_table[i+j])) {
> -				good_spot = 0;
> -				i += j;
> -				break;
> -			}
> -		if (good_spot == 0)
> -			continue;
> +static int get_free_serial(struct usb_serial *serial, int num_ports)
> +{
> +	unsigned int i;
> +	unsigned int j;
> +	int x;
>  
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
> +	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
> +
> +	for (i = 0; i < num_ports; ++i) {
> +		x = get_free_port(serial->port[i]);
> +		if (x < 0)
> +			goto error;
> +		serial->port[i]->port_number = i;
>  	}

What do you think about removing get_free_port altogether and simply
call idr_alloc directly in the loop above instead? This would have the
benefit of only acquiring the table_lock once per device, which would
also prevent the possibility of higher port numbers receiving smaller
minors (e.g. due to a parallel disconnect).

> +	serial->minors_reserved = 1;
> +	return 0;
> +error:
> +	/* unwind the already allocated minors */
> +	mutex_lock(&table_lock);
> +	for (j = 0; j < i; ++j)
> +		idr_remove(&serial_minors, serial->port[j]->minor);
>  	mutex_unlock(&table_lock);
> -	return NULL;
> +	return x;
>  }

[...]

> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -21,7 +21,6 @@
>  
>  #define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
>  #define SERIAL_TTY_MINORS	254	/* loads of devices :) */
> -#define SERIAL_TTY_NO_MINOR	255	/* No minor was assigned */
>  
>  /* The maximum number of ports one device can grab at once */
>  #define MAX_NUM_PORTS		8
> @@ -142,7 +141,6 @@ static inline void usb_set_serial_port_d
>   * @dev: pointer to the struct usb_device for this device
>   * @type: pointer to the struct usb_serial_driver for this device
>   * @interface: pointer to the struct usb_interface for this device
> - * @minor: the starting minor number for this device
>   * @num_ports: the number of ports this device has
>   * @num_interrupt_in: number of interrupt in endpoints we have
>   * @num_interrupt_out: number of interrupt out endpoints we have
> @@ -161,7 +159,7 @@ struct usb_serial {
>  	unsigned char			disconnected:1;
>  	unsigned char			suspending:1;
>  	unsigned char			attached:1;
> -	unsigned char			minor;
> +	unsigned char			minors_reserved:1;
>  	unsigned char			num_ports;
>  	unsigned char			num_port_pointers;
>  	char				num_interrupt_in;
> @@ -321,7 +319,7 @@ static inline void usb_serial_console_di
>  #endif
>  
>  /* Functions needed by other parts of the usbserial core */
> -extern struct usb_serial *usb_serial_get_by_index(unsigned int minor);
> +extern struct usb_serial_port *usb_serial_port_get_by_minor(unsigned int minor);

As Tobias already noted, this breaks the USB console driver. However, it
looks like the call in that driver is not really needed and that
therefore usb_serial_port_get_by_minor need not be exported at all.

>  extern void usb_serial_put(struct usb_serial *serial);
>  extern int usb_serial_generic_open(struct tty_struct *tty,
>  	struct usb_serial_port *port);

Thanks,
Johan
