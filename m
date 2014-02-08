Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaBHAtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:43 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3323 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbaBHAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:26 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 5/6] mailbox: omap1: move to common mbox framework
Date: Fri, 7 Feb 2014 16:50:18 -0800
Message-ID: <1391820619-25487-6-git-send-email-courtney.cavin@sonymobile.com>
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
 drivers/mailbox/mailbox-omap1.c | 153 +++++++++++++++++++---------------------
 2 files changed, 73 insertions(+), 81 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 6befc6e..ae6b09b 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -19,7 +19,6 @@ config PL320_MBOX
 config OMAP1_MBOX
 	tristate "OMAP1 Mailbox framework support"
 	depends on ARCH_OMAP1
-	depends on BROKEN
 	help
 	  Mailbox implementation for OMAP chips with hardware for
 	  interprocessor communication involving DSP in OMAP1. Say Y here
diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 9001b76..474890d 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -12,10 +12,10 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/mbox.h>
 #include <linux/io.h>
 
-#include "omap-mbox.h"
-
 #define MAILBOX_ARM2DSP1		0x00
 #define MAILBOX_ARM2DSP1b		0x04
 #define MAILBOX_DSP2ARM1		0x08
@@ -26,8 +26,6 @@
 #define MAILBOX_DSP2ARM1_Flag		0x1c
 #define MAILBOX_DSP2ARM2_Flag		0x20
 
-static void __iomem *mbox_base;
-
 struct omap_mbox1_fifo {
 	unsigned long cmd;
 	unsigned long data;
@@ -39,90 +37,70 @@ struct omap_mbox1_priv {
 	struct omap_mbox1_fifo rx_fifo;
 };
 
-static inline int mbox_read_reg(size_t ofs)
+struct omap1_mbox {
+	struct mbox_adapter adapter;
+	struct omap_mbox1_priv priv;
+	void __iomem *base;
+	int irq;
+};
+
+static inline int mbox_read_reg(void __iomem *base, size_t ofs)
 {
-	return __raw_readw(mbox_base + ofs);
+	return __raw_readw(base + ofs);
 }
 
-static inline void mbox_write_reg(u32 val, size_t ofs)
+static inline void mbox_write_reg(void __iomem *base, u32 val, size_t ofs)
 {
-	__raw_writew(val, mbox_base + ofs);
+	__raw_writew(val, base + ofs);
 }
 
-/* msg */
-static mbox_msg_t omap1_mbox_fifo_read(struct omap_mbox *mbox)
+static int omap1_mbox_put_message(struct mbox_adapter *adap,
+		struct mbox_channel *chan, const void *data, unsigned int len)
+
 {
-	struct omap_mbox1_fifo *fifo =
-		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
-	mbox_msg_t msg;
+	struct omap_mbox1_fifo *fifo;
+	struct omap1_mbox *mbox;
+	u32 msg;
+	int i;
 
-	msg = mbox_read_reg(fifo->data);
-	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
+	if (len != sizeof(msg))
+		return -EINVAL;
 
-	return msg;
-}
+	msg = ((u32 *)data)[0];
+	mbox = container_of(adap, struct omap1_mbox, adapter);
+	fifo = &mbox->priv.tx_fifo;
 
-static void
-omap1_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	struct omap_mbox1_fifo *fifo =
-		&((struct omap_mbox1_priv *)mbox->priv)->tx_fifo;
+	/* wait for available space */
+	for (i = 0; i < 100 && mbox_read_reg(mbox->base, fifo->flag); ++i)
+		usleep_range(10, 20);
+	if (i == 100)
+		return -ETIMEDOUT;
 
-	mbox_write_reg(msg & 0xffff, fifo->data);
-	mbox_write_reg(msg >> 16, fifo->cmd);
-}
+	mbox_write_reg(mbox->base, msg & 0xffff, fifo->data);
+	mbox_write_reg(mbox->base, msg >> 16, fifo->cmd);
 
-static int omap1_mbox_fifo_empty(struct omap_mbox *mbox)
-{
 	return 0;
 }
 
