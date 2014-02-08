Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaBHAtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:41 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3287 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbaBHAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:15 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 3/6] mailbox: pl320: migrate to mbox framework
Date: Fri, 7 Feb 2014 16:50:16 -0800
Message-ID: <1391820619-25487-4-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't remove the legacy methods here, but we mark them as deprecated
in the hopes that people with the ability to properly test modifications
can adapt its users.

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 drivers/mailbox/pl320-ipc.c | 258 ++++++++++++++++++++++++++++++++++----------
 include/linux/mailbox.h     |  29 ++++-
 2 files changed, 225 insertions(+), 62 deletions(-)

diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cba..b8da247 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -15,7 +15,6 @@
  */
 #include <linux/types.h>
 #include <linux/err.h>
-#include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
@@ -27,6 +26,7 @@
 #include <linux/amba/bus.h>
 
 #include <linux/mailbox.h>
+#include <linux/mbox.h>
 
 #define IPCMxSOURCE(m)		((m) * 0x40)
 #define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
@@ -50,131 +50,162 @@
 #define A9_SOURCE		1
 #define M3_SOURCE		0
 
-static void __iomem *ipc_base;
-static int ipc_irq;
-static DEFINE_MUTEX(ipc_m1_lock);
-static DECLARE_COMPLETION(ipc_completion);
-static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
+struct pl320 {
+	struct mbox_adapter adapter;
+	void __iomem *base;
+	int irq;
+	struct completion completion;
+};
 
-static inline void set_destination(int source, int mbox)
+static inline void set_destination(struct pl320 *pl, int source, int mbox)
 {
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
+	__raw_writel(CHAN_MASK(source), pl->base + IPCMxDSET(mbox));
+	__raw_writel(CHAN_MASK(source), pl->base + IPCMxMSET(mbox));
 }
 
-static inline void clear_destination(int source, int mbox)
+static inline void clear_destination(struct pl320 *pl, int source, int mbox)
 {
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
+	__raw_writel(CHAN_MASK(source), pl->base + IPCMxDCLEAR(mbox));
+	__raw_writel(CHAN_MASK(source), pl->base + IPCMxMCLEAR(mbox));
 }
 
-static void __ipc_send(int mbox, u32 *data)
+static void __ipc_send(struct pl320 *pl, int mbox, const u32 *data)
 {
 	int i;
 	for (i = 0; i < 7; i++)
-		__raw_writel(data[i], ipc_base + IPCMxDR(mbox, i));
-	__raw_writel(0x1, ipc_base + IPCMxSEND(mbox));
+		__raw_writel(data[i], pl->base + IPCMxDR(mbox, i));
+	__raw_writel(0x1, pl->base + IPCMxSEND(mbox));
 }
 
-static u32 __ipc_rcv(int mbox, u32 *data)
+static u32 __ipc_rcv(struct pl320 *pl, int mbox, u32 *data)
 {
 	int i;
 	for (i = 0; i < 7; i++)
-		data[i] = __raw_readl(ipc_base + IPCMxDR(mbox, i));
+		data[i] = __raw_readl(pl->base + IPCMxDR(mbox, i));
 	return data[1];
 }
 
 /* blocking implmentation from the A9 side, not usuable in interrupts! */
