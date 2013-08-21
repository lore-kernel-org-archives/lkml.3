Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3HUGth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:49:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41276 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3HUGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:48:12 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 5/5] msm_serial: Send more than 1 character on the console w/ UARTDM
Date: Tue, 20 Aug 2013 23:48:06 -0700
Message-Id: <1377067686-31957-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
References: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently added support to send more than one character at a
time for UARTDM hardware but we didn't add the same support in
the console code path. Add support here to speed up console
messages on UARTDM hardware.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 59 +++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 2094eb5..128b222 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -761,32 +761,63 @@ static inline struct uart_port *get_port_from_line(unsigned int line)
 }
 
 #ifdef CONFIG_SERIAL_MSM_CONSOLE
-
-static void msm_console_putchar(struct uart_port *port, int c)
-{
-	struct msm_port *msm_port = UART_TO_MSM(port);
-
-	if (msm_port->is_uartdm)
-		reset_dm_count(port, 1);
-
-	while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
-		;
-	msm_write(port, c, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
-}
-
 static void msm_console_write(struct console *co, const char *s,
 			      unsigned int count)
 {
+	int i;
 	struct uart_port *port;
 	struct msm_port *msm_port;
+	int num_newlines = 0;
+	bool replaced = false;
 
 	BUG_ON(co->index < 0 || co->index >= UART_NR);
 
 	port = get_port_from_line(co->index);
 	msm_port = UART_TO_MSM(port);
 
+	/* Account for newlines that will get a carriage return added */
+	for (i = 0; i < count; i++)
+		if (s[i] == '\n')
+			num_newlines++;
+	count += num_newlines;
+
 	spin_lock(&port->lock);
-	uart_console_write(port, s, count, msm_console_putchar);
+	if (msm_port->is_uartdm)
+		reset_dm_count(port, count);
+
+	i = 0;
+	while (i < count) {
+		int j;
+		unsigned int num_chars;
+		char buf[4] = { 0 };
+		unsigned int *bf = (unsigned int *)&buf;
+
+		if (msm_port->is_uartdm)
+			num_chars = min(count - i, (unsigned int)sizeof(buf));
+		else
+			num_chars = 1;
+
+		for (j = 0; j < num_chars; j++) {
+			char c = *s;
+
+			if (c == '\n' && !replaced) {
+				buf[j] = '\r';
+				j++;
+				replaced = true;
+			}
+			if (j < num_chars) {
+				buf[j] = c;
+				s++;
+				replaced = false;
+			}
+		}
+
+		while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
+			cpu_relax();
+
+		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
+		i += num_chars;
+	}
 	spin_unlock(&port->lock);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

