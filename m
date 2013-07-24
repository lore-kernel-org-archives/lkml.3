Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3GXSis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:38:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44529 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3GXShg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Subject: [PATCH 3/4] msm_serial: Make baud_code detection more dynamic
Date: Wed, 24 Jul 2013 11:37:30 -0700
Message-Id: <1374691051-28544-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently msm_set_baud_rate() assumes the uart clock rate is
1.8432 MHz. This is not always true, and limits our options to
program the baud rate. Instead of assuming the rate and
hard-coding the baud_code based on it, calculate the divider that
we want and try to find the closest baud_code that matches. This
allows us to support uarts with faster clock speeds.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 98 ++++++++++++++++++-----------------------
 drivers/tty/serial/msm_serial.h | 18 ++------
 2 files changed, 48 insertions(+), 68 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index cab4105..cef8f40 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -322,70 +322,60 @@ static void msm_break_ctl(struct uart_port *port, int break_ctl)
 		msm_write(port, UART_CR_CMD_STOP_BREAK, UART_CR);
 }
 
+struct msm_baud_map {
+	u16	divisor;
+	u8	code;
+	u8	rxstale;
+};
+
+static const struct msm_baud_map *
+msm_find_best_baud(struct uart_port *port, unsigned int baud)
+{
+	unsigned int i, divisor;
+	const struct msm_baud_map *entry;
+	static const struct msm_baud_map table[] = {
+		{ 1536, 0x00,  1 },
+		{  768, 0x11,  1 },
+		{  384, 0x22,  1 },
+		{  192, 0x33,  1 },
+		{   96, 0x44,  1 },
+		{   48, 0x55,  1 },
+		{   32, 0x66,  1 },
+		{   24, 0x77,  1 },
+		{   16, 0x88,  1 },
+		{   12, 0x99,  6 },
+		{    8, 0xaa,  6 },
+		{    6, 0xbb,  6 },
+		{    4, 0xcc,  6 },
+		{    3, 0xdd,  8 },
+		{    2, 0xee, 16 },
+		{    1, 0xff, 31 },
+	};
+
+	divisor = uart_get_divisor(port, baud);
+
+	for (i = 0, entry = table; i < ARRAY_SIZE(table); i++, entry++)
+		if (entry->divisor <= divisor)
+			break;
+
+	return entry; /* Default to smallest divider */
+}
+
 static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 {
-	unsigned int baud_code, rxstale, watermark;
+	unsigned int rxstale, watermark;
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	const struct msm_baud_map *entry;
 
-	switch (baud) {
-	case 300:
-		baud_code = UART_CSR_300;
-		rxstale = 1;
-		break;
-	case 600:
-		baud_code = UART_CSR_600;
-		rxstale = 1;
-		break;
-	case 1200:
-		baud_code = UART_CSR_1200;
-		rxstale = 1;
-		break;
-	case 2400:
-		baud_code = UART_CSR_2400;
-		rxstale = 1;
-		break;
-	case 4800:
-		baud_code = UART_CSR_4800;
-		rxstale = 1;
-		break;
-	case 9600:
-		baud_code = UART_CSR_9600;
-		rxstale = 2;
-		break;
-	case 14400:
-		baud_code = UART_CSR_14400;
-		rxstale = 3;
-		break;
-	case 19200:
-		baud_code = UART_CSR_19200;
-		rxstale = 4;
-		break;
-	case 28800:
-		baud_code = UART_CSR_28800;
-		rxstale = 6;
-		break;
-	case 38400:
-		baud_code = UART_CSR_38400;
-		rxstale = 8;
-		break;
-	case 57600:
-		baud_code = UART_CSR_57600;
-		rxstale = 16;
-		break;
-	case 115200:
-	default:
-		baud_code = UART_CSR_115200;
-		baud = 115200;
-		rxstale = 31;
-		break;
-	}
+	entry = msm_find_best_baud(port, baud);
 
 	if (msm_port->is_uartdm)
 		msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
 
-	msm_write(port, baud_code, UART_CSR);
+	msm_write(port, entry->code, UART_CSR);
 
 	/* RX stale watermark */
+	rxstale = entry->rxstale;
 	watermark = UART_IPR_STALE_LSB & rxstale;
 	watermark |= UART_IPR_RXSTALE_LAST;
 	watermark |= UART_IPR_STALE_TIMEOUT_MSB & (rxstale << 2);
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index 15c186e..469fda5 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -38,19 +38,7 @@
 #define UART_MR2_PARITY_MODE_SPACE	0x3
 #define UART_MR2_PARITY_MODE		0x3
 
-#define UART_CSR	0x0008
-#define UART_CSR_115200	0xFF
-#define UART_CSR_57600	0xEE
-#define UART_CSR_38400	0xDD
-#define UART_CSR_28800	0xCC
-#define UART_CSR_19200	0xBB
-#define UART_CSR_14400	0xAA
-#define UART_CSR_9600	0x99
-#define UART_CSR_4800	0x77
-#define UART_CSR_2400	0x55
-#define UART_CSR_1200	0x44
-#define UART_CSR_600	0x33
-#define UART_CSR_300	0x22
+#define UART_CSR			0x0008
 
 #define UART_TF		0x000C
 #define UARTDM_TF	0x0070
@@ -152,6 +140,7 @@ static inline void msm_serial_set_mnd_regs_tcxo(struct uart_port *port)
 	msm_write(port, 0xF1, UART_NREG);
 	msm_write(port, 0x0F, UART_DREG);
 	msm_write(port, 0x1A, UART_MNDREG);
+	port->uartclk = 1843200;
 }
 
 /*
@@ -163,6 +152,7 @@ static inline void msm_serial_set_mnd_regs_tcxoby4(struct uart_port *port)
 	msm_write(port, 0xF6, UART_NREG);
 	msm_write(port, 0x0F, UART_DREG);
 	msm_write(port, 0x0A, UART_MNDREG);
+	port->uartclk = 1843200;
 }
 
 static inline
@@ -170,7 +160,7 @@ void msm_serial_set_mnd_regs_from_uartclk(struct uart_port *port)
 {
 	if (port->uartclk == 19200000)
 		msm_serial_set_mnd_regs_tcxo(port);
-	else
+	else if (port->uartclk == 4800000)
 		msm_serial_set_mnd_regs_tcxoby4(port);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

