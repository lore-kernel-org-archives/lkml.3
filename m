Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIJV15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:27:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59974 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbaIJV1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:27:53 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [REPOST PATCHv3 1/2] mailbox/omap: adapt to the new mailbox framework
Date: Wed, 10 Sep 2014 16:27:24 -0500
Message-ID: <1410384445-44894-2-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410384445-44894-1-git-send-email-s-anna@ti.com>
References: <1410384445-44894-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP mailbox driver and its existing clients (remoteproc
for OMAP4+) are adapted to use the generic mailbox framework.
No changes are done to OMAP3 TI DSP/Bridge driver as it was
deleted.

The main changes for the adaptation are:
  - The tasklet used for Tx is replaced with the state machine from
    the generic mailbox framework. The workqueue used for processing
    the received messages stays intact for minimizing the effects on
    the OMAP mailbox clients.
  - The existing exported client API, omap_mbox_get, omap_mbox_put and
    omap_mbox_send_msg are deleted, as the framework provides equivalent
    functionality. A OMAP-specific omap_mbox_request_channel is added
    though to support non-DT way of requesting mailboxes.
  - The OMAP mailbox driver is integrated with the mailbox framework
    through the proper implementations of mbox_chan_ops, except for
    .last_tx_done and .peek_data. The OMAP mailbox driver does not need
    these ops, as it is completely interrupt driven.
  - The OMAP mailbox driver uses a custom of_xlate controller ops that
    allows phandles for the pargs specifier instead of indexing to avoid
    any channel registration order dependencies.
  - The new framework does not support multiple clients operating on a
    single channel, so the reference counting logic is simplified.
  - The remoteproc driver (current client) is adapted to use the new API.
    The notifier callbacks used within this client is replaced with the
    regular callbacks from the newer framework.
  - The exported OMAP mailbox API are limited to omap_mbox_save_ctx,
    omap_mbox_restore_ctx, omap_mbox_enable_irq & omap_mbox_disable_irq,
    with the signature modified to take in the new mbox_chan handle instead
    of the OMAP specific omap_mbox handle. The first 2 will be removed when
    the OMAP mailbox driver is adapted to runtime_pm. The other exported
    API omap_mbox_request_channel will be removed once OMAP3 becomes DT-boot
    only.

Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 .../devicetree/bindings/mailbox/omap-mailbox.txt   |  24 ++
 drivers/mailbox/omap-mailbox.c                     | 346 ++++++++++++---------
 drivers/remoteproc/omap_remoteproc.c               |  51 +--
 include/linux/omap-mailbox.h                       |  16 +-
 4 files changed, 257 insertions(+), 180 deletions(-)

diff --git a/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
index 48edc4b..1c6aa0d 100644
--- a/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
+++ b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
@@ -43,6 +43,9 @@ Required properties:
 			device. The format is dependent on which interrupt
 			controller the OMAP device uses
 - ti,hwmods:		Name of the hwmod associated with the mailbox
+- #mbox-cells:		Common mailbox binding property to identify the number
+			of cells required for the mailbox specifier. Should be
+			1
 - ti,mbox-num-users:	Number of targets (processor devices) that the mailbox
 			device can interrupt
 - ti,mbox-num-fifos:	Number of h/w fifo queues within the mailbox IP block
@@ -72,6 +75,18 @@ data that represent the following:
     Cell #3 (usr_id)  - mailbox user id for identifying the interrupt line
                         associated with generating a tx/rx fifo interrupt.
 
+Mailbox Users:
+==============
+A device needing to communicate with a target processor device should specify
+them using the common mailbox binding properties, "mboxes" and the optional
+"mbox-names" (please see Documentation/devicetree/bindings/mailbox/mailbox.txt
+for details). Each value of the mboxes property should contain a phandle to the
+mailbox controller device node and an args specifier that will be the phandle to
+the intended sub-mailbox child node to be used for communication. The equivalent
+"mbox-names" property value can be used to give a name to the communication channel
+to be used by the client user.
+
+
 Example:
 --------
 
