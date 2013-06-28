Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3F1Sqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:46:39 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.204]:20852 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab3F1Sqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:46:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1372445194!11552181!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] spi: spi-ep93xx: convert to the queued driver infrastructure
Date: Fri, 28 Jun 2013 11:45:56 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281145.56990.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPI core provides infrastructure for standard message queueing. Use
that instead of handling it in the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 164 ++++++-----------------------------------------
 1 file changed, 19 insertions(+), 145 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 56305d3..93dad1e 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/scatterlist.h>
 #include <linux/spi/spi.h>
@@ -70,19 +69,13 @@
 
 /**
  * struct ep93xx_spi - EP93xx SPI controller structure
- * @lock: spinlock that protects concurrent accesses to fields @running,
- *        @current_msg and @msg_queue
  * @pdev: pointer to platform device
  * @clk: clock for the controller
  * @regs_base: pointer to ioremap()'d registers
  * @sspdr_phys: physical address of the SSPDR register
  * @min_rate: minimum clock rate (in Hz) supported by the controller
  * @max_rate: maximum clock rate (in Hz) supported by the controller
- * @running: is the queue running
- * @wq: workqueue used by the driver
- * @msg_work: work that is queued for the driver
  * @wait: wait here until given transfer is completed
- * @msg_queue: queue for the messages
  * @current_msg: message that is currently processed (or %NULL if none)
  * @tx: current byte in transfer to transmit
  * @rx: current byte in transfer to receive
@@ -96,31 +89,16 @@
  * @tx_sgt: sg table for TX transfers
  * @zeropage: dummy page used as RX buffer when only TX buffer is passed in by
  *            the client
- *
- * This structure holds EP93xx SPI controller specific information. When
- * @running is %true, driver accepts transfer requests from protocol drivers.
- * @current_msg is used to hold pointer to the message that is currently
- * processed. If @current_msg is %NULL, it means that no processing is going
- * on.
- *
- * Most of the fields are only written once and they can be accessed without
- * taking the @lock. Fields that are accessed concurrently are: @current_msg,
- * @running, and @msg_queue.
  */
 struct ep93xx_spi {
-	spinlock_t			lock;
 	const struct platform_device	*pdev;
 	struct clk			*clk;
 	void __iomem			*regs_base;
 	unsigned long			sspdr_phys;
 	unsigned long			min_rate;
 	unsigned long			max_rate;
-	bool				running;
 	bool				word_xfer;
-	struct workqueue_struct		*wq;
-	struct work_struct		msg_work;
 	struct completion		wait;
-	struct list_head		msg_queue;
 	struct spi_message		*current_msg;
 	size_t				tx;
 	size_t				rx;
@@ -206,7 +184,7 @@ static int ep93xx_spi_calc_divisors(const struct ep93xx_spi *espi,
 	/*
 	 * Make sure that max value is between values supported by the
 	 * controller. Note that minimum value is already checked in
-	 * ep93xx_spi_transfer().
+	 * ep93xx_spi_transfer_one_message().
 	 */
 	rate = clamp(rate, espi->min_rate, espi->max_rate);
 
@@ -282,54 +260,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
 }
 
 /**
- * ep93xx_spi_transfer() - queue message to be transferred
- * @spi: target SPI device
- * @msg: message to be transferred
- *
- * This function is called by SPI device drivers when they are going to transfer
- * a new message. It simply puts the message in the queue and schedules
- * workqueue to perform the actual transfer later on.
- *
- * Returns %0 on success and negative error in case of failure.
- */
-static int ep93xx_spi_transfer(struct spi_device *spi, struct spi_message *msg)
-{
-	struct ep93xx_spi *espi = spi_master_get_devdata(spi->master);
-	struct spi_transfer *t;
-	unsigned long flags;
-
-	if (!msg || !msg->complete)
-		return -EINVAL;
-
-	/* first validate each transfer */
-	list_for_each_entry(t, &msg->transfers, transfer_list) {
-		if (t->speed_hz && t->speed_hz < espi->min_rate)
-				return -EINVAL;
-	}
-
-	/*
-	 * Now that we own the message, let's initialize it so that it is
-	 * suitable for us. We use @msg->status to signal whether there was
-	 * error in transfer and @msg->state is used to hold pointer to the
-	 * current transfer (or %NULL if no active current transfer).
-	 */
-	msg->state = NULL;
-	msg->status = 0;
-	msg->actual_length = 0;
-
-	spin_lock_irqsave(&espi->lock, flags);
-	if (!espi->running) {
-		spin_unlock_irqrestore(&espi->lock, flags);
-		return -ESHUTDOWN;
-	}
-	list_add_tail(&msg->queue, &espi->msg_queue);
-	queue_work(espi->wq, &espi->msg_work);
-	spin_unlock_irqrestore(&espi->lock, flags);
-
-	return 0;
-}
-
-/**
  * ep93xx_spi_cleanup() - cleans up master controller specific state
  * @spi: SPI device to cleanup
  *
@@ -777,50 +707,29 @@ static void ep93xx_spi_process_message(struct ep93xx_spi *espi,
 	ep93xx_spi_disable(espi);
 }
 
-#define work_to_espi(work) (container_of((work), struct ep93xx_spi, msg_work))
-
-/**
- * ep93xx_spi_work() - EP93xx SPI workqueue worker function
- * @work: work struct
- *
- * Workqueue worker function. This function is called when there are new
- * SPI messages to be processed. Message is taken out from the queue and then
- * passed to ep93xx_spi_process_message().
- *
- * After message is transferred, protocol driver is notified by calling
- * @msg->complete(). In case of error, @msg->status is set to negative error
- * number, otherwise it contains zero (and @msg->actual_length is updated).
- */
-static void ep93xx_spi_work(struct work_struct *work)
+static int ep93xx_spi_transfer_one_message(struct spi_master *master,
+					   struct spi_message *msg)
 {
-	struct ep93xx_spi *espi = work_to_espi(work);
-	struct spi_message *msg;
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+	struct spi_transfer *t;
 
-	spin_lock_irq(&espi->lock);
-	if (!espi->running || espi->current_msg ||
-		list_empty(&espi->msg_queue)) {
-		spin_unlock_irq(&espi->lock);
-		return;
+	/* first validate each transfer */
+	list_for_each_entry(t, &msg->transfers, transfer_list) {
+		if (t->speed_hz < espi->min_rate)
+			return -EINVAL;
 	}
-	msg = list_first_entry(&espi->msg_queue, struct spi_message, queue);
-	list_del_init(&msg->queue);
-	espi->current_msg = msg;
-	spin_unlock_irq(&espi->lock);
 
-	ep93xx_spi_process_message(espi, msg);
+	msg->state = NULL;
+	msg->status = 0;
+	msg->actual_length = 0;
 
-	/*
-	 * Update the current message and re-schedule ourselves if there are
-	 * more messages in the queue.
-	 */
-	spin_lock_irq(&espi->lock);
+	espi->current_msg = msg;
+	ep93xx_spi_process_message(espi, msg);
 	espi->current_msg = NULL;
-	if (espi->running && !list_empty(&espi->msg_queue))
-		queue_work(espi->wq, &espi->msg_work);
-	spin_unlock_irq(&espi->lock);
 
-	/* notify the protocol driver that we are done with this message */
-	msg->complete(msg->context);
+	spi_finalize_current_message(master);
+
+	return 0;
 }
 
 static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
@@ -950,7 +859,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	}
 
 	master->setup = ep93xx_spi_setup;
-	master->transfer = ep93xx_spi_transfer;
+	master->transfer_one_message = ep93xx_spi_transfer_one_message;
 	master->cleanup = ep93xx_spi_cleanup;
 	master->bus_num = pdev->id;
 	master->num_chipselect = info->num_chipselect;
@@ -968,7 +877,6 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 		goto fail_release_master;
 	}
 