-int pl320_ipc_transmit(u32 *data)
+static int pl320_ipc_put_message(struct mbox_adapter *adap,
+		struct mbox_channel *chan, const void *data, unsigned int len)
 {
+	struct pl320 *pl;
+	u32 repl[7];
 	int ret;
 
-	mutex_lock(&ipc_m1_lock);
+	if (len != 28 || chan->id != 0)
+		return -EINVAL;
 
-	init_completion(&ipc_completion);
-	__ipc_send(IPC_TX_MBOX, data);
-	ret = wait_for_completion_timeout(&ipc_completion,
+	pl = container_of(adap, struct pl320, adapter);
+	reinit_completion(&pl->completion);
+	__ipc_send(pl, IPC_TX_MBOX, data);
+	ret = wait_for_completion_timeout(&pl->completion,
 					  msecs_to_jiffies(1000));
-	if (ret == 0) {
-		ret = -ETIMEDOUT;
-		goto out;
-	}
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	ret = __ipc_rcv(pl, IPC_TX_MBOX, repl);
 
-	ret = __ipc_rcv(IPC_TX_MBOX, data);
-out:
-	mutex_unlock(&ipc_m1_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pl320_ipc_transmit);
 
 static irqreturn_t ipc_handler(int irq, void *dev)
 {
+	struct pl320 *pl = dev;
 	u32 irq_stat;
 	u32 data[7];
 
-	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
+	irq_stat = __raw_readl(pl->base + IPCMMIS(1));
 	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
-		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
-		complete(&ipc_completion);
+		__raw_writel(0, pl->base + IPCMxSEND(IPC_TX_MBOX));
+		complete(&pl->completion);
 	}
 	if (irq_stat & MBOX_MASK(IPC_RX_MBOX)) {
-		__ipc_rcv(IPC_RX_MBOX, data);
-		atomic_notifier_call_chain(&ipc_notifier, data[0], data + 1);
-		__raw_writel(2, ipc_base + IPCMxSEND(IPC_RX_MBOX));
+		__ipc_rcv(pl, IPC_RX_MBOX, data);
+		mbox_channel_notify(&pl->adapter.channels[0], data, 28);
+		__raw_writel(2, pl->base + IPCMxSEND(IPC_RX_MBOX));
 	}
 
 	return IRQ_HANDLED;
 }
 
-int pl320_ipc_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&ipc_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(pl320_ipc_register_notifier);
-
-int pl320_ipc_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(pl320_ipc_unregister_notifier);
+static const struct mbox_adapter_ops pl320_mbox_ops = {
+	.owner = THIS_MODULE,
+	.put_message = pl320_ipc_put_message,
+};
 
 static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
 {
+	struct pl320 *pl;
 	int ret;
 
-	ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
-	if (ipc_base == NULL)
+	pl = devm_kzalloc(&adev->dev, sizeof(*pl), GFP_KERNEL);
+	if (pl == NULL)
+		return -ENOMEM;
+	pl->base = ioremap(adev->res.start, resource_size(&adev->res));
+	if (pl->base == NULL)
 		return -ENOMEM;
 
-	__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
+	init_completion(&pl->completion);
 
-	ipc_irq = adev->irq[0];
-	ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
+	pl->adapter.dev = &adev->dev;
+	pl->adapter.ops = &pl320_mbox_ops;
+	pl->adapter.nchannels = 1;
+
+	ret = mbox_adapter_add(&pl->adapter);
+	if (ret)
+		goto err;
+
+	__raw_writel(0, pl->base + IPCMxSEND(IPC_TX_MBOX));
+
+	pl->irq = adev->irq[0];
+	ret = request_irq(pl->irq, ipc_handler, 0, dev_name(&adev->dev), pl);
 	if (ret < 0)
 		goto err;
 
 	/* Init slow mailbox */
 	__raw_writel(CHAN_MASK(A9_SOURCE),
-			ipc_base + IPCMxSOURCE(IPC_TX_MBOX));
+			pl->base + IPCMxSOURCE(IPC_TX_MBOX));
 	__raw_writel(CHAN_MASK(M3_SOURCE),
-			ipc_base + IPCMxDSET(IPC_TX_MBOX));
+			pl->base + IPCMxDSET(IPC_TX_MBOX));
 	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
-		     ipc_base + IPCMxMSET(IPC_TX_MBOX));
+		     pl->base + IPCMxMSET(IPC_TX_MBOX));
 
 	/* Init receive mailbox */
 	__raw_writel(CHAN_MASK(M3_SOURCE),
-			ipc_base + IPCMxSOURCE(IPC_RX_MBOX));
+			pl->base + IPCMxSOURCE(IPC_RX_MBOX));
 	__raw_writel(CHAN_MASK(A9_SOURCE),
-			ipc_base + IPCMxDSET(IPC_RX_MBOX));
+			pl->base + IPCMxDSET(IPC_RX_MBOX));
 	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
-		     ipc_base + IPCMxMSET(IPC_RX_MBOX));
+		     pl->base + IPCMxMSET(IPC_RX_MBOX));
 
+	amba_set_drvdata(adev, pl);
 	return 0;
 err:
-	iounmap(ipc_base);
+	iounmap(pl->base);
 	return ret;
 }
 
+static int pl320_remove(struct amba_device *adev)
+{
+	struct pl320 *pl;
+	int ret;
+
+	pl = amba_get_drvdata(adev);
+
+	disable_irq(pl->irq);
+
+	ret = mbox_adapter_remove(&pl->adapter);
+	if (ret) {
+		enable_irq(pl->irq);
+		return ret;
+	}
+
+	free_irq(pl->irq, pl);
+	iounmap(pl->base);
+	return 0;
+}
+
 static struct amba_id pl320_ids[] = {
 	{
 		.id	= 0x00041320,
@@ -189,6 +220,7 @@ static struct amba_driver pl320_driver = {
 	},
 	.id_table	= pl320_ids,
 	.probe		= pl320_probe,
+	.remove		= pl320_remove,
 };
 
 static int __init ipc_init(void)
@@ -196,3 +228,111 @@ static int __init ipc_init(void)
 	return amba_driver_register(&pl320_driver);
 }
 module_init(ipc_init);
