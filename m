Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaHYMSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:18:38 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46371 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbaHYMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:18:37 -0400
Message-ID: <53FB2991.20103@hurleysoftware.com>
Date: Mon, 25 Aug 2014 08:18:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Scott Yuan <scottzero0@gmail.com>, gregkh@linuxfoundation.org,
        robh@kernel.org
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: serial device file is out of order
References: <53FB2033.5010101@gmail.com>
In-Reply-To: <53FB2033.5010101@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On 08/25/2014 07:38 AM, Scott Yuan wrote:
> From ebb85a61456bf25f87aeb8a31c92c74540bdf306 Mon Sep 17 00:00:00 2001
> From: Scott Yuan <scottzero0@gmail.com>
> Date: Sun, 24 Aug 2014 13:46:56 +0800
> Subject: [PATCH] 8250: serial device file is out of order
> 
> On x86 architecture, the configuration of serial device maybe get from ACPI
> DSDT, but the order of DSDT is not mandatory, result as array serial8250_ports
> is out of order. This situation is more obvious in multiple serial port
> mainboard. Sort it by unique id that in DSDT will fix it.

Why does this matter?


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
>          return -ENOMEM;
>       dev->data = device;
> +    dev->is_acpi = 1;
>      /* .enabled means the device can decode the resources */
>      dev->active = device->status.enabled;
>      if (acpi_has_method(device->handle, "_SRS"))
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 7a91c6d..0e5ece5 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -3221,6 +3221,41 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
>      return NULL;
>  }
>  +static struct uart_8250_port *
> +serial8250_find_match_sorted_port(struct uart_port *port)
> +{
> +    int i, j;
> +    struct uart_8250_port *uart;
> +
> +    uart = container_of(port, struct uart_8250_port, port);
> +
> +    /*
> +     * We need sorted array serial8250_ports, it is sort by ACPI
> +     * device unique id, so find an apropriate position to insert.
> +     */
> +    for (i = 0; i < nr_uarts; i++) {
> +        if (serial8250_ports[i].uid == 0 ||
> +            uart->uid < serial8250_ports[i].uid)
> +            break;
> +    }
> +
> +    /*
> +     * If current uid that in serial8250_ports is big than port uid,
> +     * then move 8250 port data.
> +     */

The port index cannot be changed after the port is registered with the
tty core. That's because the tty core associates the index at registration
time with a specific tty.

Also, this is thread-unsafe: the 8250 driver uses serial_mutex to
protect concurrent add/remove to the serial8250_ports but otherwise
does not claim that mutex to dereference that table once a given port
index has been assigned.


> +    if (i < nr_uarts - 1 &&
> +        uart->uid < serial8250_ports[i].uid) {
> +        memmove(&serial8250_ports[i+1], &serial8250_ports[i],
> +            (nr_uarts - i - 1) * sizeof(struct uart_8250_port));
> +
> +        /* modify port.line, since data moved */
> +        for (j = i + 1; j < nr_uarts; j++)
> +            serial8250_ports[j].port.line += 1;
> +    }
> +    serial8250_ports[i].uid = uart->uid;
> +    return &serial8250_ports[i];
> +}
> +
>  /**
>   *    serial8250_register_8250_port - register a serial port
>   *    @up: serial port template
> @@ -3244,7 +3279,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
>       mutex_lock(&serial_mutex);
>  -    uart = serial8250_find_match_or_unused(&up->port);
> +    if (up->is_acpi)
> +        uart = serial8250_find_match_sorted_port(&up->port);
> +    else
> +        uart = serial8250_find_match_or_unused(&up->port);
>      if (uart && uart->port.type != PORT_8250_CIR) {
>          if (uart->port.dev)
>              uart_remove_one_port(&serial8250_reg, &uart->port);
> diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
> index 682a2fb..c880ed3 100644
> --- a/drivers/tty/serial/8250/8250_pnp.c
> +++ b/drivers/tty/serial/8250/8250_pnp.c
> @@ -15,6 +15,8 @@
>  #include <linux/pci.h>
>  #include <linux/pnp.h>
>  #include <linux/string.h>
> +#include <acpi/acpi.h>
> +#include <acpi/acpi_bus.h>
>  #include <linux/kernel.h>
>  #include <linux/serial_core.h>
>  #include <linux/bitops.h>
> @@ -427,6 +429,8 @@ static int
>  serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>  {
>      struct uart_8250_port uart;
> +    struct acpi_device *acpi_dev;
> +    char *serial_uid;
>      int ret, line, flags = dev_id->driver_data;
>       if (flags & UNKNOWN_DEV) {
> @@ -451,6 +455,14 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>      } else
>          return -ENODEV;
>  +    if (dev->is_acpi) {
> +        acpi_dev = dev->data;
> +        serial_uid = acpi_dev->pnp.unique_id;
> +        uart.is_acpi = 1;
> +        if (kstrtoint(serial_uid, 10, &uart.uid))
> +            return -EINVAL;
> +    }
> +
>  #ifdef SERIAL_DEBUG_PNP
>      printk(KERN_DEBUG
>          "Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
> diff --git a/include/linux/pnp.h b/include/linux/pnp.h
> index 195aafc..d745f14 100644
> --- a/include/linux/pnp.h
> +++ b/include/linux/pnp.h
> @@ -245,6 +245,7 @@ struct pnp_dev {
>      u64 dma_mask;
>      unsigned int number;        /* used as an index, must be unique */
>      int status;
> +    unsigned char is_acpi;        /* is acpi device */
>       struct list_head global_list;    /* node in global list of devices */
>      struct list_head protocol_list;    /* node in list of device's protocol */
> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
> index af47a8a..8f1e1bd 100644
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -74,7 +74,9 @@ struct uart_8250_port {
>      struct list_head    list;        /* ports on this IRQ */
>      unsigned short        capabilities;    /* port capabilities */
>      unsigned short        bugs;        /* port bugs */
> +    int            uid;        /* ACPI device unique id */
>      unsigned int        tx_loadsz;    /* transmit fifo load size */
> +    unsigned char        is_acpi;    /* is acpi device */
>      unsigned char        acr;
>      unsigned char        ier;
>      unsigned char        lcr;

Regards,
Peter Hurley

