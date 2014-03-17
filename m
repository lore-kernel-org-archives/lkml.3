Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaCQDDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:03:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38372 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaCQDDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:03:13 -0400
X-AuditID: 85900ec0-d1328b9000001514-76-532665edac95
Message-ID: <532665ED.7090401@hitachi.com>
Date: Mon, 17 Mar 2014 12:03:09 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan <gnomes@lxorguk.ukuu.org.uk>, Stephen Warren <swarren@nvidia.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [PATCH V3] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
References: <20140314022154.4345.23024.stgit@yunodevel> <20140314141602.GA11603@xps8300>
In-Reply-To: <20140314141602.GA11603@xps8300>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

Thank you for your reply.

(2014/03/14 23:16), Heikki Krogerus wrote:
> Hi,
>
> On Fri, Mar 14, 2014 at 11:21:54AM +0900, Yoshihiro YUNOMAE wrote:
>>   void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
>>   {
>> -	unsigned char fcr;
>> -
>>   	serial8250_clear_fifos(p);
>> -	fcr = uart_config[p->port.type].fcr;
>> -	serial_out(p, UART_FCR, fcr);
>> +	p->fcr = uart_config[p->port.type].fcr;
>> +	serial_out(p, UART_FCR, p->fcr);
>
> You should allow also the probe drivers to set this..
>
>          if (!p->fcr)
>                  p->fcr = uart_config[p->port.type].fcr;

Oh, I'll fix it.

>>   }
>>   EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
>>
>> @@ -2325,10 +2323,19 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
>>   		if ((baud < 2400 && !up->dma) || fifo_bug) {
>>   			fcr &= ~UART_FCR_TRIGGER_MASK;
>>   			fcr |= UART_FCR_TRIGGER_1;
>> +			/* Don't use user setting RX trigger */
>> +			up->fcr = 0;
>
> I don't know about this but..
>
>>   		}
>>   	}
>>
>>   	/*
>> +	 * If up->fcr exists, a user has opened this port, changed RX trigger,
>> +	 * or read RX trigger before. So, we don't need to change up->fcr here.
>> +	 */
>> +	if (!up->fcr)
>> +		up->fcr = fcr;
>
> Why not just set fcr = up->fcr in the beginning of the function?

Ah, we don't need to set up->fcr = 0 in the previous flow when we
implement as follows:

unsigned char fcr = up->fcr;

  ... <snip> ...

     /*
      * If fcr exists, a user has opened this port, changed RX
      * trigger, or read RX trigger before. If so, we do not change
      * fcr.
      */
     if (!fcr)
         fcr = uart_config[port_type].fcr;
     if ((baud < 2400 && !up->dma) || fifo_bug) {
         fcr &= ~UART_FCR_TRIGGER_MASK;
         fcr |= UART_FCR_TRIGGER_1;
     }

up->fcr = fcr;

> <snip>
>
>> +static int do_set_rx_int_trig(struct tty_port *port, unsigned char val)
>> +{
>> +	struct uart_state *state = container_of(port, struct uart_state, port);
>> +	struct uart_port *uport = state->uart_port;
>> +	struct uart_8250_port *up =
>> +		container_of(uport, struct uart_8250_port, port);
>> +	unsigned char fcr;
>> +	int rx_trig;
>> +
>> +	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1)
>> +		return -EINVAL;
>> +
>> +	rx_trig = convert_val2rxtrig(up, val);
>> +	if (rx_trig < 0)
>> +		return rx_trig;
>> +
>> +	serial8250_clear_fifos(up);
>> +	if (!up->fcr)
>> +		/* termios is not set yet */
>> +		fcr = uart_config[up->port.type].fcr;
>> +	else
>> +		fcr = up->fcr;
>> +	fcr &= ~UART_FCR_TRIGGER_MASK;
>> +	fcr |= (unsigned char)rx_trig;
>> +	up->fcr = fcr;
>> +	serial_out(up, UART_FCR, up->fcr);
>> +	return 0;
>> +}
>
> Where are you setting UART_FCR_ENABLE_FIFO bit? Am I missing
> something?

In these implementation, the driver sets up->fcr as
uart_config[up->port.type].fcr first and changes only RX trigger. So,
we don't need to set the bit in a direct way.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