-	spin_lock_init(&espi->lock);
 	init_completion(&espi->wait);
 
 	/*
@@ -1011,22 +919,13 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	if (info->use_dma && ep93xx_spi_setup_dma(espi))
 		dev_warn(&pdev->dev, "DMA setup failed. Falling back to PIO\n");
 
-	espi->wq = create_singlethread_workqueue("ep93xx_spid");
-	if (!espi->wq) {
-		dev_err(&pdev->dev, "unable to create workqueue\n");
-		goto fail_free_dma;
-	}
-	INIT_WORK(&espi->msg_work, ep93xx_spi_work);
-	INIT_LIST_HEAD(&espi->msg_queue);
-	espi->running = true;
-
 	/* make sure that the hardware is disabled */
 	writeb(0, espi->regs_base + SSPCR1);
 
 	error = spi_register_master(master);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register SPI master\n");
-		goto fail_free_queue;
+		goto fail_free_dma;
 	}
 
 	dev_info(&pdev->dev, "EP93xx SPI Controller at 0x%08lx irq %d\n",
@@ -1034,8 +933,6 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail_free_queue:
-	destroy_workqueue(espi->wq);
 fail_free_dma:
 	ep93xx_spi_release_dma(espi);
 fail_put_clock:
@@ -1052,29 +949,6 @@ static int ep93xx_spi_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 
-	spin_lock_irq(&espi->lock);
-	espi->running = false;
-	spin_unlock_irq(&espi->lock);
-
-	destroy_workqueue(espi->wq);
-
-	/*
-	 * Complete remaining messages with %-ESHUTDOWN status.
-	 */
-	spin_lock_irq(&espi->lock);
-	while (!list_empty(&espi->msg_queue)) {
-		struct spi_message *msg;
-
-		msg = list_first_entry(&espi->msg_queue,
-				       struct spi_message, queue);
-		list_del_init(&msg->queue);
-		msg->status = -ESHUTDOWN;
-		spin_unlock_irq(&espi->lock);
-		msg->complete(msg->context);
-		spin_lock_irq(&espi->lock);
-	}
-	spin_unlock_irq(&espi->lock);
-
 	ep93xx_spi_release_dma(espi);
 	clk_put(espi->clk);
 	platform_set_drvdata(pdev, NULL);
-- 
1.8.1.4