@@ -81,6 +96,7 @@ mailbox: mailbox@4a0f4000 {
 	reg = <0x4a0f4000 0x200>;
 	interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 	ti,hwmods = "mailbox";
+	#mbox-cells = <1>;
 	ti,mbox-num-users = <3>;
 	ti,mbox-num-fifos = <8>;
 	mbox_ipu: mbox_ipu {
@@ -99,6 +115,7 @@ mailbox: mailbox@480C8000 {
 	reg = <0x480C8000 0x200>;
 	interrupts = <77>;
 	ti,hwmods = "mailbox";
+	#mbox-cells = <1>;
 	ti,mbox-num-users = <4>;
 	ti,mbox-num-fifos = <8>;
 	mbox_wkupm3: wkup_m3 {
@@ -106,3 +123,10 @@ mailbox: mailbox@480C8000 {
 		ti,mbox-rx = <0 0 3>;
 	};
 };
+
+wkup_m3: wkup_m3@44d00000 {
+	...
+	mbox-names = "wkup_m3";
+	mboxes = <&mailbox &mbox_wkupm3>;
+	...
+};
diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index bcc7ee1..66b83ca 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -29,13 +29,14 @@
 #include <linux/slab.h>
 #include <linux/kfifo.h>
 #include <linux/err.h>
-#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mailbox-omap.h>
 #include <linux/omap-mailbox.h>
+#include <linux/mailbox_controller.h>
+#include <linux/mailbox_client.h>
 
 #define MAILBOX_REVISION		0x000
 #define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
@@ -80,7 +81,6 @@ struct omap_mbox_queue {
 	spinlock_t		lock;
 	struct kfifo		fifo;
 	struct work_struct	work;
-	struct tasklet_struct	tasklet;
 	struct omap_mbox	*mbox;
 	bool full;
 };
@@ -92,6 +92,7 @@ struct omap_mbox_device {
 	u32 num_users;
 	u32 num_fifos;
 	struct omap_mbox **mboxes;
+	struct mbox_controller controller;
 	struct list_head elem;
 };
 
@@ -110,15 +111,14 @@ struct omap_mbox_fifo_info {
 struct omap_mbox {
 	const char		*name;
 	int			irq;
-	struct omap_mbox_queue	*txq, *rxq;
+	struct omap_mbox_queue	*rxq;
 	struct device		*dev;
 	struct omap_mbox_device *parent;
 	struct omap_mbox_fifo	tx_fifo;
 	struct omap_mbox_fifo	rx_fifo;
 	u32			ctx[OMAP4_MBOX_NR_REGS];
 	u32			intr_type;
-	int			use_count;
-	struct blocking_notifier_head	notifier;
+	struct mbox_chan	*chan;
 };
 
 /* global variables for the mailbox devices */
@@ -129,6 +129,14 @@ static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
 module_param(mbox_kfifo_size, uint, S_IRUGO);
 MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
 
+static struct omap_mbox *mbox_chan_to_omap_mbox(struct mbox_chan *chan)
+{
+	if (!chan || !chan->con_priv)
+		return NULL;
+
+	return (struct omap_mbox *)chan->con_priv;
+}
+
 static inline
 unsigned int mbox_read_reg(struct omap_mbox_device *mdev, size_t ofs)
 {
@@ -194,41 +202,14 @@ static int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 	return (int)(enable & status & bit);
 }
 
-/*
- * message sender
- */
-int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	struct omap_mbox_queue *mq = mbox->txq;
-	int ret = 0, len;
-
-	spin_lock_bh(&mq->lock);
-
-	if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (kfifo_is_empty(&mq->fifo) && !mbox_fifo_full(mbox)) {
-		mbox_fifo_write(mbox, msg);
-		goto out;
-	}
-
-	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-	WARN_ON(len != sizeof(msg));
-
-	tasklet_schedule(&mbox->txq->tasklet);
-
-out:
-	spin_unlock_bh(&mq->lock);
-	return ret;
-}
-EXPORT_SYMBOL(omap_mbox_msg_send);
-
-void omap_mbox_save_ctx(struct omap_mbox *mbox)
+void omap_mbox_save_ctx(struct mbox_chan *chan)
 {
 	int i;
 	int nr_regs;
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return;
 
 	if (mbox->intr_type)
 		nr_regs = OMAP4_MBOX_NR_REGS;
@@ -243,10 +224,14 @@ void omap_mbox_save_ctx(struct omap_mbox *mbox)
 }
 EXPORT_SYMBOL(omap_mbox_save_ctx);
 
-void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+void omap_mbox_restore_ctx(struct mbox_chan *chan)
 {
 	int i;
 	int nr_regs;
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return;
 
 	if (mbox->intr_type)
 		nr_regs = OMAP4_MBOX_NR_REGS;
@@ -254,14 +239,13 @@ void omap_mbox_restore_ctx(struct omap_mbox *mbox)
 		nr_regs = MBOX_NR_REGS;
 	for (i = 0; i < nr_regs; i++) {
 		mbox_write_reg(mbox->parent, mbox->ctx[i], i * sizeof(u32));
-
 		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
 			i, mbox->ctx[i]);
 	}
 }
 EXPORT_SYMBOL(omap_mbox_restore_ctx);
 
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static void _omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 {
 	u32 l;
 	struct omap_mbox_fifo *fifo = (irq == IRQ_TX) ?
@@ -273,9 +257,8 @@ void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 	l |= bit;
 	mbox_write_reg(mbox->parent, l, irqenable);
 }
-EXPORT_SYMBOL(omap_mbox_enable_irq);
 
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static void _omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 {
 	struct omap_mbox_fifo *fifo = (irq == IRQ_TX) ?
 				&mbox->tx_fifo : &mbox->rx_fifo;
@@ -291,28 +274,28 @@ void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 
 	mbox_write_reg(mbox->parent, bit, irqdisable);
 }
-EXPORT_SYMBOL(omap_mbox_disable_irq);
 
-static void mbox_tx_tasklet(unsigned long tx_data)
+void omap_mbox_enable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq)
 {
-	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
-	struct omap_mbox_queue *mq = mbox->txq;
-	mbox_msg_t msg;
-	int ret;
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
 
-	while (kfifo_len(&mq->fifo)) {
-		if (mbox_fifo_full(mbox)) {
-			omap_mbox_enable_irq(mbox, IRQ_TX);
-			break;
-		}
+	if (WARN_ON(!mbox))
+		return;
 
-		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
-								sizeof(msg));
-		WARN_ON(ret != sizeof(msg));
+	_omap_mbox_enable_irq(mbox, irq);
+}
+EXPORT_SYMBOL(omap_mbox_enable_irq);
 
-		mbox_fifo_write(mbox, msg);
-	}
+void omap_mbox_disable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq)
+{
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return;
+
+	_omap_mbox_disable_irq(mbox, irq);
 }
