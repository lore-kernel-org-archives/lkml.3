Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaBMSIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:08:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaBMSIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:08:49 -0500
Date: Thu, 13 Feb 2014 10:10:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] serial/uart: Add tunable RX interrupt trigger I/F of
 FIFO buffers
Message-ID: <20140213181007.GA24155@kroah.com>
References: <20140206021655.8613.52786.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206021655.8613.52786.stgit@yunodevel>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 11:16:55AM +0900, Yoshihiro YUNOMAE wrote:
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
> 
> This patch makes a 16550A device change RX interrupt trigger from userland.
> 
> <How to use>
> unsigned char rx_trig_byte = 1;
> fd = open(TTY_PASS, O_RDWR | O_NONBLOCK);
> ioctl(fd, TIOCSFIFOTRIG, &rx_trig_byte);
> read(fd, buf, size);
> 
> <Support uart device>
> - 16550A (1, 4, 8, or 14 bytes)
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
>  drivers/tty/serial/8250/8250_core.c |   63 +++++++++++++++++++++++++++++++++++
>  include/uapi/asm-generic/ioctls.h   |    2 +
>  2 files changed, 65 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 61ecd70..f51637a 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -2699,6 +2699,68 @@ serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
>  	return 0;
>  }
>  
> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
> +{
> +	switch (up->port.type) {
> +	case PORT_16550A:
> +		if (val == 1)
> +			return UART_FCR_R_TRIG_00;
> +		else if (val == 4)
> +			return UART_FCR_R_TRIG_01;
> +		else if (val == 8)
> +			return UART_FCR_R_TRIG_10;
> +		else if (val == 14)
> +			return UART_FCR_R_TRIG_11;
> +		break;
> +	default:
> +		pr_info("Not support RX-trigger setting for this serial %u\n",
> +			up->port.type);
> +	}
> +	return -EINVAL;
> +}
> +
> +static int set_fifo_rx_trigger(struct uart_8250_port *up,
> +			       unsigned char __user *uval)
> +{
> +	unsigned char fcr, val;
> +	int rx_trig;
> +
> +	if (copy_from_user(&val, uval, sizeof(unsigned char)))
> +		return -EFAULT;
> +
> +	rx_trig = convert_val2rxtrig(up, val);
> +	if (rx_trig < 0)
> +		return rx_trig;
> +
> +	fcr = uart_config[up->port.type].fcr;
> +	serial8250_clear_fifos(up);
> +	fcr &= ~UART_FCR_TRIGGER_MASK;
> +	fcr |= (unsigned char)rx_trig;
> +	serial_out(up, UART_FCR, fcr);
> +	return 0;
> +}
> +
> +static int
> +serial8250_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
> +{
> +	struct uart_8250_port *up =
> +		container_of(port, struct uart_8250_port, port);
> +	void __user *uarg = (void __user *)arg;
> +	int ret;
> +
> +	if (!(up->capabilities & UART_CAP_FIFO) || port->fifosize <= 1)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case TIOCSFIFORTRIG:
> +		ret = set_fifo_rx_trigger(up, uarg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +	}
> +	return ret;
> +}
> +
>  static const char *
>  serial8250_type(struct uart_port *port)
>  {
> @@ -2728,6 +2790,7 @@ static struct uart_ops serial8250_pops = {
>  	.request_port	= serial8250_request_port,
>  	.config_port	= serial8250_config_port,
>  	.verify_port	= serial8250_verify_port,
> +	.ioctl		= serial8250_ioctl,
>  #ifdef CONFIG_CONSOLE_POLL
>  	.poll_get_char = serial8250_get_poll_char,
>  	.poll_put_char = serial8250_put_poll_char,
> diff --git a/include/uapi/asm-generic/ioctls.h b/include/uapi/asm-generic/ioctls.h
> index 143dacb..d2e56a4 100644
> --- a/include/uapi/asm-generic/ioctls.h
> +++ b/include/uapi/asm-generic/ioctls.h
> @@ -78,6 +78,8 @@
>  #define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
>  #define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
>  
> +#define TIOCSFIFORTRIG	0x5441

Please define this as a "proper" ioctl command by using the correct IO*
macros.

Also, why pass a pointer to a variable, and not just the value itself?

And are you sure there's no other way to do this already?  It's odd that
no one else has ever hit this before...

thanks,

greg k-h
