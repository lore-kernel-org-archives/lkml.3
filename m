Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbbASBzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:55:03 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34154 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbASBzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:55:00 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH 1/1] usb: serial: Fintek F81232 driver improvement
Date: Mon, 19 Jan 2015 09:54:55 +0800
Message-Id: <1421632495-26260-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original driver completed with TX function, but RX/MSR/MCR/LSR is not
workable with this driver. So we rewrite it to make this device workable.

This patch is tested with PassMark BurnInTest with Cycle-to-115200 +
MCR/MSR check for 15mins & checked with Suspend-To-RAM/DISK

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/usb/serial/f81232.c | 528 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 440 insertions(+), 88 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index c5dc233..5ae6bc9 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -23,9 +23,16 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/serial_reg.h>
+#include <linux/version.h>
+
+#define FINTEK_MAGIC 'F'
+#define FINTEK_GET_ID		_IOR(FINTEK_MAGIC, 3, int)
+#define FINTEK_VENDOR_ID	0x1934
+#define FINTEK_DEVICE_ID	0x0706	/* RS232 1 port */
 
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x1934, 0x0706) },
+	{ USB_DEVICE(FINTEK_VENDOR_ID, FINTEK_DEVICE_ID) },
 	{ }					/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -37,30 +44,257 @@ MODULE_DEVICE_TABLE(usb, id_table);
 #define UART_STATE_TRANSIENT_MASK	0x74
 #define UART_DCD			0x01
 #define UART_DSR			0x02
-#define UART_BREAK_ERROR		0x04
 #define UART_RING			0x08
-#define UART_FRAME_ERROR		0x10
-#define UART_PARITY_ERROR		0x20
-#define UART_OVERRUN_ERROR		0x40
 #define UART_CTS			0x80
 