+EXPORT_SYMBOL(omap_mbox_disable_irq);
 
 /*
  * Message receiver(workqueue)
@@ -328,12 +311,11 @@ static void mbox_rx_work(struct work_struct *work)
 		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
-		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-								(void *)msg);
+		mbox_chan_received_data(mq->mbox->chan, (void *)msg);
 		spin_lock_irq(&mq->lock);
 		if (mq->full) {
 			mq->full = false;
-			omap_mbox_enable_irq(mq->mbox, IRQ_RX);
+			_omap_mbox_enable_irq(mq->mbox, IRQ_RX);
 		}
 		spin_unlock_irq(&mq->lock);
 	}
@@ -344,9 +326,9 @@ static void mbox_rx_work(struct work_struct *work)
  */
 static void __mbox_tx_interrupt(struct omap_mbox *mbox)
 {
-	omap_mbox_disable_irq(mbox, IRQ_TX);
+	_omap_mbox_disable_irq(mbox, IRQ_TX);
 	ack_mbox_irq(mbox, IRQ_TX);
-	tasklet_schedule(&mbox->txq->tasklet);
+	mbox_chan_txdone(mbox->chan, 0);
 }
 
 static void __mbox_rx_interrupt(struct omap_mbox *mbox)
@@ -357,7 +339,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 
 	while (!mbox_fifo_empty(mbox)) {
 		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
-			omap_mbox_disable_irq(mbox, IRQ_RX);
+			_omap_mbox_disable_irq(mbox, IRQ_RX);
 			mq->full = true;
 			goto nomem;
 		}
