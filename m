Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaJAOqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:46:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:59619 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaJAOqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:46:06 -0400
MIME-Version: 1.0
Message-ID: <trinity-e77efb94-335b-4ae1-9311-beec43297b07-1412174761195@3capp-gmx-bs15>
From: "Helge Deller" <deller@gmx.de>
To: "Peter Hurley" <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, linux-parisc <linux-parisc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: serial console broken in v3.17-rc6 ?
Content-Type: text/plain; charset=UTF-8
Date: Wed, 1 Oct 2014 16:46:01 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <542B0B98.1040407@hurleysoftware.com>
References: <5421D3E3.6080805@gmx.de> <5421E166.7060206@hurleysoftware.com>
 <5423120E.8060204@gmx.de>, <542B0B98.1040407@hurleysoftware.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:J3nJzaBiHMEBkEasI9Ght8WAYvgLRpa3vfG9htbEzyK
 DZv4ZdGuN7YWRhdMEgcGgxMutXYwrNAbxZiUyBHlh2WJrqJI9u
 1WWX7q1j6xZ0WM1OFBKlr3DmSlwUch6y/2LAOzULgrTDdjZE6n
 AS04VUi5cJygrBo0dsRyi/CX/GZw1pIw1yFPaEb6Pp6MDkZff1
 H/ab0M6dDs17bGiR+d4ntJ3N8EtjSLwYt1VmJ4JnzbzH6m7fjy
 DeI3GCWk1cowOPbHYY5+6BXfnP1qm+vzokviEFWFZ7HB9fSdZn nzovXc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > serial8250: ttyS0 at I/O 0x3f8 (irq = 3, base_baud = 115200) is a 16550A
> > 
> > The source code for this driver is in drivers/parisc/superio.c,
> > see e.g. function superio_serial_init().
> > Maybe something is missing in here which was done to the other serial drivers?
> 
> Ok. So still the 8250 driver.
> 
> What are the remote line settings? (speed/parity/bits/stop)

9600,8,N,1

> See if reverting commit ae84db9661cafc63d179e1d985a2c5b841ff0ac4,
> 'serial: core: Preserve termios c_cflag for console resume', has some effect.
> I'm not seeing how this commit would affect your setup, but if it does, I can
> provide a debug patch to find out what userspace is doing.

No, this did not fixed it.

> If not, then I think you'll need to bisect drivers/tty/serial. I tried to
> analyze if the new generic earlycon was somehow triggering but I got lost
> multiple times in the static analysis.
> 
> BTW, since superio_serial_init() assigns the port type as PORT_16550A,
> superio_serial_init() should be doing:
> 
> diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
> index a042d06..36b3adb 100644
> --- a/drivers/parisc/superio.c
> +++ b/drivers/parisc/superio.c
> @@ -395,7 +395,7 @@ static void __init superio_serial_init(void)
>  	serial_port.iotype	= UPIO_PORT;
>  	serial_port.type	= PORT_16550A;
>  	serial_port.uartclk	= 115200*16;
> -	serial_port.fifosize	= 16;
> +	serial_port.flags	= UPF_FIXED_TYPE;
>  
>  	/* serial port #1 */
>  	serial_port.iobase	= sio_dev.sp1_base;
> 
> to properly initialize the 8250 port definition. Right now, the fifosize
> has no effect because the fifo capabilities is not on.
> 
> Also, consider adding
> 
> -	serial_port.flags	= UPF_FIXED_TYPE;
> +	serial_port.flags	= UPF_FIXED_PORT | UPF_FIXED_TYPE;
> 
> to disable reprogramming the irq and ioport from setserial.

That was partly solving the problem!
By looking at the other drivers, I found that they set the UPF_BOOT_AUTOCONF flag too.
So, changing it to 
-       serial_port.fifosize    = 16;
+       serial_port.flags       = UPF_FIXED_PORT | UPF_FIXED_TYPE | UPF_BOOT_AUTOCONF;
solved the problem :-)

Might this be the right fix? If yes, I can push it upstream.
All those flags like UPF_BOOT_AUTOCONF seem to be poorly documented btw.

> > Interestingly the *same* kernel don't show this problem on another (older) parisc
> > machine, but this older machine uses another serial driver:
> > This (working) machine is using the drivers/tty/serial/8250/8250_gsc.c driver.
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > 2:0:4: ttyS0 at MMIO 0xf0105800 (irq = 18, base_baud = 454545) is a 16550A
> > 5:0:2: ttyS1 at MMIO 0xf0202800 (irq = 25, base_baud = 454545) is a 16550A
> 
> PS - Unrelated note. This base_baud is junk ---------------^

Is it?
The base_baud value is calculated as "port->uartclk / 16" in drivers/tty/serial/serial_core.c.

Looking at the machine specific driver code we have:
+++ b/drivers/tty/serial/8250/8250_gsc.c
@@ -56,12 +56,12 @@ static int __init serial_init_chip(struct parisc_device *dev)
        /* 7.272727MHz on Lasi.  Assumed the same for Dino, Wax and Timi. */
        uart.port.uartclk       = (dev->id.sversion != 0xad) ?  /* XX */
                                        7272727 : 1843200;

which comes from the description of this chip which can be found in section 7.4 in this PDF file:
https://parisc.wiki.kernel.org/images-parisc/7/79/Lasi_ers.pdf (page "64 of 111" or 76):
7.4 Differences from NS16550A
The Lasi serial port is intended to function just like the real National NS16550A. This includes
behavior that often seems rather stupid. The National NS16550A was chosen over the WD16C552
because the National part came first, and the WD part is supposed to be compatible. There are a few
minor differences, however, between the NS16550A and this implementation.
Baud clock generation is an area of slight differences from the NS16550A. The baudrate reference
frequency is taken from the 40 MHz IO system clock. The frequency 7.2727 MHz is generated by
dividing 40 MHz by 5.5. 

So, probably the calculation of "port->uartclk / 16" is wrong for this chip?

Helge
