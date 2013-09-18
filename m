Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3IRPxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:53:55 -0400
Received: from lmv.inov.pt ([146.193.64.2]:55755 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3IRPxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:53:53 -0400
From: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
To: t.figa@samsung.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de, s.nawrocki@samsung.com,
        =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
Subject: [PATCH v2] serial: samsung: add support for manual RTS setting
Date: Wed, 18 Sep 2013 16:52:49 +0100
Message-Id: <1379519569-7266-1-git-send-email-jose.goncalves@inov.pt>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Samsung serial driver currently does not support setting the
RTS pin with an ioctl(TIOCMSET) call. This patch adds this support.

Changes in v2:
 - Preserve the RTS pin's manual setting  in set_termios() also when
   enabling CRTSCTS.

Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
---
 drivers/tty/serial/samsung.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index f3dfa19..401ef4f 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -407,7 +407,14 @@ static unsigned int s3c24xx_serial_get_mctrl(struct uart_port *port)
 
 static void s3c24xx_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	/* todo - possibly remove AFC and do manual CTS */
+	unsigned int umcon = rd_regl(port, S3C2410_UMCON);
+
+	if (mctrl & TIOCM_RTS)
+		umcon |= S3C2410_UMCOM_RTS_LOW;
+	else
+		umcon &= ~S3C2410_UMCOM_RTS_LOW;
+
+	wr_regl(port, S3C2410_UMCON, umcon);
 }
 
 static void s3c24xx_serial_break_ctl(struct uart_port *port, int break_state)
@@ -774,8 +781,6 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 	if (termios->c_cflag & CSTOPB)
 		ulcon |= S3C2410_LCON_STOPB;
 
-	umcon = (termios->c_cflag & CRTSCTS) ? S3C2410_UMCOM_AFC : 0;
-
 	if (termios->c_cflag & PARENB) {
 		if (termios->c_cflag & PARODD)
 			ulcon |= S3C2410_LCON_PODD;
@@ -792,6 +797,15 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 
 	wr_regl(port, S3C2410_ULCON, ulcon);
 	wr_regl(port, S3C2410_UBRDIV, quot);
+
+	umcon = rd_regl(port, S3C2410_UMCON);
+	if (termios->c_cflag & CRTSCTS) {
+		umcon |= S3C2410_UMCOM_AFC;
+		/* Disable RTS when RX FIFO contains 63 bytes */
+		umcon &= ~S3C2412_UMCON_AFC_8;
+	} else {
+		umcon &= ~S3C2410_UMCOM_AFC;
+	}
 	wr_regl(port, S3C2410_UMCON, umcon);
 
 	if (ourport->info->has_divslot)
-- 
1.7.10.4

