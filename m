Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3CSJwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:20 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:64137 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3CSJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZfiWyKITs
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZfiWyKITs
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18789992"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 7/9] staging/sb105x: use tty_port
Date: Tue, 19 Mar 2013 10:51:28 +0100
Message-Id: <1363686690-27090-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct tty_port wherever is needed, fixing compilation errors.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c   |   18 +++++++++++-------
 drivers/staging/sb105x/sb_ser_core.h |    1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 7fa6ef7..deeeed2 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -878,7 +878,7 @@ static int mp_set_info(struct sb_uart_state *state, struct serial_struct *newinf
 	state->closing_wait    = closing_wait;
 	port->fifosize         = new_serial.xmit_fifo_size;
 	if (state->info->tty)
-		state->info->tty->low_latency =
+		port->tty_port.low_latency =
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
@@ -1323,6 +1323,7 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 	mp_shutdown(state);
 	mp_flush_buffer(tty);
 	tty_ldisc_flush(tty);
+	tty_port_close(&state->port->tty_port, tty, filp);
 	tty->closing = 0;
 	state->info->tty = NULL;
 
@@ -1525,7 +1526,7 @@ static int mp_open(struct tty_struct *tty, struct file *filp)
 	mtpt  = (struct mp_port *)state->port;
 
 	tty->driver_data = state;
-	tty->low_latency = (state->port->flags & UPF_LOW_LATENCY) ? 1 : 0;
+	state->port->tty_port.low_latency = (state->port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 	tty->alt_speed = 0;
 	state->info->tty = tty;
 
@@ -1553,6 +1554,7 @@ static int mp_open(struct tty_struct *tty, struct file *filp)
 
 	uart_clear_mctrl(state->port, TIOCM_RTS);
 	try_module_get(THIS_MODULE);
+	retval = tty_port_open(&state->port->tty_port, tty, filp);
 fail:
 	return retval;
 }
@@ -1784,7 +1786,9 @@ static int mp_add_one_port(struct uart_driver *drv, struct sb_uart_port *port)
 
 	mp_configure_port(drv, state, port);
 
-	tty_register_device(drv->tty_driver, port->line, port->dev);
+	tty_port_init(&port->tty_port);
+//	port->tty_port.ops = &mp_tty_port_ops; /* XXX: Need to define tty_port ops */
+	tty_port_register_device(&port->tty_port, port->info->tty->driver, port->line, port->dev);
 
 out:
 	MP_MUTEX_UNLOCK(mp_mutex);
@@ -1804,6 +1808,7 @@ static int mp_remove_one_port(struct uart_driver *drv, struct sb_uart_port *port
 	MP_MUTEX_LOCK(mp_mutex);
 
 	tty_unregister_device(drv->tty_driver, port->line);
+	tty_port_destroy(&port->tty_port);
 
 	mp_unconfigure_port(drv, state);
 	state->port = NULL;
@@ -2009,7 +2014,6 @@ static void multi_enable_ms(struct sb_uart_port *port)
 
 static inline void receive_chars(struct mp_port *mtpt, int *status )
 {
-	struct tty_struct *tty = mtpt->port.info->tty;
 	unsigned char lsr = *status;
 	int max_count = 256;
 	unsigned char ch;
@@ -2044,17 +2048,17 @@ static inline void receive_chars(struct mp_port *mtpt, int *status )
 					mtpt->port.icount.overrun++;
 					flag = TTY_OVERRUN;
 				}
-				tty_insert_flip_char(tty, ch, flag);
+				tty_insert_flip_char(&mtpt->port.tty_port, ch, flag);
 			} else {
 				ch = serial_inp(mtpt, UART_RX);
-				tty_insert_flip_char(tty, ch, 0);
+				tty_insert_flip_char(&mtpt->port.tty_port, ch, 0);
 			}
 		}
 ignore_char:
 		lsr = serial_inp(mtpt, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 
-	tty_flip_buffer_push(tty);
+	tty_flip_buffer_push(&mtpt->port.tty_port);
 }
 
 
diff --git a/drivers/staging/sb105x/sb_ser_core.h b/drivers/staging/sb105x/sb_ser_core.h
index 41111b0..90de931 100644
--- a/drivers/staging/sb105x/sb_ser_core.h
+++ b/drivers/staging/sb105x/sb_ser_core.h
@@ -143,6 +143,7 @@ struct sb_uart_port {
 	struct device		*dev;			/* parent device */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		unused[3];
+	struct tty_port         tty_port;
 };
 
 #define mdmode			unused[2]
-- 
1.7.10.4

