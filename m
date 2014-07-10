Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaGJPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:55:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:49644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGJPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:55:37 -0400
Message-ID: <53BEB75C.70304@linutronix.de>
Date: Thu, 10 Jul 2014 17:55:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 5/6] tty: serial: 8250-core: add rs485 support
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de> <1404928177-26554-6-git-send-email-bigeasy@linutronix.de> <20140709190143.GF17769@csclub.uwaterloo.ca>
In-Reply-To: <20140709190143.GF17769@csclub.uwaterloo.ca>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 09:01 PM, Lennart Sorensen wrote:
>> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
>> index c7c3bf7..bf06a4c 100644
>> --- a/drivers/tty/serial/8250/8250_core.c
>> +++ b/drivers/tty/serial/8250/8250_core.c
>> @@ -1281,10 +1283,34 @@ static void autoconfig_irq(struct uart_8250_port *up)
>>  
>>  static inline void __stop_tx(struct uart_8250_port *p)
>>  {
>> +	if (p->rs485.flags & SER_RS485_ENABLED) {
>> +		int ret;
>> +
>> +		ret = (p->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
>> +		if (gpio_get_value(p->rts_gpio) != ret) {
>> +			if (p->rs485.delay_rts_after_send > 0)
>> +				mdelay(p->rs485.delay_rts_after_send);
>> +			gpio_set_value(p->rts_gpio, ret);
> 
> Usually the delay for RS485 is done in bit times, not msec.  Not sure
> how you expect this to work.  Not sure doing it in software is precise
> enough either.  It probably should be calculated based on the current
> baudrate with a bit time rather than msec in the DT data.  No one wants
> to have to change the DT data to change the baud rate.  After all this
> is very often used with modbus and the modbus rules specify turn around
> times in bit times.

My understanding is that this is not baudrate related. This is the
delay that the hardware (the transceiver) to perform the change and
work.
There is the ioctl() interface which can change the delay, too. The
only required thing is the gpio.

> I hope TI puts this into the UART in future designs where it belongs
> (similar to what Exar and many others already did).
> 

Sebastian