-static int omap1_mbox_fifo_full(struct omap_mbox *mbox)
+static irqreturn_t omap1_mbox_irq(int irq, void *dev)
 {
-	struct omap_mbox1_fifo *fifo =
-		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
+	struct omap1_mbox *mbox = dev;
+	struct omap_mbox1_fifo *fifo;
+	u32 msg;
 
-	return mbox_read_reg(fifo->flag);
-}
+	fifo = &mbox->priv.rx_fifo;
+	msg = mbox_read_reg(mbox->base, fifo->data);
+	msg |= ((u32)mbox_read_reg(mbox->base, fifo->cmd)) << 16;
 
-/* irq */
-static void
-omap1_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (irq == IRQ_RX)
-		enable_irq(mbox->irq);
-}
+	mbox_channel_notify(&mbox->adapter.channels[0], &msg, sizeof(msg));
 
-static void
-omap1_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (irq == IRQ_RX)
-		disable_irq(mbox->irq);
+	return IRQ_HANDLED;
 }
 
-static int
-omap1_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (irq == IRQ_TX)
-		return 0;
-	return 1;
-}
-
-static struct omap_mbox_ops omap1_mbox_ops = {
-	.type		= OMAP_MBOX_TYPE1,
-	.fifo_read	= omap1_mbox_fifo_read,
-	.fifo_write	= omap1_mbox_fifo_write,
-	.fifo_empty	= omap1_mbox_fifo_empty,
-	.fifo_full	= omap1_mbox_fifo_full,
-	.enable_irq	= omap1_mbox_enable_irq,
-	.disable_irq	= omap1_mbox_disable_irq,
-	.is_irq		= omap1_mbox_is_irq,
-};
-
 /* FIXME: the following struct should be created automatically by the user id */
 
 /* DSP */
-static struct omap_mbox1_priv omap1_mbox_dsp_priv = {
+static const struct omap_mbox1_priv omap1_mbox_dsp_priv = {
 	.tx_fifo = {
 		.cmd	= MAILBOX_ARM2DSP1b,
 		.data	= MAILBOX_ARM2DSP1,
@@ -135,44 +113,59 @@ static struct omap_mbox1_priv omap1_mbox_dsp_priv = {
 	},
 };
 
-static struct omap_mbox mbox_dsp_info = {
-	.name	= "dsp",
-	.ops	= &omap1_mbox_ops,
-	.priv	= &omap1_mbox_dsp_priv,
+static const struct mbox_adapter_ops omap1_mbox_ops = {
+	.owner = THIS_MODULE,
+	.put_message = omap1_mbox_put_message,
 };
 
-static struct omap_mbox *omap1_mboxes[] = { &mbox_dsp_info, NULL };
-
 static int omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
+	struct omap1_mbox *mbox;
 	int ret;
-	struct omap_mbox **list;
 
-	list = omap1_mboxes;
-	list[0]->irq = platform_get_irq_byname(pdev, "dsp");
+	mbox = devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
+	if (mbox == NULL)
+		return -ENOMEM;
+
+	mbox->irq = platform_get_irq_byname(pdev, "dsp");
+	if (mbox->irq < 0)
+		return -EINVAL;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
 		return -ENOENT;
 
-	mbox_base = ioremap(mem->start, resource_size(mem));
-	if (!mbox_base)
+	mbox->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!mbox->base)
 		return -ENOMEM;
 
-	ret = omap_mbox_register(&pdev->dev, list);
-	if (ret) {
-		iounmap(mbox_base);
+	mbox->priv = omap1_mbox_dsp_priv;
+	mbox->adapter.dev = &pdev->dev;
+	mbox->adapter.ops = &omap1_mbox_ops;
+	mbox->adapter.nchannels = 1;
+
+	ret = mbox_adapter_add(&mbox->adapter);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(&pdev->dev, mbox->irq, omap1_mbox_irq, 0,
+			dev_name(&pdev->dev), mbox);
+	if (ret < 0) {
+		mbox_adapter_remove(&mbox->adapter);
 		return ret;
 	}
+	platform_set_drvdata(pdev, mbox);
 
 	return 0;
 }
 
 static int omap1_mbox_remove(struct platform_device *pdev)
 {
-	omap_mbox_unregister();
-	iounmap(mbox_base);
+	struct omap1_mbox *mbox;
+
+	mbox = platform_get_drvdata(pdev);
+	mbox_adapter_remove(&mbox->adapter);
 	return 0;
 }
 
-- 
1.8.1.5

