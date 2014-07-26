Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbaGZCoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45751 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaGZCnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 08/11] PCI/MSI: Introduce new struct msi_irqs and struct msi_ops
Date: Sat, 26 Jul 2014 11:08:45 +0800
Message-ID: <1406344128-27055-9-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, MSI driver is bonding with PCI everywhere.
Now introduce a new struct msi_irqs to manage all MSI
related informations in a MSI support device. In addition,
we introduce struct msi_ops to hook all device specific
MSI operations. Then MSI driver can be decoupled with
PCI.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 include/linux/msi.h |   30 +++++++++++++++++++++++++++++-
 include/linux/pci.h |    7 +------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 3ad8416..5a672d3 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -10,6 +10,34 @@ struct msi_msg {
 	u32	data;		/* 16 bits of msi message data */
 };
 
+struct msi_ops;
+
+struct msi_irqs {
+	u8 msi_enabled:1;
+	u8 msix_enabled:1;
+	int node;
+	struct list_head msi_list;
+	void *data;
+	struct msi_ops *ops;
+};
+
+struct msix_entry {
+	u32	vector;	/* kernel uses to write allocated vector */
+	u16	entry;	/* driver uses to specify entry, OS writes */
+};
+
+struct msi_ops {
+	void (*msi_set_enable)(struct msi_irqs *msi, int enable, int type);
+	struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi);
+	int (*msix_setup_entries)(struct msi_irqs *msi, void __iomem *base,
+			struct msix_entry *entries, int nvec);
+	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
+	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
+	void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
+	void (*msi_write_message)(struct msi_desc *desc, struct msi_msg *msg);
+	void (*msi_set_intx)(struct msi_irqs *msi, int enable);
+};
+
 /* Helper functions */
 struct irq_data;
 struct msi_desc;
@@ -42,7 +70,7 @@ struct msi_desc {
 		void __iomem *mask_base;
 		u8 mask_pos;
 	};
-	struct pci_dev *dev;
+	struct msi_irqs *msi;
 
 	/* Last set MSI message */
 	struct msi_msg msg;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c6c01ae..c7bca1c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -32,8 +32,8 @@
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
-
 #include <linux/msi.h>
+
 /*
  * The PCI interface treats multi-function devices as independent
  * devices.  The slot/function address of each device is encoded
@@ -1182,11 +1182,6 @@ enum pci_dma_burst_strategy {
 				   strategy_parameter byte boundaries */
 };
 
-struct msix_entry {
-	u32	vector;	/* kernel uses to write allocated vector */
-	u16	entry;	/* driver uses to specify entry, OS writes */
-};
-
 
 #ifdef CONFIG_PCI_MSI
 int pci_msi_vec_count(struct pci_dev *dev);
-- 
1.7.1

