Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaIPRBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:01:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:43256 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaIPRBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:01:36 -0400
Message-ID: <54186CE9.5030303@linutronix.de>
Date: Tue, 16 Sep 2014 19:01:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>, linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 06/16] tty: serial: Add 8250-core based omap driver
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-7-git-send-email-bigeasy@linutronix.de> <54118E1B.5070706@hurleysoftware.com>
In-Reply-To: <54118E1B.5070706@hurleysoftware.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:57 PM, Peter Hurley wrote:
> Hi Sebastian,

Hi Peter,

> Nice work. Minor comments within.

Thanks.

> After this is merged, it may be worth investigating how to use Yoshihiro's
> newly-added 8250-based tunable RX trigger interface for omap.

We need to overwrite the FCR callback. First because we can support
trigger levels 1…64 and it it split across two registers and second
because a change here results also in different DMA attributes.

>> +++ b/drivers/tty/serial/8250/8250_omap.c
>> @@ -0,0 +1,911 @@
>> +/*
>> + * 8250-core based driver for the OMAP internal UART
>> + *
>> + *  Copyright (C) 2014 Sebastian Andrzej Siewior
> 
> + * based on omap-serial.c, Copyright (C) 2010 Texas Instruments.
> 
> or something like that, since this is (partly) based on omap-serial.c

of course.

>> + *
>> + */
>> +
…
>> +	/*
>> +	 * Ask the core to calculate the divisor for us.
>> +	 */
>> +	baud = uart_get_baud_rate(port, termios, old,
>> +			port->uartclk / 16 / 0xffff,
>> +			port->uartclk / 13);
>> +	omap_8250_get_divisor(port, baud, priv);
>> +
>> +	/*
>> +	 * Ok, we're now changing the port state. Do it with
>> +	 * interrupts disabled.
>> +	 */
>> +	pm_runtime_get_sync(port->dev);
>> +	spin_lock_irqsave(&port->lock, flags);
>                    ^^^
>         spin_lock_irq(&port->lock);
> 
> The serial core calls the ->set_termios() method with interrupts enabled.

Okay, this could work.

>> +
>> +	/*
>> +	 * Update the per-port timeout.
>> +	 */
>> +	uart_update_timeout(port, termios->c_cflag, baud);
>> +
>> +	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
>> +	if (termios->c_iflag & INPCK)
>> +		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
>> +	if (termios->c_iflag & (BRKINT | PARMRK))
>                                 ^
>                               IGNBRK |
> 
> Otherwise, the read_status_mask will mask out the BI condition, so
> uart_insert_char() will send '\0' byte as TTY_NORMAL.
> 
> The 8250 and omap RX path differed so the omap driver didn't need this
> change, whereas the 8250 driver does.

Updated.

>> +		up->port.read_status_mask |= UART_LSR_BI;
>> +
>> +	/*
…
>> +
>> +	priv->efr = 0;
>> +	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW) {
>> +		/* Enable AUTORTS and AUTOCTS */
>> +		priv->efr |= UART_EFR_CTS | UART_EFR_RTS;
>> +
>> +		/* Ensure MCR RTS is asserted */
>> +		up->mcr |= UART_MCR_RTS;
>> +	}
>> +
>> +	if (up->port.flags & UPF_SOFT_FLOW) {
> 
> I'm aware that this is basically from the omap driver but can someone clear
> up if omap hardware can actually do UPF_HARD_FLOW and UPF_SOFT_FLOW
> simultaneously? The datasheets that I've looked at say no.

The one that I have here for am335x says:
"The UART module can use hardware or software flow control to manage
transmission and reception".
So yes, you are right about this. I changed this to do UPF_HARD_FLOW if
possible + else UPF_SOFT_FLOW.

> Regards,
> Peter Hurley

Sebastian
