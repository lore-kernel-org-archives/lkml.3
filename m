Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaCSTva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:51:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46088 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaCSTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:51:28 -0400
Message-ID: <5329F53B.3020800@wwwdotorg.org>
Date: Wed, 19 Mar 2014 13:51:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Alan <gnomes@lxorguk.ukuu.org.uk>
CC: Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V4] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
References: <20140319101556.22672.8782.stgit@yunodevel>
In-Reply-To: <20140319101556.22672.8782.stgit@yunodevel>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 04:15 AM, Yoshihiro YUNOMAE wrote:
> Add tunable RX interrupt trigger I/F of FIFO buffers.
> Serial devices are used as not only message communication devices but control
> or sending communication devices. For the latter uses, normally small data
> will be exchanged, so user applications want to receive data unit as soon as
> possible for real-time tendency. If we have a sensor which sends a 1 byte data
> each time and must control a device based on the sensor feedback, the RX
> interrupt should be triggered for each data.
> 
> According to HW specification of serial UART devices, RX interrupt trigger
> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
> the trigger to only 8bytes.

> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 69932b7..fc17fb2 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -531,11 +531,10 @@ static void serial8250_clear_fifos(struct uart_8250_port *p)
>  
>  void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
>  {
> -	unsigned char fcr;
> -
>  	serial8250_clear_fifos(p);
> -	fcr = uart_config[p->port.type].fcr;
> -	serial_out(p, UART_FCR, fcr);
> +	if (!p->fcr)
> +		p->fcr = uart_config[p->port.type].fcr;

Rather than sprinkling this initialization all over the place, can't the
fcr value be set up one time, when the port is first created?

> +static int convert_fcr2val(struct uart_8250_port *up, unsigned char fcr)
> +{
> +	unsigned char trig_raw = fcr & UART_FCR_TRIGGER_MASK;
> +
> +	switch (up->port.type) {
> +	case PORT_16550A:
> +		if (trig_raw == UART_FCR_R_TRIG_00)
> +			return 1;
> +		else if (trig_raw == UART_FCR_R_TRIG_01)
> +			return 4;
> +		else if (trig_raw == UART_FCR_R_TRIG_10)
> +			return 8;
> +		else if (trig_raw == UART_FCR_R_TRIG_11)
> +			return 14;
> +		break;
> +	}
> +	return -EOPNOTSUPP;
> +}

Rather than implementing this translation inside this one function
(well, and convert_val2rxtrig() too), perhaps it would make sense to put
the values into uart_config[] and just look them up here. That would
better isolate the type-specific data into one place.

The comment right before UART_FCR_R_TRIG_00 in
include/uapi/linux/serial_reg.h might help when filling in any extra
fields in uart_config[].
