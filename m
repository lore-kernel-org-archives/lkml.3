Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbaHZETo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:19:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaHZETn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:19:43 -0400
Date: Mon, 25 Aug 2014 21:19:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Scott Yuan <scottzero0@gmail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: serial device file is out of order
Message-ID: <20140826041902.GA27596@kroah.com>
References: <1409022297-15555-1-git-send-email-scottzero0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409022297-15555-1-git-send-email-scottzero0@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:04:57AM +0800, Scott Yuan wrote:
> On x86 architecture, the configuration of serial device maybe get from ACPI
> DSDT, but the order of DSDT is not mandatory, result as array serial8250_ports
> is out of order. This situation is more obvious in multiple serial port
> mainboard. Sort it by unique id that in DSDT will fix it.

Who cares about the order, you should use the "persistant" names in
/dev/serial/ to connect to things that you really care about which is
which.

> 
> Signed-off-by: Scott Yuan <scottzero0@gmail.com>
> ---
>  drivers/pnp/pnpacpi/core.c          |  1 +
>  drivers/tty/serial/8250/8250_core.c | 40 ++++++++++++++++++++++++++++++++++++-
>  drivers/tty/serial/8250/8250_pnp.c  | 12 +++++++++++
>  include/linux/pnp.h                 |  1 +
>  include/linux/serial_8250.h         |  2 ++
>  5 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index a5c6cb7..84b518e 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -254,6 +254,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  		return -ENOMEM;
>  
>  	dev->data = device;
> +	dev->is_acpi = 1;
>  	/* .enabled means the device can decode the resources */
>  	dev->active = device->status.enabled;
>  	if (acpi_has_method(device->handle, "_SRS"))
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 7a91c6d..0e5ece5 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -3221,6 +3221,41 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
>  	return NULL;
>  }
>  
> +static struct uart_8250_port *
> +serial8250_find_match_sorted_port(struct uart_port *port)
> +{
> +	int i, j;
> +	struct uart_8250_port *uart;
> +
> +	uart = container_of(port, struct uart_8250_port, port);
> +
> +	/*
> +	 * We need sorted array serial8250_ports, it is sort by ACPI
> +	 * device unique id, so find an apropriate position to insert.
> +	 */
> +	for (i = 0; i < nr_uarts; i++) {
> +		if (serial8250_ports[i].uid == 0 ||
> +			uart->uid < serial8250_ports[i].uid)
> +			break;
> +	}
> +
> +	/*
> +	 * If current uid that in serial8250_ports is big than port uid,
> +	 * then move 8250 port data.
> +	 */
> +	if (i < nr_uarts - 1 &&
> +		uart->uid < serial8250_ports[i].uid) {
> +		memmove(&serial8250_ports[i+1], &serial8250_ports[i],
> +			(nr_uarts - i - 1) * sizeof(struct uart_8250_port));

Heh, no, that's crazy...

> +
> +		/* modify port.line, since data moved */
> +		for (j = i + 1; j < nr_uarts; j++)
> +			serial8250_ports[j].port.line += 1;
> +	}
> +	serial8250_ports[i].uid = uart->uid;
> +	return &serial8250_ports[i];
> +}

I really don't understand what you are trying to "solve" here.  What is
wrong with the current kernel code?  What does this patch change?

Why is acpi "special"?

greg k-h
