Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbbAJAJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:09:08 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:36856 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbAJAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:09:06 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 2/2] serial: fsl_lpuart: avoid new transfer while DMA is running
Date: Sat, 10 Jan 2015 01:08:59 +0100
Message-Id: <1420848539-4519-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420848539-4519-1-git-send-email-stefan@agner.ch>
References: <1420848539-4519-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the UART is in DMA receive mode (RDMAS set) and one character
just arrived while another interrupt is handled (e.g. TX), the RDRF
(receiver data register full flag) is set due to the water level of
1. But since the DMA will take care of this character, there is no
need to handle it by calling lpuart_prepare_rx. Handling it leads to
adding the RX timeout timer twice:

[   74.336698] Kernel BUG at 80053070 [verbose debug info unavailable]
[   74.342999] Internal error: Oops - BUG: 0 [#1] ARM0:00.00 khungtaskd
[   74.347817] Modules linked in:    0 S  0.0  0.0   0:00.00 writeback
[   74.350926] CPU: 0 PID: 0 Comm: swapper Not tainted 3.19.0-rc3-00001-g39d78e2 #1788
[   74.358617] Hardware name: Freescale Vybrid VF610 (Device Tree)t
[   74.364563] task: 807a7678 ti: 8079c000 task.ti: 8079c000 kblockd
[   74.370002] PC is at add_timer+0x24/0x28.0  0.0   0:00.09 kworker/u2:1
[   74.373960] LR is at lpuart_int+0x15c/0x3d8
[   74.378171] pc : [<80053070>]    lr : [<802e0d88>]    psr: a0010193
[   74.378171] sp : 8079de10  ip : 8079de20  fp : 8079de1c
[   74.389694] r10: 807d44c0  r9 : 8688c300  r8 : 00000013
[   74.394943] r7 : 20010193  r6 : 00000000  r5 : 000000a0  r4 : 86997210
[   74.401498] r3 : ffffa7da  r2 : 80817868  r1 : 86997210  r0 : 86997344
[   74.408052] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   74.415489] Control: 10c5387d  Table: 8611c059  DAC: 00000015
[   74.421265] Process swapper (pid: 0, stack limit = 0x8079c230)
...

Solve this by only execute the receiver path (lpuart_prepare_rx) if
the DMA receive mode (RDMAS) is not set. Also, make sure the flag is
cleared on initialization, in case it has been left set.

This can be best reproduced using UART as a serial console, then
running top while dd'ing data into the terminal.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/tty/serial/fsl_lpuart.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 29932b7..e95c497 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -755,18 +755,18 @@ out:
 static irqreturn_t lpuart_int(int irq, void *dev_id)
 {
 	struct lpuart_port *sport = dev_id;
-	unsigned char sts;
+	unsigned char sts, crdma;
 
 	sts = readb(sport->port.membase + UARTSR1);
+	crdma = readb(sport->port.membase + UARTCR5);
 
-	if (sts & UARTSR1_RDRF) {
+	if (sts & UARTSR1_RDRF && !(crdma & UARTCR5_RDMAS)) {
 		if (sport->lpuart_dma_use)
 			lpuart_prepare_rx(sport);
 		else
 			lpuart_rxint(irq, dev_id);
 	}
-	if (sts & UARTSR1_TDRE &&
-		!(readb(sport->port.membase + UARTCR5) & UARTCR5_TDMAS)) {
+	if (sts & UARTSR1_TDRE && !(crdma & UARTCR5_TDMAS)) {
 		if (sport->lpuart_dma_use)
 			lpuart_pio_tx(sport);
 		else
@@ -1106,6 +1106,7 @@ static int lpuart_startup(struct uart_port *port)
 		setup_timer(&sport->lpuart_timer, lpuart_timer_func,
 			    (unsigned long)sport);
 		temp = readb(port->membase + UARTCR5);
+		temp &= ~UARTCR5_RDMAS;
 		writeb(temp | UARTCR5_TDMAS, port->membase + UARTCR5);
 	}
 
-- 
2.2.1

