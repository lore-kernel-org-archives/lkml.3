Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbbANPsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:48:31 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:44734 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbbANPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:48:29 -0500
Date: Wed, 14 Jan 2015 15:48:16 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] char: Added support for u-blox 6 i2c gps driver
Message-ID: <20150114154816.58b0f9c7@lxorguk.ukuu.org.uk>
In-Reply-To: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
References: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 17:16:42 -0800
"Felipe F. Tonello" <eu@felipetonello.com> wrote:

> This driver will basically translate serial communication to i2c communication
> between the user-space and the GPS module.
> 
> It creates a /dev/ttyS device node.

It shouldn't. It should use its own name. (ttyubl or something .. )


> There are specific tty termios flags in order to the tty line discipliner not
> to change the date it is pushed to user space. That is necessary so the NMEA
> data is not corrupted.
> * iflags: added IGNCR: Ignore carriage return on input.
> * oflags: removed ONLCR: (XSI) Map NL to CR-NL on output.

The user space should probably set these but if its a single purpose
device then it's not unreasonable to just set defaults I guess.

> +static DECLARE_DELAYED_WORK(ublox_gps_wq, ublox_gps_read_worker);
> +
> +static void ublox_gps_read_worker(struct work_struct *private)
> +{
> +	s32 gps_buf_size, buf_size = 0;
> +	u8 *buf;
> +
> +	if (!ublox_gps_is_open)
> +		return;
> +
> +	/* check if driver was removed */
> +	if (!ublox_gps_i2c_client)
> +		return;


Greg has pointed out your locking is nonsensical - you want to be
refcounting. In the tty side case it's done for you for the most part,
but for the i2c side it's your problem and you need to ensure that you
hold suitable references between tty open and close, and on the close you
kill and wait for any work queues.


> +static int ublox_gps_serial_open(struct tty_struct *tty, struct file *filp)
> +{
> +	if (ublox_gps_is_open)
> +		return -EBUSY;
> +
> +	ublox_gps_filp = filp;
> +	ublox_gps_tty_port = tty->port;
> +	ublox_gps_tty_port->low_latency = true; /* make sure we push data immediately */
> +	ublox_gps_is_open = true;

tty semantics for exclusive are standardised in POSIX and this is not the
expected behaviour. See the TIOCEXCL ioctl.

> +static void ublox_gps_serial_close(struct tty_struct *tty, struct file *filp)
> +{
> +	if (!ublox_gps_is_open)
> +		return;
> +
> +	/* avoid stop when the denied (in open) file structure closes itself */
> +	if (ublox_gps_filp != filp)
> +		return;

That should never be possible. If it can happen you've got a locking bug
that needs fixing instead

> +static int ublox_gps_serial_write(struct tty_struct *tty, const unsigned char *buf,
> +	int count)
> +{
> +	if (!ublox_gps_is_open)
> +		return 0;
> +
> +	/* check if driver was removed */
> +	if (!ublox_gps_i2c_client)
> +		return 0;
> +
> +	/* we don't write back to the GPS so just return same value here */
> +	return count;

Just omit the serial_write method, or return -EIO; don't pretend it
worked.

> +	ublox_gps_tty_driver->driver_name = "ublox_gps";
> +	ublox_gps_tty_driver->name = "ttyS";
> +	ublox_gps_tty_driver->major = UBLOX_GPS_MAJOR;

Not ttyS and use dynamic numbering

> +	ublox_gps_tty_driver->minor_start = 0;
> +	ublox_gps_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
> +	ublox_gps_tty_driver->subtype = SERIAL_TYPE_NORMAL;
> +	ublox_gps_tty_driver->flags = TTY_DRIVER_REAL_RAW;
> +	ublox_gps_tty_driver->init_termios = tty_std_termios;
> +	ublox_gps_tty_driver->init_termios.c_iflag = IGNCR | IXON;
> +	ublox_gps_tty_driver->init_termios.c_oflag = OPOST;
> +	ublox_gps_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
> +		HUPCL | CLOCAL;
> +	ublox_gps_tty_driver->init_termios.c_ispeed = 9600;
> +	ublox_gps_tty_driver->init_termios.c_ospeed = 9600;
> +	tty_set_operations(ublox_gps_tty_driver, &ublox_gps_serial_ops);
> +	result = tty_register_driver(ublox_gps_tty_driver);
> +	if (result) {
> +		dev_err(&ublox_gps_i2c_client->dev, KBUILD_MODNAME ": %s - tty_register_driver failed\n",
> +			__func__);
> +		goto err;
> +	}
> +
> +	ublox_gps_i2c_client = client;
> +	ublox_gps_filp = NULL;
> +	ublox_gps_tty_port = NULL;
> +	ublox_gps_is_open = false;

There are some other i2c based tty drivers in the kernel - notably those
in drivers/tty/serial that use the uart layer to deal with most of the
awkward locking cases.

You can do it by hand but it's fairly hairy (see
drivers/mmc/card/sdio_uart.c, so it might be simplest to tweak the driver
to use the uart layer. You don't really gain much from it for your driver
except easier locking - but the locking is rather handy.

Alan
