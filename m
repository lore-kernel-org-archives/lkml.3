Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3LBJDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:03:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:15840 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3LBJDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:03:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,809,1378882800"; 
   d="scan'208";a="443027897"
Date: Mon, 2 Dec 2013 11:02:53 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
Message-ID: <20131202090253.GE3942@xps8300>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385879185-22455-2-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 01, 2013 at 10:26:14AM +0400, Sergei Ianovich wrote:
> PXA serial ports have "standard" UART names (ttyS[0-3]), major
> device number (4) and first minor device number (64) by default.
> 
> If the system has extra 8250 serial port hardware in addition
> to onboard PXA serial ports, default settings produce a device
> allocation conflict.
> 
> The patch provides a configuration option which can move onboard
> ports out of the way of 8250_core by assigning a different (204)
> major number and corresponding device names (ttySA[0-3]).
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> ---
>  drivers/tty/serial/Kconfig | 19 +++++++++++++++++++
>  drivers/tty/serial/pxa.c   | 22 ++++++++++++++++++----
>  2 files changed, 37 insertions(+), 4 deletions(-)
> diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c

<snip>

> --- a/drivers/tty/serial/pxa.c
> +++ b/drivers/tty/serial/pxa.c
> @@ -593,6 +593,20 @@ serial_pxa_type(struct uart_port *port)
>  static struct uart_pxa_port *serial_pxa_ports[4];
>  static struct uart_driver serial_pxa_reg;
>  
> +#ifndef CONFIG_SERIAL_PXA_AS_TTYSA
> +
> +#define PXA_TTY_NAME	"ttyS"
> +#define PXA_TTY_MAJOR	TTY_MAJOR
> +#define PXA_TTY_MINOR	64
> +
> +#else
> +
> +#define PXA_TTY_NAME	"ttySA"
> +#define PXA_TTY_MAJOR	204
> +#define PXA_TTY_MINOR	5
> +
> +#endif
> +
>  #ifdef CONFIG_SERIAL_PXA_CONSOLE
>  
>  #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
> @@ -751,7 +765,7 @@ serial_pxa_console_setup(struct console *co, char *options)
>  }
>  
>  static struct console serial_pxa_console = {
> -	.name		= "ttyS",
> +	.name		= PXA_TTY_NAME,
>  	.write		= serial_pxa_console_write,
>  	.device		= uart_console_device,
>  	.setup		= serial_pxa_console_setup,
> @@ -792,9 +806,9 @@ static struct uart_ops serial_pxa_pops = {
>  static struct uart_driver serial_pxa_reg = {
>  	.owner		= THIS_MODULE,
>  	.driver_name	= "PXA serial",
> -	.dev_name	= "ttyS",
> -	.major		= TTY_MAJOR,
> -	.minor		= 64,
> +	.dev_name	= PXA_TTY_NAME,
> +	.major		= PXA_TTY_MAJOR,
> +	.minor		= PXA_TTY_MINOR,
>  	.nr		= 4,
>  	.cons		= PXA_CONSOLE,
>  };

If drivers/tty/serial/pxa.c was converted to an other probe driver for
the 8250, this would not be an issue.

Br,

-- 
heikki
