Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaCTIN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:13:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56474 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaCTIM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:12:59 -0400
X-Greylist: delayed 79018 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 04:12:58 EDT
X-AuditID: 85900ec0-d1328b9000001514-dd-532aa307e545
Message-ID: <532AA306.4040207@hitachi.com>
Date: Thu, 20 Mar 2014 17:12:54 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Alan <gnomes@lxorguk.ukuu.org.uk>, Stephen Warren <swarren@nvidia.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [PATCH V4] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
References: <20140319101556.22672.8782.stgit@yunodevel> <5329F53B.3020800@wwwdotorg.org>
In-Reply-To: <5329F53B.3020800@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thank you for your reply.

(2014/03/20 4:51), Stephen Warren wrote:
> On 03/19/2014 04:15 AM, Yoshihiro YUNOMAE wrote:
>> Add tunable RX interrupt trigger I/F of FIFO buffers.
>> Serial devices are used as not only message communication devices but control
>> or sending communication devices. For the latter uses, normally small data
>> will be exchanged, so user applications want to receive data unit as soon as
>> possible for real-time tendency. If we have a sensor which sends a 1 byte data
>> each time and must control a device based on the sensor feedback, the RX
>> interrupt should be triggered for each data.
>>
>> According to HW specification of serial UART devices, RX interrupt trigger
>> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
>> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
>> the trigger to only 8bytes.
>
>> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
>> index 69932b7..fc17fb2 100644
>> --- a/drivers/tty/serial/8250/8250_core.c
>> +++ b/drivers/tty/serial/8250/8250_core.c
>> @@ -531,11 +531,10 @@ static void serial8250_clear_fifos(struct uart_8250_port *p)
>>
>>   void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
>>   {
>> -	unsigned char fcr;
>> -
>>   	serial8250_clear_fifos(p);
>> -	fcr = uart_config[p->port.type].fcr;
>> -	serial_out(p, UART_FCR, fcr);
>> +	if (!p->fcr)
>> +		p->fcr = uart_config[p->port.type].fcr;
>
> Rather than sprinkling this initialization all over the place, can't the
> fcr value be set up one time, when the port is first created?

It's nice idea. If we can store default value of fcr to up->fcr when
the port is first created, we don't need to check whether p->fcr exists
or not.
Maybe by adding the operation after register_dev_spec_attr_grp()
in my patch, we can avoid the check.

>> +static int convert_fcr2val(struct uart_8250_port *up, unsigned char fcr)
>> +{
>> +	unsigned char trig_raw = fcr & UART_FCR_TRIGGER_MASK;
>> +
>> +	switch (up->port.type) {
>> +	case PORT_16550A:
>> +		if (trig_raw == UART_FCR_R_TRIG_00)
>> +			return 1;
>> +		else if (trig_raw == UART_FCR_R_TRIG_01)
>> +			return 4;
>> +		else if (trig_raw == UART_FCR_R_TRIG_10)
>> +			return 8;
>> +		else if (trig_raw == UART_FCR_R_TRIG_11)
>> +			return 14;
>> +		break;
>> +	}
>> +	return -EOPNOTSUPP;
>> +}
>
> Rather than implementing this translation inside this one function
> (well, and convert_val2rxtrig() too), perhaps it would make sense to put
> the values into uart_config[] and just look them up here. That would
> better isolate the type-specific data into one place.

Sure. I'll apply following implementation:

  [PORT_16550A] = {
     .name		= "16550A",
     .fifo_size		= 16,
     .tx_loadsz		= 16,
     .fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+   .rx_trig_byte	= {1, 4, 8, 14},
     .flags		= UART_CAP_FIFO,
  };


> The comment right before UART_FCR_R_TRIG_00 in
> include/uapi/linux/serial_reg.h might help when filling in any extra
> fields in uart_config[].

OK, I'll add following rx_trig_byte to PORT_16650V2, PORT_16654,
PORT_16750, and PORT_TEGRA in uart_config[].

/*
  * Note: The FIFO trigger levels are chip specific:
  *      RX:76 = 00  01  10  11  TX:54 = 00  01  10  11
  * PC16550D:     1   4   8  14          xx  xx  xx  xx
  * TI16C550A:    1   4   8  14          xx  xx  xx  xx
  * TI16C550C:    1   4   8  14          xx  xx  xx  xx
  * ST16C550:     1   4   8  14          xx  xx  xx  xx
  * ST16C650:     8  16  24  28          16   8  24  30  PORT_16650V2
  * NS16C552:     1   4   8  14          xx  xx  xx  xx
  * ST16C654:     8  16  56  60           8  16  32  56  PORT_16654
  * TI16C750:     1  16  32  56          xx  xx  xx  xx  PORT_16750
  * TI16C752:     8  16  56  60           8  16  32  56
  * Tegra:        1   4   8  14          16   8   4   1  PORT_TEGRA
  */

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


