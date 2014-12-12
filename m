Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbaLLKFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:05:23 -0500
Received: from mail-by2on0076.outbound.protection.outlook.com ([207.46.100.76]:61171
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934771AbaLLKE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:04:59 -0500
From: Ley Foon Tan <lftan@altera.com>
To: Jassi Brar <jassisinghbrar@gmail.com>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        Suman Anna <s-anna@ti.com>, <devicetree@vger.kernel.org>
Subject: [PATCH (resend)] mailbox: Add Altera mailbox driver
Date: Fri, 12 Dec 2014 18:04:50 +0800
Message-ID: <1418378690-3466-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(22564002)(189002)(33646002)(6806004)(21056001)(36756003)(89996001)(92566001)(84676001)(86362001)(19580395003)(19580405001)(4396001)(87936001)(120916001)(42186005)(575784001)(50226001)(50986999)(68736005)(2420400003)(46102003)(97736003)(15975445007)(99396003)(31966008)(64706001)(20776003)(47776003)(107046002)(77156002)(62966003)(106466001)(105596002)(48376002)(50466002)(229853001)(7099022)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB590;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB590;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BLUPR03MB590;
X-Forefront-PRVS: 04238CD941
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB590;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Altera mailbox allows for interprocessor communication. It supports
only one channel and work as either sender or receiver.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 .../devicetree/bindings/mailbox/altera-mailbox.txt |  49 +++
 drivers/mailbox/Kconfig                            |   6 +
 drivers/mailbox/Makefile                           |   2 +
 drivers/mailbox/mailbox-altera.c                   | 404 +++++++++++++++++++++
 4 files changed, 461 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
 create mode 100644 drivers/mailbox/mailbox-altera.c

diff --git a/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
new file mode 100644
index 0000000..c261979
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
@@ -0,0 +1,49 @@
+Altera Mailbox Driver
+=====================
+
+Required properties:
+- compatible :	"altr,mailbox-1.0".
+- reg : 	physical base address of the mailbox and length of
+		memory mapped region.
+- #mbox-cells:	Common mailbox binding property to identify the number
+		of cells required for the mailbox specifier. Should be 1.
+
+Optional properties:
+- interrupt-parent :	interrupt source phandle.
+- interrupts :		interrupt number. The interrupt specifier format
+			depends on the interrupt controller parent.
+
+Example:
+	mbox_tx: mailbox@0x100 {
+		compatible = "altr,mailbox-1.0";
+		reg = <0x100 0x8>;
+		interrupt-parent = < &gic_0 >;
+		interrupts = <5>;
+		#mbox-cells = <1>;
+	};
+
+	mbox_rx: mailbox@0x200 {
+		compatible = "altr,mailbox-1.0";
+		reg = <0x200 0x8>;
+		interrupt-parent = < &gic_0 >;
+		interrupts = <6>;
+		#mbox-cells = <1>;
+	};
+
+Mailbox client
+===============
+"mboxes" and the optional "mbox-names" (please see
+Documentation/devicetree/bindings/mailbox/mailbox.txt for details). Each value
+of the mboxes property should contain a phandle to the mailbox controller
+device node and second argument is the channel index. It must be 0 (hardware
+support only one channel).The equivalent "mbox-names" property value can be
+used to give a name to the communication channel to be used by the client user.
+
+Example:
+	mclient0: mclient0@0x400 {
+		compatible = "client-1.0";
+		reg = <0x400 0x10>;
+		mbox-names = "mbox-tx", "mbox-rx";
+		mboxes = <&mbox_tx 0>,
+			 <&mbox_rx 0>;
+	};
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index c04fed9..84325f2 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -45,4 +45,10 @@ config PCC
 	  states). Select this driver if your platform implements the
 	  PCC clients mentioned above.
 
+config ALTERA_MBOX
+	tristate "Altera Mailbox"
+	help
+	  An implementation of the Altera Mailbox soft core. It is used
+	  to send message between processors. Say Y here if you want to use the
+	  Altera mailbox support.
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index dd412c2..2e79231 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
 obj-$(CONFIG_OMAP2PLUS_MBOX)	+= omap-mailbox.o
 
 obj-$(CONFIG_PCC)		+= pcc.o
