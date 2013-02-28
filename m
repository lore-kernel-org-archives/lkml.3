Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3B1Me3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:34:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:61048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3B1Me0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:34:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,755,1355126400"; 
   d="scan'208";a="207291831"
Date: Thu, 28 Feb 2013 14:34:21 +0200
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
Message-ID: <20130228123421.GC5688@xps8300>
References: <512E1AD9.4090403@free-electrons.com>
 <512E2F64.2010706@free-electrons.com>
 <20130228092602.GA5688@xps8300>
 <512F428E.3080400@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512F428E.3080400@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 28, 2013 at 12:42:06PM +0100, Gregory CLEMENT wrote:
> >> Would you agree with this kind of patch to fix the issue?
> >>
> >> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> >> index e2ac25a..0b284c6 100644
> >> --- a/drivers/tty/serial/8250/8250.c
> >> +++ b/drivers/tty/serial/8250/8250.c
> >> @@ -1119,7 +1119,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
> >>         serial_out(up, UART_LCR, 0);
> >>
> >>         serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
> >> -       scratch = serial_in(up, UART_IIR) >> 6;
> >> +       scratch = (serial_in(up, UART_IIR) & 0xFF) >> 6;
> >>
> >>         switch (scratch) {
> >>         case 0:
> > 
> > Instead, can you test if it's enough for you to set the reg-io-width
> > to 1 instead of 4:
> 
> Yes indeed it worked and it seems to be the correct description of my
> hardware. So I will fix the dtsi file.
> 
> However isn't buggy to use a function as it returned a char whereas
> it returns an int?

Yes, the driver should probable be cleaned.

It seems to be happening in quite a few places in 8250.c.
autoconfig_16550a() has pretty much identical code in it, where
UART_IIR is read to unsigned char and shifted without a mask.

Br,

-- 
heikki
