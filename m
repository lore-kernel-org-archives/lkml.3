Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab3CVJY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:24:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:18305 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079Ab3CVJYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:24:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,891,1355126400"; 
   d="scan'208";a="217687126"
Date: Fri, 22 Mar 2013 11:24:21 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCHv2 2/2] serial: of_serial: Handle fifo-size property
Message-ID: <20130322092421.GA3134@xps8300>
References: <20130322074154.GA9250@xps8300>
 <1363939516-17308-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1363940208.2289.22.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363940208.2289.22.camel@leyfoon-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 22, 2013 at 04:16:48PM +0800, Ley Foon Tan wrote:
> On Fri, 2013-03-22 at 10:05 +0200, Heikki Krogerus wrote:
> > This will reduce the need for extra types in 8250.c just
> > in case the fifo size differs from the standard.
> Besides the fifo size, we need to have hardware flow control setting
> from device tree as well.

This is a bit problematic. We can set the uart_8250_port.capabilities
flag UART_CAP_AFE based on "hw-flow-control" property, but then the
properties from the type will not be used, just like in case of
fifosize. We would need to know all the flags of the type that are
normally taken from the uart_config[] array.

The UART_CAP_FIFO can be set by checking if we have set the
port.fifosize or not, so if the bellow is acceptable then I can make a
patch. There is no risk of overriding the capabilities for the
existing uarts, as we only touch the uart_8250_port.capabilities if
the new properties are used. So is it OK?

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 267711b..cc5135d 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -171,11 +171,16 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 #ifdef CONFIG_SERIAL_8250
        case PORT_8250 ... PORT_MAX_8250:
        {
-               /* For now the of bindings don't support the extra
-                  8250 specific bits */
                struct uart_8250_port port8250;
                memset(&port8250, 0, sizeof(port8250));
                port8250.port = port;
+
+               if (port.fifosize)
+                       port8250.capabilities = UART_CAP_FIFO;
+
+               if (of_property_read_u32(np, "hw-flow-control", &prop) == 0)
+                       port8250.capabilities |= UART_CAP_AFE;
+
                ret = serial8250_register_8250_port(&port8250);
                break;
        }

-- 
heikki
