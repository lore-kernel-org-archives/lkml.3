Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab3BLFDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:03:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34517 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab3BLFDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:35 -0500
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <greg@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH v2 05/13] mailbox: create opened message type
Date: Mon, 11 Feb 2013 22:57:04 -0600
Message-ID: <1360645032-9668-6-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@st.com>

Current message type is a u32 to fit HW fifo format.
This should be extended to support any message exchanges
and type of mailbox.

Proposed structure owns the original u32 and an optional
pointer on additional data.

Adaptations made to remoteproc and tidspbridge drivers.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mailbox/Kconfig                      |  9 ++++
 drivers/mailbox/mailbox-omap1.c              | 26 +++++-----
 drivers/mailbox/mailbox-omap2.c              | 17 ++++---
 drivers/mailbox/mailbox.c                    | 73 +++++++++++++++++++---------
 drivers/mailbox/mailbox_internal.h           |  8 +--
 drivers/remoteproc/omap_remoteproc.c         | 20 +++++---
 drivers/staging/tidspbridge/core/io_sm.c     |  5 +-
 drivers/staging/tidspbridge/core/tiomap_io.c |  5 +-
 include/linux/mailbox.h                      | 15 +++++-
 9 files changed, 123 insertions(+), 55 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index d4e0bf2..c28897d 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -33,4 +33,13 @@ config MBOX_KFIFO_SIZE
          This can also be changed at runtime (via the mbox_kfifo_size
          module parameter).
 
+config MBOX_DATA_SIZE
+	int "Mailbox associated data max size (bytes)"
+	default 4
+	help
+	  Specify the default size of mailbox's associated data buffer
+	  (bytes)
+          This can also be changed at runtime (via the mbox_kfifo_size
+          module parameter).
+
 endif
diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index cadf971..c7c5b6f 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -37,6 +37,7 @@ struct omap_mbox1_fifo {
 struct omap_mbox1_priv {
 	struct omap_mbox1_fifo tx_fifo;
 	struct omap_mbox1_fifo rx_fifo;
+	u32 data;
 };
 
 static inline int mbox_read_reg(size_t ofs)
@@ -50,26 +51,27 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
 }
 
 /* msg */
-static mbox_msg_t omap1_mbox_fifo_read(struct mailbox *mbox)
+static void omap1_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	struct omap_mbox1_fifo *fifo =
-		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
-	mbox_msg_t msg;
+	struct omap_mbox1_priv *priv = mbox->priv;
+	struct omap_mbox1_fifo *fifo = &priv->rx_fifo;
 
-	msg = mbox_read_reg(fifo->data);
-	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
-
-	return msg;
+	priv->data = mbox_read_reg(fifo->data);
+	priv->data |= ((u32) mbox_read_reg(fifo->cmd)) << 16;
+	MAILBOX_FILL_MSG((*msg), 0, priv->data, 0);
 }
 
-static void
-omap1_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static int
+omap1_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->tx_fifo;
+	u32 data = (u32)msg->pdata;
+
+	mbox_write_reg(data & 0xffff, fifo->data);
+	mbox_write_reg(data >> 16, fifo->cmd);
 
-	mbox_write_reg(msg & 0xffff, fifo->data);
-	mbox_write_reg(msg >> 16, fifo->cmd);
+	return 0;
 }
 
 static int omap1_mbox_fifo_empty(struct mailbox *mbox)
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 32e5816..2554138 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -60,6 +60,7 @@ struct omap_mbox2_priv {
 	u32 ctx[OMAP4_MBOX_NR_REGS];
 	unsigned long irqdisable;
 	u32 intr_type;
+	u32 data;
 };
 
 static void omap2_mbox_enable_irq(struct mailbox *mbox,
@@ -96,18 +97,22 @@ static void omap2_mbox_shutdown(struct mailbox *mbox)
 }
 
 /* Mailbox FIFO handle functions */
-static mbox_msg_t omap2_mbox_fifo_read(struct mailbox *mbox)
+static void omap2_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	struct omap_mbox2_fifo *fifo =
-		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
-	return (mbox_msg_t) mbox_read_reg(fifo->msg);
+	struct omap_mbox2_priv *priv = mbox->priv;
+	struct omap_mbox2_fifo *fifo = &priv->rx_fifo;
+	priv->data = mbox_read_reg(fifo->msg);
+	MAILBOX_FILL_MSG((*msg), 0, priv->data, 0);
 }
 
