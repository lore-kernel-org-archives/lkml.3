Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHRRPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:15:31 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39041 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaHRRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:15:29 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Mon, 18 Aug 2014 10:08:18 -0700
Message-Id: <1408381705-3623-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra xHCI controller's firmware communicates requests to the host
processor through a mailbox interface.  While there is only a single
communication channel, messages sent by the controller can be divided
into two groups: those intended for the PHY driver and those intended
for the host-controller driver.  This mailbox driver exposes the two
channels and routes incoming messages to the appropriate channel based
on the command encoded in the message.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - Converted to common mailbox framework.
 - Removed useless polling sequences in TX path.
 - Moved xusb include from linux/ to soc/tegra/
---
 drivers/mailbox/Kconfig              |   3 +
 drivers/mailbox/Makefile             |   2 +
 drivers/mailbox/tegra-xusb-mailbox.c | 279 +++++++++++++++++++++++++++++++++++
 include/soc/tegra/xusb.h             |  45 ++++++
 4 files changed, 329 insertions(+)
 create mode 100644 drivers/mailbox/tegra-xusb-mailbox.c
 create mode 100644 include/soc/tegra/xusb.h

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 9fd9c67..97369c2 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -33,4 +33,7 @@ config OMAP_MBOX_KFIFO_SIZE
 	  Specify the default size of mailbox's kfifo buffers (bytes).
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
+
+config TEGRA_XUSB_MBOX
+	def_bool y if ARCH_TEGRA
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index 94ed7ce..7f0af9c 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_MAILBOX)		+= mailbox.o
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
 
 obj-$(CONFIG_OMAP2PLUS_MBOX)	+= omap-mailbox.o
