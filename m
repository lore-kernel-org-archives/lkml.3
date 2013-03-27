Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3C0JiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:38:17 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39345 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3C0JiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:38:13 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 18:38:11 +0900
X-Google-Sender-Auth: G4cIrqAXsVf1QHwj8D3me9t5wwY
Message-ID: <CAOAMb1AcBprsZ1RpA3XDjUC6hAZMrbBcmvVJk7oryeMsPcJy1A@mail.gmail.com>
Subject: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling.
From: Chanho Min <chanho.min@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In DMA support, The received data is not pushed to tty until the DMA buffer
is filled. But some megabyte rate chips such as BT expect fast response and
data should be pushed immediately. In order to fix this issue, We suggest
the use of the timer for polling DMA buffer.
In our test, no data loss occurred at high-baudrate as compared with interrupt-
driven (We tested with 3Mbps).
We changes:

- We add timer for polling. If we set poll_timer to 10, every 10ms,
 timer handler checks the residue in the dma buffer and transfer data
 to the tty. Also, last_residue is updated for the next polling.

- poll_timeout is used to prevent the timer's system cost.
  If poll_timeout is set to 3000 and no data is received in 3 seconds,
  we inactivate poll timer and driver falls back to interrupt-driven.
  When data is received again in FIFO and UART irq is occurred, we switch
  back to DMA mode and start polling.

- We use consistent DMA mappings to avoid from the frequent cache operation
  of the timer function for default.

- pl011_dma_rx_chars is modified. the pending size is recalculated because
  data can be taken by polling.

- the polling time is adjusted if dma rx poll is enabled but no rate is
  specified. Ideal polling interval to push 1 character at every interval
  is the reciprocal of 'baud rate / 10 line bits per character / 1000 ms
  per sec'. But It is very aggressive to system. Experimentally,
 '10000000 / baud' is suitable to receive dozens of characters. the poll rate
 can be specified statically by dma_rx_poll_rate of the platform data as well.

Changes compared to v1:
 - Use of consistent DMA mappings.
 - Added dma_rx_poll_rate in platform data to specify the polling interval.
 - Added dma_rx_poll_timeout in platform data to specify the polling timeout.

Changes compared to v2:
 - Use of consistent DMA mappings for default.
 - Added dma_rx_poll_enable in platform data to adjust the polling time
   according to the baud rate.
 - remove unnecessary lock from the polling function.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/tty/serial/amba-pl011.c |  157 ++++++++++++++++++++++++++++++++++-----
 include/linux/amba/serial.h     |    3 +
 2 files changed, 141 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3ea5408..3b093b5 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -29,6 +29,7 @@
  * and hooked into this driver.
  */

+
 #if defined(CONFIG_SERIAL_AMBA_PL011_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
 #endif
@@ -117,6 +118,12 @@ struct pl011_dmarx_data {
 	struct pl011_sgbuf	sgbuf_b;
 	dma_cookie_t		cookie;
 	bool			running;
+	struct timer_list	timer;
+	unsigned int last_residue;
+	unsigned long last_jiffies;
+	bool auto_poll_rate;
+	unsigned int poll_rate;
+	unsigned int poll_timeout;
 };

 struct pl011_dmatx_data {
@@ -223,16 +230,18 @@ static int pl011_fifo_to_tty(struct uart_amba_port *uap)
 static int pl011_sgbuf_init(struct dma_chan *chan, struct pl011_sgbuf *sg,
 	enum dma_data_direction dir)
 {
-	sg->buf = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
+	dma_addr_t dma_addr;
+
+	sg->buf = dma_alloc_coherent(chan->device->dev,
+		PL011_DMA_BUFFER_SIZE, &dma_addr, GFP_KERNEL);
 	if (!sg->buf)
 		return -ENOMEM;

-	sg_init_one(&sg->sg, sg->buf, PL011_DMA_BUFFER_SIZE);
+	sg_init_table(&sg->sg, 1);
+	sg_set_page(&sg->sg, phys_to_page(dma_addr),
+		PL011_DMA_BUFFER_SIZE, offset_in_page(dma_addr));
+	sg_dma_address(&sg->sg) = dma_addr;

-	if (dma_map_sg(chan->device->dev, &sg->sg, 1, dir) != 1) {
-		kfree(sg->buf);
-		return -EINVAL;
-	}
 	return 0;
 }

@@ -240,8 +249,9 @@ static void pl011_sgbuf_free(struct dma_chan
*chan, struct pl011_sgbuf *sg,
 	enum dma_data_direction dir)
 {
 	if (sg->buf) {
-		dma_unmap_sg(chan->device->dev, &sg->sg, 1, dir);
-		kfree(sg->buf);
+		dma_free_coherent(chan->device->dev,
+			PL011_DMA_BUFFER_SIZE, sg->buf,
+			sg_dma_address(&sg->sg));
 	}
 }

@@ -300,6 +310,29 @@ static void pl011_dma_probe_initcall(struct
uart_amba_port *uap)
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;

+		if (plat->dma_rx_poll_enable) {
+			/* Set poll rate if specified. */
+			if (plat->dma_rx_poll_rate) {
+				uap->dmarx.auto_poll_rate = false;
+				uap->dmarx.poll_rate = plat->dma_rx_poll_rate;
+			} else {
+				/*
+				 * 100 ms defaults to poll rate if not
+				 * specified. This will be adjusted with
+				 * the baud rate at set_termios.
+				 */
+				uap->dmarx.auto_poll_rate = true;
+				uap->dmarx.poll_rate =  100;
+			}
+			/* 3 secs defaults poll_timeout if not specified. */
+			if (plat->dma_rx_poll_timeout)
+				uap->dmarx.poll_timeout =
+					plat->dma_rx_poll_timeout;
+			else
+				uap->dmarx.poll_timeout = 3000;
+		} else
+			uap->dmarx.auto_poll_rate = false;
+
 		dev_info(uap->port.dev, "DMA channel RX %s\n",
 			 dma_chan_name(uap->dmarx.chan));
 	}