-static void omap2_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static int omap2_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
-	mbox_write_reg(msg, fifo->msg);
+
+	mbox_write_reg((u32)msg->pdata, fifo->msg);
+
+	return 0;
 }
 
 static int omap2_mbox_fifo_empty(struct mailbox *mbox)
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 7856fbd..6b43e7c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -44,13 +44,13 @@ module_param(mbox_kfifo_size, uint, S_IRUGO);
 MODULE_PARM_DESC(mbox_kfifo_size, "Size of mailbox kfifo (bytes)");
 
 /* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct mailbox *mbox)
+static inline void mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	return mbox->ops->fifo_read(mbox);
+	mbox->ops->fifo_read(mbox, msg);
 }
-static inline void mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
+static inline int mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	mbox->ops->fifo_write(mbox, msg);
+	return mbox->ops->fifo_write(mbox, msg);
 }
 static inline int mbox_fifo_empty(struct mailbox *mbox)
 {
@@ -89,26 +89,32 @@ static int __mbox_poll_for_space(struct mailbox *mbox)
 	return ret;
 }
 
-int mailbox_msg_send(struct mailbox *mbox, mbox_msg_t msg)
+int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 {
 	struct mailbox_queue *mq = mbox->txq;
 	int ret = 0, len;
 
 	spin_lock_bh(&mq->lock);
 
-	if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
+	if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
-		mbox_fifo_write(mbox, msg);
+		ret = mbox_fifo_write(mbox, msg);
 		goto out;
 	}
 
-	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
 	WARN_ON(len != sizeof(msg));
 
+	if (msg->size && msg->pdata) {
+		len = kfifo_in(&mq->fifo, (unsigned char *)msg->pdata,
+								msg->size);
+		WARN_ON(len != msg->size);
+	}
+
 	tasklet_schedule(&mbox->txq->tasklet);
 
 out:
@@ -155,8 +161,9 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 {
 	struct mailbox *mbox = (struct mailbox *)tx_data;
 	struct mailbox_queue *mq = mbox->txq;
-	mbox_msg_t msg;
+	struct mailbox_msg msg;
 	int ret;
+	unsigned char tx_data_buf[CONFIG_MBOX_DATA_SIZE];
 
 	while (kfifo_len(&mq->fifo)) {
 		if (__mbox_poll_for_space(mbox)) {
@@ -164,34 +171,50 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 			break;
 		}
 
-		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
-				sizeof(msg));
+		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(ret != sizeof(msg));
 
-		mbox_fifo_write(mbox, msg);
+		if (msg.size) {
+			ret = kfifo_out(&mq->fifo, tx_data_buf,
+							sizeof(msg.size));
+			WARN_ON(ret != msg.size);
+			msg.pdata = tx_data_buf;
+		}
+
+		ret = mbox_fifo_write(mbox, &msg);
+		WARN_ON(ret);
 	}
 }
 
 /*
  * Message receiver(workqueue)
  */
+static unsigned char rx_work_data[CONFIG_MBOX_DATA_SIZE];
+
 static void mbox_rx_work(struct work_struct *work)
 {
 	struct mailbox_queue *mq =
 		container_of(work, struct mailbox_queue, work);
-	mbox_msg_t msg;
 	int len;
+	struct mailbox *mbox = mq->mbox;
+	struct mailbox_msg msg;
 
 	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
 		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
-		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-				(void *)msg);
+		if (msg.size) {
+			len = kfifo_out(&mq->fifo, rx_work_data, msg.size);
+			WARN_ON(len != msg.size);
+			msg.pdata = rx_work_data;
+		}
+
+		blocking_notifier_call_chain(&mbox->notifier, len,
+								(void *)&msg);
 		spin_lock_irq(&mq->lock);
 		if (mq->full) {
 			mq->full = false;
-			mailbox_enable_irq(mq->mbox, IRQ_RX);
+			mailbox_enable_irq(mbox, IRQ_RX);
 		}
 		spin_unlock_irq(&mq->lock);
 	}