+
+#define UART_BREAK_ERROR		0x10
+#define UART_FRAME_ERROR		0x08
+#define UART_PARITY_ERROR		0x04
+#define UART_OVERRUN_ERROR		0x02
+
+
+#define  SERIAL_EVEN_PARITY         (UART_LCR_PARITY | UART_LCR_EPAR)
+
+
+#define REGISTER_REQUEST 0xA0
+#define F81232_USB_TIMEOUT 1000
+#define F81232_USB_RETRY 20
+
+
+#define SERIAL_BASE_ADDRESS	   ((__u16)0x0120)
+#define RECEIVE_BUFFER_REGISTER    ((__u16)(0x00) + SERIAL_BASE_ADDRESS)
+#define TRANSMIT_HOLDING_REGISTER  ((__u16)(0x00) + SERIAL_BASE_ADDRESS)
+#define INTERRUPT_ENABLE_REGISTER  ((__u16)(0x01) + SERIAL_BASE_ADDRESS)
+#define INTERRUPT_IDENT_REGISTER   ((__u16)(0x02) + SERIAL_BASE_ADDRESS)
+#define FIFO_CONTROL_REGISTER      ((__u16)(0x02) + SERIAL_BASE_ADDRESS)
+#define LINE_CONTROL_REGISTER      ((__u16)(0x03) + SERIAL_BASE_ADDRESS)
+#define MODEM_CONTROL_REGISTER     ((__u16)(0x04) + SERIAL_BASE_ADDRESS)
+#define LINE_STATUS_REGISTER       ((__u16)(0x05) + SERIAL_BASE_ADDRESS)
+#define MODEM_STATUS_REGISTER      ((__u16)(0x06) + SERIAL_BASE_ADDRESS)
+
+static int m_enable_debug;
+
+module_param(m_enable_debug, int, S_IRUGO);
+MODULE_PARM_DESC(m_enable_debug, "Debugging mode enabled or not");
+
+#define LOG_MESSAGE(x, y, ...)	\
+	printk(x  y, ##__VA_ARGS__)
+
+#define LOG_DEBUG_MESSAGE(level, y, ...)	\
+	do { if (unlikely(m_enable_debug))  \
+			printk(level  y, ##__VA_ARGS__); } while (0)
+
+
 struct f81232_private {
 	spinlock_t lock;
-	u8 line_control;
-	u8 line_status;
+	u8 modem_control;
+	u8 modem_status;
+	struct usb_device *dev;
+
+	struct work_struct int_worker;
+	struct usb_serial_port *port;
 };
 
-static void f81232_update_line_status(struct usb_serial_port *port,
-				      unsigned char *data,
-				      unsigned int actual_length)
+
+static inline int calc_baud_divisor(u32 baudrate)
 {
-	/*
-	 * FIXME: Update port->icount, and call
-	 *
-	 *		wake_up_interruptible(&port->port.delta_msr_wait);
-	 *
-	 *	  on MSR changes.
-	 */
+	u32 divisor, rem;
+
+	divisor = 115200L / baudrate;
+	rem = 115200L % baudrate;
+
+	/* Round to nearest divisor */
+	if (((rem * 2) >= baudrate) && (baudrate != 110))
+		divisor++;
+
+	return divisor;
+}
+
+
+static inline int f81232_get_register(struct usb_device *dev,
+	u16 reg, u8 *data)
+{
+	int status;
+	int i = 0;
+timeout_get_repeat:
+
+	status = usb_control_msg(dev,
+			 usb_rcvctrlpipe(dev, 0),
+			 REGISTER_REQUEST,
+			 0xc0,
+			 reg,
+			 0,
+			 data,
+			 sizeof(*data),
+			 F81232_USB_TIMEOUT);
+	if (status < 0) {
+		i++;
+
+		if (i < F81232_USB_RETRY) {
+			mdelay(1);
+			goto timeout_get_repeat;
+		}
+	}
+	return status;
+}
+
+
+static inline int f81232_set_register(struct usb_device *dev,
+	u16 reg, u8 data)
+{
+	int status;
+	int i = 0;
+
+timeout_set_repeat:
+	status = 0;
+
+	status = usb_control_msg(dev,
+		 usb_sndctrlpipe(dev, 0),
+		 REGISTER_REQUEST,
+		 0x40,
+		 reg,
+		 0,
+		 &data,
+		 1,
+		 F81232_USB_TIMEOUT);
+
+	if (status < 0) {
+		i++;
+		if (i < F81232_USB_RETRY) {
+			mdelay(1);
+			goto timeout_set_repeat;
+		}
+	}
+
+	return status;
+}
+
+static void f81232_read_msr(struct f81232_private *priv)
+{
+	unsigned long flags;
+	u8 current_msr, old_msr;
+
+	f81232_get_register(priv->dev,
+		MODEM_STATUS_REGISTER, &current_msr);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	old_msr = priv->modem_status;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+
+	if ((current_msr & 0xf0) ^ (old_msr & 0xf0)) {
+		usb_serial_handle_dcd_change(priv->port, priv->port->port.tty,
+			current_msr & UART_MSR_DCD);
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->modem_status = current_msr;
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
+
+	LOG_DEBUG_MESSAGE(KERN_INFO,
+		"f81232_read_msr: %x\n", priv->modem_status);
+}
+
+
+static inline int update_mctrl(struct f81232_private *port_priv,
+	unsigned int set, unsigned int clear)
+{
+	struct usb_device *dev = port_priv->dev;
+	u8 urb_value;
+	int status;
+	unsigned long flags;
+
+	if (((set | clear) & (TIOCM_DTR | TIOCM_RTS)) == 0) {
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[FINTEK]:update_mctrl fail - DTR|RTS %d\n",
+			__LINE__);
+
+		return 0;	/* no change */
+	}
+
+
+	clear &= ~set;	/* 'set' takes precedence over 'clear' */
+	urb_value = 8 | port_priv->modem_control;
+
+
+	if (clear & TIOCM_DTR) {
+		urb_value &= ~UART_MCR_DTR;
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[FINTEK]: port:%d clear DTR\n", 0);
+	}
+
+	if (clear & TIOCM_RTS) {
+		urb_value &= ~UART_MCR_RTS;
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[FINTEK]: port:%d clear RTS\n", 0);
+	}
+
+	if (set & TIOCM_DTR) {
+		urb_value |= UART_MCR_DTR;
+		LOG_DEBUG_MESSAGE(KERN_INFO, "[FINTEK]: port:%d set DTR\n", 0);
+	}
+
+	if (set & TIOCM_RTS) {
+		urb_value |= UART_MCR_RTS;
+		LOG_DEBUG_MESSAGE(KERN_INFO, "[FINTEK]: port:%d set RTS\n", 0);
+	}
+	/* urb_value &= ~UART_MCR_RTS; */
+
+
+	/* if(urb_value != port_priv->modem_control) { */
+	LOG_DEBUG_MESSAGE(KERN_INFO,
+		"[fintek]: update_mctrl urb_value:%x, modem_control:%x\n",
+		urb_value,
+		port_priv->modem_control);
+
+	status = f81232_set_register(dev, MODEM_CONTROL_REGISTER, urb_value);
+
+	if (status < 0) {
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[FINTEK]: MODEM_CONTROL_REGISTER < 0\n");
+	} else {
+		spin_lock_irqsave(&port_priv->lock, flags);
+		port_priv->modem_control = urb_value;
+		spin_unlock_irqrestore(&port_priv->lock, flags);
+	}
+
+	f81232_read_msr(port_priv);
+
+	return status;
+}
+
+static void f81232_iir_status(struct usb_serial_port *port,
+	unsigned char *data,
+	unsigned int actual_length)
+{
+	/* IIR Section*/
+
+	struct f81232_private *priv = usb_get_serial_port_data(port);
+
+	if (!actual_length)
+		return;
+
+	switch (data[0] & 0x07) {
+	case 0x00: /* msr change */
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[fintek]: IIR: MSR Change: %x\n", data[0]);
+		schedule_work(&priv->int_worker);
+		break;
+
+	case 0x02: /* tx-empty */
+		break;
+
+	case 0x04: /* rx data available */
+		break;
+
+	case 0x06: /* lsr change */
+		LOG_DEBUG_MESSAGE(KERN_INFO,
+			"[fintek]: IIR: LSR Change: %x\n", data[0]);
+		break;
+	}
+
 }
 
 static void f81232_read_int_callback(struct urb *urb)
@@ -80,48 +314,43 @@ static void f81232_read_int_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dev_dbg(&port->dev, "%s - urb shutting down with status: %d\n",
-			__func__, status);
+				__func__, status);
 		return;
 	default:
 		dev_dbg(&port->dev, "%s - nonzero urb status received: %d\n",
-			__func__, status);
+				__func__, status);
 		goto exit;
 	}
 
 	usb_serial_debug_data(&port->dev, __func__,
-			      urb->actual_length, urb->transfer_buffer);
+		urb->actual_length, urb->transfer_buffer);
 
