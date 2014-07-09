Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbaGITBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:01:53 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:60345 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbaGITBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:01:52 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 9 Jul 2014 15:01:44 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 5/6] tty: serial: 8250-core: add rs485 support
Message-ID: <20140709190143.GF17769@csclub.uwaterloo.ca>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
 <1404928177-26554-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404928177-26554-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:49:36PM +0200, Sebastian Andrzej Siewior wrote:
> So after I stuffed the rs485 support from the omap-serial into
> 8250-omap, I've been looking at it and the only omap specific part was
> the OMAP_UART_SCR_TX_EMPTY part. The driver has always TX_EMPTY set
> because the 8250 core expects an interrupt after the TX fifo + shift
> register is empty. The rs485 parts seems to wait for half fifo and then
> again for the empty fifo. With this change gone it fits fine as generic
> code and here it is.
> 
> It is expected that the potential rs485 user invokes
> serial_omap_probe_rs485() to configure atleast RTS gpio which is a must
> have property. The code has been taken from omap-serial driver and
> received limited tested due to -ENODEV (the compiler said it works).
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/8250/8250_core.c | 171 ++++++++++++++++++++++++++++++++++++
>  include/linux/serial_8250.h         |   6 ++
>  2 files changed, 177 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index c7c3bf7..bf06a4c 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -39,6 +39,8 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #ifdef CONFIG_SPARC
>  #include <linux/sunserialcore.h>
>  #endif
> @@ -1281,10 +1283,34 @@ static void autoconfig_irq(struct uart_8250_port *up)
>  
>  static inline void __stop_tx(struct uart_8250_port *p)
>  {
> +	if (p->rs485.flags & SER_RS485_ENABLED) {
> +		int ret;
> +
> +		ret = (p->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
> +		if (gpio_get_value(p->rts_gpio) != ret) {
> +			if (p->rs485.delay_rts_after_send > 0)
> +				mdelay(p->rs485.delay_rts_after_send);
> +			gpio_set_value(p->rts_gpio, ret);

Usually the delay for RS485 is done in bit times, not msec.  Not sure
how you expect this to work.  Not sure doing it in software is precise
enough either.  It probably should be calculated based on the current
baudrate with a bit time rather than msec in the DT data.  No one wants
to have to change the DT data to change the baud rate.  After all this
is very often used with modbus and the modbus rules specify turn around
times in bit times.

I hope TI puts this into the UART in future designs where it belongs
(similar to what Exar and many others already did).

-- 
Len Sorensen
