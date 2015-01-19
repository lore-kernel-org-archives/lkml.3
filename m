Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbbASNeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:34:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbASNeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:34:03 -0500
From: Colin King <colin.king@canonical.com>
To: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][V2] drivers/usb/serial/mos7840.c: remove unused code
Date: Mon, 19 Jan 2015 13:32:58 +0000
Message-Id: <1421674378-14451-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is old, unused code that is #defined out by the
use of NOTMOS7840 and NOTMCS7840 - these are not
defined anywhere.

If NOTMOS7840 is defined then the code will break on null
pointer dereferences on mos7840_port.  So the code is
currently unused, and broken anyway, so why not just
remove it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/usb/serial/mos7840.c | 60 --------------------------------------------
 1 file changed, 60 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 220b4be..e4473a9 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1309,35 +1309,6 @@ static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 	const unsigned char *current_position = data;
 	unsigned char *data1;
 
-#ifdef NOTMOS7840
-	Data = 0x00;
-	status = mos7840_get_uart_reg(port, LINE_CONTROL_REGISTER, &Data);
-	mos7840_port->shadowLCR = Data;
-	dev_dbg(&port->dev, "%s: LINE_CONTROL_REGISTER is %x\n", __func__, Data);
-	dev_dbg(&port->dev, "%s: mos7840_port->shadowLCR is %x\n", __func__, mos7840_port->shadowLCR);
-
-	/* Data = 0x03; */
-	/* status = mos7840_set_uart_reg(port,LINE_CONTROL_REGISTER,Data); */
-	/* mos7840_port->shadowLCR=Data;//Need to add later */
-
-	Data |= SERIAL_LCR_DLAB;	/* data latch enable in LCR 0x80 */
-	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
-
-	/* Data = 0x0c; */
-	/* status = mos7840_set_uart_reg(port,DIVISOR_LATCH_LSB,Data); */
-	Data = 0x00;
-	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_LSB, &Data);
-	dev_dbg(&port->dev, "%s: DLL value is %x\n", __func__, Data);
-
-	Data = 0x0;
-	status = mos7840_get_uart_reg(port, DIVISOR_LATCH_MSB, &Data);
-	dev_dbg(&port->dev, "%s: DLM value is %x\n", __func__, Data);
-
-	Data = Data & ~SERIAL_LCR_DLAB;
-	dev_dbg(&port->dev, "%s: mos7840_port->shadowLCR is %x\n", __func__, mos7840_port->shadowLCR);
-	status = mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER, Data);
-#endif
-
 	if (mos7840_port_paranoia_check(port, __func__))
 		return -1;
 
@@ -1614,37 +1585,6 @@ static int mos7840_calc_baud_rate_divisor(struct usb_serial_port *port,
 		*clk_sel_val = 0x70;
 	}
 	return 0;
-
-#ifdef NOTMCS7840
-
-	for (i = 0; i < ARRAY_SIZE(mos7840_divisor_table); i++) {
-		if (mos7840_divisor_table[i].BaudRate == baudrate) {
-			*divisor = mos7840_divisor_table[i].Divisor;
-			return 0;
-		}
-	}
-
-	/* After trying for all the standard baud rates    *
-	 * Try calculating the divisor for this baud rate  */
-
-	if (baudrate > 75 && baudrate < 230400) {
-		/* get the divisor */
-		custom = (__u16) (230400L / baudrate);
-
-		/* Check for round off */
-		round1 = (__u16) (2304000L / baudrate);
-		round = (__u16) (round1 - (custom * 10));
-		if (round > 4)
-			custom++;
-		*divisor = custom;
-
-		dev_dbg(&port->dev, " Baud %d = %d\n", baudrate, custom);
-		return 0;
-	}
-
-	dev_dbg(&port->dev, "%s", " Baud calculation Failed...\n");
-	return -1;
-#endif
 }
 
 /*****************************************************************************
-- 
2.1.4

