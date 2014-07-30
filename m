Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaG3Mnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:43:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36628 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qipan Li <Qipan.Li@csr.com>,
        Barry Song <Baohua.Song@csr.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/94] serial: sirf: fix spinlock deadlock issue
Date: Wed, 30 Jul 2014 14:13:52 +0200
Message-Id: <67aedbd928624d9e7e44c531ae3e2f18f099eb3f.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qipan Li <Qipan.Li@csr.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 07d410e06463f3c1c106e2bb2a7ff23eff1e71c9 upstream.

commit fb78b811422cd2d8c8605949cc4cc13618347ad5 provide a workaround for
kernel panic, but bring potential deadlock risk. that is in
sirfsoc_rx_tmo_process_tl while enter into sirfsoc_uart_pio_rx_chars
cpu hold uart_port->lock, if uart interrupt comes cpu enter into
sirfsoc_uart_isr and deadlock occurs in getting uart_port->lock.

the patch replace spin_lock version to spin_lock_irq* version to avoid
spinlock dead lock issue. let function tty_flip_buffer_push in tasklet
outof spin_lock_irq* protect area to avoid add the pair of spin_lock and
spin_unlock for tty_flip_buffer_push.
BTW drop self defined unused spinlock protect of tx_lock/rx_lock.

56274.220464] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
[56274.223648]  lock: 0xc05d9db0, .magic: dead4ead, .owner: swapper/0/0,
	.owner_cpu: 0
	[56274.231278] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G
	O 3.10.35 #1
	[56274.238241] [<c0015530>] (unwind_backtrace+0x0/0xf4) from
	[<c00120d8>] (show_stack+0x10/0x14)
	[56274.246742] [<c00120d8>] (show_stack+0x10/0x14) from
	[<c01b11b0>] (do_raw_spin_lock+0x110/0x184)
	[56274.255501] [<c01b11b0>] (do_raw_spin_lock+0x110/0x184) from
	[<c02124c8>] (sirfsoc_uart_isr+0x20/0x42c)
	[56274.264874] [<c02124c8>] (sirfsoc_uart_isr+0x20/0x42c) from
	[<c0075790>] (handle_irq_event_percpu+0x54/0x17c)
	[56274.274758] [<c0075790>] (handle_irq_event_percpu+0x54/0x17c)
	from [<c00758f4>] (handle_irq_event+0x3c/0x5c)
	[56274.284561] [<c00758f4>] (handle_irq_event+0x3c/0x5c) from
	[<c0077fa0>] (handle_level_irq+0x98/0xfc)
	[56274.293670] [<c0077fa0>] (handle_level_irq+0x98/0xfc) from
	[<c0074f44>] (generic_handle_irq+0x2c/0x3c)
	[56274.302952] [<c0074f44>] (generic_handle_irq+0x2c/0x3c) from
	[<c000ef80>] (handle_IRQ+0x40/0x90)
	[56274.311706] [<c000ef80>] (handle_IRQ+0x40/0x90) from
	[<c000dc80>] (__irq_svc+0x40/0x70)
	[56274.319697] [<c000dc80>] (__irq_svc+0x40/0x70) from
	[<c038113c>] (_raw_spin_unlock_irqrestore+0x10/0x48)
	[56274.329158] [<c038113c>]
	(_raw_spin_unlock_irqrestore+0x10/0x48) from [<c0200034>]
	(tty_port_tty_get+0x58/0x90)
	[56274.339213] [<c0200034>] (tty_port_tty_get+0x58/0x90) from
	[<c0212008>] (sirfsoc_uart_pio_rx_chars+0x1c/0xc8)
	[56274.349097] [<c0212008>]
	(sirfsoc_uart_pio_rx_chars+0x1c/0xc8) from [<c0212ef8>]
	(sirfsoc_rx_tmo_process_tl+0xe4/0x1fc)
	[56274.359853] [<c0212ef8>]
	(sirfsoc_rx_tmo_process_tl+0xe4/0x1fc) from [<c0027c04>]
	(tasklet_action+0x84/0x114)
	[56274.369739] [<c0027c04>] (tasklet_action+0x84/0x114) from
	[<c0027db4>] (__do_softirq+0x120/0x200)
	[56274.378585] [<c0027db4>] (__do_softirq+0x120/0x200) from
	[<c0027f44>] (do_softirq+0x54/0x5c)
	[56274.386998] [<c0027f44>] (do_softirq+0x54/0x5c) from
	[<c00281ec>] (irq_exit+0x9c/0xd0)
	[56274.394899] [<c00281ec>] (irq_exit+0x9c/0xd0) from
	[<c000ef84>] (handle_IRQ+0x44/0x90)
	[56274.402790] [<c000ef84>] (handle_IRQ+0x44/0x90) from
	[<c000dc80>] (__irq_svc+0x40/0x70)
	[56274.410774] [<c000dc80>] (__irq_svc+0x40/0x70) from
	[<c0288af4>] (cpuidle_enter_state+0x50/0xe0)
	[56274.419532] [<c0288af4>] (cpuidle_enter_state+0x50/0xe0) from
	[<c0288c34>] (cpuidle_idle_call+0xb0/0x148)
	[56274.429080] [<c0288c34>] (cpuidle_idle_call+0xb0/0x148) from
	[<c000f3ac>] (arch_cpu_idle+0x8/0x38)
	[56274.438016] [<c000f3ac>] (arch_cpu_idle+0x8/0x38) from
	[<c0059344>] (cpu_startup_entry+0xfc/0x140)
	[56274.446956] [<c0059344>] (cpu_startup_entry+0xfc/0x140) from
	[<c04a3a54>] (start_kernel+0x2d8/0x2e4)

