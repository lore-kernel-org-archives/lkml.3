Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3B0QIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:08:13 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3B0QIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:08:09 -0500
Message-ID: <512E2F64.2010706@free-electrons.com>
Date: Wed, 27 Feb 2013 17:08:04 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jamie Iles <jamie@jamieiles.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: Serial port initialization broken on Armada 370/XP due to "serial:
 8250_dw: Don't use UPF_FIXED_TYPE"
References: <512E1AD9.4090403@free-electrons.com>
In-Reply-To: <512E1AD9.4090403@free-electrons.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:40 PM, Gregory CLEMENT wrote:
> Hello,
> 

[ I have added linux-serial mailing list as I should added them
initially ]

> when I tried to use the linux-next git tree (next-20130226), I
> encountered a problem during boot: the serial port was no more
> initialized on my Armada XP (ARM SoC) base board . I get:
> 
> [...]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> sata_mv d00a0000.sata: slots 32 ports 2
> [...]
> turn off boot console earlycon0
> 
> 
> And then nothing.
> 
> So after git bisect I ended to the commit " serial: 8250_dw: Don't use
> UPF_FIXED_TYPE". Then by adding again the UPF_FIXED_TYPE flag (ie
> reverting this commit) I got the usual boot log:
> 
> [...]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> d0012000.serial: ttyS0 at MMIO 0xd0012000 (irq = 17) is a 8250
> console [ttyS0] enabled, bootconsole disabled
> console [ttyS0] enabled, bootconsole disabled
> d0012100.serial: ttyS1 at MMIO 0xd0012100 (irq = 18) is a 8250
> d0012200.serial: ttyS2 at MMIO 0xd0012200 (irq = 29) is a 8250
> d0012300.serial: ttyS3 at MMIO 0xd0012300 (irq = 30) is a 8250
> sata_mv d00a0000.sata: slots 32 ports 2
> [...]
> Freeing init memory: 2160K
> Starting logging: OK
> Initializing random number generator... done.
> Starting network...
> 
> Welcome to Buildroot
> buildroot login:
> 
> 
> 
> I understand that the purpose of this commit was to let the driver
> find by itself the port type, but I didn't find yet how it managed to
> do it and then why it failed in our case.
> 
> I will continue to investigate but any pointers are welcome.
> 

I found the root of the problem in drivers/tty/serial/8250/8250.c

in the autoconfig() function, when the IIR register is acceded, it is
done using serial_in(), this function return an int but is used as it
have returned a char. There is a lot of implicit cast to a char when
the returned value is put in a char variable, this seems to not be a
problem most of the time. The problematic line is the following:

scratch = serial_in(up, UART_IIR) >> 6;

the shift is done here before any cast or mask, and unfortunately my
hardware send 0xC1C1C1C1, that lead to get a '7' in the scratch
variable instead of a '3'.

Would you agree with this kind of patch to fix the issue?

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index e2ac25a..0b284c6 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1119,7 +1119,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
        serial_out(up, UART_LCR, 0);

        serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-       scratch = serial_in(up, UART_IIR) >> 6;
+       scratch = (serial_in(up, UART_IIR) & 0xFF) >> 6;

        switch (scratch) {
        case 0:




-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
