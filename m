Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbbA1Vra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:47:30 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42887 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbbA1Ue3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:29 -0500
Date: Wed, 28 Jan 2015 18:55:25 +0100
From: Johan Hovold <johan@kernel.org>
To: Peter Hung <hpeter@gmail.com>
Cc: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v3 1/5] usb: serial: add register map for F81232
Message-ID: <20150128175525.GE2433@localhost>
References: <1422424676-7395-1-git-send-email-hpeter+linux_kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422424676-7395-1-git-send-email-hpeter+linux_kernel@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:57:56PM +0800, Peter Hung wrote:
> Add register map for F81232. and add some function to operating this device.
> etc. f81232_get_register()/f81232_set_register() to work with USB control
> point. and worker f81232_int_work_wq() to read MSR when IIR acquired.
> 
> Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
> ---
>  drivers/usb/serial/f81232.c | 229 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 214 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index c5dc233..efd45a7 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
> @@ -23,6 +23,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
> +#include <linux/serial_reg.h>
> +#include <linux/version.h>

You don't need this header.

>  static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x1934, 0x0706) },
> @@ -37,19 +39,197 @@ MODULE_DEVICE_TABLE(usb, id_table);
>  #define UART_STATE_TRANSIENT_MASK	0x74
>  #define UART_DCD			0x01
>  #define UART_DSR			0x02
> -#define UART_BREAK_ERROR		0x04
>  #define UART_RING			0x08
> -#define UART_FRAME_ERROR		0x10
> -#define UART_PARITY_ERROR		0x20
> -#define UART_OVERRUN_ERROR		0x40
>  #define UART_CTS			0x80
>  
> +#define UART_BREAK_ERROR		0x10
> +#define UART_FRAME_ERROR		0x08
> +#define UART_PARITY_ERROR		0x04
> +#define UART_OVERRUN_ERROR		0x02
> +#define  SERIAL_EVEN_PARITY         (UART_LCR_PARITY | UART_LCR_EPAR)

You never use this define.

> +#define REGISTER_REQUEST 0xA0
> +#define GET_REGISTER 0xc0
> +#define SET_REGISTER 0x40
> +#define F81232_USB_TIMEOUT 1000
> +#define F81232_USB_RETRY 20

Why on earth are you retrying your control requests 20 times? You never
answered my question to a previous version whether the retries are at
all needed.

> +
> +#define SERIAL_BASE_ADDRESS	   (0x0120)
> +#define RECEIVE_BUFFER_REGISTER    (0x00 + SERIAL_BASE_ADDRESS)
> +#define TRANSMIT_HOLDING_REGISTER  (0x00 + SERIAL_BASE_ADDRESS)
> +#define INTERRUPT_ENABLE_REGISTER  (0x01 + SERIAL_BASE_ADDRESS)
> +#define INTERRUPT_IDENT_REGISTER   (0x02 + SERIAL_BASE_ADDRESS)
> +#define FIFO_CONTROL_REGISTER      (0x02 + SERIAL_BASE_ADDRESS)
> +#define LINE_CONTROL_REGISTER      (0x03 + SERIAL_BASE_ADDRESS)
> +#define MODEM_CONTROL_REGISTER     (0x04 + SERIAL_BASE_ADDRESS)
> +#define LINE_STATUS_REGISTER       (0x05 + SERIAL_BASE_ADDRESS)
> +#define MODEM_STATUS_REGISTER      (0x06 + SERIAL_BASE_ADDRESS)
> +
>  struct f81232_private {
>  	spinlock_t lock;
>  	u8 line_control;
>  	u8 line_status;
> +
> +	struct work_struct int_worker;

You never schedule this work.

> +	struct usb_serial_port *port;
>  };
>  
> +static inline int calc_baud_divisor(u32 baudrate)
> +{
> +	u32 divisor, rem;
> +
> +	divisor = 115200L / baudrate;
> +	rem = 115200L % baudrate;
> +
> +	/* Round to nearest divisor */
> +	if (((rem * 2) >= baudrate) && (baudrate != 110))
> +		divisor++;
> +
> +	return divisor;
> +}

You never use this either.

You need to take more care when preparing your patches. As I already
asked, break them up into logical changes and only add things that you
will actually use.

