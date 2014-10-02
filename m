Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaJBK1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:27:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:42608 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaJBK1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:27:33 -0400
Date: Thu, 2 Oct 2014 12:27:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20141002102723.GB23661@linutronix.de>
References: <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <20140922092853.GH20438@ci00147.xsens-tech.local>
 <20140925151403.GH19396@linutronix.de>
 <20140929085042.GA13952@ci00147.xsens-tech.local>
 <20140929095440.GB13142@linutronix.de>
 <20140929103042.GA31111@ci00147.xsens-tech.local>
 <20140930084416.GB31111@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140930084416.GB31111@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-30 10:44:16 [+0200]:

>On Mon, Sep 29, 2014 at 12:30:43PM +0200, Frans Klaver wrote:
>> On Mon, Sep 29, 2014 at 11:54:40AM +0200, Sebastian Andrzej Siewior wrote:
>> > For your "too much work for irq" problem: Could you add trace_printk()
>> > in tx/rx dma start/complete, and irq routine? The interresting part is
>> > what is the irq routine doing once entered. It might be a condition that
>> > is ignored at first and "acked" later while serving another event. Or it
>> > is really doing something and this is more or less "legal".
>> 
>
>Here's some trace output I get. I hope branches become clear by the
>calls they do.
>
>       uart_test-482   [000] .ns.    17.860139: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
>       uart_test-482   [000] .ns.    17.860141: __dma_rx_do_complete: rx_dma(p, 0)

these two happen outside the IRQ routine for every 48 bytes.
…
>       uart_test-483   [000] dnh.    17.861018: serial8250_interrupt: irq 89
>       uart_test-483   [000] dnh.    17.861026: serial8250_interrupt: 89 e
e? Did was the routine invoked 0xe times or this a register?

>       uart_test-483   [000] .ns.    17.861045: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
>       uart_test-483   [000] .ns.    17.861047: __dma_rx_do_complete: rx_dma(p, 0)
another 48bytes

>       uart_test-479   [000] d.H.    17.861124: serial8250_interrupt: irq 89
>       uart_test-479   [000] d.H.    17.861133: serial8250_handle_irq: l1 IIR cc LSR 61
>       uart_test-479   [000] d.H.    17.861135: serial8250_handle_irq: rx_dma(up, iir)
>       uart_test-479   [000] d.H.    17.861139: serial8250_rx_dma: l1, UART_IIR_RX_TIMEOUT
>       uart_test-479   [000] d.H.    17.861147: __dma_rx_do_complete: error: 1, uart_bug_dma: 32
>       uart_test-479   [000] d.H.    17.861150: serial8250_handle_irq: rx_chars(up, status)
>       uart_test-479   [000] d.H.    17.861190: serial8250_handle_irq: rx_dma(up, 0)
timeout, manual purge. Do you have an idea how many bytes were manually
received?

>       uart_test-479   [000] d.H.    17.861205: serial8250_interrupt: 89 e
>     kworker/0:1-10    [000] dnH.    17.864949: serial8250_interrupt: irq 89
>
>So far so good. We're just entered interrupt where stuff goes awry. The
>following pattern repeats over 600 times:
>
>     kworker/0:1-10    [000] dnH.    17.865198: serial8250_handle_irq: l1 IIR cc LSR 61
>     kworker/0:1-10    [000] dnH.    17.865254: serial8250_handle_irq: rx_dma(up, iir)
>     kworker/0:1-10    [000] dnH.    17.865333: serial8250_rx_dma: l1, UART_IIR_RX_TIMEOUT
>     kworker/0:1-10    [000] dnH.    17.865626: __dma_rx_do_complete: error: 1, uart_bug_dma: 32
>     kworker/0:1-10    [000] dnH.    17.865747: serial8250_handle_irq: rx_chars(up, status)
>     kworker/0:1-10    [000] dnH.    17.868797: serial8250_handle_irq: rx_dma(up, 0)
>
>ending with:
>
>     kworker/0:1-10    [000] dnH.    20.027093: serial8250_interrupt: serial8250: too much work for irq89
>     kworker/0:1-10    [000] dnH.    20.027181: serial8250_interrupt: 89 e
>
>This clogs the entire system until I disconnect the communication lines.
>
>So we get an RX timeout. The receiver fifo trigger level was not reached
>and 8250_core is left to copy the remaining data. I would expect that if
>the trigger level wasn't reached, we wouldn't need to be doing this that
>often. On the other hand, could we be trapped reading data from rx
>without dma helping us? And how could we resolve this?

So if I understand you correct, then you enter serial8250_interrupt()
and then you enter multiple times omap_8250_dma_handle_irq() and
you always get a TIMEOUT event and fetch byte(s) manualy via
serial8250_rx_chars(). And after one iteration UART_IIR_NO_INT is not
set and you do it again, right?

I have no idea when exactly the timeout-interrupt fires. The manual
says: "… the count is reset when there is activity on uarti_rx …" but it
does not say how often it increments before the level is reached.
It also might be that you have a small gap between two bytes and this
high baud rate the gap is considered as a timeout event.

Another thing could be that if the we enqueue a RX transfer from the
dma_completion callback then we have too many bytes in the FIFO already
becahse the callback is invoked from softirq. What happens if we cut the
middle man via


diff --git a/drivers/dma/virt-dma.c b/drivers/dma/virt-dma.c
index 6f80432..21b04bd 100644
--- a/drivers/dma/virt-dma.c
+++ b/drivers/dma/virt-dma.c
@@ -63,8 +63,9 @@ static void vchan_complete(unsigned long arg)
 	dma_async_tx_callback cb = NULL;
 	void *cb_data = NULL;
 	LIST_HEAD(head);
+	unsigned long flags;
 
-	spin_lock_irq(&vc->lock);
+	spin_lock_irqsave(&vc->lock, flags);
 	list_splice_tail_init(&vc->desc_completed, &head);
 	vd = vc->cyclic;
 	if (vd) {
@@ -72,7 +73,7 @@ static void vchan_complete(unsigned long arg)
 		cb = vd->tx.callback;
 		cb_data = vd->tx.callback_param;
 	}
-	spin_unlock_irq(&vc->lock);
+	spin_unlock_irqrestore(&vc->lock, flags);
 
 	if (cb)
 		cb(cb_data);
diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
index 181b952..7632338 100644
--- a/drivers/dma/virt-dma.h
+++ b/drivers/dma/virt-dma.h
@@ -92,7 +92,10 @@ static inline void vchan_cookie_complete(struct virt_dma_desc *vd)
 		 vd, cookie);
 	list_add_tail(&vd->node, &vc->desc_completed);
 
-	tasklet_schedule(&vc->task);
+	if (vd->tx.my_uart)
+		vc->task.func(vc);
+	else
+		tasklet_schedule(&vc->task);
 }
 
 /**
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 57a8b12..5d7ee92 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -728,6 +728,7 @@ static int omap_8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 	dma->rx_running = 1;
 	desc->callback = __dma_rx_complete;
 	desc->callback_param = p;
+	desc->my_uart = 1;
 
 	dma->rx_cookie = dmaengine_submit(desc);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1f9e642..0f5fbe1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -459,6 +459,7 @@ struct dmaengine_unmap_data {
 struct dma_async_tx_descriptor {
 	dma_cookie_t cookie;
 	enum dma_ctrl_flags flags; /* not a 'long' to pack with cookie */
+	u32 my_uart;
 	dma_addr_t phys;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);

>
>Frans

Sebastian
