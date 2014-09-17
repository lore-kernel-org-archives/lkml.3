Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaIQU7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:59:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIQU7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:59:13 -0400
Date: Wed, 17 Sep 2014 13:58:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: cadence: Add generic earlycon support
Message-ID: <20140917205823.GA23595@kroah.com>
References: <58f2c9cf267e64f5d7566920844fb2db251e77d2.1410345777.git.michal.simek@xilinx.com>
 <5419905A.6030701@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5419905A.6030701@monstr.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:44:58PM +0200, Michal Simek wrote:
> Hi Greg,
> 
> On 09/10/2014 12:43 PM, Michal Simek wrote:
> > Add earlycon support for the cadence serial port.
> > This is based on recent patches:
> > "tty/serial: pl011: add generic earlycon support"
> > (sha1: 0d3c673e7881e691991b2a4745bd4f149603baa2)
> > "tty/serial: add arm/arm64 semihosting earlycon"
> > (sha1: d50d7269ebcb438afa346cdffce0f4e2a1b9e831)
> > 
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> > 
> >  Documentation/kernel-parameters.txt |  6 ++++++
> >  drivers/tty/serial/Kconfig          |  1 +
> >  drivers/tty/serial/xilinx_uartps.c  | 19 +++++++++++++++++++
> >  3 files changed, 26 insertions(+)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index a8eb6afce6a4..97055dc43167 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -921,6 +921,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> > 
> >  	earlycon=	[KNL] Output early console device and options.
> > 
> > +		cdns,<addr>
> > +			Start an early, polled-mode console on a cadence serial
> > +			port at the specified address. The cadence serial port
> > +			must already be setup and configured. Options are not
> > +			yet supported.
> > +
> >  		uart[8250],io,<addr>[,options]
> >  		uart[8250],mmio,<addr>[,options]
> >  		uart[8250],mmio32,<addr>[,options]
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index b4d61e6bf28c..72fd2b6e2241 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -1411,6 +1411,7 @@ config SERIAL_XILINX_PS_UART_CONSOLE
> >  	bool "Cadence UART console support"
> >  	depends on SERIAL_XILINX_PS_UART=y
> >  	select SERIAL_CORE_CONSOLE
> > +	select SERIAL_EARLYCON
> >  	help
> >  	  Enable a Cadence UART port to be the system console.
> > 
> > diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
> > index 01951d27cc03..675f3fe068f6 100644
> > --- a/drivers/tty/serial/xilinx_uartps.c
> > +++ b/drivers/tty/serial/xilinx_uartps.c
> > @@ -1051,6 +1051,25 @@ static void cdns_uart_console_putchar(struct uart_port *port, int ch)
> >  	cdns_uart_writel(ch, CDNS_UART_FIFO_OFFSET);
> >  }
> > 
> > +static void cdns_early_write(struct console *con, const char *s, unsigned n)
> > +{
> > +	struct earlycon_device *dev = con->data;
> > +
> > +	uart_console_write(&dev->port, s, n, cdns_uart_console_putchar);
> > +}
> > +
> > +static int __init cdns_early_console_setup(struct earlycon_device *device,
> > +					   const char *opt)
> > +{
> > +	if (!device->port.membase)
> > +		return -ENODEV;
> > +
> > +	device->con->write = cdns_early_write;
> > +
> > +	return 0;
> > +}
> > +EARLYCON_DECLARE(cdns, cdns_early_console_setup);
> > +
> >  /**
> >   * cdns_uart_console_write - perform write operation
> >   * @co: Console handle
> > --
> > 1.8.2.3
> > 
> 
> Any problem with this patch?

Don't know, it's in my todo queue which is really long at the moment...