> +
> +static inline int f81232_get_register(struct usb_device *dev,
> +							  u16 reg, u8 *data)
> +{
> +	int status;
> +	int i = F81232_USB_RETRY;
> +
> +	while (i--) {
> +		status = usb_control_msg(dev,
> +				 usb_rcvctrlpipe(dev, 0),
> +				 REGISTER_REQUEST,
> +				 GET_REGISTER,
> +				 reg,
> +				 0,
> +				 data,
> +				 sizeof(*data),
> +				 F81232_USB_TIMEOUT);
> +
> +		if (status < 0) {
> +			dev_dbg(&dev->dev,
> +				"f81232_get_register status: %d, fail:%d\n",
> +				status, i);
> +		} else
> +			break;

Missing brackets { } on the else branch.

> +	}
> +
> +	return status;
> +}
> +
> +
> +static inline int f81232_set_register(struct usb_device *dev,
> +							  u16 reg, u8 data)
> +{
> +	int status;
> +	int i = F81232_USB_RETRY;
> +
> +	while (i--) {
> +		status = usb_control_msg(dev,
> +				 usb_sndctrlpipe(dev, 0),
> +				 REGISTER_REQUEST,
> +				 SET_REGISTER,
> +				 reg,
> +				 0,
> +				 &data,
> +				 1,
> +				 F81232_USB_TIMEOUT);
> +
> +		if (status < 0)
> +			dev_dbg(&dev->dev,
> +				"f81232_set_register status: %d, fail:%d\n",
> +				status, i);
> +		else
> +			break;
> +	}
> +
> +	return status;
> +}
> +
> +static void f81232_read_msr(struct f81232_private *priv)
> +{
> +	unsigned long flags;
> +	u8 current_msr, old_msr;
> +	struct usb_device *dev = priv->port->serial->dev;
> +
> +	f81232_get_register(dev, MODEM_STATUS_REGISTER, &current_msr);

Error handling?

> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	old_msr = priv->line_status;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +

Stray newline.

> +	if ((current_msr & 0xf0) ^ (old_msr & 0xf0)) {

Use defines for constants.

> +		if (priv->port->port.tty)

You need to acquire a tty reference using tty_port_tty_get().

> +			usb_serial_handle_dcd_change(priv->port,
> +				priv->port->port.tty,
> +				current_msr & UART_MSR_DCD);
> +
> +		spin_lock_irqsave(&priv->lock, flags);
> +		priv->line_status = current_msr;
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +	}
> +
> +	dev_dbg(&dev->dev, "f81232_read_msr: %x\n", priv->line_status);

Use %s and __func__.

> +}
> +
> +

Only one newline. Fix this throughout.

> +static inline int update_mctrl(struct f81232_private *port_priv,
> +					   unsigned int set, unsigned int clear)
> +{
> +	struct usb_device *dev = port_priv->port->serial->dev;
> +	u8 urb_value;
> +	int status;
> +	unsigned long flags;
> +
> +	if (((set | clear) & (TIOCM_DTR | TIOCM_RTS)) == 0) {
> +		dev_dbg(&dev->dev, "update_mctrl fail - DTR|RTS %d\n",
> +			__LINE__);
> +		return 0;	/* no change */
> +	}
> +
> +
> +	clear &= ~set;	/* 'set' takes precedence over 'clear' */
> +	urb_value = 8 | port_priv->line_control;
> +
> +
> +	if (clear & TIOCM_DTR) {
> +		urb_value &= ~UART_MCR_DTR;
> +		dev_dbg(&dev->dev, "clear DTR\n");
> +	}
> +
> +	if (clear & TIOCM_RTS) {
> +		urb_value &= ~UART_MCR_RTS;
> +		dev_dbg(&dev->dev, "clear RTS\n");
> +	}
> +
> +	if (set & TIOCM_DTR) {
> +		urb_value |= UART_MCR_DTR;
> +		dev_dbg(&dev->dev, "set DTR\n");
> +	}
> +
> +	if (set & TIOCM_RTS) {
> +		urb_value |= UART_MCR_RTS;
> +		dev_dbg(&dev->dev, "set RTS\n");
> +	}
> +
> +	dev_dbg(&dev->dev, "update_mctrl n:%x o:%x\n", urb_value,
> +			port_priv->line_control);
> +
> +	status = f81232_set_register(dev, MODEM_CONTROL_REGISTER, urb_value);
> +
> +	if (status < 0) {
> +		dev_dbg(&dev->dev, "MODEM_CONTROL_REGISTER < 0\n");
> +	} else {
> +		spin_lock_irqsave(&port_priv->lock, flags);
> +		port_priv->line_control = urb_value;
> +		spin_unlock_irqrestore(&port_priv->lock, flags);
> +	}
> +
> +	f81232_read_msr(port_priv);
> +
> +	return status;
> +}

You never call this function either.

