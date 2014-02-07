Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaBGLzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:55:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaBGLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Roszko <mark.roszko@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 227/233] tty/serial: at91: Handle shutdown more safely
Date: Fri,  7 Feb 2014 11:47:26 +0000
Message-Id: <1391773652-25214-228-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Roszko <mark.roszko@gmail.com>

commit 0cc7c6c7916b1b6f34350ff1473b80b9f7e459c0 upstream.

Interrupts were being cleaned up late in the shutdown handler, it is possible
that an interrupt can occur and schedule a tasklet that runs after the port is
cleaned up. There is a null dereference due to this race condition with the
following stacktrace:

[<c02092b0>] (atmel_tasklet_func+0x514/0x814) from [<c001fd34>] (tasklet_action+0x70/0xa8)
[<c001fd34>] (tasklet_action+0x70/0xa8) from [<c001f60c>] (__do_softirq+0x90/0x144)
[<c001f60c>] (__do_softirq+0x90/0x144) from [<c001fa18>] (irq_exit+0x40/0x4c)
[<c001fa18>] (irq_exit+0x40/0x4c) from [<c000e298>] (handle_IRQ+0x64/0x84)
[<c000e298>] (handle_IRQ+0x64/0x84) from [<c000d6c0>] (__irq_svc+0x40/0x50)
[<c000d6c0>] (__irq_svc+0x40/0x50) from [<c0208060>] (atmel_rx_dma_release+0x88/0xb8)
[<c0208060>] (atmel_rx_dma_release+0x88/0xb8) from [<c0209740>] (atmel_shutdown+0x104/0x160)
[<c0209740>] (atmel_shutdown+0x104/0x160) from [<c0205e8c>] (uart_port_shutdown+0x2c/0x38)

Signed-off-by: Marek Roszko <mark.roszko@gmail.com>
Acked-by: Leilei Zhao <leilei.zhao@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/atmel_serial.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 691265f..b70276d 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1022,12 +1022,24 @@ static int atmel_startup(struct uart_port *port)
 static void atmel_shutdown(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
 	/*
-	 * Ensure everything is stopped.
+	 * Clear out any scheduled tasklets before
+	 * we destroy the buffers
+	 */
+	tasklet_kill(&atmel_port->tasklet);
+
+	/*
+	 * Ensure everything is stopped and
+	 * disable all interrupts, port and break condition.
 	 */
 	atmel_stop_rx(port);
 	atmel_stop_tx(port);
 
+	UART_PUT_CR(port, ATMEL_US_RSTSTA);
+	UART_PUT_IDR(port, -1);
+
+
 	/*
 	 * Shut-down the DMA.
 	 */
@@ -1054,12 +1066,6 @@ static void atmel_shutdown(struct uart_port *port)
 	}
 
 	/*
-	 * Disable all interrupts, port and break condition.
-	 */
-	UART_PUT_CR(port, ATMEL_US_RSTSTA);
-	UART_PUT_IDR(port, -1);
-
-	/*
 	 * Free the interrupt
 	 */
 	free_irq(port->irq, port);
-- 
1.8.3.2

