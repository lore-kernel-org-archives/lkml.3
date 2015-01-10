Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbbAJAJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:09:10 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:36855 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbbAJAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:09:06 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 1/2] serial: fsl_lpuart: delete timer on shutdown
Date: Sat, 10 Jan 2015 01:08:58 +0100
Message-Id: <1420848539-4519-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420848539-4519-1-git-send-email-stefan@agner.ch>
References: <1420848539-4519-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the serial port gets closed while a RX transfer is in progress,
the timer might fire after the serial port shutdown finished. This
leads in a NULL pointer dereference:

[    7.508324] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    7.516590] pgd = 86348000
[    7.519445] [00000000] *pgd=86179831, *pte=00000000, *ppte=00000000
[    7.526145] Internal error: Oops: 17 [#1] ARM
[    7.530611] Modules linked in:
[    7.533876] CPU: 0 PID: 123 Comm: systemd Not tainted 3.19.0-rc3-00004-g5b11ea7 #1778
[    7.541827] Hardware name: Freescale Vybrid VF610 (Device Tree)
[    7.547862] task: 861c3400 ti: 86ac8000 task.ti: 86ac8000
[    7.553392] PC is at lpuart_timer_func+0x24/0xf8
[    7.558127] LR is at lpuart_timer_func+0x20/0xf8
[    7.562857] pc : [<802df99c>]    lr : [<802df998>]    psr: 600b0113
[    7.562857] sp : 86ac9b90  ip : 86ac9b90  fp : 86ac9bbc
[    7.574467] r10: 80817180  r9 : 80817b98  r8 : 80817998
[    7.579803] r7 : 807acee0  r6 : 86989000  r5 : 00000100  r4 : 86997210
[    7.586444] r3 : 86ac8000  r2 : 86ac9bc0  r1 : 86997210  r0 : 00000000
[    7.593085] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    7.600341] Control: 10c5387d  Table: 86348059  DAC: 00000015
[    7.606203] Process systemd (pid: 123, stack limit = 0x86ac8230)

Setup the timer on UART startup which allows to delete the timer
unconditionally on shutdown. This also saves the initialization
on each transfer.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/tty/serial/fsl_lpuart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index e7cde3a..29932b7 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -506,9 +506,6 @@ static inline void lpuart_prepare_rx(struct lpuart_port *sport)
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
-	init_timer(&sport->lpuart_timer);
-	sport->lpuart_timer.function = lpuart_timer_func;
-	sport->lpuart_timer.data = (unsigned long)sport;
 	sport->lpuart_timer.expires = jiffies + sport->dma_rx_timeout;
 	add_timer(&sport->lpuart_timer);
 
@@ -1106,6 +1103,8 @@ static int lpuart_startup(struct uart_port *port)
 		sport->lpuart_dma_use = false;
 	} else {
 		sport->lpuart_dma_use = true;
+		setup_timer(&sport->lpuart_timer, lpuart_timer_func,
+			    (unsigned long)sport);
 		temp = readb(port->membase + UARTCR5);
 		writeb(temp | UARTCR5_TDMAS, port->membase + UARTCR5);
 	}
@@ -1180,6 +1179,8 @@ static void lpuart_shutdown(struct uart_port *port)
 	devm_free_irq(port->dev, port->irq, sport);
 
 	if (sport->lpuart_dma_use) {
+		del_timer_sync(&sport->lpuart_timer);
+
 		lpuart_dma_tx_free(port);
 		lpuart_dma_rx_free(port);
 	}
-- 
2.2.1