@@ -388,11 +370,13 @@ static irqreturn_t mbox_interrupt(int irq, void *p)
 }
 
 static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
-					void (*work) (struct work_struct *),
-					void (*tasklet)(unsigned long))
+					void (*work)(struct work_struct *))
 {
 	struct omap_mbox_queue *mq;
 
+	if (!work)
+		return NULL;
+
 	mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
 	if (!mq)
 		return NULL;
@@ -402,12 +386,9 @@ static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
 	if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
 		goto error;
 
-	if (work)
-		INIT_WORK(&mq->work, work);
-
-	if (tasklet)
-		tasklet_init(&mq->tasklet, tasklet, (unsigned long)mbox);
+	INIT_WORK(&mq->work, work);
 	return mq;
+
 error:
 	kfree(mq);
 	return NULL;
@@ -423,71 +404,35 @@ static int omap_mbox_startup(struct omap_mbox *mbox)
 {
 	int ret = 0;
 	struct omap_mbox_queue *mq;
-	struct omap_mbox_device *mdev = mbox->parent;
 
-	mutex_lock(&mdev->cfg_lock);
-	ret = pm_runtime_get_sync(mdev->dev);
-	if (unlikely(ret < 0))
-		goto fail_startup;
-
-	if (!mbox->use_count++) {
-		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
-		if (!mq) {
-			ret = -ENOMEM;
-			goto fail_alloc_txq;
-		}
-		mbox->txq = mq;
+	mq = mbox_queue_alloc(mbox, mbox_rx_work);
+	if (!mq)
+		return -ENOMEM;
+	mbox->rxq = mq;
+	mq->mbox = mbox;
+
+	ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
+			  mbox->name, mbox);
+	if (unlikely(ret)) {
+		pr_err("failed to register mailbox interrupt:%d\n", ret);
+		goto fail_request_irq;
+	}
 
-		mq = mbox_queue_alloc(mbox, mbox_rx_work, NULL);
-		if (!mq) {
-			ret = -ENOMEM;
-			goto fail_alloc_rxq;
-		}
-		mbox->rxq = mq;
-		mq->mbox = mbox;
-		ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
-							mbox->name, mbox);
-		if (unlikely(ret)) {
-			pr_err("failed to register mailbox interrupt:%d\n",
-									ret);
-			goto fail_request_irq;
-		}
+	_omap_mbox_enable_irq(mbox, IRQ_RX);
 
-		omap_mbox_enable_irq(mbox, IRQ_RX);
-	}
-	mutex_unlock(&mdev->cfg_lock);
 	return 0;
 
 fail_request_irq:
 	mbox_queue_free(mbox->rxq);
