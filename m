Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3B1J0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:26:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:15725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3B1J0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:26:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="291713211"
Date: Thu, 28 Feb 2013 11:26:02 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: Serial port initialization broken on Armada 370/XP due to
 "serial: 8250_dw: Don't use UPF_FIXED_TYPE"
Message-ID: <20130228092602.GA5688@xps8300>
References: <512E1AD9.4090403@free-electrons.com>
 <512E2F64.2010706@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E2F64.2010706@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory.

On Wed, Feb 27, 2013 at 05:08:04PM +0100, Gregory CLEMENT wrote:
> I found the root of the problem in drivers/tty/serial/8250/8250.c
> 
> in the autoconfig() function, when the IIR register is acceded, it is
> done using serial_in(), this function return an int but is used as it
> have returned a char. There is a lot of implicit cast to a char when
> the returned value is put in a char variable, this seems to not be a
> problem most of the time. The problematic line is the following:
> 
> scratch = serial_in(up, UART_IIR) >> 6;
> 
> the shift is done here before any cast or mask, and unfortunately my
> hardware send 0xC1C1C1C1, that lead to get a '7' in the scratch
> variable instead of a '3'.

OK, this is interesting. Why does it return that? dw_apb_uart_db.pdf I
have says that bits 31:8 read as zero?

> Would you agree with this kind of patch to fix the issue?
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index e2ac25a..0b284c6 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -1119,7 +1119,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
>         serial_out(up, UART_LCR, 0);
> 
>         serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
> -       scratch = serial_in(up, UART_IIR) >> 6;
> +       scratch = (serial_in(up, UART_IIR) & 0xFF) >> 6;
> 
>         switch (scratch) {
>         case 0:

Instead, can you test if it's enough for you to set the reg-io-width
to 1 instead of 4:

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 4c0abe8..3a87a0e 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -54,7 +54,7 @@
                                reg = <0xd0012000 0x100>;
                                reg-shift = <2>;
                                interrupts = <41>;
-                               reg-io-width = <4>;
+                               reg-io-width = <1>;
                                status = "disabled";
                };
                serial@d0012100 {
@@ -62,7 +62,7 @@
                                reg = <0xd0012100 0x100>;
                                reg-shift = <2>;
                                interrupts = <42>;
-                               reg-io-width = <4>;
+                               reg-io-width = <1>;
                                status = "disabled";
                };
 
Thanks,

-- 
heikki
