Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3FFMRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:17:30 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48929 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FFMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:28 -0400
Date: Thu, 6 Jun 2013 14:17:18 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130606121718.GJ2566@localhost>
References: <20130605175426.GA13461@kroah.com>
 <20130605175455.GB13461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605175455.GB13461@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:54:55AM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This moves the allocation of minor device numbers from a static array to
> be dynamic, using the idr interface.  This means that you could
> potentially get "gaps" in a minor number range for a single USB serial
> device with multiple ports, but all should still work properly.
> 
> Note, we still have the limitation of 255 USB to serial devices in the
> system, as that is all we are registering with the TTY layer at this
> point in time.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[...]

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
> +static int get_free_serial(struct usb_serial *serial, int num_ports,
> +			   unsigned int *minor)
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
> +	*minor = 0xffffffff;

You could use SERIAL_TTY_NO_MINOR here -- if needed at all, as it has
already been set in create_serial.

> +	for (i = 0; i < num_ports; ++i) {
> +		x = get_free_port(serial->port[i]);
> +		if (x < 0)
> +			goto error;
> +		if (*minor == 0xffffffff)
> +			*minor = x;

We must not update *minor until all port minors have been allocated, or
idr_remove might get called for unallocated minors or even minor numbers
of other ports in return_serial when the serial struct is destroyed.

> +		serial->port[i]->port_number = i;
>  	}
> -	mutex_unlock(&table_lock);
> -	return NULL;
> +	return 0;
> +error:
> +	/* unwind the already allocated minors */
> +	for (j = 0; j < i; ++j)
> +		idr_remove(&serial_minors, serial->port[j]->minor);
> +	return x;

table_lock?

>  }
>  
>  static void return_serial(struct usb_serial *serial)
> @@ -123,7 +128,7 @@ static void return_serial(struct usb_ser
>  
>  	mutex_lock(&table_lock);
>  	for (i = 0; i < serial->num_ports; ++i)
> -		serial_table[serial->minor + i] = NULL;
> +		idr_remove(&serial_minors, serial->port[i]->minor);
>  	mutex_unlock(&table_lock);
>  }
>  

[...]

Looks good otherwise.

Thanks,
Johan