-fail_alloc_rxq:
-	mbox_queue_free(mbox->txq);
-fail_alloc_txq:
-	pm_runtime_put_sync(mdev->dev);
-	mbox->use_count--;
-fail_startup:
-	mutex_unlock(&mdev->cfg_lock);
 	return ret;
 }
 
 static void omap_mbox_fini(struct omap_mbox *mbox)
 {
-	struct omap_mbox_device *mdev = mbox->parent;
-
-	mutex_lock(&mdev->cfg_lock);
-
-	if (!--mbox->use_count) {
-		omap_mbox_disable_irq(mbox, IRQ_RX);
-		free_irq(mbox->irq, mbox);
-		tasklet_kill(&mbox->txq->tasklet);
-		flush_work(&mbox->rxq->work);
-		mbox_queue_free(mbox->txq);
-		mbox_queue_free(mbox->rxq);
-	}
-
-	pm_runtime_put_sync(mdev->dev);
-
-	mutex_unlock(&mdev->cfg_lock);
+	_omap_mbox_disable_irq(mbox, IRQ_RX);
+	free_irq(mbox->irq, mbox);
+	flush_work(&mbox->rxq->work);
+	mbox_queue_free(mbox->rxq);
 }
 
 static struct omap_mbox *omap_mbox_device_find(struct omap_mbox_device *mdev,
@@ -509,42 +454,55 @@ static struct omap_mbox *omap_mbox_device_find(struct omap_mbox_device *mdev,
 	return mbox;
 }
 
-struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
+struct mbox_chan *omap_mbox_request_channel(struct mbox_client *cl,
+					    const char *chan_name)
 {
+	struct device *dev = cl->dev;
 	struct omap_mbox *mbox = NULL;
 	struct omap_mbox_device *mdev;
+	struct mbox_chan *chan;
+	unsigned long flags;
 	int ret;
 
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	if (dev->of_node) {
+		pr_err("%s: please use mbox_request_channel(), this API is supported only for OMAP non-DT usage\n",
+		       __func__);
+		return ERR_PTR(-ENODEV);
+	}
+
 	mutex_lock(&omap_mbox_devices_lock);
 	list_for_each_entry(mdev, &omap_mbox_devices, elem) {
-		mbox = omap_mbox_device_find(mdev, name);
+		mbox = omap_mbox_device_find(mdev, chan_name);
 		if (mbox)
 			break;
 	}
 	mutex_unlock(&omap_mbox_devices_lock);
 
-	if (!mbox)
+	if (!mbox || !mbox->chan)
 		return ERR_PTR(-ENOENT);
 
-	if (nb)
-		blocking_notifier_chain_register(&mbox->notifier, nb);
+	chan = mbox->chan;
+	spin_lock_irqsave(&chan->lock, flags);
+	chan->msg_free = 0;
+	chan->msg_count = 0;
+	chan->active_req = NULL;
+	chan->cl = cl;
+	init_completion(&chan->tx_complete);
+	spin_unlock_irqrestore(&chan->lock, flags);
 
-	ret = omap_mbox_startup(mbox);
+	ret = chan->mbox->ops->startup(chan);
 	if (ret) {
-		blocking_notifier_chain_unregister(&mbox->notifier, nb);
-		return ERR_PTR(-ENODEV);
+		pr_err("Unable to startup the chan (%d)\n", ret);
+		mbox_free_channel(chan);
+		chan = ERR_PTR(ret);
 	}
 
-	return mbox;
-}
-EXPORT_SYMBOL(omap_mbox_get);
-
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
-{
-	blocking_notifier_chain_unregister(&mbox->notifier, nb);
-	omap_mbox_fini(mbox);
+	return chan;
 }
-EXPORT_SYMBOL(omap_mbox_put);
+EXPORT_SYMBOL(omap_mbox_request_channel);
 
 static struct class omap_mbox_class = { .name = "mbox", };
 
@@ -560,25 +518,25 @@ static int omap_mbox_register(struct omap_mbox_device *mdev)
 	mboxes = mdev->mboxes;
 	for (i = 0; mboxes[i]; i++) {
 		struct omap_mbox *mbox = mboxes[i];
-		mbox->dev = device_create(&omap_mbox_class,
-				mdev->dev, 0, mbox, "%s", mbox->name);
+		mbox->dev = device_create(&omap_mbox_class, mdev->dev,
+					0, mbox, "%s", mbox->name);
 		if (IS_ERR(mbox->dev)) {
 			ret = PTR_ERR(mbox->dev);
 			goto err_out;
 		}
-
-		BLOCKING_INIT_NOTIFIER_HEAD(&mbox->notifier);
 	}
 
 	mutex_lock(&omap_mbox_devices_lock);
 	list_add(&mdev->elem, &omap_mbox_devices);
 	mutex_unlock(&omap_mbox_devices_lock);
 
-	return 0;
+	ret = mbox_controller_register(&mdev->controller);
 
 err_out:
-	while (i--)
-		device_unregister(mboxes[i]->dev);
+	if (ret) {
+		while (i--)
+			device_unregister(mboxes[i]->dev);
+	}
 	return ret;
 }
 