-	f81232_update_line_status(port, data, actual_length);
+	f81232_iir_status(port, data, actual_length);
 
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev,
-			"%s - usb_submit_urb failed with result %d\n",
-			__func__, retval);
+				"%s - usb_submit_urb failed with result %d\n",
+				__func__, retval);
 }
 
-static void f81232_process_read_urb(struct urb *urb)
+static void f81232_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct f81232_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	char tty_flag = TTY_NORMAL;
-	unsigned long flags;
-	u8 line_status;
+	u8 line_status = 0;
 	int i;
 
-	/* update line status */
-	spin_lock_irqsave(&priv->lock, flags);
-	line_status = priv->line_status;
-	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (!urb->actual_length)
 		return;
 
 	/* break takes precedence over parity, */
 	/* which takes precedence over framing errors */
+
+#if 0
 	if (line_status & UART_BREAK_ERROR)
 		tty_flag = TTY_BREAK;
 	else if (line_status & UART_PARITY_ERROR)
@@ -129,28 +358,22 @@ static void f81232_process_read_urb(struct urb *urb)
 	else if (line_status & UART_FRAME_ERROR)
 		tty_flag = TTY_FRAME;
 	dev_dbg(&port->dev, "%s - tty_flag = %d\n", __func__, tty_flag);
