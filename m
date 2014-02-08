Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaBHAtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:42 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3300 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbaBHAtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:21 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 4/6] mailbox: omap: remove omap-specific framework
Date: Fri, 7 Feb 2014 16:50:17 -0800
Message-ID: <1391820619-25487-5-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This framework is no longer needed, and the users should move over to
the new common framework.  Mark the existing implementations as broken,
and deprecate the api, as a stop-gap.

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 drivers/mailbox/Kconfig        |  19 +-
 drivers/mailbox/Makefile       |   1 -
 drivers/mailbox/omap-mailbox.c | 469 -----------------------------------------
 drivers/mailbox/omap-mbox.h    |  67 ------
 include/linux/omap-mailbox.h   |  45 +++-
 5 files changed, 40 insertions(+), 561 deletions(-)
 delete mode 100644 drivers/mailbox/omap-mailbox.c
 delete mode 100644 drivers/mailbox/omap-mbox.h

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index c8b5c13..6befc6e 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -16,17 +16,10 @@ config PL320_MBOX
 	  Management Engine, primarily for cpufreq. Say Y here if you want
 	  to use the PL320 IPCM support.
 
-config OMAP_MBOX
-	tristate
-	help
-	  This option is selected by any OMAP architecture specific mailbox
-	  driver such as CONFIG_OMAP1_MBOX or CONFIG_OMAP2PLUS_MBOX. This
-	  enables the common OMAP mailbox framework code.
-
 config OMAP1_MBOX
 	tristate "OMAP1 Mailbox framework support"
 	depends on ARCH_OMAP1
-	select OMAP_MBOX
+	depends on BROKEN
 	help
 	  Mailbox implementation for OMAP chips with hardware for
 	  interprocessor communication involving DSP in OMAP1. Say Y here
@@ -35,19 +28,11 @@ config OMAP1_MBOX
 config OMAP2PLUS_MBOX
 	tristate "OMAP2+ Mailbox framework support"
 	depends on ARCH_OMAP2PLUS
-	select OMAP_MBOX
+	depends on BROKEN
 	help
 	  Mailbox implementation for OMAP family chips with hardware for
 	  interprocessor communication involving DSP, IVA1.0 and IVA2 in
 	  OMAP2/3; or IPU, IVA HD and DSP in OMAP4/5. Say Y here if you
 	  want to use OMAP2+ Mailbox framework support.
 
-config OMAP_MBOX_KFIFO_SIZE
-	int "Mailbox kfifo default buffer size (bytes)"
-	depends on OMAP2PLUS_MBOX || OMAP1_MBOX
-	default 256
-	help
-	  Specify the default size of mailbox's kfifo buffers (bytes).
-	  This can also be changed at runtime (via the mbox_kfifo_size
-	  module parameter).
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index 53712ed..c8e51a0 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_MAILBOX)		+= core.o
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
 
-obj-$(CONFIG_OMAP_MBOX)		+= omap-mailbox.o
 obj-$(CONFIG_OMAP1_MBOX)	+= mailbox_omap1.o
 mailbox_omap1-objs		:= mailbox-omap1.o
 obj-$(CONFIG_OMAP2PLUS_MBOX)	+= mailbox_omap2.o
diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
deleted file mode 100644
index d79a646..0000000
--- a/drivers/mailbox/omap-mailbox.c
+++ /dev/null
@@ -1,469 +0,0 @@
-/*
- * OMAP mailbox driver
- *
- * Copyright (C) 2006-2009 Nokia Corporation. All rights reserved.
- *
- * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/kfifo.h>
-#include <linux/err.h>
-#include <linux/notifier.h>
-#include <linux/module.h>
-
-#include "omap-mbox.h"
-
-static struct omap_mbox **mboxes;
-
-static int mbox_configured;
-static DEFINE_MUTEX(mbox_configured_lock);
-
-static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
-module_param(mbox_kfifo_size, uint, S_IRUGO);
-MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
-
-/* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_read(mbox);
-}
-static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	mbox->ops->fifo_write(mbox, msg);
-}
-static inline int mbox_fifo_empty(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_empty(mbox);
-}
-static inline int mbox_fifo_full(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_full(mbox);
-}
-
-/* Mailbox IRQ handle functions */
-static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (mbox->ops->ack_irq)
-		mbox->ops->ack_irq(mbox, irq);
-}
-static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	return mbox->ops->is_irq(mbox, irq);
-}
-
-/*
- * message sender
- */
-static int __mbox_poll_for_space(struct omap_mbox *mbox)
-{
-	int ret = 0, i = 1000;
-
-	while (mbox_fifo_full(mbox)) {
-		if (mbox->ops->type == OMAP_MBOX_TYPE2)
-			return -1;
-		if (--i == 0)
-			return -1;
-		udelay(1);
-	}
-	return ret;
-}
-
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
-	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
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
-{
-	if (!mbox->ops->save_ctx) {
-		dev_err(mbox->dev, "%s:\tno save\n", __func__);
-		return;
-	}
-
-	mbox->ops->save_ctx(mbox);
-}
-EXPORT_SYMBOL(omap_mbox_save_ctx);
-
-void omap_mbox_restore_ctx(struct omap_mbox *mbox)
-{
-	if (!mbox->ops->restore_ctx) {
-		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
-		return;
-	}
-
-	mbox->ops->restore_ctx(mbox);
-}
-EXPORT_SYMBOL(omap_mbox_restore_ctx);
-
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	mbox->ops->enable_irq(mbox, irq);
-}
-EXPORT_SYMBOL(omap_mbox_enable_irq);
-
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	mbox->ops->disable_irq(mbox, irq);
-}
-EXPORT_SYMBOL(omap_mbox_disable_irq);
-
-static void mbox_tx_tasklet(unsigned long tx_data)
-{
-	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
-	struct omap_mbox_queue *mq = mbox->txq;
-	mbox_msg_t msg;
-	int ret;
-
-	while (kfifo_len(&mq->fifo)) {
-		if (__mbox_poll_for_space(mbox)) {
-			omap_mbox_enable_irq(mbox, IRQ_TX);
-			break;
-		}
-
-		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
-								sizeof(msg));
-		WARN_ON(ret != sizeof(msg));
-
-		mbox_fifo_write(mbox, msg);
-	}
-}
-
-/*
- * Message receiver(workqueue)
- */
-static void mbox_rx_work(struct work_struct *work)
-{
-	struct omap_mbox_queue *mq =
-			container_of(work, struct omap_mbox_queue, work);
-	mbox_msg_t msg;
-	int len;
-
-	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
-		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-		WARN_ON(len != sizeof(msg));
-
-		blocking_notifier_call_chain(&mq->mbox->notifier, len,
-								(void *)msg);
-		spin_lock_irq(&mq->lock);
-		if (mq->full) {
-			mq->full = false;
-			omap_mbox_enable_irq(mq->mbox, IRQ_RX);
-		}
-		spin_unlock_irq(&mq->lock);
-	}
-}
-
-/*
- * Mailbox interrupt handler
- */
-static void __mbox_tx_interrupt(struct omap_mbox *mbox)
-{
-	omap_mbox_disable_irq(mbox, IRQ_TX);
-	ack_mbox_irq(mbox, IRQ_TX);
-	tasklet_schedule(&mbox->txq->tasklet);
-}
-
-static void __mbox_rx_interrupt(struct omap_mbox *mbox)
-{
-	struct omap_mbox_queue *mq = mbox->rxq;
-	mbox_msg_t msg;
-	int len;
-
-	while (!mbox_fifo_empty(mbox)) {
-		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
-			omap_mbox_disable_irq(mbox, IRQ_RX);
-			mq->full = true;
-			goto nomem;
-		}
-
-		msg = mbox_fifo_read(mbox);
-
-		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
-		WARN_ON(len != sizeof(msg));
-
-		if (mbox->ops->type == OMAP_MBOX_TYPE1)
-			break;
-	}
-
-	/* no more messages in the fifo. clear IRQ source. */
-	ack_mbox_irq(mbox, IRQ_RX);
-nomem:
-	schedule_work(&mbox->rxq->work);
-}
-
-static irqreturn_t mbox_interrupt(int irq, void *p)
-{
-	struct omap_mbox *mbox = p;
-
-	if (is_mbox_irq(mbox, IRQ_TX))
-		__mbox_tx_interrupt(mbox);
-
-	if (is_mbox_irq(mbox, IRQ_RX))
-		__mbox_rx_interrupt(mbox);
-
-	return IRQ_HANDLED;
-}
-
-static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
-					void (*work) (struct work_struct *),
-					void (*tasklet)(unsigned long))
-{
-	struct omap_mbox_queue *mq;
-
-	mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
-	if (!mq)
-		return NULL;
-
-	spin_lock_init(&mq->lock);
-
-	if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
-		goto error;
-
-	if (work)
-		INIT_WORK(&mq->work, work);
-
-	if (tasklet)
-		tasklet_init(&mq->tasklet, tasklet, (unsigned long)mbox);
-	return mq;
-error:
-	kfree(mq);
-	return NULL;
-}
-
-static void mbox_queue_free(struct omap_mbox_queue *q)
-{
-	kfifo_free(&q->fifo);
-	kfree(q);
-}
-
-static int omap_mbox_startup(struct omap_mbox *mbox)
-{
-	int ret = 0;
-	struct omap_mbox_queue *mq;
-
-	mutex_lock(&mbox_configured_lock);
-	if (!mbox_configured++) {
-		if (likely(mbox->ops->startup)) {
-			ret = mbox->ops->startup(mbox);
-			if (unlikely(ret))
-				goto fail_startup;
-		} else
-			goto fail_startup;
-	}
-
-	if (!mbox->use_count++) {
-		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
-		if (!mq) {
-			ret = -ENOMEM;
-			goto fail_alloc_txq;
-		}
-		mbox->txq = mq;
-
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
-
-		omap_mbox_enable_irq(mbox, IRQ_RX);
-	}
-	mutex_unlock(&mbox_configured_lock);
-	return 0;
-
-fail_request_irq:
-	mbox_queue_free(mbox->rxq);
-fail_alloc_rxq:
-	mbox_queue_free(mbox->txq);
-fail_alloc_txq:
-	if (mbox->ops->shutdown)
-		mbox->ops->shutdown(mbox);
-	mbox->use_count--;
-fail_startup:
-	mbox_configured--;
-	mutex_unlock(&mbox_configured_lock);
-	return ret;
-}
-
-static void omap_mbox_fini(struct omap_mbox *mbox)
-{
-	mutex_lock(&mbox_configured_lock);
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
-	if (likely(mbox->ops->shutdown)) {
-		if (!--mbox_configured)
-			mbox->ops->shutdown(mbox);
-	}
-
-	mutex_unlock(&mbox_configured_lock);
-}
-
-struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
-{
-	struct omap_mbox *_mbox, *mbox = NULL;
-	int i, ret;
-
-	if (!mboxes)
-		return ERR_PTR(-EINVAL);
-
-	for (i = 0; (_mbox = mboxes[i]); i++) {
-		if (!strcmp(_mbox->name, name)) {
-			mbox = _mbox;
-			break;
-		}
-	}
-
-	if (!mbox)
-		return ERR_PTR(-ENOENT);
-
-	if (nb)
-		blocking_notifier_chain_register(&mbox->notifier, nb);
-
-	ret = omap_mbox_startup(mbox);
-	if (ret) {
-		blocking_notifier_chain_unregister(&mbox->notifier, nb);
-		return ERR_PTR(-ENODEV);
-	}
-
-	return mbox;
-}
-EXPORT_SYMBOL(omap_mbox_get);
-
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
-{
-	blocking_notifier_chain_unregister(&mbox->notifier, nb);
-	omap_mbox_fini(mbox);
-}
-EXPORT_SYMBOL(omap_mbox_put);
-
-static struct class omap_mbox_class = { .name = "mbox", };
-
-int omap_mbox_register(struct device *parent, struct omap_mbox **list)
-{
-	int ret;
-	int i;
-
-	mboxes = list;
-	if (!mboxes)
-		return -EINVAL;
-
-	for (i = 0; mboxes[i]; i++) {
-		struct omap_mbox *mbox = mboxes[i];
-		mbox->dev = device_create(&omap_mbox_class,
-				parent, 0, mbox, "%s", mbox->name);
-		if (IS_ERR(mbox->dev)) {
-			ret = PTR_ERR(mbox->dev);
-			goto err_out;
-		}
-
-		BLOCKING_INIT_NOTIFIER_HEAD(&mbox->notifier);
-	}
-	return 0;
-
-err_out:
-	while (i--)
-		device_unregister(mboxes[i]->dev);
-	return ret;
-}
-EXPORT_SYMBOL(omap_mbox_register);
-
-int omap_mbox_unregister(void)
-{
-	int i;
-
-	if (!mboxes)
-		return -EINVAL;
-
-	for (i = 0; mboxes[i]; i++)
-		device_unregister(mboxes[i]->dev);
-	mboxes = NULL;
-	return 0;
-}
-EXPORT_SYMBOL(omap_mbox_unregister);
-
-static int __init omap_mbox_init(void)
-{
-	int err;
-
-	err = class_register(&omap_mbox_class);
-	if (err)
-		return err;
-
-	/* kfifo size sanity check: alignment and minimal size */
-	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
-	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size,
-							sizeof(mbox_msg_t));
-
-	return 0;
-}
-subsys_initcall(omap_mbox_init);
-
-static void __exit omap_mbox_exit(void)
-{
-	class_unregister(&omap_mbox_class);
-}
-module_exit(omap_mbox_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("omap mailbox: interrupt driven messaging");
-MODULE_AUTHOR("Toshihiro Kobayashi");
-MODULE_AUTHOR("Hiroshi DOYU");
diff --git a/drivers/mailbox/omap-mbox.h b/drivers/mailbox/omap-mbox.h
deleted file mode 100644
index 6cd38fc..0000000
--- a/drivers/mailbox/omap-mbox.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * omap-mbox.h: OMAP mailbox internal definitions
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef OMAP_MBOX_H
-#define OMAP_MBOX_H
-
-#include <linux/device.h>
-#include <linux/interrupt.h>
-#include <linux/kfifo.h>
-#include <linux/spinlock.h>
-#include <linux/workqueue.h>
-#include <linux/omap-mailbox.h>
-
-typedef int __bitwise omap_mbox_type_t;
-#define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
-#define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
-
-struct omap_mbox_ops {
-	omap_mbox_type_t	type;
-	int		(*startup)(struct omap_mbox *mbox);
-	void		(*shutdown)(struct omap_mbox *mbox);
-	/* fifo */
-	mbox_msg_t	(*fifo_read)(struct omap_mbox *mbox);
-	void		(*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
-	int		(*fifo_empty)(struct omap_mbox *mbox);
-	int		(*fifo_full)(struct omap_mbox *mbox);
-	/* irq */
-	void		(*enable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*disable_irq)(struct omap_mbox *mbox,
-						omap_mbox_irq_t irq);
-	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	/* ctx */
-	void		(*save_ctx)(struct omap_mbox *mbox);
-	void		(*restore_ctx)(struct omap_mbox *mbox);
-};
-
-struct omap_mbox_queue {
-	spinlock_t		lock;
-	struct kfifo		fifo;
-	struct work_struct	work;
-	struct tasklet_struct	tasklet;
-	struct omap_mbox	*mbox;
-	bool full;
-};
-
-struct omap_mbox {
-	const char		*name;
-	unsigned int		irq;
-	struct omap_mbox_queue	*txq, *rxq;
-	struct omap_mbox_ops	*ops;
-	struct device		*dev;
-	void			*priv;
-	int			use_count;
-	struct blocking_notifier_head	notifier;
-};
-
-int omap_mbox_register(struct device *parent, struct omap_mbox **);
-int omap_mbox_unregister(void);
-
-#endif /* OMAP_MBOX_H */
diff --git a/include/linux/omap-mailbox.h b/include/linux/omap-mailbox.h
index f8322d9..89fb606 100644
--- a/include/linux/omap-mailbox.h
+++ b/include/linux/omap-mailbox.h
@@ -9,6 +9,9 @@
 #ifndef OMAP_MAILBOX_H
 #define OMAP_MAILBOX_H
 
+#include <linux/compiler.h>
+#include <linux/mbox.h>
+
 typedef u32 mbox_msg_t;
 struct omap_mbox;
 
@@ -16,14 +19,42 @@ typedef int __bitwise omap_mbox_irq_t;
 #define IRQ_TX ((__force omap_mbox_irq_t) 1)
 #define IRQ_RX ((__force omap_mbox_irq_t) 2)
 
-int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
+static inline int __deprecated omap_mbox_msg_send(struct omap_mbox *mbox,
+		mbox_msg_t msg)
+{
+	struct mbox *m = (struct mbox *)mbox;
+	return mbox_put_message(m, &msg, sizeof(msg));
+}
+
+static inline struct omap_mbox *__deprecated omap_mbox_get(const char *name,
+		struct notifier_block *nb);
+{
+	return (struct omap_mbox *)mbox_request(NULL, name, nb);
+}
+
+static inline void __deprecated omap_mbox_put(struct omap_mbox *mbox,
+		struct notifier_block *nb)
+{
+	struct mbox *m = (struct mbox *)mbox;
+	mbox_release(m, nb);
+}
+
+static inline void __deprecated omap_mbox_save_ctx(struct omap_mbox *mbox)
+{
+}
+
+static inline void __deprecated omap_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+}
 
-struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
+static inline void __deprecated omap_mbox_enable_irq(struct omap_mbox *mbox,
+		omap_mbox_irq_t irq)
+{
+}
 
-void omap_mbox_save_ctx(struct omap_mbox *mbox);
-void omap_mbox_restore_ctx(struct omap_mbox *mbox);
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+static inline void __deprecated omap_mbox_disable_irq(struct omap_mbox *mbox,
+		omap_mbox_irq_t irq)
+{
+}
 
 #endif /* OMAP_MAILBOX_H */
-- 
1.8.1.5

