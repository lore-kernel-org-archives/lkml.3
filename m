Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaFRGQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:16:41 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:63320 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbaFRGQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:16:35 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Tue, 17 Jun 2014 23:16:13 -0700
Message-Id: <1403072180-4944-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra XHCI controller communicates requests to the host through
a mailbox interface.  Host drivers which can handle these requests,
such as the Tegra XUSB pad controller driver and upcoming Tegra XHCI
host controller driver, can send messages and register to be notified
of incoming messages.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mailbox/Kconfig           |   7 +
 drivers/mailbox/Makefile          |   2 +
 drivers/mailbox/tegra-xusb-mbox.c | 308 ++++++++++++++++++++++++++++++++++++++
 include/linux/tegra-xusb-mbox.h   |  98 ++++++++++++
 4 files changed, 415 insertions(+)
 create mode 100644 drivers/mailbox/tegra-xusb-mbox.c
 create mode 100644 include/linux/tegra-xusb-mbox.h

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index c8b5c13..510c44a 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -50,4 +50,11 @@ config OMAP_MBOX_KFIFO_SIZE
 	  Specify the default size of mailbox's kfifo buffers (bytes).
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
+
+config TEGRA_XUSB_MBOX
+	bool "NVIDIA Tegra XUSB mailbox support"
+	depends on ARCH_TEGRA
+	help
+	  Mailbox driver used for communication with the firmware on the
+	  on-chip XHCI controller present on NVIDIA Tegra124 SoCs.
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index e0facb3..8cc53ef 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_OMAP1_MBOX)	+= mailbox_omap1.o
 mailbox_omap1-objs		:= mailbox-omap1.o
 obj-$(CONFIG_OMAP2PLUS_MBOX)	+= mailbox_omap2.o
 mailbox_omap2-objs		:= mailbox-omap2.o