@@ -210,21 +233,28 @@ static void __mbox_tx_interrupt(struct mailbox *mbox)
 static void __mbox_rx_interrupt(struct mailbox *mbox)
 {
 	struct mailbox_queue *mq = mbox->rxq;
-	mbox_msg_t msg;
+	struct mailbox_msg msg;
 	int len;
 
 	while (!mbox_fifo_empty(mbox)) {
-		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
+		if (unlikely(kfifo_avail(&mq->fifo) <
+				(sizeof(msg) + CONFIG_MBOX_DATA_SIZE))) {
 			mailbox_disable_irq(mbox, IRQ_RX);
 			mq->full = true;
 			goto nomem;
 		}
 
-		msg = mbox_fifo_read(mbox);
+		mbox_fifo_read(mbox, &msg);
 
 		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
+		if (msg.pdata && msg.size) {
+			len = kfifo_in(&mq->fifo, (unsigned char *)msg.pdata,
+					msg.size);
+			WARN_ON(len != msg.size);
+		}
+
 		if (mbox->ops->type == MBOX_HW_FIFO1_TYPE)
 			break;
 	}
@@ -450,10 +480,9 @@ static int __init mailbox_init(void)
 		return err;
 
 	/* kfifo size sanity check: alignment and minimal size */
-	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
+	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(struct mailbox_msg));
 	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
-			sizeof(mbox_msg_t));
-
+			sizeof(struct mailbox_msg) + CONFIG_MBOX_DATA_SIZE);
 	return 0;
 }
 subsys_initcall(mailbox_init);