@@ -594,12 +552,64 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
 	list_del(&mdev->elem);
 	mutex_unlock(&omap_mbox_devices_lock);
 
+	mbox_controller_unregister(&mdev->controller);
+
 	mboxes = mdev->mboxes;
 	for (i = 0; mboxes[i]; i++)
 		device_unregister(mboxes[i]->dev);
 	return 0;
 }
 
+static int omap_mbox_chan_startup(struct mbox_chan *chan)
+{
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+	struct omap_mbox_device *mdev = mbox->parent;
+	int ret = 0;
+
+	mutex_lock(&mdev->cfg_lock);
+	pm_runtime_get_sync(mdev->dev);
+	ret = omap_mbox_startup(mbox);
+	if (ret)
+		pm_runtime_put_sync(mdev->dev);
+	mutex_unlock(&mdev->cfg_lock);
+	return ret;
+}
+
+static void omap_mbox_chan_shutdown(struct mbox_chan *chan)
+{
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+	struct omap_mbox_device *mdev = mbox->parent;
+
+	mutex_lock(&mdev->cfg_lock);
+	omap_mbox_fini(mbox);
+	pm_runtime_put_sync(mdev->dev);
+	mutex_unlock(&mdev->cfg_lock);
+}
+
+static int omap_mbox_chan_send_data(struct mbox_chan *chan, void *data)
+{
+	struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
+	int ret = -EBUSY;
+
+	if (!mbox)
+		return -EINVAL;
+
+	if (!mbox_fifo_full(mbox)) {
+		mbox_fifo_write(mbox, (mbox_msg_t)data);
+		ret = 0;
+	}
+
+	/* always enable the interrupt */
+	_omap_mbox_enable_irq(mbox, IRQ_TX);
+	return ret;
+}
+
+static struct mbox_chan_ops omap_mbox_chan_ops = {
+	.startup        = omap_mbox_chan_startup,
+	.send_data      = omap_mbox_chan_send_data,
+	.shutdown       = omap_mbox_chan_shutdown,
+};
+
 static const struct of_device_id omap_mailbox_of_match[] = {
 	{
 		.compatible	= "ti,omap2-mailbox",
@@ -619,10 +629,35 @@ static const struct of_device_id omap_mailbox_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_mailbox_of_match);
 
+static struct mbox_chan *omap_mbox_of_xlate(struct mbox_controller *controller,
+					    const struct of_phandle_args *sp)
+{
+	phandle phandle = sp->args[0];
+	struct device_node *node;
+	struct omap_mbox_device *mdev;
+	struct omap_mbox *mbox;
+
+	mdev = container_of(controller, struct omap_mbox_device, controller);
+	if (WARN_ON(!mdev))
+		return NULL;
+
+	node = of_find_node_by_phandle(phandle);
+	if (!node) {
+		pr_err("%s: could not find node phandle 0x%x\n",
+		       __func__, phandle);
+		return NULL;
+	}
+
+	mbox = omap_mbox_device_find(mdev, node->name);
+	of_node_put(node);
+	return mbox ? mbox->chan : NULL;
+}
+
 static int omap_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
+	struct mbox_chan *chnls;
 	struct omap_mbox **list, *mbox, *mboxblk;
 	struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
 	struct omap_mbox_dev_info *info = NULL;
@@ -727,6 +762,11 @@ static int omap_mbox_probe(struct platform_device *pdev)
 	if (!list)
 		return -ENOMEM;
 
+	chnls = devm_kzalloc(&pdev->dev, (info_count + 1) * sizeof(*chnls),
+			     GFP_KERNEL);
+	if (!chnls)
+		return -ENOMEM;
+
 	mboxblk = devm_kzalloc(&pdev->dev, info_count * sizeof(*mbox),
 			       GFP_KERNEL);
 	if (!mboxblk)
@@ -758,6 +798,8 @@ static int omap_mbox_probe(struct platform_device *pdev)
 		mbox->irq = platform_get_irq(pdev, finfo->tx_irq);
 		if (mbox->irq < 0)
 			return mbox->irq;
+		mbox->chan = &chnls[i];
+		chnls[i].con_priv = mbox;
 		list[i] = mbox++;
 	}
 
