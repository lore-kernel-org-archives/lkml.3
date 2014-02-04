Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935767AbaBDWTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:19:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbaBDVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Roszko <mark.roszko@gmail.com>,
        Leilei Zhao <leilei.zhao@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.12 055/133] tty/serial: at91: Handle shutdown more safely
Date: Tue,  4 Feb 2014 13:07:36 -0800
Message-Id: <20140204210738.588516155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/atmel_serial.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1633,12 +1633,24 @@ static int atmel_startup(struct uart_por
 static void atmel_shutdown(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
+	/*
+	 * Clear out any scheduled tasklets before
+	 * we destroy the buffers
+	 */
+	tasklet_kill(&atmel_port->tasklet);
+
 	/*
-	 * Ensure everything is stopped.
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
@@ -1648,12 +1660,6 @@ static void atmel_shutdown(struct uart_p
 		atmel_port->release_tx(port);
 
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


