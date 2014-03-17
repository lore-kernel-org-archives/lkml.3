Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaCQGEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:04:13 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60048 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaCQGEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:04:11 -0400
X-AuditID: 85900ec0-d452db9000001514-45-532690572d4c
Message-ID: <53269056.6000903@hitachi.com>
Date: Mon, 17 Mar 2014 15:04:06 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [PATCH V3] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
References: <20140314022154.4345.23024.stgit@yunodevel> <20140314120400.4e17c47a@alan.etchedpixels.co.uk>
In-Reply-To: <20140314120400.4e17c47a@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your reply.

(2014/03/14 21:04), One Thousand Gnomes wrote:
>> @@ -2325,10 +2323,19 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
>>   		if ((baud < 2400 && !up->dma) || fifo_bug) {
>>   			fcr &= ~UART_FCR_TRIGGER_MASK;
>>   			fcr |= UART_FCR_TRIGGER_1;
>> +			/* Don't use user setting RX trigger */
>> +			up->fcr = 0;
>
> This breaks
>
> 	set fcr via sysfs
> 	set baud rate below 2400
> 	set baud rate higher
>
> If baud < 2400 and the user has set a value then probably we should honour

OK, I'll add !up->fcr in this flow as follows:

/* NOTE: If fifo_bug is not set, a user can set RX trigger. */
if ((baud < 2400 && !up->dma && !up->fcr) || fifo_bug) {
      fcr &= ~UART_TRIGGER_MASK;
      fcr |= UART_FCR_TRIGGER_1;
      up->fcr = 0;
}

> it. If fifo_bug is set then we should never honour it (and should perhaps
> eventually error it in the sysfs set).

When fifo_bug is set to "1", we need to check not only
whether (up->bugs & UART_BUG_PARITY) but whether parity is enabled.
We can check whether parity is enable only in this function currently,
so I think we need to store fifo_bug's value into up->fifo_bug and
refer it in the sysfs set(do_set_rx_int_trig()) as follows:

@do_set_rx_int_trig()
     if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1
         || (up->fifo_bug & UART_BUG_PARITY))
         return -EINVAL;

>
>> +static unsigned char convert_fcr2val(struct uart_8250_port *up,
>> +				     unsigned char fcr)
>> +{
>> +	unsigned char val = 0, trig_raw = fcr & UART_FCR_TRIGGER_MASK;
>> +
>> +	switch (up->port.type) {
>> +	case PORT_16550A:
>> +		if (trig_raw == UART_FCR_R_TRIG_00)
>> +			val = 1;
>> +		else if (trig_raw == UART_FCR_R_TRIG_01)
>> +			val = 4;
>> +		else if (trig_raw == UART_FCR_R_TRIG_10)
>> +			val = 8;
>> +		else if (trig_raw == UART_FCR_R_TRIG_11)
>> +			val = 14;
>> +		break;
>
> Surely the default case should be returning 1 not 0 ?

In the default case, it returns "0" meaning error because "1" has
other meaning (1 byte RX trigger). But, "0" is not instinctive value for
the error, so it should return -EOPNOTSUPP here.

>
>> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
>> +{
>> +	switch (up->port.type) {
>> +	case PORT_16550A:
>> +		if (val == 1)
>> +			return UART_FCR_R_TRIG_00;
>> +		else if (val == 4)
>> +			return UART_FCR_R_TRIG_01;
>> +		else if (val == 8)
>> +			return UART_FCR_R_TRIG_10;
>> +		else if (val == 14)
>> +			return UART_FCR_R_TRIG_11;
>
> What happens if you specify a meaningless value. Doing exact matching
> means that you have to know the hardware exactly. How about
>
> 	if (val < 4)
> 		return UART_FCR_R_TRIG_00;
> 	else if (val < 8)
> 		return UART_FCR_R_TRIG_01;
> 	else if (val < 14)
> 		return UART_FCR_R_TRIG_10;
> 	else
> 		return UART_FCR_R_TRIG_11;
>
> so you get the nearest lower value that the hardware can provide ?

It is a good idea. I was concerned about the same thing which users
must know the HW exactly.

I'll implement it as you say.

>> +		break;
>> +	default:
>> +		pr_info("Not support RX-trigger setting for this serial %u\n",
>> +			up->port.type);
>
> That lets users spew into the logs. I think actually you just want
>
> 	default:
> 		return -EOPNOTSUPP;

OK, I'll use this.

Thank you,

Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