+#endif
 
-	/* overrun is special, not associated with a char */
-	if (line_status & UART_OVERRUN_ERROR)
-		tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
+	if (urb->actual_length >= 2) {
 
-	if (port->port.console && port->sysrq) {
-		for (i = 0; i < urb->actual_length; ++i)
-			if (!usb_serial_handle_sysrq_char(port, data[i]))
-				tty_insert_flip_char(&port->port, data[i],
-						tty_flag);
-	} else {
-		tty_insert_flip_string_fixed_flag(&port->port, data, tty_flag,
-							urb->actual_length);
-	}
+		for (i = 0 ; i < urb->actual_length ; i += 2) {
+			line_status |= data[i+0];
+			tty_insert_flip_string_fixed_flag(&port->port,
+				&data[i+1], tty_flag, 1);
+		}
 
-	tty_flip_buffer_push(&port->port);
-}
+		if (unlikely(line_status & UART_OVERRUN_ERROR))
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
+
+		tty_flip_buffer_push(&port->port);
+	}
 
-static int set_control_lines(struct usb_device *dev, u8 value)
-{
-	/* FIXME - Stubbed out for now */
-	return 0;
 }
 
 static void f81232_break_ctl(struct tty_struct *tty, int break_state)
@@ -165,30 +388,117 @@ static void f81232_break_ctl(struct tty_struct *tty, int break_state)
 }
 
 static void f81232_set_termios(struct tty_struct *tty,
-		struct usb_serial_port *port, struct ktermios *old_termios)
+			struct usb_serial_port *port,
+			struct ktermios *old_termios)
 {
-	/* FIXME - Stubbed out for now */
+	u16 divisor;
+	u16 new_lcr = 0;
+/*
+The following comment is for legacy 3.7.0- kernel, You
+can uncomment and build it if toy need
+*/
 
-	/* Don't change anything if nothing has changed */
-	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
-		return;
+/*
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 7, 0)
+	struct ktermios *termios = &tty->termios;
+#else
+	struct ktermios *termios = tty->termios;
+#endif
+*/
+	struct ktermios *termios = &tty->termios;
+
+	unsigned int cflag = termios->c_cflag;
+	int status;
+
+	struct usb_device *dev = port->serial->dev;
+
+	divisor = calc_baud_divisor(tty_get_baud_rate(tty));
+
+	status = f81232_set_register(dev, LINE_CONTROL_REGISTER,
+		UART_LCR_DLAB); /* DLAB */
+	mdelay(1);
+	status = f81232_set_register(dev, RECEIVE_BUFFER_REGISTER,
+		divisor & 0x00ff); /* low */
+	mdelay(1);
+	status = f81232_set_register(dev, INTERRUPT_ENABLE_REGISTER,
+		(divisor & 0xff00) >> 8); /* high */
+	mdelay(1);
+	status = f81232_set_register(dev, LINE_CONTROL_REGISTER, 0x00);
+	mdelay(1);
+
+	if (cflag & PARENB) {
+		if (cflag & PARODD)
+			new_lcr |= UART_LCR_PARITY; /* odd */
+		else
+			new_lcr |= SERIAL_EVEN_PARITY; /* even */
+	}
+
+
+	if (cflag & CSTOPB)
+		new_lcr |= UART_LCR_STOP;
+	else
+		new_lcr &= ~UART_LCR_STOP;
+
+	switch (cflag & CSIZE) {
+	case CS5:
+		new_lcr |= UART_LCR_WLEN5;
+		break;
+	case CS6:
+		new_lcr |= UART_LCR_WLEN6;
+		break;
+	case CS7:
+		new_lcr |= UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		new_lcr |= UART_LCR_WLEN8;
+		break;
+	}
+
+	status |= f81232_set_register(dev, LINE_CONTROL_REGISTER, new_lcr);
+
+	status |= f81232_set_register(dev, FIFO_CONTROL_REGISTER,
+						  0x87); /* fifo, trigger8 */
+	status |= f81232_set_register(dev,
+		INTERRUPT_ENABLE_REGISTER, 0xf); /* IER */
+
+	if (status < 0) {
+		LOG_MESSAGE(KERN_INFO,
+			"[Fintek]: LINE_CONTROL_REGISTER set error: %d\n"
+			, status);
+	}
 
-	/* Do the real work here... */
-	if (old_termios)
-		tty_termios_copy_hw(&tty->termios, old_termios);
 }
 
 static int f81232_tiocmget(struct tty_struct *tty)
 {
-	/* FIXME - Stubbed out for now */
-	return 0;
+	int r;
+	struct usb_serial_port *port = tty->driver_data;
+	struct f81232_private *port_priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+
+	LOG_DEBUG_MESSAGE(KERN_INFO, "f81232_tiocmget in\n");
+	spin_lock_irqsave(&port_priv->lock, flags);
+	r = (port_priv->modem_control & UART_MCR_DTR ? TIOCM_DTR : 0) |
+		(port_priv->modem_control & UART_MCR_RTS ? TIOCM_RTS : 0) |
+		(port_priv->modem_status & UART_MSR_CTS ? TIOCM_CTS : 0) |
+		(port_priv->modem_status & UART_MSR_DCD ? TIOCM_CAR : 0) |
+		(port_priv->modem_status & UART_MSR_RI ? TIOCM_RI : 0) |
+		(port_priv->modem_status & UART_MSR_DSR ? TIOCM_DSR : 0);
+	spin_unlock_irqrestore(&port_priv->lock, flags);
+	LOG_DEBUG_MESSAGE(KERN_INFO, "f81232_tiocmget out\n");
+	return r;
 }
 
 static int f81232_tiocmset(struct tty_struct *tty,
-			unsigned int set, unsigned int clear)
+						   unsigned int set,
+						   unsigned int clear)
 {
-	/* FIXME - Stubbed out for now */
-	return 0;
+	struct usb_serial_port *port = tty->driver_data;
+	struct f81232_private *port_priv =
+		usb_get_serial_port_data(port);
+
+	return update_mctrl(port_priv, set, clear);
 }
 
 static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