@@ -766,6 +808,14 @@ static int omap_mbox_probe(struct platform_device *pdev)
 	mdev->num_users = num_users;
 	mdev->num_fifos = num_fifos;
 	mdev->mboxes = list;
+
+	/* OMAP does not have a Tx-Done IRQ, but rather a Tx-Ready IRQ */
+	mdev->controller.txdone_irq = true;
+	mdev->controller.dev = mdev->dev;
+	mdev->controller.ops = &omap_mbox_chan_ops;
+	mdev->controller.chans = chnls;
+	mdev->controller.num_chans = info_count;
+	mdev->controller.of_xlate = omap_mbox_of_xlate;
 	ret = omap_mbox_register(mdev);
 	if (ret)
 		return ret;
diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index 5168972..cf92f6e 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/remoteproc.h>
+#include <linux/mailbox_client.h>
 #include <linux/omap-mailbox.h>
 
 #include <linux/platform_data/remoteproc-omap.h>
@@ -36,20 +37,19 @@
 
 /**
  * struct omap_rproc - omap remote processor state
- * @mbox: omap mailbox handle
- * @nb: notifier block that will be invoked on inbound mailbox messages
+ * @mbox: mailbox channel handle
+ * @client: mailbox client to request the mailbox channel
  * @rproc: rproc handle
  */
 struct omap_rproc {
-	struct omap_mbox *mbox;
-	struct notifier_block nb;
+	struct mbox_chan *mbox;
+	struct mbox_client client;
 	struct rproc *rproc;
 };
 
 /**
  * omap_rproc_mbox_callback() - inbound mailbox message handler
- * @this: notifier block
- * @index: unused
+ * @client: mailbox client pointer used for requesting the mailbox channel
  * @data: mailbox payload
  *
  * This handler is invoked by omap's mailbox driver whenever a mailbox
@@ -61,13 +61,13 @@ struct omap_rproc {
  * that indicates different events. Those values are deliberately very
  * big so they don't coincide with virtqueue indices.
  */
-static int omap_rproc_mbox_callback(struct notifier_block *this,
-					unsigned long index, void *data)
+static void omap_rproc_mbox_callback(struct mbox_client *client, void *data)
 {
-	mbox_msg_t msg = (mbox_msg_t) data;
-	struct omap_rproc *oproc = container_of(this, struct omap_rproc, nb);
+	struct omap_rproc *oproc = container_of(client, struct omap_rproc,
+						client);
 	struct device *dev = oproc->rproc->dev.parent;
 	const char *name = oproc->rproc->name;
+	u32 msg = (u32)data;
 
 	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
 
@@ -84,8 +84,6 @@ static int omap_rproc_mbox_callback(struct notifier_block *this,
 		if (rproc_vq_interrupt(oproc->rproc, msg) == IRQ_NONE)
 			dev_dbg(dev, "no message was found in vqid %d\n", msg);
 	}
-
-	return NOTIFY_DONE;
 }
 
 /* kick a virtqueue */
@@ -96,8 +94,8 @@ static void omap_rproc_kick(struct rproc *rproc, int vqid)
 	int ret;
 
 	/* send the index of the triggered virtqueue in the mailbox payload */
