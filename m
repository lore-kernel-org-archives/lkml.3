Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbaKMLkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:40:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:54220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbaKMLkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:40:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607188135"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch V1 2/6] PCI, MSI: Introduce helpers to hide struct msi_desc implemenation details
Date: Thu, 13 Nov 2014 19:43:44 +0800
Message-Id: <1415879029-20098-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helpers to hide struct msi_desc implementation details,
so we could easily support non-PCI-compliant MSI devices later by
moving msi_list into struct device.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/msi.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 190c7abbec84..714716a3ffdd 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -44,6 +44,25 @@ struct msi_desc {
 	struct msi_msg msg;
 };
 
+/* Helpers to hide struct msi_desc implementation details */
+#define msi_desc_to_dev(desc)		(&(desc)->dev.dev)
+#define dev_to_msi_list(dev)		(&to_pci_dev((dev))->msi_list)
+#define first_msi_entry(dev)		\
+	list_first_entry(dev_to_msi_list((dev)), struct msi_desc, list)
+#define for_each_msi_entry(desc, dev)	\
+	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
+
+#ifdef CONFIG_PCI_MSI
+#define first_pci_msi_entry(pdev)	first_msi_entry(&(pdev)->dev)
+#define for_each_pci_msi_entry(desc, pdev)	\
+	for_each_msi_entry((desc), &(pdev)->dev)
+
+static inline struct pci_dev *msi_desc_to_pci_dev(struct msi_desc *desc)
+{
+	return desc->dev;
+}
+#endif /* CONFIG_PCI_MSI */
+
 void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg);
-- 
1.7.10.4

