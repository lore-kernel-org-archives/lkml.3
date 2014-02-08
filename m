Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBHAtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:45 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3344 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbaBHAtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:32 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 6/6] mailbox: omap2+: move to common mbox framework
Date: Fri, 7 Feb 2014 16:50:19 -0800
Message-ID: <1391820619-25487-7-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 drivers/mailbox/Kconfig         |   1 -
 drivers/mailbox/mailbox-omap2.c | 315 +++++++++++++++++-----------------------
 2 files changed, 132 insertions(+), 184 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index ae6b09b..a592a5a 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -27,7 +27,6 @@ config OMAP1_MBOX
 config OMAP2PLUS_MBOX
 	tristate "OMAP2+ Mailbox framework support"
 	depends on ARCH_OMAP2PLUS
-	depends on BROKEN
 	help
 	  Mailbox implementation for OMAP family chips with hardware for
 	  interprocessor communication involving DSP, IVA1.0 and IVA2 in
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 42d2b89..7ddde19 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -18,8 +18,8 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mailbox-omap.h>
-
-#include "omap-mbox.h"
+#include <linux/interrupt.h>
+#include <linux/mbox.h>
 
 #define MAILBOX_REVISION		0x000
 #define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
@@ -42,192 +42,165 @@
 #define MBOX_NR_REGS			(MBOX_REG_SIZE / sizeof(u32))
 #define OMAP4_MBOX_NR_REGS		(OMAP4_MBOX_REG_SIZE / sizeof(u32))
 
-static void __iomem *mbox_base;
-
 struct omap_mbox2_fifo {
 	unsigned long msg;
 	unsigned long fifo_stat;
 	unsigned long msg_stat;
 };
 
+struct omap2_mbox;
+
 struct omap_mbox2_priv {
+	struct omap2_mbox *mbox;
+	int irq;
+
 	struct omap_mbox2_fifo tx_fifo;
 	struct omap_mbox2_fifo rx_fifo;
 	unsigned long irqenable;
 	unsigned long irqstatus;
 	u32 newmsg_bit;
 	u32 notfull_bit;
-	u32 ctx[OMAP4_MBOX_NR_REGS];
 	unsigned long irqdisable;
 	u32 intr_type;
 };
 
-static inline unsigned int mbox_read_reg(size_t ofs)
-{
-	return __raw_readl(mbox_base + ofs);
-}
+struct omap2_mbox {
+	struct mbox_adapter adapter;
+	struct completion completion;
+	void __iomem *base;
+	atomic_t active;
+	struct omap_mbox2_priv *priv;
+};
 
-static inline void mbox_write_reg(u32 val, size_t ofs)
+static inline unsigned int mbox_read_reg(void __iomem *base, size_t ofs)
 {
-	__raw_writel(val, mbox_base + ofs);
+	return __raw_readl(base + ofs);
 }
 
-/* Mailbox H/W preparations */
-static int omap2_mbox_startup(struct omap_mbox *mbox)
+static inline void mbox_write_reg(void __iomem *base, u32 val, size_t ofs)
 {
-	u32 l;
-
-	pm_runtime_enable(mbox->dev->parent);
-	pm_runtime_get_sync(mbox->dev->parent);
-
-	l = mbox_read_reg(MAILBOX_REVISION);
-	pr_debug("omap mailbox rev %d.%d\n", (l & 0xf0) >> 4, (l & 0x0f));
-
-	return 0;
+	__raw_writel(val, base + ofs);
 }
 
-static void omap2_mbox_shutdown(struct omap_mbox *mbox)
+static int omap2_mbox_request(struct mbox_adapter *adap,
+		struct mbox_channel *chan)
 {
-	pm_runtime_put_sync(mbox->dev->parent);
-	pm_runtime_disable(mbox->dev->parent);
-}
+	struct omap_mbox2_priv *p;
+	struct omap2_mbox *mbox;
+	u32 enable;
 