@@ -701,24 +734,30 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 	struct tty_port *port = &uap->port.state->port;
 	struct pl011_sgbuf *sgbuf = use_buf_b ?
 		&uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
-	struct device *dev = uap->dmarx.chan->device->dev;
 	int dma_count = 0;
 	u32 fifotaken = 0; /* only used for vdbg() */

-	/* Pick everything from the DMA first */
+	struct pl011_dmarx_data *dmarx = &uap->dmarx;
+	int dmataken = 0;
+
+	if (uap->dmarx.poll_rate) {
+		/* The data can be taken by polling */
+		dmataken = sgbuf->sg.length - dmarx->last_residue;
+		/* Recalculate the pending size */
+		if (pending >= dmataken)
+			pending -= dmataken;
+	}
+
+	/* Pick the remain data from the DMA */
 	if (pending) {
-		/* Sync in buffer */
-		dma_sync_sg_for_cpu(dev, &sgbuf->sg, 1, DMA_FROM_DEVICE);

 		/*
 		 * First take all chars in the DMA pipe, then look in the FIFO.
 		 * Note that tty_insert_flip_buf() tries to take as many chars
 		 * as it can.
 		 */
-		dma_count = tty_insert_flip_string(port, sgbuf->buf, pending);
-
-		/* Return buffer to device */
-		dma_sync_sg_for_device(dev, &sgbuf->sg, 1, DMA_FROM_DEVICE);
+		dma_count = tty_insert_flip_string(port, sgbuf->buf + dmataken,
+				pending);

 		uap->port.icount.rx += dma_count;
 		if (dma_count < pending)
@@ -726,6 +765,10 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 				 "couldn't insert all characters (TTY is full?)\n");
 	}

+	/* Reset the last_residue for Rx DMA poll */
+	if (uap->dmarx.poll_rate)
+		dmarx->last_residue = sgbuf->sg.length;
+
 	/*
 	 * Only continue with trying to read the FIFO if all DMA chars have
 	 * been taken first.
@@ -865,6 +908,57 @@ static inline void pl011_dma_rx_stop(struct
uart_amba_port *uap)
 	writew(uap->dmacr, uap->port.membase + UART011_DMACR);
 }

+/*
+ * Timer handler for Rx DMA polling.
+ * Every polling, It checks the residue in the dma buffer and transfer
+ * data to the tty. Also, last_residue is updated for the next polling.
+ */
+static void pl011_dma_rx_poll(unsigned long args)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)args;
+	struct tty_port *port = &uap->port.state->port;
+	struct pl011_dmarx_data *dmarx = &uap->dmarx;
+	struct dma_chan *rxchan = uap->dmarx.chan;
+	unsigned long flags = 0;
+	unsigned int dmataken = 0;
+	unsigned int size = 0;
+	struct pl011_sgbuf *sgbuf;
+	int dma_count;
+	struct dma_tx_state state;
+
+	sgbuf = dmarx->use_buf_b ? &uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
+	rxchan->device->device_tx_status(rxchan, dmarx->cookie, &state);
+	if (likely(state.residue < dmarx->last_residue)) {
+		dmataken = sgbuf->sg.length - dmarx->last_residue;
+		size = dmarx->last_residue - state.residue;
+		dma_count = tty_insert_flip_string(port, sgbuf->buf + dmataken,
+				size);
+		if (dma_count == size)
+			dmarx->last_residue =  state.residue;
+		dmarx->last_jiffies = jiffies;
+	}
+	tty_flip_buffer_push(port);
+
+	/*
+	 * If no data is received in poll_timeout, the driver will fall back
+	 * to interrupt mode. We will retrigger DMA at the first interrupt.
+	 */
+	if (jiffies_to_msecs(jiffies - dmarx->last_jiffies)
+			> uap->dmarx.poll_timeout) {
+
+		spin_lock_irqsave(&uap->port.lock, flags);
+		pl011_dma_rx_stop(uap);
+		spin_unlock_irqrestore(&uap->port.lock, flags);
+
+		uap->dmarx.running = false;
+		dmaengine_terminate_all(rxchan);
+		del_timer(&uap->dmarx.timer);
+	} else {
+		mod_timer(&uap->dmarx.timer,
+			jiffies + msecs_to_jiffies(uap->dmarx.poll_rate));
+	}
+}
+
 static void pl011_dma_startup(struct uart_amba_port *uap)
 {
 	int ret;
@@ -927,6 +1021,16 @@ skip_rx:
 		if (pl011_dma_rx_trigger_dma(uap))
 			dev_dbg(uap->port.dev, "could not trigger initial "
 				"RX DMA job, fall back to interrupt mode\n");
+		if (uap->dmarx.poll_rate) {
+			init_timer(&(uap->dmarx.timer));
+			uap->dmarx.timer.function = pl011_dma_rx_poll;
+			uap->dmarx.timer.data = (unsigned long)uap;
+			mod_timer(&uap->dmarx.timer,
+				jiffies +
+				msecs_to_jiffies(uap->dmarx.poll_rate));
+			uap->dmarx.last_residue = PL011_DMA_BUFFER_SIZE;
+			uap->dmarx.last_jiffies = jiffies;
+		}
 	}
 }