@@ -201,12 +511,14 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
-		dev_err(&port->dev, "%s - failed submitting interrupt urb,"
-			" error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting interrupt urb, error %d\n"
+				, __func__, result);
 		return result;
 	}
 
 	result = usb_serial_generic_open(tty, port);
+
 	if (result) {
 		usb_kill_urb(port->interrupt_in_urb);
 		return result;
@@ -217,6 +529,7 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 static void f81232_close(struct usb_serial_port *port)
 {
+
 	usb_serial_generic_close(port);
 	usb_kill_urb(port->interrupt_in_urb);
 }
@@ -224,52 +537,89 @@ static void f81232_close(struct usb_serial_port *port)
 static void f81232_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct f81232_private *priv = usb_get_serial_port_data(port);
-	unsigned long flags;
-	u8 control;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	/* Change DTR and RTS */
 	if (on)
-		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
+		update_mctrl(priv, TIOCM_DTR | TIOCM_RTS, 0);
 	else
-		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	control = priv->line_control;
-	spin_unlock_irqrestore(&priv->lock, flags);
-	set_control_lines(port->serial->dev, control);
+		update_mctrl(priv, 0, TIOCM_DTR | TIOCM_RTS);
 }
 
 static int f81232_carrier_raised(struct usb_serial_port *port)
 {
 	struct f81232_private *priv = usb_get_serial_port_data(port);
-	if (priv->line_status & UART_DCD)
+	unsigned long flags;
+	int modem_status;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	modem_status = priv->modem_status;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (modem_status & UART_DCD)
 		return 1;
 	return 0;
 }
 
