Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3AVMus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:50:48 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:42556 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3AVMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1BS6gvezeSrUTNJ--gGxCRL17AO8PHJ_eLrxzjOex7w1g@mail.gmail.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
	<20130114002608.GV23505@n2100.arm.linux.org.uk>
	<CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
	<CAOAMb1BgcvBb6KHaZbwbh0rq8r1WfAtdCeZJexfaYoOwGfU7Sg@mail.gmail.com>
	<CAOAMb1BS6gvezeSrUTNJ--gGxCRL17AO8PHJ_eLrxzjOex7w1g@mail.gmail.com>
Date: Tue, 22 Jan 2013 21:45:41 +0900
X-Google-Sender-Auth: _1_7mCY0NslQqBuynuzXMODPjwc
Message-ID: <CAOAMb1C=b2fXqKJKx1ZR7UD7n=c7qQoLnMgMmy2FXEubyP=dtw@mail.gmail.com>
Subject: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Chanho Min <chanho0207@gmail.com>
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

- If poll timer is activated, We use consistent DMA mappings to avoid from
  the frequent cache operation of the timer function. sg->coherency is used
  to check if buffer is coherent.

- pl011_dma_rx_chars is modified. the pending size is recalculated because
  data can be taken by polling.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/tty/serial/amba-pl011.c |  160 ++++++++++++++++++++++++++++++++++-----
 include/linux/amba/serial.h     |    2 +
 2 files changed, 145 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7fca402..0bcd5b5 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -107,6 +107,7 @@ static struct uart_amba_port *amba_ports[UART_NR];
 struct pl011_sgbuf {
 	struct scatterlist sg;
 	char *buf;
+	bool coherency;
 };

 struct pl011_dmarx_data {
@@ -117,6 +118,11 @@ struct pl011_dmarx_data {
 	struct pl011_sgbuf	sgbuf_b;
 	dma_cookie_t		cookie;
 	bool			running;
+	struct timer_list	timer;
+	unsigned int last_residue;
+	unsigned long  last_jiffies;
+	unsigned int poll_rate;
+	unsigned int poll_timeout;
 };

 struct pl011_dmatx_data {
@@ -223,15 +229,29 @@ static int pl011_fifo_to_tty(struct uart_amba_port *uap)
 static int pl011_sgbuf_init(struct dma_chan *chan, struct pl011_sgbuf *sg,
 	enum dma_data_direction dir)
 {
-	sg->buf = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
-	if (!sg->buf)
-		return -ENOMEM;
+	if (sg->coherency) {
+		dma_addr_t dma_addr;

-	sg_init_one(&sg->sg, sg->buf, PL011_DMA_BUFFER_SIZE);
+		sg->buf = dma_alloc_coherent(chan->device->dev,
+			PL011_DMA_BUFFER_SIZE, &dma_addr, GFP_KERNEL);
+		if (!sg->buf)
+			return -ENOMEM;

-	if (dma_map_sg(chan->device->dev, &sg->sg, 1, dir) != 1) {
-		kfree(sg->buf);
-		return -EINVAL;
+		sg_init_table(&sg->sg, 1);
+		sg_set_page(&sg->sg, phys_to_page(dma_addr),
+			PL011_DMA_BUFFER_SIZE, offset_in_page(dma_addr));
+		sg_dma_address(&sg->sg) = dma_addr;
+	} else {
+		sg->buf = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
+		if (!sg->buf)
+			return -ENOMEM;
+
+		sg_init_one(&sg->sg, sg->buf, PL011_DMA_BUFFER_SIZE);
+
+		if (dma_map_sg(chan->device->dev, &sg->sg, 1, dir) != 1) {
+			kfree(sg->buf);
+			return -EINVAL;
+		}
 	}
 	return 0;
 }
@@ -240,8 +260,14 @@ static void pl011_sgbuf_free(struct dma_chan
*chan, struct pl011_sgbuf *sg,
 	enum dma_data_direction dir)
 {
 	if (sg->buf) {
-		dma_unmap_sg(chan->device->dev, &sg->sg, 1, dir);
-		kfree(sg->buf);
+		if (sg->coherency)
+			dma_free_coherent(chan->device->dev,
+				PL011_DMA_BUFFER_SIZE, sg->buf,
+				sg_dma_address(&sg->sg));
+		else {
+			dma_unmap_sg(chan->device->dev, &sg->sg, 1, dir);
+			kfree(sg->buf);
+		}
 	}
 }

@@ -300,6 +326,9 @@ static void pl011_dma_probe_initcall(struct
uart_amba_port *uap)
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;

+		uap->dmarx.poll_rate = plat->dma_rx_poll_rate;
+		uap->dmarx.poll_timeout = plat->dma_rx_poll_timeout;
+
 		dev_info(uap->port.dev, "DMA channel RX %s\n",
 			 dma_chan_name(uap->dmarx.chan));
 	}
@@ -705,10 +734,23 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
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
+		if (pending > dmataken)
+			pending -= dmataken;
+	}
+
+	/* Pick the remain data from the DMA */
 	if (pending) {
-		/* Sync in buffer */
-		dma_sync_sg_for_cpu(dev, &sgbuf->sg, 1, DMA_FROM_DEVICE);
+		/* Sync in buffer for non-coherent DMA */
+		if (!sgbuf->coherency)
+			dma_sync_sg_for_cpu(dev, &sgbuf->sg, 1,
+				DMA_FROM_DEVICE);

 		/*
 		 * First take all chars in the DMA pipe, then look in the FIFO.
@@ -716,10 +758,12 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 		 * as it can.
 		 */
 		dma_count = tty_insert_flip_string(uap->port.state->port.tty,
-						   sgbuf->buf, pending);
+					   sgbuf->buf + dmataken, pending);

-		/* Return buffer to device */
-		dma_sync_sg_for_device(dev, &sgbuf->sg, 1, DMA_FROM_DEVICE);
+		/* Return buffer to device for non-coherent DMA */
+		if (!sgbuf->coherency)
+			dma_sync_sg_for_device(dev, &sgbuf->sg, 1,
+				DMA_FROM_DEVICE);

 		uap->port.icount.rx += dma_count;
 		if (dma_count < pending)
@@ -727,6 +771,10 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 				 "couldn't insert all characters (TTY is full?)\n");
 	}

