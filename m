Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3D0SPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 14:15:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61798 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3D0SPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:15:33 -0400
From: jassisinghbrar@gmail.com
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.green@linaro.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [RFC 3/3] mailbox: pl320: Introduce common API driver
Date: Sat, 27 Apr 2013 23:44:56 +0530
Message-Id: <1367086496-28647-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jassi Brar <jaswinder.singh@linaro.org>

Convert the PL320 controller driver to work with the common
mailbox API. Also convert the only user of PL320, highbank-cpufreq.c
to work with thee API. Drop the obsoleted driver pl320-ipc.c

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/cpufreq/highbank-cpufreq.c       |   22 +++-
 drivers/mailbox/Makefile                 |    2 +-
 drivers/mailbox/{pl320-ipc.c => pl320.c} |  194 ++++++++++++++++--------------
 include/linux/pl320-ipc.h                |   17 ---
 4 files changed, 125 insertions(+), 110 deletions(-)
 rename drivers/mailbox/{pl320-ipc.c => pl320.c} (51%)
 delete mode 100644 include/linux/pl320-ipc.h

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index 3118b87..5c057e0 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -19,7 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/of.h>
-#include <linux/pl320-ipc.h>
+#include <linux/mailbox_client.h>
 #include <linux/platform_device.h>
 
 #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
@@ -29,8 +29,26 @@
 static int hb_voltage_change(unsigned int freq)
 {
 	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
+	struct ipc_client cl;
+	int ret = -ETIMEDOUT;
+	void *chan;
 
-	return pl320_ipc_transmit(msg);
+	cl.rxcb = NULL;
+	cl.txcb = NULL;
+	cl.tx_block = true;
+	cl.tx_tout = 1000; /* 1 sec */
+	cl.cntlr_data = NULL;
+	cl.knows_txdone = false;
+	cl.chan_name = "pl320:A9_to_M3";
+
+	chan = ipc_request_channel(&cl);
+
+	if (ipc_send_message(chan, (void *)msg))
+		ret = msg[1]; /* PL320 updates buffer with FIFO after ACK */
+
+	ipc_free_channel(chan);
+
+	return ret;
 }
 
 static int hb_cpufreq_clk_notify(struct notifier_block *nb,
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index fefef7e..7b897f3 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -2,4 +2,4 @@
 
 obj-$(CONFIG_MAILBOX)		+= mailbox.o
 
-obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
+obj-$(CONFIG_PL320_MBOX)	+= pl320.o
diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320.c
similarity index 51%
rename from drivers/mailbox/pl320-ipc.c
rename to drivers/mailbox/pl320.c
index f3755e0..98b40f4 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320.c
@@ -25,8 +25,9 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
-
-#include <linux/pl320-ipc.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mailbox_controller.h>
 
 #define IPCMxSOURCE(m)		((m) * 0x40)
 #define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
@@ -44,114 +45,86 @@
 
 #define MBOX_MASK(n)		(1 << (n))
 #define IPC_TX_MBOX		1
-#define IPC_RX_MBOX		2
 
 #define CHAN_MASK(n)		(1 << (n))
 #define A9_SOURCE		1
 #define M3_SOURCE		0
 
-static void __iomem *ipc_base;
-static int ipc_irq;
-static DEFINE_MUTEX(ipc_m1_lock);
-static DECLARE_COMPLETION(ipc_completion);
-static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
+struct pl320_con {
+	u32 *data;
+	int ipc_irq;
+	struct device *dev;
+	struct ipc_link link;
+	void __iomem *ipc_base;
+	struct ipc_controller ipc_con;
+};
 
-static inline void set_destination(int source, int mbox)
+static inline struct pl320_con *to_pl320(struct ipc_link *l)
 {
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
-}
+	if (!l)
+		return NULL;
 
-static inline void clear_destination(int source, int mbox)
-{
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
+	return container_of(l, struct pl320_con, link);
 }
 
-static void __ipc_send(int mbox, u32 *data)
+static irqreturn_t ipc_handler(int irq, void *p)
 {
-	int i;
-	for (i = 0; i < 7; i++)
-		__raw_writel(data[i], ipc_base + IPCMxDR(mbox, i));
-	__raw_writel(0x1, ipc_base + IPCMxSEND(mbox));
-}
+	struct ipc_link *link = (struct ipc_link *)p;
+	struct pl320_con *pl320 = to_pl320(link);
+	void __iomem *ipc_base = pl320->ipc_base;
+	u32 irq_stat;
 
-static u32 __ipc_rcv(int mbox, u32 *data)
-{
-	int i;
-	for (i = 0; i < 7; i++)
-		data[i] = __raw_readl(ipc_base + IPCMxDR(mbox, i));
-	return data[1];
-}
+	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
+	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
+		u32 *data = pl320->data;
+		int i;
 
-/* blocking implmentation from the A9 side, not usuable in interrupts! */
-int pl320_ipc_transmit(u32 *data)
-{
-	int ret;
+		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
+
+		/*
+		 * The PL320 driver specifies that the send buffer
+		 * will be overwritten by same fifo upon TX ACK.
+		 */
+		for (i = 0; i < 7; i++)
+			data[i] = __raw_readl(ipc_base
+					 + IPCMxDR(IPC_TX_MBOX, i));
 
-	mutex_lock(&ipc_m1_lock);
+		ipc_link_txdone(link, XFER_OK);
 
-	init_completion(&ipc_completion);
-	__ipc_send(IPC_TX_MBOX, data);
-	ret = wait_for_completion_timeout(&ipc_completion,
-					  msecs_to_jiffies(1000));
-	if (ret == 0) {
-		ret = -ETIMEDOUT;
-		goto out;
+		pl320->data = NULL;
 	}
 
-	ret = __ipc_rcv(IPC_TX_MBOX, data);
-out:
-	mutex_unlock(&ipc_m1_lock);
-	return ret;
+	return IRQ_HANDLED;
 }
-EXPORT_SYMBOL_GPL(pl320_ipc_transmit);
 
-static irqreturn_t ipc_handler(int irq, void *dev)
+static int pl320_send_data(struct ipc_link *link, void *msg)
 {
-	u32 irq_stat;
-	u32 data[7];
+	struct pl320_con *pl320 = to_pl320(link);
+	void __iomem *ipc_base = pl320->ipc_base;
+	u32 *data = (u32 *)msg;
+	int i;
 
-	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
-	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
-		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
-		complete(&ipc_completion);
-	}
-	if (irq_stat & MBOX_MASK(IPC_RX_MBOX)) {
-		__ipc_rcv(IPC_RX_MBOX, data);
-		atomic_notifier_call_chain(&ipc_notifier, data[0], data + 1);
-		__raw_writel(2, ipc_base + IPCMxSEND(IPC_RX_MBOX));
-	}
+	pl320->data = data;
 
-	return IRQ_HANDLED;
-}
+	for (i = 0; i < 7; i++)
+		__raw_writel(data[i], ipc_base + IPCMxDR(IPC_TX_MBOX, i));
 