-/* Mailbox FIFO handle functions */
-static mbox_msg_t omap2_mbox_fifo_read(struct omap_mbox *mbox)
-{
-	struct omap_mbox2_fifo *fifo =
-		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
-	return (mbox_msg_t) mbox_read_reg(fifo->msg);
-}
+	mbox = container_of(adap, struct omap2_mbox, adapter);
+	p = &mbox->priv[chan->id];
 
-static void omap2_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	struct omap_mbox2_fifo *fifo =
-		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
-	mbox_write_reg(msg, fifo->msg);
-}
+	if (atomic_inc_return(&mbox->active) == 1) {
+		pm_runtime_enable(adap->dev);
+		pm_runtime_get_sync(adap->dev);
+	}
 
-static int omap2_mbox_fifo_empty(struct omap_mbox *mbox)
-{
-	struct omap_mbox2_fifo *fifo =
-		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
-	return (mbox_read_reg(fifo->msg_stat) == 0);
-}
+	enable = mbox_read_reg(mbox->base, p->irqenable);
+	enable |= p->notfull_bit | p->newmsg_bit;
+	mbox_write_reg(mbox->base, enable, p->irqenable);
 
-static int omap2_mbox_fifo_full(struct omap_mbox *mbox)
-{
-	struct omap_mbox2_fifo *fifo =
-		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
-	return mbox_read_reg(fifo->fifo_stat);
+	return 0;
 }
 
-/* Mailbox IRQ handle functions */
-static void omap2_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static int omap2_mbox_release(struct mbox_adapter *adap,
+		struct mbox_channel *chan)
 {
-	struct omap_mbox2_priv *p = mbox->priv;
-	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+	struct omap_mbox2_priv *p;
+	struct omap2_mbox *mbox;
+	u32 disable;
 
-	l = mbox_read_reg(p->irqenable);
-	l |= bit;
-	mbox_write_reg(l, p->irqenable);
-}
+	mbox = container_of(adap, struct omap2_mbox, adapter);
+	p = &mbox->priv[chan->id];
 
-static void omap2_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	struct omap_mbox2_priv *p = mbox->priv;
-	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+	disable = p->notfull_bit | p->newmsg_bit;
 
 	/*
 	 * Read and update the interrupt configuration register for pre-OMAP4.
 	 * OMAP4 and later SoCs have a dedicated interrupt disabling register.
 	 */
 	if (!p->intr_type)
-		bit = mbox_read_reg(p->irqdisable) & ~bit;
+		disable = mbox_read_reg(mbox->base, p->irqdisable) & ~disable;
+	mbox_write_reg(mbox->base, disable, p->irqdisable);
 
-	mbox_write_reg(bit, p->irqdisable);
+	if (atomic_dec_return(&mbox->active) == 0) {
+		pm_runtime_put_sync(adap->dev);
+		pm_runtime_disable(adap->dev);
+	}
+	return 0;
 }
 
-static void omap2_mbox_ack_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static int omap2_mbox_put_message(struct mbox_adapter *adap,
+		struct mbox_channel *chan, const void *data, unsigned int len)
 {
-	struct omap_mbox2_priv *p = mbox->priv;
-	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+	struct omap_mbox2_fifo *fifo;
+	struct omap2_mbox *mbox;
+	int ret;
+	u32 msg;
 
-	mbox_write_reg(bit, p->irqstatus);
+	if (len != sizeof(msg))
+		return -EINVAL;
 
-	/* Flush posted write for irq status to avoid spurious interrupts */
-	mbox_read_reg(p->irqstatus);
-}
+	msg = ((u32 *)data)[0];
+	mbox = container_of(adap, struct omap2_mbox, adapter);
+	fifo = &mbox->priv[chan->id].tx_fifo;
 
-static int omap2_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	struct omap_mbox2_priv *p = mbox->priv;
-	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
-	u32 enable = mbox_read_reg(p->irqenable);
-	u32 status = mbox_read_reg(p->irqstatus);
+	while (mbox_read_reg(mbox->base, fifo->fifo_stat)) {
+		ret = wait_for_completion_timeout(&mbox->completion,
+				msecs_to_jiffies(2));
+		if (!ret)
+			return -ETIMEDOUT;
+	}
 