+static int f81232_get_id(struct usb_serial_port *port, int __user *arg)
+{
+	/* 0x19340706 */
+	int data = (FINTEK_VENDOR_ID << 16) | FINTEK_DEVICE_ID;
+
+	if (copy_to_user((int __user *) arg, &data, sizeof(int)))
+		return -EFAULT;
+
+	return 0;
+}
+
+
 static int f81232_ioctl(struct tty_struct *tty,
-			unsigned int cmd, unsigned long arg)
+						unsigned int cmd,
+						unsigned long arg)
 {
 	struct serial_struct ser;
 	struct usb_serial_port *port = tty->driver_data;
 
 	switch (cmd) {
 	case TIOCGSERIAL:
-		memset(&ser, 0, sizeof ser);
-		ser.type = PORT_16654;
+		memset(&ser, 0, sizeof(ser));
+		ser.flags		= ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
+		ser.xmit_fifo_size	= port->bulk_out_size;
+		ser.close_delay		= 5*HZ;
+		ser.closing_wait	= 30*HZ;
+
+		ser.type = PORT_16550A;
 		ser.line = port->minor;
 		ser.port = port->port_number;
-		ser.baud_base = 460800;
+		ser.baud_base = 115200;
 
-		if (copy_to_user((void __user *)arg, &ser, sizeof ser))
+		if (copy_to_user((void __user *)arg, &ser, sizeof(ser)))
 			return -EFAULT;
 
 		return 0;
+
+	case FINTEK_GET_ID:
+		return f81232_get_id(port, (int __user *)arg);
+
 	default:
 		break;
 	}
 	return -ENOIOCTLCMD;
 }
 
+
+
+
+static void f81232_int_work_wq(struct work_struct *work)
+{
+	struct f81232_private *priv =
+		container_of(work, struct f81232_private, int_worker);
+
+
+	LOG_DEBUG_MESSAGE(KERN_INFO, "f81232_int_work_wq\n");
+	f81232_read_msr(priv);
+
+
+}
+
 static int f81232_port_probe(struct usb_serial_port *port)
 {
 	struct f81232_private *priv;
@@ -279,10 +629,12 @@ static int f81232_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
+	INIT_WORK(&priv->int_worker, f81232_int_work_wq);
 
 	usb_set_serial_port_data(port, priv);
 
-	port->port.drain_delay = 256;
+	priv->dev = port->serial->dev;
+	priv->port = port;
 
 	return 0;
 }
@@ -304,22 +656,21 @@ static struct usb_serial_driver f81232_device = {
 	},
 	.id_table =		id_table,
 	.num_ports =		1,
-	.bulk_in_size =		256,
-	.bulk_out_size =	256,
+	.bulk_in_size =		64,
+	.bulk_out_size =	64,
 	.open =			f81232_open,
 	.close =		f81232_close,
-	.dtr_rts = 		f81232_dtr_rts,
+	.dtr_rts =		f81232_dtr_rts,
 	.carrier_raised =	f81232_carrier_raised,
 	.ioctl =		f81232_ioctl,
 	.break_ctl =		f81232_break_ctl,
 	.set_termios =		f81232_set_termios,
 	.tiocmget =		f81232_tiocmget,
 	.tiocmset =		f81232_tiocmset,
-	.tiocmiwait =		usb_serial_generic_tiocmiwait,
-	.process_read_urb =	f81232_process_read_urb,
+	.process_read_urb = f81232_read_bulk_callback,
 	.read_int_callback =	f81232_read_int_callback,
 	.port_probe =		f81232_port_probe,
-	.port_remove =		f81232_port_remove,
+	.port_remove = f81232_port_remove,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
@@ -330,5 +681,6 @@ static struct usb_serial_driver * const serial_drivers[] = {
 module_usb_serial_driver(serial_drivers, id_table);
 
 MODULE_DESCRIPTION("Fintek F81232 USB to serial adaptor driver");
-MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@linuxfoundation.org");
+MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@linuxfoundation.org>");
+MODULE_AUTHOR("Peter Hong <peter_hong@fintek.com.tw>");
 MODULE_LICENSE("GPL v2");
-- 
1.9.1