@@ -962,6 +1066,8 @@ static void pl011_dma_shutdown(struct uart_amba_port *uap)
 		/* Clean up the RX DMA */
 		pl011_sgbuf_free(uap->dmarx.chan, &uap->dmarx.sgbuf_a, DMA_FROM_DEVICE);
 		pl011_sgbuf_free(uap->dmarx.chan, &uap->dmarx.sgbuf_b, DMA_FROM_DEVICE);
+		if (uap->dmarx.poll_rate)
+			del_timer_sync(&uap->dmarx.timer);
 		uap->using_rx_dma = false;
 	}
 }
@@ -976,7 +1082,6 @@ static inline bool pl011_dma_rx_running(struct
uart_amba_port *uap)
 	return uap->using_rx_dma && uap->dmarx.running;
 }

-
 #else
 /* Blank functions if the DMA engine is not available */
 static inline void pl011_dma_probe(struct uart_amba_port *uap)
@@ -1088,8 +1193,18 @@ static void pl011_rx_chars(struct uart_amba_port *uap)
 			dev_dbg(uap->port.dev, "could not trigger RX DMA job "
 				"fall back to interrupt mode again\n");
 			uap->im |= UART011_RXIM;
-		} else
+		} else {
 			uap->im &= ~UART011_RXIM;
+			/* Start Rx DMA poll */
+			if (uap->dmarx.poll_rate) {
+				uap->dmarx.last_jiffies = jiffies;
+				uap->dmarx.last_residue	= PL011_DMA_BUFFER_SIZE;
+				mod_timer(&uap->dmarx.timer,
+					jiffies +
+					msecs_to_jiffies(uap->dmarx.poll_rate));
+			}
+		}
+
 		writew(uap->im, uap->port.membase + UART011_IMSC);
 	}
 	spin_lock(&uap->port.lock);
@@ -1164,7 +1279,6 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 	unsigned int dummy_read;

 	spin_lock_irqsave(&uap->port.lock, flags);
-
 	status = readw(uap->port.membase + UART011_MIS);
 	if (status) {
 		do {
@@ -1551,6 +1665,11 @@ pl011_set_termios(struct uart_port *port,
struct ktermios *termios,
 	 */
 	baud = uart_get_baud_rate(port, termios, old, 0,
 				  port->uartclk / clkdiv);
+	/*
+	 * Adjust RX DMA polling rate with baud rate if not specified.
+	 */
+	if (uap->dmarx.auto_poll_rate)
+		uap->dmarx.poll_rate = DIV_ROUND_UP(10000000, baud);

 	if (baud > port->uartclk/16)
 		quot = DIV_ROUND_CLOSEST(port->uartclk * 8, baud);
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index f612c78..62d9303 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -203,6 +203,9 @@ struct amba_pl011_data {
 	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
 	void *dma_rx_param;
 	void *dma_tx_param;
+	bool dma_rx_poll_enable;
+	unsigned int dma_rx_poll_rate;
+	unsigned int dma_rx_poll_timeout;
         void (*init) (void);
 	void (*exit) (void);
 };
-- 
1.7.9.5