-	return (int)(enable & status & bit);
-}
+	mbox_write_reg(mbox->base, msg, fifo->msg);
 
-static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
-{
-	int i;
-	struct omap_mbox2_priv *p = mbox->priv;
-	int nr_regs;
-
-	if (p->intr_type)
-		nr_regs = OMAP4_MBOX_NR_REGS;
-	else
-		nr_regs = MBOX_NR_REGS;
-	for (i = 0; i < nr_regs; i++) {
-		p->ctx[i] = mbox_read_reg(i * sizeof(u32));
-
-		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
-			i, p->ctx[i]);
-	}
+	return 0;
 }
 
-static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
+static irqreturn_t omap2_mbox_irq(int irq, void *dev)
 {
-	int i;
-	struct omap_mbox2_priv *p = mbox->priv;
-	int nr_regs;
-
-	if (p->intr_type)
-		nr_regs = OMAP4_MBOX_NR_REGS;
-	else
-		nr_regs = MBOX_NR_REGS;
-	for (i = 0; i < nr_regs; i++) {
-		mbox_write_reg(p->ctx[i], i * sizeof(u32));
-
-		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
-			i, p->ctx[i]);
+	struct mbox_channel *chan;
+	struct omap_mbox2_priv *p = dev;
+	struct omap2_mbox *mbox;
+	u32 status;
+
+	mbox = p->mbox;
+	status = mbox_read_reg(mbox->base, p->irqstatus);
+	status &= mbox_read_reg(mbox->base, p->irqenable);
+
+	chan = &mbox->adapter.channels[p - mbox->priv];
+
+	if (status & p->notfull_bit) {
+		complete(&mbox->completion);
+		mbox_write_reg(mbox->base, p->newmsg_bit, p->notfull_bit);
+	} else if (status & p->newmsg_bit) {
+		u32 msg = mbox_read_reg(mbox->base, p->rx_fifo.msg);
+		mbox_channel_notify(chan, &msg, sizeof(msg));
+		mbox_write_reg(mbox->base, p->newmsg_bit, p->irqstatus);
 	}
+
+	/* Flush posted write for irq status to avoid spurious interrupts */
+	mbox_read_reg(mbox->base, p->irqstatus);
+
+	return IRQ_HANDLED;
 }
 
