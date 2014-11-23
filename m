Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaKXU0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:26:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaKXU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:26:29 -0500
Date: Sun, 23 Nov 2014 10:08:48 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-d31eb342409b24e3d2e1989c775f3361e93acc08@git.kernel.org>
Cc: jiang.liu@linux.intel.com, tglx@linutronix.de, bhelgaas@google.com,
        matthias.bgg@gmail.com, marc.zyngier@arm.com, wangyijing@huawei.com,
        hpa@zytor.com, tony.luck@intel.com, bp@alien8.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        yingjoe.chen@mediatek.com, agordeev@redhat.com,
        grant.likely@linaro.org
Reply-To: grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, bp@alien8.de, tony.luck@intel.com,
        yingjoe.chen@mediatek.com, agordeev@redhat.com, matthias.bgg@gmail.com,
        wangyijing@huawei.com, hpa@zytor.com, marc.zyngier@arm.com,
        jiang.liu@linux.intel.com, tglx@linutronix.de, bhelgaas@google.com
In-Reply-To: <1416061447-9472-6-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] PCI/MSI:
  Introduce helpers to hide struct msi_desc implementation details
Git-Commit-ID: d31eb342409b24e3d2e1989c775f3361e93acc08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d31eb342409b24e3d2e1989c775f3361e93acc08
Gitweb:     http://git.kernel.org/tip/d31eb342409b24e3d2e1989c775f3361e93acc08
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 15 Nov 2014 22:24:03 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:45 +0100

PCI/MSI: Introduce helpers to hide struct msi_desc implementation details

Introduce helpers to hide struct msi_desc implementation details,
so we could easily support non-PCI-compliant MSI devices later by
moving msi_list into struct device.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/1416061447-9472-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/msi.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 1dcad0c..e0d0851 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -43,6 +43,25 @@ struct msi_desc {
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
