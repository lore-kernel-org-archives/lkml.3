Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaDIMkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:40:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37228 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaDIMkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:40:31 -0400
Date: Wed, 9 Apr 2014 13:39:09 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: fix uart PORT_UNKNOWN handling
Message-ID: <20140409133909.2073453a@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.LNX.2.00.1404091151430.6519@lxtpfaff.pcs.ditec.de>
References: <alpine.LNX.2.00.1404091151430.6519@lxtpfaff.pcs.ditec.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 13:22:14 +0200
Thomas Pfaff <tpfaff@pcs.com> wrote:

> From: "Thomas Pfaff" <tpfaff@pcs.com>
> 
> While porting a RS485 driver from 2.6.29 to 3.14, i noticed that the serial tty 
> driver could break it by using uart ports that it does not own :

Yes thats one spectacularly ugly driver that doesn't want integrating
into 8250.c - although you do need to pull some things the other way for
modern ports as it'll blow up spectacularly if 8250.c has set it up for
DMA etc!

You ought however to be able to re-implement it as a line discipline at
least for fixed ports (it's never going to work on USB ones).

The low level driver calls the ldisc->dcd_change method on a DCD, and you
can issue set_termios requests in order to change the other pins. Adding
a method for other bits used that way is trivial and better than the
existing staging horror.

 
> 1. uart_change_pm ist called during uart_open and calls the uart pm function
>    without checking for PORT_UNKNOWN.

Removing this breaks other parts of the code assume that the port will be
powered up (notably setserial paths). So it makes sense that
uart_change_pm for a "none" port is a no-op but needs logic in the
setserial path to power up a port when we move none->known and power it
down on known->none

> 2. uart_shutdown is called from uart_set_info and does not check it either.

I don't see why this one matters. We would have done

	uart_startup
		uart_port_startup
			uport->type == PORT_UNKNOWN
			return 1;
		ASYNCB_INITIALIZED is not set

	uart_shutdown
		ASYNCB_INITIALISED is not set
			Skip call to uart_port_shutdown

So that code looks correct to me.

> 3. The return code from the uart request_port call in uart_set_info is not
>    handled properly, leading to the situation that the serial driver also
>    thinks it owns the uart ports.
>    This can triggered by doing following actions :
> 
>    setserial /dev/ttyS0 uart none    # release the uart ports
>    modprobe lirc-serial              # or any other device that uses the uart

This bit looks correct.