Missing newline.

>  static void f81232_update_line_status(struct usb_serial_port *port,
>  				      unsigned char *data,
>  				      unsigned int actual_length)
> @@ -201,8 +381,8 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
>  
>  	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
>  	if (result) {
> -		dev_err(&port->dev, "%s - failed submitting interrupt urb,"
> -			" error %d\n", __func__, result);
> +		dev_err(&port->dev, "failed submitting interrupt urb, error %d\n",
> +			result);

I already asked you to fix this separately.

>  		return result;
>  	}
>  
> @@ -241,6 +421,7 @@ static void f81232_dtr_rts(struct usb_serial_port *port, int on)
>  static int f81232_carrier_raised(struct usb_serial_port *port)
>  {
>  	struct f81232_private *priv = usb_get_serial_port_data(port);
> +

And I also also asked you not to include random white space changes.

>  	if (priv->line_status & UART_DCD)
>  		return 1;
>  	return 0;
> @@ -254,13 +435,18 @@ static int f81232_ioctl(struct tty_struct *tty,
>  
>  	switch (cmd) {
>  	case TIOCGSERIAL:
> -		memset(&ser, 0, sizeof ser);
> -		ser.type = PORT_16654;
> +		memset(&ser, 0, sizeof(ser));
> +		ser.flags		= ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
> +		ser.xmit_fifo_size	= port->bulk_out_size;
> +		ser.close_delay		= 5*HZ;
> +		ser.closing_wait	= 30*HZ;
> +
> +		ser.type = PORT_16550A;
>  		ser.line = port->minor;
>  		ser.port = port->port_number;
> -		ser.baud_base = 460800;
> +		ser.baud_base = 115200;
>  
> -		if (copy_to_user((void __user *)arg, &ser, sizeof ser))
> +		if (copy_to_user((void __user *)arg, &ser, sizeof(ser)))

This is also unrelated.

>  			return -EFAULT;
>  
>  		return 0;
> @@ -270,6 +456,17 @@ static int f81232_ioctl(struct tty_struct *tty,
>  	return -ENOIOCTLCMD;
>  }
>  
> +
> +
> +
> +static void f81232_int_work_wq(struct work_struct *work)
> +{
> +	struct f81232_private *priv =
> +		container_of(work, struct f81232_private, int_worker);
> +
> +	f81232_read_msr(priv);
> +}
> +
>  static int f81232_port_probe(struct usb_serial_port *port)
>  {
>  	struct f81232_private *priv;
> @@ -279,10 +476,11 @@ static int f81232_port_probe(struct usb_serial_port *port)
>  		return -ENOMEM;
>  
>  	spin_lock_init(&priv->lock);
> +	INIT_WORK(&priv->int_worker, f81232_int_work_wq);
>  
>  	usb_set_serial_port_data(port, priv);
>  
> -	port->port.drain_delay = 256;

Why are you removing the drain delay?̈́

> +	priv->port = port;
>  
>  	return 0;
>  }
> @@ -304,11 +502,11 @@ static struct usb_serial_driver f81232_device = {
>  	},
>  	.id_table =		id_table,
>  	.num_ports =		1,
> -	.bulk_in_size =		256,
> -	.bulk_out_size =	256,
> +	.bulk_in_size =		64,
> +	.bulk_out_size =	64,

You never answered my questions about this change either.

>  	.open =			f81232_open,
>  	.close =		f81232_close,
> -	.dtr_rts = 		f81232_dtr_rts,
> +	.dtr_rts =		f81232_dtr_rts,

I already asked you to drop this random whitespace change.

>  	.carrier_raised =	f81232_carrier_raised,
>  	.ioctl =		f81232_ioctl,
>  	.break_ctl =		f81232_break_ctl,
> @@ -330,5 +528,6 @@ static struct usb_serial_driver * const serial_drivers[] = {
>  module_usb_serial_driver(serial_drivers, id_table);
>  
>  MODULE_DESCRIPTION("Fintek F81232 USB to serial adaptor driver");
> -MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@linuxfoundation.org");
> +MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@linuxfoundation.org>");

Yes, there seems to be a missing bracket here, but please fix that
separately.

> +MODULE_AUTHOR("Peter Hong <peter_hong@fintek.com.tw>");
>  MODULE_LICENSE("GPL v2");

Make sure to fix the above, including similar issues in the other
patches in the series. I'm not going to look at the rest of the patches
until you clean this up and resend.

Please take more care in addressing review comments and answer any
questions already asked on the previous versions of the series.

Thanks,
Johan