+	/* Reset the last_residue for Rx DMA poll */
+	if (uap->dmarx.poll_rate)
+		dmarx->last_residue = sgbuf->sg.length;
+
 	/*
 	 * Only continue with trying to read the FIFO if all DMA chars have
 	 * been taken first.
@@ -866,6 +914,59 @@ static inline void pl011_dma_rx_stop(struct
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
+	struct pl011_dmarx_data *dmarx = &uap->dmarx;
+	struct dma_chan *rxchan = uap->dmarx.chan;
+	unsigned long flags = 0;
+	unsigned int dmataken = 0;
+	unsigned int size = 0;
+	struct pl011_sgbuf *sgbuf;
+	int dma_count;
+	struct dma_tx_state state;
+
+	spin_lock(&uap->port.lock);
+	sgbuf = dmarx->use_buf_b ? &uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
+	rxchan->device->device_tx_status(rxchan, dmarx->cookie, &state);
+	if (likely(state.residue < dmarx->last_residue)) {
+		dmataken = sgbuf->sg.length - dmarx->last_residue;
+		size = dmarx->last_residue - state.residue;
+		dma_count = tty_insert_flip_string(uap->port.state->port.tty,
+						sgbuf->buf + dmataken, size);
+		if (dma_count == size)
+			dmarx->last_residue =  state.residue;
+		dmarx->last_jiffies = jiffies;
+	}
+	spin_unlock(&uap->port.lock);
+
+	tty_flip_buffer_push(uap->port.state->port.tty);
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
@@ -889,6 +990,10 @@ static void pl011_dma_startup(struct uart_amba_port *uap)
 	if (!uap->dmarx.chan)
 		goto skip_rx;

+	/* Set coherency of the DMA RX buffer */
+	uap->dmarx.sgbuf_a.coherency  = uap->dmarx.sgbuf_b.coherency
+		= uap->dmarx.poll_rate ? true : false;
+
 	/* Allocate and map DMA RX buffers */
 	ret = pl011_sgbuf_init(uap->dmarx.chan, &uap->dmarx.sgbuf_a,
 			       DMA_FROM_DEVICE);
@@ -928,6 +1033,16 @@ skip_rx:
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

@@ -963,6 +1078,8 @@ static void pl011_dma_shutdown(struct uart_amba_port *uap)
 		/* Clean up the RX DMA */
 		pl011_sgbuf_free(uap->dmarx.chan, &uap->dmarx.sgbuf_a, DMA_FROM_DEVICE);
 		pl011_sgbuf_free(uap->dmarx.chan, &uap->dmarx.sgbuf_b, DMA_FROM_DEVICE);
+		if (uap->dmarx.poll_rate)
+			del_timer_sync(&uap->dmarx.timer);
 		uap->using_rx_dma = false;
 	}
 }
@@ -977,7 +1094,6 @@ static inline bool pl011_dma_rx_running(struct
uart_amba_port *uap)
 	return uap->using_rx_dma && uap->dmarx.running;
 }

-
 #else
 /* Blank functions if the DMA engine is not available */
 static inline void pl011_dma_probe(struct uart_amba_port *uap)
@@ -1091,8 +1207,18 @@ static void pl011_rx_chars(struct uart_amba_port *uap)
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
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index f612c78..7501a5a 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -203,6 +203,8 @@ struct amba_pl011_data {
 	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
 	void *dma_rx_param;
 	void *dma_tx_param;
+	unsigned int dma_rx_poll_rate;
+	unsigned int dma_rx_poll_timeout;
         void (*init) (void);
 	void (*exit) (void);
 };
-- 
1.7.9.5
