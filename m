Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab3CZCok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:44:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12440 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3CZCoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:44:39 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v5 2/5] PCI/AER: use list_for_each_entry to avoid a small race condition window
Date: Tue, 26 Mar 2013 10:43:36 +0800
Message-ID: <1364265819-6732-3-git-send-email-wangyijing@huawei.com>
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

When we rmmod aer_inject module, there is a small race condition window between pci_bus_ops_pop()
and pci_bus_set_ops() in aer_inject_exit, eg. pci_read_aer/pci_write_aer was called between
them. So keep pci_bus_ops_list until pci_bus_set_ops complete, use list_for_each_entry() instead of
pci_bus_ops_pop to get bus_ops.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/aer/aer_inject.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index fdab3bb..f499f01 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -543,10 +543,11 @@ static void __exit aer_inject_exit(void)
 
 	misc_deregister(&aer_inject_device);
 
-	while ((bus_ops = pci_bus_ops_pop())) {
+	list_for_each_entry(bus_ops, &pci_bus_ops_list, list)
 		pci_bus_set_ops(bus_ops->bus, bus_ops->ops);
+
+	while ((bus_ops = pci_bus_ops_pop()))
 		kfree(bus_ops);
-	}
 
 	spin_lock_irqsave(&inject_lock, flags);
 	list_for_each_entry_safe(err, err_next, &einjected, list) {
-- 
1.7.1


