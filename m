Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaAGKpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:45:38 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:40329 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaAGKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:45:36 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: Leilei Zhao <leilei.zhao@atmel.com>, <mark.roszko@gmail.com>,
        <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <stable@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/4] tty/serial: at91: Handle shutdown more safely
Date: Tue, 7 Jan 2014 11:45:06 +0100
Message-ID: <dc7afa0aaab583d94211069f3696168f67efbcf3.1389090437.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1389090437.git.nicolas.ferre@atmel.com>
References: <cover.1389090437.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Roszko <mark.roszko@gmail.com>

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
Cc: <stable@vger.kernel.org> # v3.12
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c7d99af46a96..48ea47a32d5f 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1650,12 +1650,24 @@ static int atmel_startup(struct uart_port *port)
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
@@ -1665,12 +1677,6 @@ static void atmel_shutdown(struct uart_port *port)
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
-- 
1.8.2.2