+
+/* Legacy API */
+static struct mbox *pl320_mbox;
+static struct notifier_block *pl320_notifier;
+static DEFINE_SPINLOCK(pl320_legacy_lock);
+static DEFINE_MUTEX(pl320_mutex);
+
+static int __pl320_notify(struct notifier_block *nb,
+		unsigned long len, void *data)
+{
+	unsigned long flags;
+	u32 *mdata = data;
+	int rc;
+
+	spin_lock_irqsave(&pl320_legacy_lock, flags);
+	if (!pl320_notifier) {
+		spin_unlock_irqrestore(&pl320_legacy_lock, flags);
+		return NOTIFY_DONE;
+	}
+
+	rc = pl320_notifier->notifier_call(pl320_notifier,
+			mdata[0], mdata + 1);
+	spin_unlock_irqrestore(&pl320_legacy_lock, flags);
+	return rc;
+}
+
+static void __pl320_set_notifier(struct notifier_block *nb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pl320_legacy_lock, flags);
+	pl320_notifier = nb;
+	spin_unlock_irqrestore(&pl320_legacy_lock, flags);
+}
+
+static struct notifier_block pl320_nb = {
+	.notifier_call = __pl320_notify,
+};
+
+static int __pl320_legacy_setup(struct notifier_block *nb, bool exist_ok)
+{
+	int rc = 0;
+
+	if (WARN_ON(!exist_ok && pl320_mbox))
+		return -EBUSY;
+
+	if (pl320_mbox)
+		return 0;
+
+	__pl320_set_notifier(nb);
+
+	pl320_mbox = mbox_request(NULL, "pl320", &pl320_nb);
+	if (IS_ERR(pl320_mbox)) {
+		rc = PTR_ERR(pl320_mbox);
+		pl320_mbox = NULL;
+		__pl320_set_notifier(NULL);
+	}
+
+	return rc;
+}
+
+int __pl320_legacy_ipc_transmit(u32 *data)
+{
+	int rc;
+
+	mutex_lock(&pl320_mutex);
+	rc = __pl320_legacy_setup(NULL, true);
+	if (rc)
+		goto out;
+
+	rc = mbox_put_message(pl320_mbox, data, 7 * sizeof(*data));
+out:
+	mutex_unlock(&pl320_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL(__pl320_legacy_ipc_transmit);
+
+int __pl320_legacy_ipc_register_notifier(struct notifier_block *nb)
+{
+	int rc;
+
+	mutex_lock(&pl320_mutex);
+	rc = __pl320_legacy_setup(nb, false);
+	mutex_unlock(&pl320_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL(__pl320_legacy_ipc_register_notifier);
+
+int __pl320_legacy_ipc_unregister_notifier(struct notifier_block *nb)
+{
+	mutex_lock(&pl320_mutex);
+
+	if (WARN_ON(!pl320_mbox)) {
+		mutex_unlock(&pl320_mutex);
+		return -EINVAL;
+	}
+
+	mbox_release(pl320_mbox);
+	__pl320_set_notifier(NULL);
+	pl320_mbox = NULL;
+
+	mutex_unlock(&pl320_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(__pl320_legacy_ipc_unregister_notifier);
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index 5161f63..2330954 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -12,6 +12,29 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-int pl320_ipc_transmit(u32 *data);
-int pl320_ipc_register_notifier(struct notifier_block *nb);
-int pl320_ipc_unregister_notifier(struct notifier_block *nb);
+#ifndef PL320_MAILBOX_H
+#define PL320_MAILBOX_H
+
+#include <linux/compiler.h>
+#include <linux/mbox.h>
+
+int __pl320_legacy_ipc_transmit(u32 *data);
+int __pl320_legacy_ipc_register_notifier(struct notifier_block *nb);
+int __pl320_legacy_ipc_unregister_notifier(struct notifier_block *nb);
+
+static inline int __deprecated pl320_ipc_transmit(u32 *data)
+{
+	return __pl320_legacy_ipc_transmit(data);
+}
+static inline int __deprecated
+pl320_ipc_register_notifier(struct notifier_block *nb)
+{
+	return __pl320_legacy_ipc_register_notifier(nb);
+}
+static inline int __deprecated
+pl320_ipc_unregister_notifier(struct notifier_block *nb)
+{
+	return __pl320_legacy_ipc_unregister_notifier(nb);
+}
+
+#endif
-- 
1.8.1.5