-	ret = omap_mbox_msg_send(oproc->mbox, vqid);
-	if (ret)
+	ret = mbox_send_message(oproc->mbox, (void *)vqid);
+	if (ret < 0)
 		dev_err(dev, "omap_mbox_msg_send failed: %d\n", ret);
 }
 
@@ -115,17 +113,22 @@ static int omap_rproc_start(struct rproc *rproc)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
 	int ret;
+	struct mbox_client *client = &oproc->client;
 
 	if (pdata->set_bootaddr)
 		pdata->set_bootaddr(rproc->bootaddr);
 
-	oproc->nb.notifier_call = omap_rproc_mbox_callback;
+	client->dev = dev;
+	client->tx_done = NULL;
+	client->rx_callback = omap_rproc_mbox_callback;
+	client->tx_block = false;
+	client->knows_txdone = false;
 
-	/* every omap rproc is assigned a mailbox instance for messaging */
-	oproc->mbox = omap_mbox_get(pdata->mbox_name, &oproc->nb);
+	oproc->mbox = omap_mbox_request_channel(client, pdata->mbox_name);
 	if (IS_ERR(oproc->mbox)) {
-		ret = PTR_ERR(oproc->mbox);
-		dev_err(dev, "omap_mbox_get failed: %d\n", ret);
+		ret = -EBUSY;
+		dev_err(dev, "mbox_request_channel failed: %ld\n",
+			PTR_ERR(oproc->mbox));
 		return ret;
 	}
 
@@ -136,9 +139,9 @@ static int omap_rproc_start(struct rproc *rproc)
 	 * Note that the reply will _not_ arrive immediately: this message
 	 * will wait in the mailbox fifo until the remote processor is booted.
 	 */
-	ret = omap_mbox_msg_send(oproc->mbox, RP_MBOX_ECHO_REQUEST);
-	if (ret) {
-		dev_err(dev, "omap_mbox_get failed: %d\n", ret);
+	ret = mbox_send_message(oproc->mbox, (void *)RP_MBOX_ECHO_REQUEST);
+	if (ret < 0) {
+		dev_err(dev, "mbox_send_message failed: %d\n", ret);
 		goto put_mbox;
 	}
 
@@ -151,7 +154,7 @@ static int omap_rproc_start(struct rproc *rproc)
 	return 0;
 
 put_mbox:
-	omap_mbox_put(oproc->mbox, &oproc->nb);
+	mbox_free_channel(oproc->mbox);
 	return ret;
 }
 
@@ -168,7 +171,7 @@ static int omap_rproc_stop(struct rproc *rproc)
 	if (ret)
 		return ret;
 
-	omap_mbox_put(oproc->mbox, &oproc->nb);
+	mbox_free_channel(oproc->mbox);
 
 	return 0;
 }
diff --git a/include/linux/omap-mailbox.h b/include/linux/omap-mailbox.h
index f8322d9..587bbdd 100644
--- a/include/linux/omap-mailbox.h
+++ b/include/linux/omap-mailbox.h
@@ -10,20 +10,20 @@
 #define OMAP_MAILBOX_H
 
 typedef u32 mbox_msg_t;
-struct omap_mbox;
 
 typedef int __bitwise omap_mbox_irq_t;
 #define IRQ_TX ((__force omap_mbox_irq_t) 1)
 #define IRQ_RX ((__force omap_mbox_irq_t) 2)
 
-int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
+struct mbox_chan;
+struct mbox_client;
 
-struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
+struct mbox_chan *omap_mbox_request_channel(struct mbox_client *cl,
+					    const char *chan_name);
 
-void omap_mbox_save_ctx(struct omap_mbox *mbox);
-void omap_mbox_restore_ctx(struct omap_mbox *mbox);
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+void omap_mbox_save_ctx(struct mbox_chan *chan);
+void omap_mbox_restore_ctx(struct mbox_chan *chan);
+void omap_mbox_enable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq);
+void omap_mbox_disable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq);
 
 #endif /* OMAP_MAILBOX_H */
-- 
2.0.4

