Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaHORoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:44:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:57669 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaHORnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:43:06 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/15] tty: serial: 8250_core: read only RX if there is something in the FIFO
Date: Fri, 15 Aug 2014 19:42:32 +0200
Message-Id: <1408124563-31541-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial8250_do_startup() function unconditionally clears the
interrupts and for that it reads from the RX-FIFO without checking if
there is a byte in the FIFO or not. This works fine on OMAP4+ HW like
AM335x or DRA7.
OMAP3630 ES1.1 (which means probably all OMAP3 and earlier) does not like
this:

|Unhandled fault: external abort on non-linefetch (0x1028) at 0xfb020000
|Internal error: : 1028 [#1] ARM
|Modules linked in:
|CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-00022-g7edcb57-dirty #1213
|task: de0572c0 ti: de058000 task.ti: de058000
|PC is at mem32_serial_in+0xc/0x1c
|LR is at serial8250_do_startup+0x220/0x85c
|Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
|Control: 10c5387d  Table: 80004019  DAC: 00000015
|[<c03051d4>] (mem32_serial_in) from [<c0307fe8>] (serial8250_do_startup+0x220/0x85c)
|[<c0307fe8>] (serial8250_do_startup) from [<c0309e00>] (omap_8250_startup+0x5c/0xe0)
|[<c0309e00>] (omap_8250_startup) from [<c030863c>] (serial8250_startup+0x18/0x2c)
|[<c030863c>] (serial8250_startup) from [<c030394c>] (uart_startup+0x78/0x1d8)
|[<c030394c>] (uart_startup) from [<c0304678>] (uart_open+0xe8/0x114)
|[<c0304678>] (uart_open) from [<c02e9e10>] (tty_open+0x1a8/0x5a4)

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index ae268e3..cc90c19 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2087,8 +2087,8 @@ int serial8250_do_startup(struct uart_port *port)
 	/*
 	 * Clear the interrupt registers.
 	 */
-	serial_port_in(port, UART_LSR);
-	serial_port_in(port, UART_RX);
+	if (serial_port_in(port, UART_LSR) & UART_LSR_DR)
+		serial_port_in(port, UART_RX);
 	serial_port_in(port, UART_IIR);
 	serial_port_in(port, UART_MSR);
 
@@ -2249,8 +2249,8 @@ int serial8250_do_startup(struct uart_port *port)
 	 * saved flags to avoid getting false values from polling
 	 * routines or the previous session.
 	 */
-	serial_port_in(port, UART_LSR);
-	serial_port_in(port, UART_RX);
+	if (serial_port_in(port, UART_LSR) & UART_LSR_DR)
+		serial_port_in(port, UART_RX);
 	serial_port_in(port, UART_IIR);
 	serial_port_in(port, UART_MSR);
 	up->lsr_saved_flags = 0;
@@ -2344,7 +2344,8 @@ void serial8250_do_shutdown(struct uart_port *port)
 	 * Read data port to reset things, and then unlink from
 	 * the IRQ chain.
 	 */
-	serial_port_in(port, UART_RX);
+	if (serial_port_in(port, UART_LSR) & UART_LSR_DR)
+		serial_port_in(port, UART_RX);
 	serial8250_rpm_put(up);
 
 	del_timer_sync(&up->timer);
-- 
2.0.1