-static struct omap_mbox_ops omap2_mbox_ops = {
-	.type		= OMAP_MBOX_TYPE2,
-	.startup	= omap2_mbox_startup,
-	.shutdown	= omap2_mbox_shutdown,
-	.fifo_read	= omap2_mbox_fifo_read,
-	.fifo_write	= omap2_mbox_fifo_write,
-	.fifo_empty	= omap2_mbox_fifo_empty,
-	.fifo_full	= omap2_mbox_fifo_full,
-	.enable_irq	= omap2_mbox_enable_irq,
-	.disable_irq	= omap2_mbox_disable_irq,
-	.ack_irq	= omap2_mbox_ack_irq,
-	.is_irq		= omap2_mbox_is_irq,
-	.save_ctx	= omap2_mbox_save_ctx,
-	.restore_ctx	= omap2_mbox_restore_ctx,
+static const struct mbox_adapter_ops omap2_mbox_ops = {
+	.owner = THIS_MODULE,
+	.request = omap2_mbox_request,
+	.release = omap2_mbox_release,
+	.put_message = omap2_mbox_put_message,
 };
 
 static int omap2_mbox_probe(struct platform_device *pdev)
 {
-	struct resource *mem;
-	int ret;
-	struct omap_mbox **list, *mbox, *mboxblk;
-	struct omap_mbox2_priv *priv, *privblk;
 	struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
+	struct omap_mbox2_priv *priv, *privblk;
 	struct omap_mbox_dev_info *info;
+	struct omap2_mbox *mbox;
+	struct resource *mem;
+	int ret;
 	int i;
 
 	if (!pdata || !pdata->info_cnt || !pdata->info) {
@@ -235,25 +208,22 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	/* allocate one extra for marking end of list */
-	list = kzalloc((pdata->info_cnt + 1) * sizeof(*list), GFP_KERNEL);
-	if (!list)
+	mbox = devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
+	if (!mbox)
 		return -ENOMEM;
 
-	mboxblk = mbox = kzalloc(pdata->info_cnt * sizeof(*mbox), GFP_KERNEL);
-	if (!mboxblk) {
-		ret = -ENOMEM;
-		goto free_list;
-	}
+	atomic_set(&mbox->active, 0);
+	init_completion(&mbox->completion);
 
-	privblk = priv = kzalloc(pdata->info_cnt * sizeof(*priv), GFP_KERNEL);
-	if (!privblk) {
-		ret = -ENOMEM;
-		goto free_mboxblk;
-	}
+	privblk = devm_kzalloc(&pdev->dev,
+			pdata->info_cnt * sizeof(*priv), GFP_KERNEL);
+	if (!privblk)
+		return -ENOMEM;
 
+	priv = privblk;
 	info = pdata->info;
 	for (i = 0; i < pdata->info_cnt; i++, info++, priv++) {
+		priv->mbox = mbox;
 		priv->tx_fifo.msg = MAILBOX_MESSAGE(info->tx_id);
 		priv->tx_fifo.fifo_stat = MAILBOX_FIFOSTATUS(info->tx_id);
 		priv->rx_fifo.msg =  MAILBOX_MESSAGE(info->rx_id);
@@ -272,61 +242,40 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 		}
 		priv->intr_type = pdata->intr_type;
 
-		mbox->priv = priv;
-		mbox->name = info->name;
-		mbox->ops = &omap2_mbox_ops;
-		mbox->irq = platform_get_irq(pdev, info->irq_id);
-		if (mbox->irq < 0) {
-			ret = mbox->irq;
-			goto free_privblk;
-		}
-		list[i] = mbox++;
+		priv->irq = platform_get_irq(pdev, info->irq_id);
+		if (priv->irq < 0)
+			return priv->irq;
+
+		ret = devm_request_irq(&pdev->dev, priv->irq,
+				omap2_mbox_irq, IRQF_SHARED, info->name, priv);
+		if (ret < 0)
+			return ret;
 	}
+	mbox->priv = privblk;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		ret = -ENOENT;
-		goto free_privblk;
-	}
+	if (!mem)
+		return -ENOENT;
 
-	mbox_base = ioremap(mem->start, resource_size(mem));
-	if (!mbox_base) {
-		ret = -ENOMEM;
-		goto free_privblk;
-	}
+	mbox->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!mbox->base)
+		return -ENOMEM;
 
-	ret = omap_mbox_register(&pdev->dev, list);
+	mbox->adapter.nchannels = pdata->info_cnt;
+	mbox->adapter.ops = &omap2_mbox_ops;
+	mbox->adapter.dev = &pdev->dev;
+	ret = mbox_adapter_add(&mbox->adapter);
 	if (ret)
-		goto unmap_mbox;
-	platform_set_drvdata(pdev, list);
+		return ret;
+	platform_set_drvdata(pdev, mbox);
 
 	return 0;
-
-unmap_mbox:
-	iounmap(mbox_base);
-free_privblk:
-	kfree(privblk);
-free_mboxblk:
-	kfree(mboxblk);
-free_list:
-	kfree(list);
-	return ret;
 }
 
 static int omap2_mbox_remove(struct platform_device *pdev)
 {
-	struct omap_mbox2_priv *privblk;
-	struct omap_mbox **list = platform_get_drvdata(pdev);
-	struct omap_mbox *mboxblk = list[0];
-
-	privblk = mboxblk->priv;
-	omap_mbox_unregister();
-	iounmap(mbox_base);
-	kfree(privblk);
-	kfree(mboxblk);
-	kfree(list);
-
-	return 0;
+	struct omap2_mbox *mbox = platform_get_drvdata(pdev);
+	return mbox_adapter_remove(&mbox->adapter);
 }
 
 static struct platform_driver omap2_mbox_driver = {
-- 
1.8.1.5

