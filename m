Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaEZT1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:27:01 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63010 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbaEZT1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:27:00 -0400
Message-ID: <1401132417.6068.26.camel@x220>
Subject: [PATCH] staging: lirc: remove checks for CONFIG_LIRC_SERIAL_NSLU2
From: Paul Bolle <pebolle@tiscali.nl>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:26:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:26:58.0284 (UTC) FILETIME=[75FEC2C0:01CF7918]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When support for homebrew serial port receivers was added in v2.6.36 its
code contained checks for CONFIG_LIRC_SERIAL_NSLU2. The related Kconfig
symbol didn't exist then. It still doesn't exist now. Remove these checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Done on top of next-20140526.

I left the "#define LIRC_NSLU2" line alone.

 drivers/staging/media/lirc/lirc_serial.c | 81 --------------------------------
 1 file changed, 81 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index dc5ba43116c7..efe561cd0935 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -73,9 +73,6 @@
 #include <linux/fcntl.h>
 #include <linux/spinlock.h>
 
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-#include <asm/hardware.h>
-#endif
 /* From Intel IXP42X Developer's Manual (#252480-005): */
 /* ftp://download.intel.com/design/network/manuals/25248005.pdf */
 #define UART_IE_IXP42X_UUE   0x40 /* IXP42X UART Unit enable */
@@ -198,33 +195,6 @@ static struct lirc_serial hardware[] = {
 		.features    = LIRC_CAN_REC_MODE2
 #endif
 	},
-
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	/*
-	 * Modified Linksys Network Storage Link USB 2.0 (NSLU2):
-	 * We receive on CTS of the 2nd serial port (R142,LHS), we
-	 * transmit with a IR diode between GPIO[1] (green status LED),
-	 * and ground (Matthias Goebl <matthias.goebl@goebl.net>).
-	 * See also http://www.nslu2-linux.org for this device
-	 */
-	[LIRC_NSLU2] = {
-		.lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_NSLU2].lock),
-		.signal_pin        = UART_MSR_CTS,
-		.signal_pin_change = UART_MSR_DCTS,
-		.on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
-		.off = (UART_MCR_RTS | UART_MCR_OUT2),
-		.send_pulse = send_pulse_homebrew,
-		.send_space = send_space_homebrew,
-#ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
-		.features    = (LIRC_CAN_SET_SEND_DUTY_CYCLE |
-				LIRC_CAN_SET_SEND_CARRIER |
-				LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2)
-#else
-		.features    = LIRC_CAN_REC_MODE2
-#endif
-	},
-#endif
-
 };
 
 #define RS_ISR_PASS_LIMIT 256
@@ -315,16 +285,6 @@ static void soutp(int offset, u8 value)
 
 static void on(void)
 {
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	/*
-	 * On NSLU2, we put the transmit diode between the output of the green
-	 * status LED and ground
-	 */
-	if (type == LIRC_NSLU2) {
-		gpio_set_value(NSLU2_LED_GRN, 0);
-		return;
-	}
-#endif
 	if (txsense)
 		soutp(UART_MCR, hardware[type].off);
 	else
@@ -333,12 +293,6 @@ static void on(void)
 
 static void off(void)
 {
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	if (type == LIRC_NSLU2) {
-		gpio_set_value(NSLU2_LED_GRN, 1);
-		return;
-	}
-#endif
 	if (txsense)
 		soutp(UART_MCR, hardware[type].on);
 	else
@@ -793,20 +747,6 @@ static int hardware_init_port(void)
 	sinp(UART_IIR);
 	sinp(UART_MSR);
 
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	if (type == LIRC_NSLU2) {
-		/* Setup NSLU2 UART */
-
-		/* Enable UART */
-		soutp(UART_IER, sinp(UART_IER) | UART_IE_IXP42X_UUE);
-		/* Disable Receiver data Time out interrupt */
-		soutp(UART_IER, sinp(UART_IER) & ~UART_IE_IXP42X_RTOIE);
-		/* set out2 = interrupt unmask; off() doesn't set MCR
-		   on NSLU2 */
-		soutp(UART_MCR, UART_MCR_RTS|UART_MCR_OUT2);
-	}
-#endif
-
 	/* Set line for power source */
 	off();
 
@@ -842,16 +782,6 @@ static int lirc_serial_probe(struct platform_device *dev)
 {
 	int i, nlow, nhigh, result;
 
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	/* This GPIO is used for a LED on the NSLU2 */
-	result = devm_gpio_request(dev, NSLU2_LED_GRN, "lirc-serial");
-	if (result)
-		return result;
-	result = gpio_direction_output(NSLU2_LED_GRN, 0);
-	if (result)
-		return result;
-#endif
-
 	result = request_irq(irq, lirc_irq_handler,
 			     (share_irq ? IRQF_SHARED : 0),
 			     LIRC_DRIVER_NAME, (void *)&hardware);
@@ -1217,14 +1147,6 @@ static int __init lirc_serial_init_module(void)
 		io = io ? io : 0x3f8;
 		irq = irq ? irq : 4;
 		break;
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-	case LIRC_NSLU2:
-		io = io ? io : IRQ_IXP4XX_UART2;
-		irq = irq ? irq : (IXP4XX_UART2_BASE_VIRT + REG_OFFSET);
-		iommap = iommap ? iommap : IXP4XX_UART2_BASE_PHYS;
-		ioshift = ioshift ? ioshift : 2;
-		break;
-#endif
 	default:
 		return -EINVAL;
 	}
@@ -1232,9 +1154,6 @@ static int __init lirc_serial_init_module(void)
 		switch (type) {
 		case LIRC_HOMEBREW:
 		case LIRC_IGOR:
-#ifdef CONFIG_LIRC_SERIAL_NSLU2
-		case LIRC_NSLU2:
-#endif
 			hardware[type].features &=
 				~(LIRC_CAN_SET_SEND_DUTY_CYCLE|
 				  LIRC_CAN_SET_SEND_CARRIER);
-- 
1.9.0

