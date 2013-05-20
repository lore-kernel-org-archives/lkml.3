Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3ETLt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:49:57 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:35108 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab3ETLt4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:49:56 -0400
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 May 2013 13:49:36 +0200
Subject: RE: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Topic: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Index: Ac5L+U6Iu9Hhyw0AT2uEVOl/dGqtqQJUw2fw
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C336343F95B@SAFEX1MAIL1.st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
In-Reply-To: <201305081634.43498.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

We have pretty much completed reworking the patch set we sent recently, but
there is one comment you made which seemed to make perfect sense
but after investigating it has left me totally confused, which was:

>I would also recommed adding a way to set the default baud rate through
> a property. Following the example of the 8250 driver, you should probably
> call that "current-speed".

I note that you are listed as the author of of_serial.c so I was assuming
that looking at this would make sense, but it doesn't at all, and I would
be really grateful if you could explain what you were trying to achieve
and how you thought it worked. The code does:

        /* If current-speed was set, then try not to change it. */
        if (of_property_read_u32(np, "current-speed", &spd) == 0)
                port->custom_divisor = clk / (16 * spd);

The "spd" variable is not used again and I do not understand why you 
thought setting port->custom_divisor would have any impact on the default 
or current baud rate of the UART, or that this information was useful to 
any other part of the system. A search has only revealed that this port 
field has only one purpose, which is to provide a "custom" speed 
(unsurprisingly) when the user requests 38.4K _and_ the port flag 
UPF_SPD_CUST has been set through a TIOCSSERIAL ioctl call, instead of
actually getting 38.4K. The key part of that assessment being the 
implementation of uart_get_divisor() :

       if (baud == 38400 && (port->flags & UPF_SPD_MASK) == UPF_SPD_CUST)
                quot = port->custom_divisor;
        else
                quot = DIV_ROUND_CLOSEST(port->uartclk, 16 * baud);

Also all of the custom_divisor functionality is basically commented as "old" 
or has a kernel warning saying it is deprecated (see uart_set_info), so as
far as I can see for our (and I suspect most) hardware it is completely 
irrelevant functionality.

If you really wanted to specify a default rate for a TTY then surely you need 
to change the driver's init_termios, or change the termios on a per port basis 
after they get registered. Only a handful of drivers do not use the default 
uart_register_driver() and change the init_termios (statically) to something 
other than 9600 8N1. I have been unable so far to find any evidence of drivers 
changing the termios after a port has been registered based on either platform 
data or OF attributes. So I do not see why we would want to provide that 
functionality explicitly in the ASC driver if nobody else does; if you want 
to change the TTY speed, use the tty IOCTL interfaces (or stty).

So I don't see why you think the concept of a default or current speed belongs 
in the device tree description of the uart at all, unless there is something 
special about the hardware. One possible example of that seems to be the ARC
driver which only appears to support one serial speed and uses "current-speed"
attribute to specify that speed; or the ARC driver is broken and they have
made a mistake in their set_termios implementation, we cannot quite work out
which of those two things is true. But that isn't the case for the ASC
hardware so it again would not be relevant in this driver.

So basically we would like some help understanding what it is you would
really like us to do. Clearly we can just duplicate what you did in
of_serial.c for the 8250 and move on, but we would like to understand why
that wouldn't just be adding redundant code.

Regards,
-stephen

