Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaDORkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:40:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49093 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaDORkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:40:03 -0400
Message-ID: <534D6EED.8000905@wwwdotorg.org>
Date: Tue, 15 Apr 2014 11:39:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V5.1] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
References: <20140415055216.14660.18270.stgit@yunodevel> <20140415080649.19209.60645.stgit@yunodevel>
In-Reply-To: <20140415080649.19209.60645.stgit@yunodevel>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 02:06 AM, Yoshihiro YUNOMAE wrote:
> /* I found a bug in V5, so I resend this as V5.1. Please do not review V5. */
> 
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

> diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h

> +#define FCR_RX_TRIG_OFFSET	6

Isn't "SHIFT" the usual term rather than "OFFSET". Why not add this
define into include/uapi/linux/serial_reg.h, along with all the other
UART_FCR_TRIGGER_* defines?

> +#define FCR_RX_TRIG_BITS(x)	(((x) >> FCR_RX_TRIG_OFFSET) & 0x3)

Perhaps use UART_FCR_TRIGGER_MASK rather than a hard-coded "3" (and then
you'd have to mask before shifting).

> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c

> @@ -2275,10 +2276,9 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,

>  	if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
> -		fcr = uart_config[port->type].fcr;
> -		if ((baud < 2400 && !up->dma) || fifo_bug) {
> -			fcr &= ~UART_FCR_TRIGGER_MASK;
> -			fcr |= UART_FCR_TRIGGER_1;
> +		/* NOTE: If fifo_bug is not set, a uaser can set RX_trigger. */
> +		if ((baud < 2400 && !up->dma &&
> +		    (up->fcr == uart_config[port->type].fcr)) || up->fifo_bug) {
> +			up->fcr &= ~UART_FCR_TRIGGER_MASK;
> +			up->fcr |= UART_FCR_TRIGGER_1;
>  		}
>  	}

Does the "(up->fcr == uart_config[port->type].fcr)" term prevent the
user from changing the trigger level multiple times? Perhaps this is
intended?

> +static int convert_fcr2val(struct uart_8250_port *up)

"val" is rather generic here, and doesn't describe what the function is
doing. What about fcr_get_rxtrig_bytes()?

> +{
> +	const struct serial8250_config *conf_type = &uart_config[up->port.type];
> +	unsigned char rx_trig_raw = up->fcr & UART_FCR_TRIGGER_MASK;
> +	unsigned char val;
> +
> +	val = conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(rx_trig_raw)];

Given that FCR_RX_TRIG_BITS() does all the required shifting/masking,
why not just:

	val = conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(up->fcr)];

> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)

Perhaps name this bytes_to_fcr_txtrig()?

> +static void register_dev_spec_attr_grp(struct uart_8250_port *up)
> +{
> +	switch (up->port.type) {
> +	case PORT_16550A:
> +	case PORT_16650V2:
> +	case PORT_16654:
> +	case PORT_16750:
> +	case PORT_TEGRA:

Why not replace that with:

const struct serial8250_config *conf_type = &uart_config[up->port.type];
if (conf_type->rx_trig_byte[0]) {

(or something like that anyway)

That means this switch statement doesn't need to be updated when new
UART types are modified to set up the rx_trig_byte field.
