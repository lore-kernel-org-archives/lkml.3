Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaIHPPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:15:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:45452 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaIHPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:15:14 -0400
Date: Mon, 8 Sep 2014 17:15:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: linux-serial@vger.kernel.org, tony@atomide.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140908151501.GA22584@linutronix.de>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908144616.GA22315@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140908144616.GA22315@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-08 16:46:18 [+0200]:

>- ncurses based applications (vi, less) don't play nice for me on the
>  console with this series. less doesn't show me anything. vi doesn't
>  return to console properly.

Can you give a test case 

>- I seem seem to get stuck in a "serial8250: too much work for irq%d"
>  loop somewhat reliably. We have a rather demanding application with
>  typically somewhere between 600 and 1000 byte packets being sent at
>  240Hz (roughly somewhere between 1.5 and 2 Mb/s). We run at baudrate
>  3500k. I get into this "too much work" thing already when running at
>  300 bytes per packet.

Do you get this message also at lower baud rates, say 115200?

What I am trying to understand is why you are spinning in the handler. 
_With_ DMA you should hardly get into the serial handler under normal 
conditions. Running at 3.5MB/sec should give one byte every 2.8us and
48 Bytes every ~137us. This looks like plenty of time to get  out of
the handler. My *guess* is that serial8250_handle_irq() has IIR often
set to timeout and you end up fetching byte after byte. 

This patch should protocol when and why you got into the handler.

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7111b22de000..59852069e4a0 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1583,6 +1583,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 	status = serial_port_in(port, UART_LSR);
 
 	DEBUG_INTR("status = %x...", status);
+	trace_printk("l%d IIR %x LSR %x\n", port->line, iir, status);
 
 	if (status & (UART_LSR_DR | UART_LSR_BI)) {
 		if (up->dma)
@@ -1707,6 +1708,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 	spin_unlock(&i->lock);
 
+	trace_printk("%d e\n", irq);
 	DEBUG_INTR("end.\n");
 
 	return IRQ_RETVAL(handled);

>I hope this is of some use to you. I'll do more testing later.

Which SoC do you use and do you have DMA enabled?

>Thanks,
>Frans

Sebastian