-int pl320_ipc_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&ipc_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(pl320_ipc_register_notifier);
+	__raw_writel(0x1, ipc_base + IPCMxSEND(IPC_TX_MBOX));
 
-int pl320_ipc_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(pl320_ipc_unregister_notifier);
 
-static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
+static int pl320_startup(struct ipc_link *link, void *ignored)
 {
-	int ret;
-
-	ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
-	if (ipc_base == NULL)
-		return -ENOMEM;
+	struct pl320_con *pl320 = to_pl320(link);
+	void __iomem *ipc_base = pl320->ipc_base;
+	int err, ipc_irq = pl320->ipc_irq;
 
 	__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
 
-	ipc_irq = adev->irq[0];
-	ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
-	if (ret < 0)
-		goto err;
+	err = request_irq(ipc_irq, ipc_handler, 0, dev_name(pl320->dev), link);
+	if (err)
+		return err;
 
 	/* Init slow mailbox */
 	__raw_writel(CHAN_MASK(A9_SOURCE),
@@ -161,17 +134,58 @@ static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
 	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
 		     ipc_base + IPCMxMSET(IPC_TX_MBOX));
 
-	/* Init receive mailbox */
-	__raw_writel(CHAN_MASK(M3_SOURCE),
-			ipc_base + IPCMxSOURCE(IPC_RX_MBOX));
-	__raw_writel(CHAN_MASK(A9_SOURCE),
-			ipc_base + IPCMxDSET(IPC_RX_MBOX));
-	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
-		     ipc_base + IPCMxMSET(IPC_RX_MBOX));
-
+	pl320->data = NULL;
 	return 0;
-err:
-	iounmap(ipc_base);
+}
+
+static void pl320_shutdown(struct ipc_link *link)
+{
+	struct pl320_con *pl320 = to_pl320(link);
+
+	pl320->data = NULL;
+	free_irq(pl320->ipc_irq, link);
+}
+
+static struct ipc_link_ops pl320_ops = {
+	.send_data = pl320_send_data,
+	.startup = pl320_startup,
+	.shutdown = pl320_shutdown,
+};
+
+static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	struct pl320_con *pl320;
+	struct ipc_link *l[2];
+	int ret;
+
+	pl320 = kzalloc(sizeof(struct pl320_con), GFP_KERNEL);
+	if (!pl320)
+		return -ENOMEM;
+
+	pl320->ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
+	if (pl320->ipc_base == NULL) {
+		kfree(pl320);
+		return -ENOMEM;
+	}
+
+	pl320->dev = &adev->dev;
+	pl320->ipc_irq = adev->irq[0];
+	amba_set_drvdata(adev, pl320);
+
+	l[0] = &pl320->link;
+	l[1] = NULL;
+	pl320->ipc_con.links = l;
+	pl320->ipc_con.txdone_irq = true;
+	pl320->ipc_con.ops = &pl320_ops;
+	snprintf(pl320->link.link_name, 16, "A9_to_M3");
+	snprintf(pl320->ipc_con.controller_name, 16, "pl320");
+
+	ret = ipc_links_register(&pl320->ipc_con);
+	if (ret) {
+		iounmap(pl320->ipc_base);
+		kfree(pl320);
+	}
+
 	return ret;
 }
 
diff --git a/include/linux/pl320-ipc.h b/include/linux/pl320-ipc.h
deleted file mode 100644
index 5161f63..0000000
--- a/include/linux/pl320-ipc.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-int pl320_ipc_transmit(u32 *data);
-int pl320_ipc_register_notifier(struct notifier_block *nb);
-int pl320_ipc_unregister_notifier(struct notifier_block *nb);
-- 
1.7.10.4

