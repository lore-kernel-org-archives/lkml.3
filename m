Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaIHSd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:33:59 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:58197 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaIHSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:33:57 -0400
X-ASG-Debug-ID: 1410201235-0759e778ba161d2e0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 8 Sep 2014 20:33:53 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140908183353.GB4686@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908144616.GA22315@ci00147.xsens-tech.local>
 <20140908151501.GA22584@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140908151501.GA22584@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410201235
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9288
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:15:01PM +0200, Sebastian Andrzej Siewior wrote:
> * Frans Klaver | 2014-09-08 16:46:18 [+0200]:
> 
> >- I seem seem to get stuck in a "serial8250: too much work for irq%d"
> >  loop somewhat reliably. We have a rather demanding application with
> >  typically somewhere between 600 and 1000 byte packets being sent at
> >  240Hz (roughly somewhere between 1.5 and 2 Mb/s). We run at baudrate
> >  3500k. I get into this "too much work" thing already when running at
> >  300 bytes per packet.
> 
> Do you get this message also at lower baud rates, say 115200?

I don't get this message at lower data rates. Haven't tested lower baud
rates yet.

> What I am trying to understand is why you are spinning in the handler. 
> _With_ DMA you should hardly get into the serial handler under normal 
> conditions. Running at 3.5MB/sec should give one byte every 2.8us and
> 48 Bytes every ~137us. This looks like plenty of time to get  out of
> the handler. My *guess* is that serial8250_handle_irq() has IIR often
> set to timeout and you end up fetching byte after byte. 
> 
> This patch should protocol when and why you got into the handler.
>
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 7111b22de000..59852069e4a0 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -1583,6 +1583,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
>  	status = serial_port_in(port, UART_LSR);
>  
>  	DEBUG_INTR("status = %x...", status);
> +	trace_printk("l%d IIR %x LSR %x\n", port->line, iir, status);
>  
>  	if (status & (UART_LSR_DR | UART_LSR_BI)) {
>  		if (up->dma)
> @@ -1707,6 +1708,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
>  
>  	spin_unlock(&i->lock);
>  
> +	trace_printk("%d e\n", irq);
>  	DEBUG_INTR("end.\n");
>  
>  	return IRQ_RETVAL(handled);
> 

Thanks. I'll give it a spin on Wednesday.


> >I hope this is of some use to you. I'll do more testing later.
> 
> Which SoC do you use and do you have DMA enabled?

am335x, DMA is enabled, unless I need to do something extra in the
device tree. We depend on am335x.dtsi, so I would think that would be
automatic if CONFIG_SERIAL_8250_DMA=y.

Thanks,
Frans
