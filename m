Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3CDN2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:28:44 -0500
Received: from pequod.mess.org ([46.65.169.142]:46762 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab3CDN2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:28:42 -0500
Date: Mon, 4 Mar 2013 13:28:40 +0000
From: Sean Young <sean@mess.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vincent Deffontaines <vincent@gryzor.com>, Alan Cox <alan@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tty/8250_pnp: serial port detection regression since
 v3.7
Message-ID: <20130304132839.GA6965@pequod.mess.org>
References: <1361550439-23504-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361550439-23504-1-git-send-email-sean@mess.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Fri, Feb 22, 2013 at 04:27:19PM +0000, Sean Young wrote:
> The InsydeH2O BIOS (version dated 09/12/2011) has the following in
> its pnp resouces for its serial ports:
> 
> $ cat /sys/bus/pnp/devices/00:0b/resources
> state = active
> io disabled
> irq disabled
> 
> We do not check if the resources are disabled, and create a bogus
> ttyS* device. Since commit 835d844d1a28e (8250_pnp: do pnp probe
> before legacy probe) we get a bogus ttyS0, which prevents the legacy
> probe from detecting it.

Would you mind accepting this patch please -- it fixes a regression I 
introduced in 3.7.

Thanks,
Sean

> Reported-by: Vincent Deffontaines <vincent@gryzor.com>
> Tested-by: Vincent Deffontaines <vincent@gryzor.com>
> Signed-off-by: Sean Young <sean@mess.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/8250/8250_pnp.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
> index 35d9ab9..b3455a9 100644
> --- a/drivers/tty/serial/8250/8250_pnp.c
> +++ b/drivers/tty/serial/8250/8250_pnp.c
> @@ -429,6 +429,7 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>  {
>  	struct uart_8250_port uart;
>  	int ret, line, flags = dev_id->driver_data;
> +	struct resource *res = NULL;
>  
>  	if (flags & UNKNOWN_DEV) {
>  		ret = serial_pnp_guess_board(dev);
> @@ -439,11 +440,12 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>  	memset(&uart, 0, sizeof(uart));
>  	if (pnp_irq_valid(dev, 0))
>  		uart.port.irq = pnp_irq(dev, 0);
> -	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2)) {
> -		uart.port.iobase = pnp_port_start(dev, 2);
> -		uart.port.iotype = UPIO_PORT;
> -	} else if (pnp_port_valid(dev, 0)) {
> -		uart.port.iobase = pnp_port_start(dev, 0);
> +	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2))
> +		res = pnp_get_resource(dev, IORESOURCE_IO, 2);
> +	else if (pnp_port_valid(dev, 0))
> +		res = pnp_get_resource(dev, IORESOURCE_IO, 0);
> +	if (pnp_resource_enabled(res)) {
> +		uart.port.iobase = res->start;
>  		uart.port.iotype = UPIO_PORT;
>  	} else if (pnp_mem_valid(dev, 0)) {
>  		uart.port.mapbase = pnp_mem_start(dev, 0);
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