diff --git a/drivers/mailbox/mailbox_internal.h b/drivers/mailbox/mailbox_internal.h
index db144d7..ba03910 100644
--- a/drivers/mailbox/mailbox_internal.h
+++ b/drivers/mailbox/mailbox_internal.h
@@ -25,8 +25,10 @@ struct mailbox_ops {
 	int             (*startup)(struct mailbox *mbox);
 	void            (*shutdown)(struct mailbox *mbox);
 	/* fifo */
-	mbox_msg_t      (*fifo_read)(struct mailbox *mbox);
-	void            (*fifo_write)(struct mailbox *mbox, mbox_msg_t msg);
+	void		(*fifo_read)(struct mailbox *mbox,
+						struct mailbox_msg *msg);
+	int             (*fifo_write)(struct mailbox *mbox,
+						struct mailbox_msg *msg);
 	int             (*fifo_empty)(struct mailbox *mbox);
 	int             (*fifo_full)(struct mailbox *mbox);
 	/* irq */
@@ -46,7 +48,7 @@ struct mailbox_queue {
 	struct kfifo            fifo;
 	struct work_struct      work;
 	struct tasklet_struct   tasklet;
-	struct mailbox        *mbox;
+	struct mailbox          *mbox;
 	bool full;
 };
 
diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index 8ecd2e7..b90beef 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -64,14 +64,15 @@ struct omap_rproc {
 static int omap_rproc_mbox_callback(struct notifier_block *this,
 					unsigned long index, void *data)
 {
-	mbox_msg_t msg = (mbox_msg_t) data;
 	struct omap_rproc *oproc = container_of(this, struct omap_rproc, nb);
 	struct device *dev = oproc->rproc->dev.parent;
+	struct mailbox_msg *msg = data;
 	const char *name = oproc->rproc->name;
+	u32 msg_data = (u32)msg->pdata;
 
-	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
+	dev_dbg(dev, "mbox msg: 0x%x\n", msg_data);
 
-	switch (msg) {
+	switch (msg_data) {
 	case RP_MBOX_CRASH:
 		/* just log this for now. later, we'll also do recovery */
 		dev_err(dev, "omap rproc %s crashed\n", name);
@@ -81,8 +82,9 @@ static int omap_rproc_mbox_callback(struct notifier_block *this,
 		break;
 	default:
 		/* msg contains the index of the triggered vring */
-		if (rproc_vq_interrupt(oproc->rproc, msg) == IRQ_NONE)
-			dev_dbg(dev, "no message was found in vqid %d\n", msg);
+		if (rproc_vq_interrupt(oproc->rproc, msg_data) == IRQ_NONE)
+			dev_dbg(dev, "no message was found in vqid %d\n",
+								msg_data);
 	}
 
 	return NOTIFY_DONE;
@@ -93,10 +95,12 @@ static void omap_rproc_kick(struct rproc *rproc, int vqid)
 {
 	struct omap_rproc *oproc = rproc->priv;
 	struct device *dev = rproc->dev.parent;
+	struct mailbox_msg msg;
 	int ret;
 
 	/* send the index of the triggered virtqueue in the mailbox payload */
-	ret = mailbox_msg_send(oproc->mbox, vqid);
+	MAILBOX_FILL_MSG(msg, 0, vqid, 0);
+	ret = mailbox_msg_send(oproc->mbox, &msg);
 	if (ret)
 		dev_err(dev, "mailbox_msg_send failed: %d\n", ret);
 }
@@ -114,6 +118,7 @@ static int omap_rproc_start(struct rproc *rproc)
 	struct device *dev = rproc->dev.parent;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
+	struct mailbox_msg msg;
 	int ret;
 
 	if (pdata->set_bootaddr)
@@ -136,7 +141,8 @@ static int omap_rproc_start(struct rproc *rproc)
 	 * Note that the reply will _not_ arrive immediately: this message
 	 * will wait in the mailbox fifo until the remote processor is booted.
 	 */
-	ret = mailbox_msg_send(oproc->mbox, RP_MBOX_ECHO_REQUEST);
+	MAILBOX_FILL_MSG(msg, 0, RP_MBOX_ECHO_REQUEST, 0);
+	ret = mailbox_msg_send(oproc->mbox, &msg);
 	if (ret) {
 		dev_err(dev, "mailbox_get failed: %d\n", ret);
 		goto put_mbox;
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index e322fb7..495ef98 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -908,10 +908,11 @@ func_end:
  *      Calls the Bridge's CHNL_ISR to determine if this interrupt is ours, then
  *      schedules a DPC to dispatch I/O.
  */
-int io_mbox_msg(struct notifier_block *self, unsigned long len, void *msg)
+int io_mbox_msg(struct notifier_block *self, unsigned long len, void *data)
 {
 	struct io_mgr *pio_mgr;
 	struct dev_object *dev_obj;
+	u32 msg = (u32)((struct mailbox_msg *)data)->pdata;
 	unsigned long flags;
 
 	dev_obj = dev_get_first();
@@ -920,7 +921,7 @@ int io_mbox_msg(struct notifier_block *self, unsigned long len, void *msg)
 	if (!pio_mgr)
 		return NOTIFY_BAD;
 
-	pio_mgr->intr_val = (u16)((u32)msg);
+	pio_mgr->intr_val = (u16)(msg);
 	if (pio_mgr->intr_val & MBX_PM_CLASS)
 		io_dispatch_pm(pio_mgr);
 
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index 41bcb1a..5bd57dd 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -374,6 +374,7 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 	struct omap_dsp_platform_data *pdata =
 		omap_dspbridge_dev->dev.platform_data;
 	struct cfg_hostres *resources = dev_context->resources;
+	struct mailbox_msg msg;
 	int status = 0;
 	u32 temp;
 
@@ -427,7 +428,9 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		dsp_clock_enable_all(dev_context->dsp_per_clks);
 	}
 
-	status = mailbox_msg_send(dev_context->mbox, mb_val);
+	temp = mb_val;
+	MAILBOX_FILL_MSG(msg, 0, temp, 0);
+	status = mailbox_msg_send(dev_context->mbox, &msg);
 
 	if (status) {
 		pr_err("mailbox_msg_send Fail and status = %d\n", status);
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index 54dd305..f8730b4 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -9,14 +9,25 @@
 #ifndef MAILBOX_H
 #define MAILBOX_H
 
-typedef u32 mbox_msg_t;
 struct mailbox;
 
 typedef int __bitwise mailbox_irq_t;
 #define IRQ_TX ((__force mailbox_irq_t) 1)
 #define IRQ_RX ((__force mailbox_irq_t) 2)
 
-int mailbox_msg_send(struct mailbox *, mbox_msg_t msg);
+struct mailbox_msg {
+	int		size;
+	u32		header;
+	void		*pdata;
+};
+
+#define MAILBOX_FILL_MSG(_msg, _header, _pdata, _size) { \
+	_msg.header = _header; \
+	_msg.pdata = (void *)_pdata; \
+	_msg.size = _size; \
+}
+
+int mailbox_msg_send(struct mailbox *, struct mailbox_msg *msg);
 
 struct mailbox *mailbox_get(const char *, struct notifier_block *nb);
 void mailbox_put(struct mailbox *mbox, struct notifier_block *nb);
-- 
1.8.1.2

