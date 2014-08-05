Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaHEXxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:53:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51123 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaHEXxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:53:34 -0400
Message-ID: <53E16E7C.8050302@codeaurora.org>
Date: Tue, 05 Aug 2014 16:53:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [request for help] tty: serial: kgdb: fix msm_serial for kgdb
References: <53E02C7C.4090206@gmail.com> <53E03475.6070007@codeaurora.org> <53E03CEC.3060108@gmail.com> <53E12F04.3000509@codeaurora.org>
In-Reply-To: <53E12F04.3000509@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/14 12:22, Stephen Boyd wrote:
>
> I tried it and it doesn't work either. Typing lots of characters finally
> unjams it like you see on 1.4 hardware.
>

Can you try this? It seems to work for me on both 1.3 and 1.4 hardware

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 72000a6d5af0..fbcb0c657d5f 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -680,17 +680,6 @@ static void msm_power(struct uart_port *port, unsigned int state,
 }
 
 #ifdef CONFIG_CONSOLE_POLL
-static int msm_poll_init(struct uart_port *port)
-{
-	struct msm_port *msm_port = UART_TO_MSM(port);
-
-	/* Enable single character mode on RX FIFO */
-	if (msm_port->is_uartdm >= UARTDM_1P4)
-		msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN);
-
-	return 0;
-}
-
 static int msm_poll_get_char_single(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -702,7 +691,7 @@ static int msm_poll_get_char_single(struct uart_port *port)
 		return msm_read(port, rf_reg) & 0xff;
 }
 
-static int msm_poll_get_char_dm_1p3(struct uart_port *port)
+static int msm_poll_get_char_dm(struct uart_port *port)
 {
 	int c;
 	static u32 slop;
@@ -726,6 +715,9 @@ static int msm_poll_get_char_dm_1p3(struct uart_port *port)
 			slop = msm_read(port, UARTDM_RF);
 			c = sp[0];
 			count--;
+			msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+			msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+			msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
 		} else {
 			c = NO_POLL_CHAR;
 		}
@@ -749,8 +741,8 @@ static int msm_poll_get_char(struct uart_port *port)
 	imr = msm_read(port, UART_IMR);
 	msm_write(port, 0, UART_IMR);
 
-	if (msm_port->is_uartdm == UARTDM_1P3)
-		c = msm_poll_get_char_dm_1p3(port);
+	if (msm_port->is_uartdm)
+		c = msm_poll_get_char_dm(port);
 	else
 		c = msm_poll_get_char_single(port);
 
@@ -809,7 +801,6 @@ static struct uart_ops msm_uart_pops = {
 	.verify_port = msm_verify_port,
 	.pm = msm_power,
 #ifdef CONFIG_CONSOLE_POLL
-	.poll_init = msm_poll_init,
 	.poll_get_char	= msm_poll_get_char,
 	.poll_put_char	= msm_poll_put_char,
 #endif


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

