Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaIJOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:16:26 -0400
Received: from sym2.noone.org ([178.63.92.236]:60749 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaIJOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:16:24 -0400
Date: Wed, 10 Sep 2014 16:16:21 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: serial: serial_mctrl_gpio: Fix build error for
 !GPIOLIB
Message-ID: <20140910141621.GA4636@distanz.ch>
References: <CA+r1ZhjCZBWjkxjoJz=PO-YZg6LbghQV75tGnpiSOrHM9CaygA@mail.gmail.com>
 <20140910080657.GC14260@distanz.ch>
 <20140910135716.GA23074@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910135716.GA23074@kroah.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 at 15:57:16 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 10, 2014 at 10:06:58AM +0200, Tobias Klauser wrote:
> > If SERIAL_MCTRL_GPIO is selected but GPIOLIB is not, the noop functions
> > from serial_mctrl_gpio.h are pulled in. However, serial_mctrl_gpio.c is
> > still compiled, leading to function redefinition build errors. Since all
> > drivers that include serial_mctrl_gpio.h also depend on
> > SERIAL_MCTRL_GPIO, let it depend on GPIOLIB as well remove the noop
> > functions alltogether.
> > 
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > ---
> >  drivers/tty/serial/Kconfig             |  1 +
> >  drivers/tty/serial/serial_mctrl_gpio.h | 35 ----------------------------------
> >  2 files changed, 1 insertion(+), 35 deletions(-)
> 
> I fixed this yesterday with commit below from Alexander, which does
> things a bit differently than you.  Any objections to it?

This is nicer in terms of being able to compile the driver without
GPIOLIB. However, it wont fix it for the other user of
SERIAL_MCTRL_GPIO, namely SERIAL_ATMEL. And for any future users of
SERIAL_MCTRL_GPIO, we need to make sure to use the same select
directive. To fix it for atmel_serial, I'd suggest the patch below.

Thanks
Tobias

>From d2435dbee5b3597536deffde4865d25b10548d91 Mon Sep 17 00:00:00 2001
From: Tobias Klauser <tklauser@distanz.ch>
Date: Wed, 10 Sep 2014 16:08:52 +0200
Subject: [PATCH] serial: atmel_serial: Fix build for target without GPIOLIB

If SERIAL_MCTRL_GPIO is selected but GPIOLIB is not, the noop functions
from serial_mctrl_gpio.h are pulled in. However, serial_mctrl_gpio.c is
still compiled, leading to function redefinition build errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 8079f52..8c43d11 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -117,7 +117,7 @@ config SERIAL_ATMEL
 	bool "AT91 / AT32 on-chip serial port support"
 	depends on ARCH_AT91 || AVR32
 	select SERIAL_CORE
-	select SERIAL_MCTRL_GPIO
+	select SERIAL_MCTRL_GPIO if GPIOLIB
 	help
 	  This enables the driver for the on-chip UARTs of the Atmel
 	  AT91 and AT32 processors.
-- 
2.0.1