+
+obj-$(CONFIG_ALTERA_MBOX)	+= mailbox-altera.o
diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
new file mode 100644
index 0000000..9ed10de
--- /dev/null
+++ b/drivers/mailbox/mailbox-altera.c
@@ -0,0 +1,404 @@
+/*
+ * Copyright Altera Corporation (C) 2013-2014. All rights reserved
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/mailbox_controller.h>
+
+#define DRIVER_NAME	"altera-mailbox"
+
+#define MAILBOX_CMD_REG			0x00
+#define MAILBOX_PTR_REG			0x04
+#define MAILBOX_STS_REG			0x08
+#define MAILBOX_INTMASK_REG		0x0C
+
+#define INT_PENDING_MSK			0x1
+#define INT_SPACE_MSK			0x2
+
+#define STS_PENDING_MSK			0x1
+#define STS_FULL_MSK			0x2
+#define STS_FULL_OFT			0x1
+
+#define MBOX_PENDING(status)	(((status) & STS_PENDING_MSK))
+#define MBOX_FULL(status)	(((status) & STS_FULL_MSK) >> STS_FULL_OFT)
+
+enum altera_mbox_msg {
+	MBOX_CMD = 0,
+	MBOX_PTR,
+};
+
+#define MBOX_POLLING_MS		1	/* polling interval 1ms */
+
+struct altera_mbox {
+	bool is_sender;		/* 1-sender, 0-receiver */
+	bool intr_mode;
+	int irq;
+	void __iomem *mbox_base;
+	struct device *dev;
+	struct mbox_chan chan;
+	struct mbox_controller controller;
+
+	/* If the controller supports only RX polling mode */
+	struct timer_list rxpoll_timer;
+};
+
+static inline struct altera_mbox *to_altera_mbox(struct mbox_chan *chan)
+{
+	if (!chan)
+		return NULL;
+
+	return container_of(chan, struct altera_mbox, chan);
+}
+
+static inline int altera_mbox_full(struct altera_mbox *mbox)
+{
+	u32 status;
+
+	status = __raw_readl(mbox->mbox_base + MAILBOX_STS_REG);
+	return MBOX_FULL(status);
+}
+
+static inline int altera_mbox_pending(struct altera_mbox *mbox)
+{
+	u32 status;
+
+	status = __raw_readl(mbox->mbox_base + MAILBOX_STS_REG);
+	return MBOX_PENDING(status);
+}
+
+static void altera_mbox_rx_intmask(struct altera_mbox *mbox, bool enable)
+{
+	u32 mask;
+
+	mask = __raw_readl(mbox->mbox_base + MAILBOX_INTMASK_REG);
+	if (enable)
+		mask |= INT_PENDING_MSK;
+	else
+		mask &= ~INT_PENDING_MSK;
+	__raw_writel(mask, mbox->mbox_base + MAILBOX_INTMASK_REG);
+}
+
+static void altera_mbox_tx_intmask(struct altera_mbox *mbox, bool enable)
+{
+	u32 mask;
+
+	mask = __raw_readl(mbox->mbox_base + MAILBOX_INTMASK_REG);
+	if (enable)
+		mask |= INT_SPACE_MSK;
+	else
+		mask &= ~INT_SPACE_MSK;
+	__raw_writel(mask, mbox->mbox_base + MAILBOX_INTMASK_REG);
+}
+
+static bool altera_mbox_is_sender(struct altera_mbox *mbox)
+{
+	u32 reg;
+	/* Write a magic number to PTR register and read back this register.
+	 * This register is read-write if it is a sender.
+	 */
+	#define MBOX_MAGIC	0xA5A5AA55
+	__raw_writel(MBOX_MAGIC, mbox->mbox_base + MAILBOX_PTR_REG);
+	reg = __raw_readl(mbox->mbox_base + MAILBOX_PTR_REG);
+	if (reg == MBOX_MAGIC) {
+		/* Clear to 0 */
+		__raw_writel(0, mbox->mbox_base + MAILBOX_PTR_REG);
+		return true;
+	}
+	return false;
+}
+
+static void altera_mbox_rx_data(struct mbox_chan *chan)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+	u32 data[2];
+
+	if (altera_mbox_pending(mbox)) {
+		data[MBOX_PTR] = __raw_readl(mbox->mbox_base + MAILBOX_PTR_REG);
+		data[MBOX_CMD] = __raw_readl(mbox->mbox_base + MAILBOX_CMD_REG);
+		mbox_chan_received_data(chan, (void *)data);
+	}
+}
+
+static void altera_mbox_poll_rx(unsigned long data)
+{
+	struct mbox_chan *chan = (struct mbox_chan *)data;
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	altera_mbox_rx_data(chan);
+
+	mod_timer(&mbox->rxpoll_timer,
+		jiffies + msecs_to_jiffies(MBOX_POLLING_MS));
+}
+
+static irqreturn_t altera_mbox_tx_interrupt(int irq, void *p)
+{
+	struct mbox_chan *chan = (struct mbox_chan *)p;
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	altera_mbox_tx_intmask(mbox, false);
+	mbox_chan_txdone(chan, 0);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t altera_mbox_rx_interrupt(int irq, void *p)
+{
+	struct mbox_chan *chan = (struct mbox_chan *)p;
+
+	altera_mbox_rx_data(chan);
+	return IRQ_HANDLED;
+}
+
+static int altera_mbox_startup_sender(struct mbox_chan *chan)
+{
+	int ret;
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	if (mbox->intr_mode) {
+		ret = request_irq(mbox->irq, altera_mbox_tx_interrupt, 0,
+			DRIVER_NAME, chan);
+		if (unlikely(ret)) {
+			dev_err(mbox->dev,
+				"failed to register mailbox interrupt:%d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int altera_mbox_startup_receiver(struct mbox_chan *chan)
+{
+	int ret;
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	if (mbox->intr_mode) {
+		ret = request_irq(mbox->irq, altera_mbox_rx_interrupt, 0,
+			DRIVER_NAME, chan);
+		if (unlikely(ret)) {
+			dev_err(mbox->dev,
+				"failed to register mailbox interrupt:%d\n",
+				ret);
+			return ret;
+		}
+		altera_mbox_rx_intmask(mbox, true);
+	} else {
+		/* Setup polling timer */
+		setup_timer(&mbox->rxpoll_timer, altera_mbox_poll_rx,
+			(unsigned long)chan);
+		mod_timer(&mbox->rxpoll_timer,
+			jiffies + msecs_to_jiffies(MBOX_POLLING_MS));
+	}
+
+	return 0;
+}
+
+static int altera_mbox_send_data(struct mbox_chan *chan, void *data)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+	u32 *udata = (u32 *)data;
+
+	if (!mbox || !data)
+		return -EINVAL;
+	if (!mbox->is_sender) {
+		dev_warn(mbox->dev,
+			"failed to send. This is receiver mailbox.\n");
+		return -EINVAL;
+	}
+
+	if (altera_mbox_full(mbox))
+		return -EBUSY;
+
+	/* Enable interrupt before send */
+	altera_mbox_tx_intmask(mbox, true);
+
+	/* Pointer register must write before command register */
+	__raw_writel(udata[MBOX_PTR], mbox->mbox_base + MAILBOX_PTR_REG);
+	__raw_writel(udata[MBOX_CMD], mbox->mbox_base + MAILBOX_CMD_REG);
+
+	return 0;
+}
+
+static bool altera_mbox_last_tx_done(struct mbox_chan *chan)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return false;
+
+	/* Return false if mailbox is full */
+	return altera_mbox_full(mbox) ? false : true;
+}
+
+static bool altera_mbox_peek_data(struct mbox_chan *chan)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return false;
+
+	return altera_mbox_pending(mbox) ? true : false;
+}
+
+static int altera_mbox_startup(struct mbox_chan *chan)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+	int ret = 0;
+
+	if (!mbox)
+		return -EINVAL;
+
+	if (mbox->is_sender)
+		ret = altera_mbox_startup_sender(chan);
+	else
+		ret = altera_mbox_startup_receiver(chan);
+
+	return ret;
+}
+
+static void altera_mbox_shutdown(struct mbox_chan *chan)
+{
+	struct altera_mbox *mbox = to_altera_mbox(chan);
+
+	if (WARN_ON(!mbox))
+		return;
+
+	if (mbox->intr_mode) {
+		/* Unmask all interrupt masks */
+		__raw_writel(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
+		free_irq(mbox->irq, chan);
+	} else if (!mbox->is_sender)
+		del_timer_sync(&mbox->rxpoll_timer);
+}
+
+static struct mbox_chan_ops altera_mbox_ops = {
+	.send_data = altera_mbox_send_data,
+	.startup = altera_mbox_startup,
+	.shutdown = altera_mbox_shutdown,
+	.last_tx_done = altera_mbox_last_tx_done,
+	.peek_data = altera_mbox_peek_data,
+};
+
+static int altera_mbox_probe(struct platform_device *pdev)
+{
+	struct altera_mbox *mbox;
+	struct mbox_chan *chans[1];
+	struct resource	*regs;
+	int ret;
+
+	mbox = devm_kzalloc(&pdev->dev, sizeof(struct altera_mbox),
+		GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	mbox->mbox_base = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(mbox->mbox_base))
+		return PTR_ERR(mbox->mbox_base);
+
+	/* Check is it a sender or receiver? */
+	mbox->is_sender = altera_mbox_is_sender(mbox);
+
+	mbox->irq = platform_get_irq(pdev, 0);
+	if (mbox->irq >= 0)
+		mbox->intr_mode = true;
+
+	mbox->dev = &pdev->dev;
+
+	/* Hardware supports only one channel. */
+	chans[0] = &mbox->chan;
+	mbox->controller.dev = mbox->dev;
+	mbox->controller.num_chans = 1;
+	mbox->controller.chans =  &mbox->chan;
+	mbox->controller.ops = &altera_mbox_ops;
+
+	if (mbox->is_sender) {
+		if (mbox->intr_mode)
+			mbox->controller.txdone_irq = true;
+		else {
+			mbox->controller.txdone_poll = true;
+			mbox->controller.txpoll_period = MBOX_POLLING_MS;
+		}
+	}
+
+	ret = mbox_controller_register(&mbox->controller);
+	if (ret) {
+		dev_err(&pdev->dev, "Register mailbox failed\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, mbox);
+	return 0;
+err:
+	return ret;
+}
+
+static int altera_mbox_remove(struct platform_device *pdev)
+{
+	struct altera_mbox *mbox = platform_get_drvdata(pdev);
+
+	if (!mbox)
+		return -EINVAL;
+
+	mbox_controller_unregister(&mbox->controller);
+
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static const struct of_device_id altera_mbox_match[] = {
+	{ .compatible = "altr,mailbox-1.0" },
+	{ /* Sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, altera_mbox_match);
+
+static struct platform_driver altera_mbox_driver = {
+	.probe	= altera_mbox_probe,
+	.remove	= altera_mbox_remove,
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table	= altera_mbox_match,
+	},
+};
+
+static int altera_mbox_init(void)
+{
+	return platform_driver_register(&altera_mbox_driver);
+}
+
+static void altera_mbox_exit(void)
+{
+	platform_driver_unregister(&altera_mbox_driver);
+}
+
+module_init(altera_mbox_init);
+module_exit(altera_mbox_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Altera mailbox specific functions");
+MODULE_AUTHOR("Ley Foon Tan <lftan@altera.com>");
+MODULE_ALIAS("platform:altera-mailbox");
-- 
1.8.2.1