Signed-off-by: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/sirfsoc_uart.c | 49 ++++++++++++++-------------------------
 drivers/tty/serial/sirfsoc_uart.h |  2 --
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index 6904818d3424..ef61908cf9c3 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -359,9 +359,11 @@ static irqreturn_t sirfsoc_uart_usp_cts_handler(int irq, void *dev_id)
 {
 	struct sirfsoc_uart_port *sirfport = (struct sirfsoc_uart_port *)dev_id;
 	struct uart_port *port = &sirfport->port;
+	spin_lock(&port->lock);
 	if (gpio_is_valid(sirfport->cts_gpio) && sirfport->ms_enabled)
 		uart_handle_cts_change(port,
 				!gpio_get_value(sirfport->cts_gpio));
+	spin_unlock(&port->lock);
 	return IRQ_HANDLED;
 }
 
@@ -429,10 +431,6 @@ sirfsoc_uart_pio_rx_chars(struct uart_port *port, unsigned int max_rx_count)
 	sirfport->rx_io_count += rx_count;
 	port->icount.rx += rx_count;
 
-	spin_unlock(&port->lock);
-	tty_flip_buffer_push(&port->state->port);
-	spin_lock(&port->lock);
-
 	return rx_count;
 }
 
@@ -466,6 +464,7 @@ static void sirfsoc_uart_tx_dma_complete_callback(void *param)
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned long flags;
 
+	spin_lock_irqsave(&port->lock, flags);
 	xmit->tail = (xmit->tail + sirfport->transfer_size) &
 				(UART_XMIT_SIZE - 1);
 	port->icount.tx += sirfport->transfer_size;
@@ -474,10 +473,9 @@ static void sirfsoc_uart_tx_dma_complete_callback(void *param)
 	if (sirfport->tx_dma_addr)
 		dma_unmap_single(port->dev, sirfport->tx_dma_addr,
 				sirfport->transfer_size, DMA_TO_DEVICE);
-	spin_lock_irqsave(&sirfport->tx_lock, flags);
 	sirfport->tx_dma_state = TX_DMA_IDLE;
 	sirfsoc_uart_tx_with_dma(sirfport);