+
+obj-$(CONFIG_TEGRA_XUSB_MBOX)	+= tegra-xusb-mbox.o
diff --git a/drivers/mailbox/tegra-xusb-mbox.c b/drivers/mailbox/tegra-xusb-mbox.c
new file mode 100644
index 0000000..a4d2929
--- /dev/null
+++ b/drivers/mailbox/tegra-xusb-mbox.c
@@ -0,0 +1,308 @@
+/*
+ * NVIDIA Tegra XUSB mailbox driver
+ *
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/tegra-xusb-mbox.h>
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
+	struct device *dev;
+	int irq;
+	struct raw_notifier_head notifiers;
+	struct mutex lock;
+	void __iomem *regs;
+};
+
+static struct platform_driver tegra_xusb_mbox_driver;
+
+int tegra_xusb_mbox_register_notifier(struct tegra_xusb_mbox *mbox,
+				      struct notifier_block *nb)
+{
+	int ret;
+
+	mutex_lock(&mbox->lock);
+	ret = raw_notifier_chain_register(&mbox->notifiers, nb);
+	mutex_unlock(&mbox->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(tegra_xusb_mbox_register_notifier);
+
+void tegra_xusb_mbox_unregister_notifier(struct tegra_xusb_mbox *mbox,
+					 struct notifier_block *nb)
+{
+	mutex_lock(&mbox->lock);
+	raw_notifier_chain_unregister(&mbox->notifiers, nb);
+	mutex_unlock(&mbox->lock);
+}
+EXPORT_SYMBOL(tegra_xusb_mbox_unregister_notifier);
+
+static int tegra_xusb_mbox_match_node(struct device *dev, void *data)
+{
+	struct device_node *np = data;
+
+	return dev->of_node == np;
+}
+
+struct tegra_xusb_mbox *
+tegra_xusb_mbox_lookup_by_phandle(struct device_node *np, const char *prop)
+{
+	struct tegra_xusb_mbox *mbox;
+	struct device_node *mbox_np;
+	struct device *dev;
+
+	mbox_np = of_parse_phandle(np, prop, 0);
+	if (!mbox_np)
+		return ERR_PTR(-ENODEV);
+
+	dev = driver_find_device(&tegra_xusb_mbox_driver.driver, NULL, mbox_np,
+				 tegra_xusb_mbox_match_node);
+	if (!dev) {
+		mbox = ERR_PTR(-EPROBE_DEFER);
+		goto out;
+	}
+	mbox = dev_get_drvdata(dev);
+out:
+	of_node_put(mbox_np);
+	return mbox;
+}
+EXPORT_SYMBOL(tegra_xusb_mbox_lookup_by_phandle);
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
+static inline u32 mbox_pack_msg(u32 cmd, u32 data)
+{
+	u32 msg;
+
+	msg = (cmd & CMD_TYPE_MASK) << CMD_TYPE_SHIFT;
+	msg |= (data & CMD_DATA_MASK) << CMD_DATA_SHIFT;
+
+	return msg;
+}
+
+static inline void mbox_unpack_msg(u32 msg, u32 *cmd, u32 *data)
+{
+	*cmd = (msg >> CMD_TYPE_SHIFT) & CMD_TYPE_MASK;
+	*data = (msg >> CMD_DATA_SHIFT) & CMD_DATA_MASK;
+}
+
+int tegra_xusb_mbox_send(struct tegra_xusb_mbox *mbox,
+			 enum tegra_xusb_mbox_cmd type, u32 data)
+{
+	unsigned long timeout;
+	u32 reg;
+
+	dev_dbg(mbox->dev, "MBOX send message 0x%x:0x%x\n", type, data);
+	mutex_lock(&mbox->lock);
+
+	/* Wait for mailbox to become idle */
+	timeout = jiffies + msecs_to_jiffies(XUSB_MBOX_IDLE_TIMEOUT);
+	while ((mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE)
+	       && time_is_after_jiffies(timeout)) {
+		mutex_unlock(&mbox->lock);
+		usleep_range(100, 200);
+		mutex_lock(&mbox->lock);
+	}
+	if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE) {
+		dev_err(mbox->dev, "Mailbox failed to go idle\n");
+		goto timeout;
+	}
+
+	/* Acquire mailbox */
+	timeout = jiffies + msecs_to_jiffies(XUSB_MBOX_ACQUIRE_TIMEOUT);
+	mbox_writel(mbox, MBOX_OWNER_SW, XUSB_CFG_ARU_MBOX_OWNER);
+	while ((mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_SW) &&
+	       time_is_after_jiffies(timeout)) {
+		mutex_unlock(&mbox->lock);
+		usleep_range(100, 200);
+		mutex_lock(&mbox->lock);
+		mbox_writel(mbox, MBOX_OWNER_SW, XUSB_CFG_ARU_MBOX_OWNER);
+	}
+	if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_SW) {
+		dev_err(mbox->dev, "Acquire mailbox timeout\n");
+		goto timeout;
+	}
+
+	mbox_writel(mbox, mbox_pack_msg(type, data), XUSB_CFG_ARU_MBOX_DATA_IN);
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
+	reg |= MBOX_INT_EN | MBOX_FALC_INT_EN;
+	mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
+
+	mutex_unlock(&mbox->lock);
+
+	return 0;
+timeout:
+	mutex_unlock(&mbox->lock);
+	return -ETIMEDOUT;
+}
+
+static irqreturn_t tegra_xusb_mbox_irq(int irq, void *p)
+{
+	struct tegra_xusb_mbox *mbox = (struct tegra_xusb_mbox *)p;
+	u32 resp = 0, cmd_in, data_in, reg;
+
+	mutex_lock(&mbox->lock);
+
+	/* Clear mbox interrupts */
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_SMI_INTR);
+	if (reg & MBOX_SMI_INTR_FW_HANG)
+		dev_err(mbox->dev, "Hang up inside firmware\n");
+	mbox_writel(mbox, reg, XUSB_CFG_ARU_SMI_INTR);
+
+	/* Get the mbox message from firmware */
+	reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_DATA_OUT);
+	mbox_unpack_msg(reg, &cmd_in, &data_in);
+
+	/* Decode the message and call the notifiers */
+	dev_dbg(mbox->dev, "MBOX receive message 0x%x:0x%x\n", cmd_in, data_in);
+	if (cmd_in < MBOX_CMD_MAX) {
+		struct tegra_xusb_mbox_msg msg;
+
+		msg.data_in = data_in;
+		msg.cmd_out = 0;
+		msg.data_out = 0;
+		raw_notifier_call_chain(&mbox->notifiers, cmd_in, &msg);
+		if (msg.cmd_out)
+			resp = mbox_pack_msg(msg.cmd_out, msg.data_out);
+	} else if (cmd_in == MBOX_CMD_ACK) {
+		dev_dbg(mbox->dev, "Firmware responds with ACK\n");
+	} else if (cmd_in == MBOX_CMD_NAK) {
+		dev_err(mbox->dev, "Firmware responds with NAK\n");
+	} else {
+		dev_err(mbox->dev, "Invalid command: 0x%x\n", cmd_in);
+	}
+
+	if (resp) {
+		/* Send ACK/NAK to firmware */
+		mbox_writel(mbox, resp, XUSB_CFG_ARU_MBOX_DATA_IN);
+		reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
+		reg |= MBOX_INT_EN | MBOX_FALC_INT_EN;
+		mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
+	} else {
+		/* Clear MBOX_SMI_INT_EN bit */
+		reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
+		reg &= ~MBOX_SMI_INT_EN;
+		mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
+		/* Clear mailbox ownership */
+		mbox_writel(mbox, MBOX_OWNER_NONE, XUSB_CFG_ARU_MBOX_OWNER);
+	}
+
+	mutex_unlock(&mbox->lock);
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
+	mbox->dev = &pdev->dev;
+	mutex_init(&mbox->lock);
+	RAW_INIT_NOTIFIER_HEAD(&mbox->notifiers);
+	platform_set_drvdata(pdev, mbox);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	mbox->regs = devm_ioremap_nocache(mbox->dev, res->start,
+					  resource_size(res));
+	if (!mbox->regs)
+		return -ENOMEM;
+
+	mbox->irq = platform_get_irq(pdev, 0);
+	if (mbox->irq < 0)
+		return mbox->irq;
+	ret = devm_request_threaded_irq(mbox->dev, mbox->irq, NULL,
+					tegra_xusb_mbox_irq, IRQF_ONESHOT,
+					dev_name(mbox->dev), mbox);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int tegra_xusb_mbox_remove(struct platform_device *pdev)
+{
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
+MODULE_DESCRIPTION("NVIDIA Tegra XUSB mailbox driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tegra-xusb-mailbox");
diff --git a/include/linux/tegra-xusb-mbox.h b/include/linux/tegra-xusb-mbox.h
new file mode 100644
index 0000000..d31b6da
--- /dev/null
+++ b/include/linux/tegra-xusb-mbox.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __TEGRA_XUSB_MBOX_H
+#define __TEGRA_XUSB_MBOX_H
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
+struct notifier_block;
+struct tegra_xusb_mbox;
+
+/*
+ * Tegra XUSB MBOX handler interface:
+ *   - Drivers which may handle mbox messages should register a notifier.
+ *   - The notifier event will be an mbox command (above) and the data will
+ *     be a pointer to struct tegra_xusb_mbox_msg.
+ *   - If a notifier has handled the message, it should return NOTIFY_STOP
+ *     and populate {cmd,data}_out appropriately.
+ *   - A cmd_out of 0 indicates that no response should be sent.
+ */
+struct tegra_xusb_mbox_msg {
+	u32 data_in;
+	enum tegra_xusb_mbox_cmd cmd_out;
+	u32 data_out;
+};
+
+#ifdef CONFIG_TEGRA_XUSB_MBOX
+extern int tegra_xusb_mbox_register_notifier(struct tegra_xusb_mbox *mbox,
+					     struct notifier_block *nb);
+extern void tegra_xusb_mbox_unregister_notifier(struct tegra_xusb_mbox *mbox,
+						struct notifier_block *nb);
+extern int tegra_xusb_mbox_send(struct tegra_xusb_mbox *mbox,
+				enum tegra_xusb_mbox_cmd cmd, u32 data);
+extern struct tegra_xusb_mbox *
+tegra_xusb_mbox_lookup_by_phandle(struct device_node *np, const char *prop);
+#else
+static inline int
+tegra_xusb_mbox_register_notifier(struct tegra_xusb_mbox *mbox,
+				  struct notifier_block *nb)
+{
+	return -ENOSYS;
+}
+static inline void
+tegra_xusb_mbox_unregister_notifier(struct tegra_xusb_mbox *mbox,
+				    struct notifier_block *nb)
+{
+}
+static inline int
+tegra_xusb_mbox_send(struct tegra_xusb_mbox *mbox,
+		     enum tegra_xusb_mbox_cmd cmd, u32 data)
+{
+	return -ENOSYS;
+}
+static inline struct tegra_xusb_mbox *
+tegra_xusb_mbox_lookup_by_phandle(struct device_node *np, const char *prop)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif
+
+#endif /* __TEGRA_XUSB_MBOX_H */
-- 
2.0.0.526.g5318336

