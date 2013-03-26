Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3CZCoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:44:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12346 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3CZCoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:44:22 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v5 4/5] PCI/AER: clean pci_bus_ops when related pci bus was removed
Date: Tue, 26 Mar 2013 10:43:38 +0800
Message-ID: <1364265819-6732-5-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1364265819-6732-1-git-send-email-wangyijing@huawei.com>
References: <1364265819-6732-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Inject aer errors to the target pci device, a pci_bus_ops will
be allocated for the pci device's pci bus.When the pci bus was removed,
we should also release the pci_bus_ops.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Reviewed-by: Sven Dietrich <Sven.Dietrich@huawei.com>
---
 drivers/pci/pcie/aer/aer_inject.c |   49 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 4777c44..c5372dd 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -553,9 +553,55 @@ static struct miscdevice aer_inject_device = {
 	.fops = &aer_inject_fops,
 };
 
+static void aer_clean_pci_bus_ops(struct pci_dev *dev)
+{
+	unsigned long flags;
+	struct pci_bus_ops *bus_ops, *tmp_ops;
+	struct pci_bus *bus;
+	bus = dev->subordinate;
+	if (!bus)
+		return;
+
+	spin_lock_irqsave(&inject_lock, flags);
+	list_for_each_entry_safe(bus_ops, tmp_ops, &pci_bus_ops_list, list)
+		if (bus_ops->bus == bus) {
+			list_del(&bus_ops->list);
+			kfree(bus_ops);
+			break;
+		}
+	spin_unlock_irqrestore(&inject_lock, flags);
+}
+
+static int aer_hp_notify_fn(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	switch (event) {
+	case BUS_NOTIFY_DEL_DEVICE:
+		aer_clean_pci_bus_ops(to_pci_dev(data));
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block aerinj_hp_notifier = {
+	.notifier_call = &aer_hp_notify_fn,
+};
+
 static int __init aer_inject_init(void)
 {
-	return misc_register(&aer_inject_device);
+	int ret;
+	ret = misc_register(&aer_inject_device);
+	if (ret)
+		goto out;
+
+	ret = bus_register_notifier(&pci_bus_type, &aerinj_hp_notifier);
+	if (ret)
+		misc_deregister(&aer_inject_device);
+out:
+	return ret;
 }
 
 static void __exit aer_inject_exit(void)
@@ -564,6 +610,7 @@ static void __exit aer_inject_exit(void)
 	unsigned long flags;
 	struct pci_bus_ops *bus_ops;
 
+	bus_unregister_notifier(&pci_bus_type, &aerinj_hp_notifier);
 	misc_deregister(&aer_inject_device);
 
 	list_for_each_entry(bus_ops, &pci_bus_ops_list, list)
-- 
1.7.1