-	spin_unlock_irqrestore(&sirfport->tx_lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void sirfsoc_uart_insert_rx_buf_to_tty(
@@ -490,7 +488,6 @@ static void sirfsoc_uart_insert_rx_buf_to_tty(
 	inserted = tty_insert_flip_string(tport,
 		sirfport->rx_dma_items[sirfport->rx_completed].xmit.buf, count);
 	port->icount.rx += inserted;
-	tty_flip_buffer_push(tport);
 }
 
 static void sirfsoc_rx_submit_one_dma_desc(struct uart_port *port, int index)
@@ -525,7 +522,7 @@ static void sirfsoc_rx_tmo_process_tl(unsigned long param)
 	unsigned int count;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sirfport->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 	while (sirfport->rx_completed != sirfport->rx_issued) {
 		sirfsoc_uart_insert_rx_buf_to_tty(sirfport,
 					SIRFSOC_RX_DMA_BUF_SIZE);
@@ -540,12 +537,8 @@ static void sirfsoc_rx_tmo_process_tl(unsigned long param)
 	wr_regl(port, ureg->sirfsoc_rx_dma_io_ctrl,
 			rd_regl(port, ureg->sirfsoc_rx_dma_io_ctrl) |
 			SIRFUART_IO_MODE);
-	spin_unlock_irqrestore(&sirfport->rx_lock, flags);
-	spin_lock(&port->lock);
 	sirfsoc_uart_pio_rx_chars(port, 4 - sirfport->rx_io_count);
-	spin_unlock(&port->lock);
 	if (sirfport->rx_io_count == 4) {
-		spin_lock_irqsave(&sirfport->rx_lock, flags);
 		sirfport->rx_io_count = 0;
 		wr_regl(port, ureg->sirfsoc_int_st_reg,
 				uint_st->sirfsoc_rx_done);
@@ -556,11 +549,8 @@ static void sirfsoc_rx_tmo_process_tl(unsigned long param)
 		else
 			wr_regl(port, SIRFUART_INT_EN_CLR,
 					uint_en->sirfsoc_rx_done_en);
-		spin_unlock_irqrestore(&sirfport->rx_lock, flags);
-
 		sirfsoc_uart_start_next_rx_dma(port);
 	} else {
-		spin_lock_irqsave(&sirfport->rx_lock, flags);
 		wr_regl(port, ureg->sirfsoc_int_st_reg,
 				uint_st->sirfsoc_rx_done);
 		if (!sirfport->is_marco)
@@ -570,8 +560,9 @@ static void sirfsoc_rx_tmo_process_tl(unsigned long param)
 		else
 			wr_regl(port, ureg->sirfsoc_int_en_reg,
 					uint_en->sirfsoc_rx_done_en);
-		spin_unlock_irqrestore(&sirfport->rx_lock, flags);
 	}
+	spin_unlock_irqrestore(&port->lock, flags);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void sirfsoc_uart_handle_rx_tmo(struct sirfsoc_uart_port *sirfport)
@@ -580,8 +571,6 @@ static void sirfsoc_uart_handle_rx_tmo(struct sirfsoc_uart_port *sirfport)
 	struct sirfsoc_register *ureg = &sirfport->uart_reg->uart_reg;
 	struct sirfsoc_int_en *uint_en = &sirfport->uart_reg->uart_int_en;
 	struct dma_tx_state tx_state;
-	spin_lock(&sirfport->rx_lock);
-
 	dmaengine_tx_status(sirfport->rx_dma_chan,
 		sirfport->rx_dma_items[sirfport->rx_issued].cookie, &tx_state);
 	dmaengine_terminate_all(sirfport->rx_dma_chan);
@@ -594,7 +583,6 @@ static void sirfsoc_uart_handle_rx_tmo(struct sirfsoc_uart_port *sirfport)
 	else
 		wr_regl(port, SIRFUART_INT_EN_CLR,
 				uint_en->sirfsoc_rx_timeout_en);
-	spin_unlock(&sirfport->rx_lock);
 	tasklet_schedule(&sirfport->rx_tmo_process_tasklet);
 }
 
@@ -658,7 +646,6 @@ static irqreturn_t sirfsoc_uart_isr(int irq, void *dev_id)
 		intr_status &= port->read_status_mask;
 		uart_insert_char(port, intr_status,
 					uint_en->sirfsoc_rx_oflow_en, 0, flag);
-		tty_flip_buffer_push(&state->port);
 	}
 recv_char:
 	if ((sirfport->uart_reg->uart_type == SIRF_REAL_UART) &&
@@ -683,6 +670,9 @@ recv_char:
 			sirfsoc_uart_pio_rx_chars(port,
 					SIRFSOC_UART_IO_RX_MAX_CNT);
 	}
+	spin_unlock(&port->lock);
+	tty_flip_buffer_push(&state->port);
+	spin_lock(&port->lock);
 	if (intr_status & uint_st->sirfsoc_txfifo_empty) {
 		if (IS_DMA_CHAN_VALID(sirfport->tx_dma_no))
 			sirfsoc_uart_tx_with_dma(sirfport);
@@ -701,6 +691,7 @@ recv_char:
 		}
 	}
 	spin_unlock(&port->lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -709,24 +700,27 @@ static void sirfsoc_uart_rx_dma_complete_tl(unsigned long param)
 	struct sirfsoc_uart_port *sirfport = (struct sirfsoc_uart_port *)param;
 	struct uart_port *port = &sirfport->port;
 	unsigned long flags;
-	spin_lock_irqsave(&sirfport->rx_lock, flags);
+	spin_lock_irqsave(&port->rx_lock, flags);
 	while (sirfport->rx_completed != sirfport->rx_issued) {
 		sirfsoc_uart_insert_rx_buf_to_tty(sirfport,
 					SIRFSOC_RX_DMA_BUF_SIZE);
 		sirfsoc_rx_submit_one_dma_desc(port, sirfport->rx_completed++);
 		sirfport->rx_completed %= SIRFSOC_RX_LOOP_BUF_CNT;
 	}
-	spin_unlock_irqrestore(&sirfport->rx_lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+	tty_flip_buffer_push(&port->state->port);
 }
 
 static void sirfsoc_uart_rx_dma_complete_callback(void *param)
 {
 	struct sirfsoc_uart_port *sirfport = (struct sirfsoc_uart_port *)param;
-	spin_lock(&sirfport->rx_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sirfport->port.lock, flags);
 	sirfport->rx_issued++;
 	sirfport->rx_issued %= SIRFSOC_RX_LOOP_BUF_CNT;
-	spin_unlock(&sirfport->rx_lock);
 	tasklet_schedule(&sirfport->rx_dma_complete_tasklet);
+	spin_unlock_irqrestore(&sirfport->port.lock, flags);
 }
 
 /* submit rx dma task into dmaengine */
@@ -735,18 +729,14 @@ static void sirfsoc_uart_start_next_rx_dma(struct uart_port *port)
 	struct sirfsoc_uart_port *sirfport = to_sirfport(port);
 	struct sirfsoc_register *ureg = &sirfport->uart_reg->uart_reg;
 	struct sirfsoc_int_en *uint_en = &sirfport->uart_reg->uart_int_en;
-	unsigned long flags;
 	int i;
-	spin_lock_irqsave(&sirfport->rx_lock, flags);
 	sirfport->rx_io_count = 0;
 	wr_regl(port, ureg->sirfsoc_rx_dma_io_ctrl,
 		rd_regl(port, ureg->sirfsoc_rx_dma_io_ctrl) &
 		~SIRFUART_IO_MODE);
-	spin_unlock_irqrestore(&sirfport->rx_lock, flags);
 	for (i = 0; i < SIRFSOC_RX_LOOP_BUF_CNT; i++)
 		sirfsoc_rx_submit_one_dma_desc(port, i);
 	sirfport->rx_completed = sirfport->rx_issued = 0;
-	spin_lock_irqsave(&sirfport->rx_lock, flags);
 	if (!sirfport->is_marco)
 		wr_regl(port, ureg->sirfsoc_int_en_reg,
 				rd_regl(port, ureg->sirfsoc_int_en_reg) |
@@ -754,7 +744,6 @@ static void sirfsoc_uart_start_next_rx_dma(struct uart_port *port)
 	else
 		wr_regl(port, ureg->sirfsoc_int_en_reg,
 			SIRFUART_RX_DMA_INT_EN(port, uint_en));
-	spin_unlock_irqrestore(&sirfport->rx_lock, flags);
 }
 
 static void sirfsoc_uart_start_rx(struct uart_port *port)
@@ -1455,8 +1444,6 @@ usp_no_flow_control:
 		ret = -EFAULT;
 		goto err;
 	}
-	spin_lock_init(&sirfport->rx_lock);
-	spin_lock_init(&sirfport->tx_lock);
 	tasklet_init(&sirfport->rx_dma_complete_tasklet,
 			sirfsoc_uart_rx_dma_complete_tl, (unsigned long)sirfport);
 	tasklet_init(&sirfport->rx_tmo_process_tasklet,
diff --git a/drivers/tty/serial/sirfsoc_uart.h b/drivers/tty/serial/sirfsoc_uart.h
index fb8d0a002607..38cb159138f1 100644
--- a/drivers/tty/serial/sirfsoc_uart.h
+++ b/drivers/tty/serial/sirfsoc_uart.h
@@ -438,8 +438,6 @@ struct sirfsoc_uart_port {
 	struct dma_chan			*tx_dma_chan;
 	dma_addr_t			tx_dma_addr;
 	struct dma_async_tx_descriptor	*tx_dma_desc;
-	spinlock_t			rx_lock;
-	spinlock_t			tx_lock;
 	struct tasklet_struct		rx_dma_complete_tasklet;
 	struct tasklet_struct		rx_tmo_process_tasklet;
 	unsigned int			rx_io_count;
-- 
2.0.1

