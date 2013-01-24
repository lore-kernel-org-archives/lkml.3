Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3AXCbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:31:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55282 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3AXCbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:31:06 -0500
Date: Thu, 24 Jan 2013 10:30:54 +0800
From: Liang Li <liang.li@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <rdunlap@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for Jan 23 (pch_uart.c)
Message-ID: <20130124023054.GA21851@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
 <51007226.1040604@infradead.org>
 <20130124130616.ee95e032326b1afee6716419@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130124130616.ee95e032326b1afee6716419@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-24 10:06, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 23 Jan 2013 15:28:38 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > on i386:
> > 
> >   CC [M]  drivers/tty/serial/pch_uart.o
> > drivers/tty/serial/pch_uart.c: In function 'pch_uart_hal_read':
> > drivers/tty/serial/pch_uart.c:572:11: error: 'struct uart_port' has no member named 'sysrq'
> > make[4]: *** [drivers/tty/serial/pch_uart.o] Error 1
> > 
> > 
> > 
> > when SERIAL_PCH_UART_CONSOLE is not enabled.
> 

Seems so .. but I have SERIAL_PCH_UART_CONSOLE and MAGIC_SYSRQ off
both .. then still has no issue on my side. So I guess that is because
I have CONFIG_SERIAL_CORE_CONSOLE then it works here:

#if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(SUPPORT_SYSRQ)
	unsigned long		sysrq;			/* sysrq timeout */
#endif

In serial_core.h.

> Caused by commit 1f9db0921f21 ("pch_uart: add sysrq support") from the
> tty tree. (added cc's)
> 

Sorry, I think we need the below fix to work with
'CONFIG_SERIAL_CORE_CONSOLE is not set' && 'PCH_UART_CONSOLE is not
set' case:

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c5ee7d45..4771aac 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -573,10 +573,12 @@ static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
 			if (uart_handle_break(port))
 				continue;
 		}
+#ifdef SUPPORT_SYSRQ
 		if (port->sysrq) {
 			if (uart_handle_sysrq_char(port, rbr))
 				continue;
 		}
+#endif
 
 		buf[i++] = rbr;
 	}

---

Should I add a fix for the compile error .. or do squash then send out
refreshed patch ?

Best regards,
Liang Li

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