+
+obj-$(CONFIG_TEGRA_XUSB_MBOX)	+= tegra-xusb-mailbox.o
diff --git a/drivers/mailbox/tegra-xusb-mailbox.c b/drivers/mailbox/tegra-xusb-mailbox.c
new file mode 100644
index 0000000..917d48e7
--- /dev/null
+++ b/drivers/mailbox/tegra-xusb-mailbox.c
@@ -0,0 +1,279 @@
+/*
+ * NVIDIA Tegra XUSB mailbox driver
+ *
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mailbox_controller.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <soc/tegra/xusb.h>
+
+#include <dt-bindings/mailbox/tegra-xusb-mailbox.h>
+
+#define XUSB_CFG_ARU_MBOX_CMD			0xe4
+#define  MBOX_FALC_INT_EN			BIT(27)
+#define  MBOX_PME_INT_EN			BIT(28)
+#define  MBOX_SMI_INT_EN			BIT(29)
+#define  MBOX_XHCI_INT_EN			BIT(30)
+#define  MBOX_INT_EN				BIT(31)
+#define XUSB_CFG_ARU_MBOX_DATA_IN		0xe8
+#define  CMD_DATA_SHIFT				0
+#define  CMD_DATA_MASK				0xffffff
+#define  CMD_TYPE_SHIFT				24
+#define  CMD_TYPE_MASK				0xff
+#define XUSB_CFG_ARU_MBOX_DATA_OUT		0xec
+#define XUSB_CFG_ARU_MBOX_OWNER			0xf0
+#define  MBOX_OWNER_NONE			0
+#define  MBOX_OWNER_FW				1
+#define  MBOX_OWNER_SW				2
+#define XUSB_CFG_ARU_SMI_INTR			0x428
+#define  MBOX_SMI_INTR_FW_HANG			BIT(1)
+#define  MBOX_SMI_INTR_EN			BIT(3)
+
+#define XUSB_MBOX_IDLE_TIMEOUT		20
+#define XUSB_MBOX_ACQUIRE_TIMEOUT	10
+
+struct tegra_xusb_mbox {
+	struct mbox_controller mbox;
+	int irq;
+	void __iomem *regs;
+	spinlock_t lock;
+};
+
+static inline u32 mbox_readl(struct tegra_xusb_mbox *mbox, unsigned long offset)
+{
+	return readl(mbox->regs + offset);
+}
+
+static inline void mbox_writel(struct tegra_xusb_mbox *mbox, u32 val,
+			       unsigned long offset)
+{
+	writel(val, mbox->regs + offset);
+}
+
+static inline u32 mbox_pack_msg(struct tegra_xusb_mbox_msg *msg)
+{
+	u32 val;
+
+	val = (msg->cmd & CMD_TYPE_MASK) << CMD_TYPE_SHIFT;
+	val |= (msg->data & CMD_DATA_MASK) << CMD_DATA_SHIFT;
+
+	return val;
+}
+
+static inline void mbox_unpack_msg(u32 val, struct tegra_xusb_mbox_msg *msg)
+{
+	msg->cmd = (val >> CMD_TYPE_SHIFT) & CMD_TYPE_MASK;
+	msg->data = (val >> CMD_DATA_SHIFT) & CMD_DATA_MASK;
+}
+
+static struct mbox_chan *mbox_cmd_to_chan(struct tegra_xusb_mbox *mbox, u32 cmd)
+{
+	switch (cmd) {
+	case MBOX_CMD_INC_FALC_CLOCK:
+	case MBOX_CMD_DEC_FALC_CLOCK:
+	case MBOX_CMD_INC_SSPI_CLOCK:
+	case MBOX_CMD_DEC_SSPI_CLOCK:
+	case MBOX_CMD_SET_BW:
+		return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_HOST];
+	case MBOX_CMD_SAVE_DFE_CTLE_CTX:
+	case MBOX_CMD_START_HSIC_IDLE:
+	case MBOX_CMD_STOP_HSIC_IDLE:
+		return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_PHY];
+	default:
+		return NULL;
+	}
+}
+
+static int tegra_xusb_mbox_send_data(struct mbox_chan *chan, void *data)
+{
+	struct tegra_xusb_mbox *mbox = dev_get_drvdata(chan->mbox->dev);
+	struct tegra_xusb_mbox_msg *msg = data;
+	unsigned long flags;
+	u32 reg, owner;
+
+	dev_dbg(mbox->mbox.dev, "TX message 0x%x:0x%x\n", msg->cmd, msg->data);
+
+	/* ACK/NAK must be sent with the controller as the mailbox owner */
+	if (msg->cmd == MBOX_CMD_ACK || msg->cmd == MBOX_CMD_NAK)
+		owner = MBOX_OWNER_FW;
+	else
+		owner = MBOX_OWNER_SW;
+
+	spin_lock_irqsave(&mbox->lock, flags);
+
+	/* Acquire mailbox */
+	if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE) {
+		dev_err(mbox->mbox.dev, "Mailbox not idle\n");
+		goto busy;
+	}
+	mbox_writel(mbox, owner, XUSB_CFG_ARU_MBOX_OWNER);
+	if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != owner) {
+		dev_err(mbox->mbox.dev, "Failed to acquire mailbox");
+		goto busy;
+	}
+
+	mbox_writel(mbox, mbox_pack_msg(msg), XUSB_CFG_ARU_MBOX_DATA_IN);
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
+	reg |= MBOX_INT_EN | MBOX_FALC_INT_EN;
+	mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
+
+	spin_unlock_irqrestore(&mbox->lock, flags);
+
+	return 0;
+busy:
+	spin_unlock_irqrestore(&mbox->lock, flags);
+	return -EBUSY;
+}
+
+static int tegra_xusb_mbox_startup(struct mbox_chan *chan)
+{
+	return 0;
+}
+
+static void tegra_xusb_mbox_shutdown(struct mbox_chan *chan)
+{
+}
+
+static bool tegra_xusb_mbox_last_tx_done(struct mbox_chan *chan)
+{
+	/*
+	 * Transmissions are assumed to be completed as soon as they are
+	 * written to the mailbox.
+	 */
+	return true;
+}
+
+static struct mbox_chan_ops tegra_xusb_mbox_chan_ops = {
+	.send_data = tegra_xusb_mbox_send_data,
+	.startup = tegra_xusb_mbox_startup,
+	.shutdown = tegra_xusb_mbox_shutdown,
+	.last_tx_done = tegra_xusb_mbox_last_tx_done,
+};
+
+static irqreturn_t tegra_xusb_mbox_irq(int irq, void *p)
+{
+	struct tegra_xusb_mbox *mbox = (struct tegra_xusb_mbox *)p;
+	struct mbox_chan *chan;
+	struct tegra_xusb_mbox_msg msg;
+	u32 reg;
+
+	spin_lock(&mbox->lock);
+
+	/* Clear mbox interrupts */
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_SMI_INTR);
+	if (reg & MBOX_SMI_INTR_FW_HANG)
+		dev_err(mbox->mbox.dev, "Controller firmware hang\n");
+	mbox_writel(mbox, reg, XUSB_CFG_ARU_SMI_INTR);
+
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_DATA_OUT);
+	mbox_unpack_msg(reg, &msg);
+
+	/*
+	 * Set the mailbox back to idle.  The recipient of the message is
+	 * responsible for sending an ACK/NAK, if necessary.
+	 */
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
+	reg &= ~MBOX_SMI_INT_EN;
+	mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
+	mbox_writel(mbox, MBOX_OWNER_NONE, XUSB_CFG_ARU_MBOX_OWNER);
+
+	spin_unlock(&mbox->lock);
+
+	dev_dbg(mbox->mbox.dev, "RX message 0x%x:0x%x\n", msg.cmd, msg.data);
+	chan = mbox_cmd_to_chan(mbox, msg.cmd);
+	if (chan)
+		mbox_chan_received_data(chan, &msg);
+	else
+		dev_err(mbox->mbox.dev, "Unexpected message: 0x%x:0x%x\n",
+			msg.cmd, msg.data);
+
+	return IRQ_HANDLED;
+}
+
+static struct of_device_id tegra_xusb_mbox_of_match[] = {
+	{ .compatible = "nvidia,tegra124-xusb-mbox" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_xusb_mbox_of_match);
+
+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
+{
+	struct tegra_xusb_mbox *mbox;
+	struct resource *res;
+	int ret;
+
+	mbox = devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, mbox);
+	spin_lock_init(&mbox->lock);
+
+	mbox->mbox.dev = &pdev->dev;
+	mbox->mbox.chans = devm_kcalloc(&pdev->dev, TEGRA_XUSB_MBOX_NUM_CHANS,
+					sizeof(*mbox->mbox.chans), GFP_KERNEL);
+	if (!mbox->mbox.chans)
+		return -ENOMEM;
+	mbox->mbox.num_chans = TEGRA_XUSB_MBOX_NUM_CHANS;
+	mbox->mbox.ops = &tegra_xusb_mbox_chan_ops;
+	mbox->mbox.txdone_poll = true;
+	mbox->mbox.txpoll_period = 0; /* no need to actually poll */
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	mbox->regs = devm_ioremap_nocache(&pdev->dev, res->start,
+					  resource_size(res));
+	if (!mbox->regs)
+		return -ENOMEM;
+
+	mbox->irq = platform_get_irq(pdev, 0);
+	if (mbox->irq < 0)
+		return mbox->irq;
+	ret = devm_request_irq(&pdev->dev, mbox->irq, tegra_xusb_mbox_irq, 0,
+			       dev_name(&pdev->dev), mbox);
+	if (ret < 0)
+		return ret;
+
+	ret = mbox_controller_register(&mbox->mbox);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to register mailbox: %d\n", ret);
+
+	return ret;
+}
+
+static int tegra_xusb_mbox_remove(struct platform_device *pdev)
+{
+	struct tegra_xusb_mbox *mbox = platform_get_drvdata(pdev);
+
+	mbox_controller_unregister(&mbox->mbox);
+
+	return 0;
+}
+
+static struct platform_driver tegra_xusb_mbox_driver = {
+	.probe	= tegra_xusb_mbox_probe,
+	.remove	= tegra_xusb_mbox_remove,
+	.driver	= {
+		.name = "tegra-xusb-mbox",
+		.of_match_table = of_match_ptr(tegra_xusb_mbox_of_match),
+	},
+};
+module_platform_driver(tegra_xusb_mbox_driver);
+
+MODULE_AUTHOR("Andrew Bresticker <abrestic@chromium.org>");
+MODULE_DESCRIPTION("NVIDIA Tegra XUSB mailbox driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tegra-xusb-mailbox");
diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
new file mode 100644
index 0000000..8efef8c
--- /dev/null
+++ b/include/soc/tegra/xusb.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#ifndef __SOC_TEGRA_XUSB_H__
+#define __SOC_TEGRA_XUSB_H__
+
+#define TEGRA_XUSB_MBOX_NUM_CHANS 2 /* host + phy */
+
+/* Command requests from the firmware */
+enum tegra_xusb_mbox_cmd {
+	MBOX_CMD_MSG_ENABLED = 1,
+	MBOX_CMD_INC_FALC_CLOCK,
+	MBOX_CMD_DEC_FALC_CLOCK,
+	MBOX_CMD_INC_SSPI_CLOCK,
+	MBOX_CMD_DEC_SSPI_CLOCK,
+	MBOX_CMD_SET_BW, /* no ACK/NAK required */
+	MBOX_CMD_SET_SS_PWR_GATING,
+	MBOX_CMD_SET_SS_PWR_UNGATING,
+	MBOX_CMD_SAVE_DFE_CTLE_CTX,
+	MBOX_CMD_AIRPLANE_MODE_ENABLED, /* unused */
+	MBOX_CMD_AIRPLANE_MODE_DISABLED, /* unused */
+	MBOX_CMD_START_HSIC_IDLE,
+	MBOX_CMD_STOP_HSIC_IDLE,
+	MBOX_CMD_DBC_WAKE_STACK, /* unused */
+	MBOX_CMD_HSIC_PRETEND_CONNECT,
+
+	MBOX_CMD_MAX,
+
+	/* Response message to above commands */
+	MBOX_CMD_ACK = 128,
+	MBOX_CMD_NAK
+};
+
+struct tegra_xusb_mbox_msg {
+	u32 cmd;
+	u32 data;
+};
+
+#endif /* __SOC_TEGRA_XUSB_H__ */
-- 
2.1.0.rc2.206.gedb03e5

