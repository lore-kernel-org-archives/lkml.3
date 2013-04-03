Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3DCGAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:00:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:38862 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761787Ab3DCGAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:00:19 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 2/8] spi/spi-atmel: add flag to controller data for lock operations
Date: Wed, 3 Apr 2013 13:58:36 +0800
Message-ID: <1364968716-23848-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Will allow to drop the lock during DMA operations.

Replacing non-irqsave versions with irqsave versions of the lock
to make it correct in both pdc and dmaengine transfer mode

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 38f8c0d..2df562f 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -195,6 +195,7 @@ struct atmel_spi_caps {
  */
 struct atmel_spi {
 	spinlock_t		lock;
+	unsigned long		flags;
 
 	phys_addr_t		phybase;
 	void __iomem		*regs;
@@ -333,6 +334,16 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 		gpio_set_value(asd->npcs_pin, !active);
 }
 
+static void atmel_spi_lock(struct atmel_spi *as)
+{
+	spin_lock_irqsave(&as->lock, as->flags);
+}
+
+static void atmel_spi_unlock(struct atmel_spi *as)
+{
+	spin_unlock_irqrestore(&as->lock, as->flags);
+}
+
 static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
 					struct spi_transfer *xfer)
 {
@@ -569,9 +580,9 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
 		"xfer complete: %u bytes transferred\n",
 		msg->actual_length);
 
-	spin_unlock(&as->lock);
+	atmel_spi_unlock(as);
 	msg->complete(msg->context);
-	spin_lock(&as->lock);
+	atmel_spi_lock(as);
 
 	as->current_transfer = NULL;
 	as->next_transfer = NULL;
@@ -594,7 +605,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 	u32			status, pending, imr;
 	int			ret = IRQ_NONE;
 
-	spin_lock(&as->lock);
+	atmel_spi_lock(as);
 
 	xfer = as->current_transfer;
 	msg = list_entry(as->queue.next, struct spi_message, queue);
@@ -697,7 +708,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	spin_unlock(&as->lock);
+	atmel_spi_unlock(as);
 
 	return ret;
 }
@@ -802,13 +813,11 @@ static int atmel_spi_setup(struct spi_device *spi)
 		spi->controller_state = asd;
 		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	} else {
-		unsigned long		flags;
-
-		spin_lock_irqsave(&as->lock, flags);
+		atmel_spi_lock(as);
 		if (as->stay == spi)
 			as->stay = NULL;
 		cs_deactivate(as, spi);
-		spin_unlock_irqrestore(&as->lock, flags);
+		atmel_spi_unlock(as);
 	}
 
 	asd->csr = csr;
@@ -827,7 +836,6 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 {
 	struct atmel_spi	*as;
 	struct spi_transfer	*xfer;
-	unsigned long		flags;
 	struct device		*controller = spi->master->dev.parent;
 	u8			bits;
 	struct atmel_spi_device	*asd;
@@ -892,11 +900,11 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 	msg->status = -EINPROGRESS;
 	msg->actual_length = 0;
 
-	spin_lock_irqsave(&as->lock, flags);
+	atmel_spi_lock(as);
 	list_add_tail(&msg->queue, &as->queue);
 	if (!as->current_transfer)
 		atmel_spi_next_message(spi->master);
-	spin_unlock_irqrestore(&as->lock, flags);
+	atmel_spi_unlock(as);
 
 	return 0;
 }
@@ -906,17 +914,16 @@ static void atmel_spi_cleanup(struct spi_device *spi)
 	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
 	struct atmel_spi_device	*asd = spi->controller_state;
 	unsigned		gpio = (unsigned) spi->controller_data;
-	unsigned long		flags;
 
 	if (!asd)
 		return;
 
-	spin_lock_irqsave(&as->lock, flags);
+	atmel_spi_lock(as);
 	if (as->stay == spi) {
 		as->stay = NULL;
 		cs_deactivate(as, spi);
 	}
-	spin_unlock_irqrestore(&as->lock, flags);
+	atmel_spi_unlock(as);
 
 	spi->controller_state = NULL;
 	gpio_free(gpio);
-- 
1.7.9.5

