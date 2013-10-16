Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726Ab3JPUOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:14:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761690Ab3JPUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:14:52 -0400
Date: Wed, 16 Oct 2013 13:14:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tty/serial: at91: add a fallback option to determine
 uart/usart property
Message-ID: <20131016201451.GA21296@kroah.com>
References: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com>
 <64f8f1db6f888456be8ee410a7e9bb9851d070a5.1381394411.git.nicolas.ferre@atmel.com>
 <20131014135921.GG11420@ns203013.ovh.net>
 <525D0896.6020907@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D0896.6020907@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:19:18AM +0200, Nicolas Ferre wrote:
> On 14/10/2013 15:59, Jean-Christophe PLAGNIOL-VILLARD :
> >On 10:43 Thu 10 Oct     , Nicolas Ferre wrote:
> >>On older SoC, the "name" field is not filled in the register map.
> >>Fix the way to figure out if the serial port is an uart or an usart for these
> >>older products (with corresponding properties).
> >>
> >>Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>---
> >>  drivers/tty/serial/atmel_serial.c | 19 ++++++++++++++++++-
> >>  include/linux/atmel_serial.h      |  1 +
> >>  2 files changed, 19 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> >>index 6b0f75e..c7d99af 100644
> >>--- a/drivers/tty/serial/atmel_serial.c
> >>+++ b/drivers/tty/serial/atmel_serial.c
> >>@@ -99,6 +99,7 @@ static void atmel_stop_rx(struct uart_port *port);
> >>  #define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
> >>  #define UART_PUT_TTGR(port, v)	__raw_writel(v, (port)->membase + ATMEL_US_TTGR)
> >>  #define UART_GET_IP_NAME(port)	__raw_readl((port)->membase + ATMEL_US_NAME)
> >>+#define UART_GET_IP_VERSION(port) __raw_readl((port)->membase + ATMEL_US_VERSION)
> >>
> >>   /* PDC registers */
> >>  #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
> >>@@ -1503,6 +1504,7 @@ static void atmel_get_ip_name(struct uart_port *port)
> >>  {
> >>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
> >>  	int name = UART_GET_IP_NAME(port);
> >>+	u32 version;
> >>  	int usart, uart;
> >>  	/* usart and uart ascii */
> >>  	usart = 0x55534152;
> >>@@ -1517,7 +1519,22 @@ static void atmel_get_ip_name(struct uart_port *port)
> >>  		dev_dbg(port->dev, "This is uart\n");
> >>  		atmel_port->is_usart = false;
> >>  	} else {
> >>-		dev_err(port->dev, "Not supported ip name, set to uart\n");
> >>+		/* fallback for older SoCs: use version field */
> >>+		version = UART_GET_IP_VERSION(port);
> >>+		switch (version) {
> >>+		case 0x302:
> >>+		case 0x10213:
> >>+			dev_dbg(port->dev, "This version is usart\n");
> >>+			atmel_port->is_usart = true;
> >>+			break;
> >>+		case 0x203:
> >>+		case 0x10202:
> >>+			dev_dbg(port->dev, "This version is uart\n");
> >>+			atmel_port->is_usart = false;
> >>+			break;
> >>+		default:
> >>+			dev_err(port->dev, "Not supported ip name nor version, set to uart\n");
> >
> >it's not really an error a dev_warn is more oppropriate
> 
> As we are already in -rc5 and that these fixes are critical for at91
> platforms, I will not re-spin another patch just for this.
> 
> Moreover, I have the feeling that if we end up in this case, it
> means that we are in big troubles because the usart/uart included in
> the product triggering this log is not known (I recall that newer
> products do not have to hit these lines of code).
> 
> With these 2 reasons, I prefer to keep my patch like it is.
> 
> Greg, can you consider taking these two patches as regression fixes
> for 3.12 (with Tested-by tag from Thomas)?

Is this really a regression from 3.11?  What's the worry about waiting
for 3.13-rc1, getting this correct, and then backporting them to the
3.12-stable trees?

I'd prefer that, so, please clean this up properly and resend it, with
the tested-by: lines and I'll queue them up for 3.13-rc1.

thanks,

greg k-h
