Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbaGQPnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:43:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:37004 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:43:07 -0400
Date: Thu, 17 Jul 2014 17:43:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140717154300.GA16623@linutronix.de>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
 <20140716151604.GG1365@saruman.home>
 <53C6A050.2050409@linutronix.de>
 <20140716160614.GI1365@saruman.home>
 <53C7EC6F.6060902@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53C7EC6F.6060902@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2014-07-17 11:31:59 [-0400]:

>On 07/16/2014 12:06 PM, Felipe Balbi wrote:
>>On Wed, Jul 16, 2014 at 05:54:56PM +0200, Sebastian Andrzej Siewior wrote:
>>>On 07/16/2014 05:16 PM, Felipe Balbi wrote:
>
>>>>I wonder if you should get_sync() on start_tx() and only
>>>>put_autosuspend() at stop_tx(). I guess the outcome would be
>>>>largely the same, no ?
>>>
>>>I just opened minicom on ttyS0 and gave a try. start_tx() was invoked
>>>each time I pressed a key (sent a character). I haven't seen stop_tx()
>>>even after after I closed minicom. I guess stop_tx() is invoked if you
>>>switch half-duplex communication.
>>
>>that's bad, I expected stop to be called also after each character.
>
>The 8250 core auto-stops tx when the tx ring buffer is empty (except
>in the case of dma, where stopping tx isn't necessary).

This is correct. So this is what I have now for the non-dma case:

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 2e4a93b..480a1c0 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1283,6 +1283,9 @@ static inline void __stop_tx(struct uart_8250_port *p)
 	if (p->ier & UART_IER_THRI) {
 		p->ier &= ~UART_IER_THRI;
 		serial_out(p, UART_IER, p->ier);
+
+		pm_runtime_mark_last_busy(p->port.dev);
+		pm_runtime_put_autosuspend(p->port.dev);
 	}
 }
 
@@ -1310,12 +1313,12 @@ static void serial8250_start_tx(struct uart_port *port)
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
 
-	pm_runtime_get_sync(port->dev);
 	if (up->dma && !serial8250_tx_dma(up)) {
 		goto out;
 	} else if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
+		pm_runtime_get_sync(port->dev);
 		serial_port_out(port, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
 			unsigned char lsr;
@@ -1500,9 +1503,10 @@ void serial8250_tx_chars(struct uart_8250_port *up)
 		uart_write_wakeup(port);
 
 	DEBUG_INTR("THRE...");
-
+#if 0
 	if (uart_circ_empty(xmit))
 		__stop_tx(up);
+#endif
 }
 EXPORT_SYMBOL_GPL(serial8250_tx_chars);
 

and now I need to come up with something that is not if (port != omap)
for that #if 0 block. The code disables the TX FIFO empty interrupt once
the transfer is complete. I want to call __stop_tx() once the tx fifo is
empty.
Felipe, Would a check for dev->power.use_autosuspend be the right thing
to do?

>Regards,
>Peter Hurley

Sebastian
