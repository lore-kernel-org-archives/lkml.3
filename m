Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaIXQre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:49692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaIXQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749880"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 25/27] tty: serial: omap: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:15 +0530
Message-Id: <1411575342-31048-26-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/tty/serial/omap-serial.c |   60 ++++++++++++-------------------------
 1 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d017cec..83a50ca 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -290,8 +290,7 @@ static void serial_omap_enable_ms(struct uart_port *port)
 	pm_runtime_get_sync(up->dev);
 	up->ier |= UART_IER_MSI;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_stop_tx(struct uart_port *port)
@@ -352,8 +351,7 @@ static void serial_omap_stop_tx(struct uart_port *port)
 		serial_out(up, UART_IER, up->ier);
 	}
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_stop_rx(struct uart_port *port)
@@ -364,8 +362,7 @@ static void serial_omap_stop_rx(struct uart_port *port)
 	up->ier &= ~(UART_IER_RLSI | UART_IER_RDI);
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
@@ -434,8 +431,7 @@ static void serial_omap_start_tx(struct uart_port *port)
 		serial_omap_stop_rx(port);
 
 	serial_omap_enable_ier_thri(up);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_throttle(struct uart_port *port)
@@ -448,8 +444,7 @@ static void serial_omap_throttle(struct uart_port *port)
 	up->ier &= ~(UART_IER_RLSI | UART_IER_RDI);
 	serial_out(up, UART_IER, up->ier);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_unthrottle(struct uart_port *port)
@@ -462,8 +457,7 @@ static void serial_omap_unthrottle(struct uart_port *port)
 	up->ier |= UART_IER_RLSI | UART_IER_RDI;
 	serial_out(up, UART_IER, up->ier);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static unsigned int check_modem_status(struct uart_omap_port *up)
@@ -616,8 +610,7 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 
 	tty_flip_buffer_push(&up->port.state->port);
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	up->port_activity = jiffies;
 
 	return ret;
@@ -634,8 +627,7 @@ static unsigned int serial_omap_tx_empty(struct uart_port *port)
 	spin_lock_irqsave(&up->port.lock, flags);
 	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	return ret;
 }
 
@@ -647,8 +639,7 @@ static unsigned int serial_omap_get_mctrl(struct uart_port *port)
 
 	pm_runtime_get_sync(up->dev);
 	status = check_modem_status(up);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 
 	dev_dbg(up->port.dev, "serial_omap_get_mctrl+%d\n", up->port.line);
 
@@ -686,8 +677,7 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 		     UART_MCR_DTR | UART_MCR_RTS);
 	up->mcr = old_mcr | mcr;
 	serial_out(up, UART_MCR, up->mcr);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
@@ -704,8 +694,7 @@ static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 		up->lcr &= ~UART_LCR_SBC;
 	serial_out(up, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static int serial_omap_startup(struct uart_port *port)
@@ -781,8 +770,7 @@ static int serial_omap_startup(struct uart_port *port)
 
 	serial_out(up, UART_OMAP_WER, up->wer);
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	up->port_activity = jiffies;
 	return 0;
 }
@@ -818,8 +806,7 @@ static void serial_omap_shutdown(struct uart_port *port)
 	if (serial_in(up, UART_LSR) & UART_LSR_DR)
 		(void) serial_in(up, UART_RX);
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	free_irq(up->port.irq, up);
 	if (up->wakeirq)
 		free_irq(up->wakeirq, up);
@@ -1088,8 +1075,7 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_omap_set_mctrl(&up->port, up->port.mctrl);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->port.line);
 }
 
@@ -1120,8 +1106,7 @@ serial_omap_pm(struct uart_port *port, unsigned int state,
 			pm_runtime_allow(up->dev);
 	}
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static void serial_omap_release_port(struct uart_port *port)
@@ -1204,8 +1189,7 @@ static void serial_omap_poll_put_char(struct uart_port *port, unsigned char ch)
 	pm_runtime_get_sync(up->dev);
 	wait_for_xmitr(up);
 	serial_out(up, UART_TX, ch);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static int serial_omap_poll_get_char(struct uart_port *port)
@@ -1223,8 +1207,7 @@ static int serial_omap_poll_get_char(struct uart_port *port)
 	status = serial_in(up, UART_RX);
 
 out:
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 
 	return status;
 }
@@ -1288,8 +1271,7 @@ serial_omap_console_write(struct console *co, const char *s,
 	if (up->msr_saved_flags)
 		check_modem_status(up);
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	if (locked)
 		spin_unlock(&up->port.lock);
 	local_irq_restore(flags);
@@ -1387,8 +1369,7 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	}
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 }
 
 static int
@@ -1724,8 +1705,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (ret != 0)
 		goto err_add_port;
 
-	pm_runtime_mark_last_busy(up->dev);
-	pm_runtime_put_autosuspend(up->dev);
+	pm_runtime_last_busy_and_autosuspend(up->dev);
 	return 0;
 
 err_add_port:
-- 
1.7.0.4

