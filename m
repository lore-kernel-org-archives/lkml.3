Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaJAQsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:48:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaJAQse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:48:34 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/3] Revert "PCI/MSI: Rename __get_cached_msi_msg() to
	get_cached_msi_msg()"
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com
Date: Wed, 01 Oct 2014 10:48:28 -0600
Message-ID: <20141001164828.2709.67767.stgit@gimli.home>
In-Reply-To: <20141001163814.2709.92885.stgit@gimli.home>
References: <20141001163814.2709.92885.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another case of making the MSI msg API inconsistent, for
seemingly no gain.  Continue to use __get_cached_msi_msg() with an
msi_desc and leave get_cached_msi_msg() for an irq interfaces.

This reverts 18ef822c59f60d52c8534b295086d38e9e8e0f7d

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 arch/ia64/kernel/msi_ia64.c    |    2 +-
 arch/ia64/sn/kernel/msi_sn.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c |    2 +-
 drivers/pci/msi.c              |    2 +-
 include/linux/msi.h            |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 4efe748..8c3730c 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -23,7 +23,7 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 	if (irq_prepare_move(irq, cpu))
 		return -1;
 
-	get_cached_msi_msg(idata->msi_desc, &msg);
+	__get_cached_msi_msg(idata->msi_desc, &msg);
 
 	addr = msg.address_lo;
 	addr &= MSI_ADDR_DEST_ID_MASK;
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 8bec242..446e779 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -175,7 +175,7 @@ static int sn_set_msi_irq_affinity(struct irq_data *data,
 	 * Release XIO resources for the old MSI PCI address
 	 */
 
-	get_cached_msi_msg(data->msi_desc, &msg);
+	__get_cached_msi_msg(data->msi_desc, &msg);
 	sn_pdev = (struct pcidev_info *)sn_irq_info->irq_pciioinfo;
 	pdev = sn_pdev->pdi_linux_pcidev;
 	provider = SN_PCIDEV_BUSPROVIDER(pdev);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e877cfb..29290f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3145,7 +3145,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	if (ret)
 		return ret;
 
-	get_cached_msi_msg(data->msi_desc, &msg);
+	__get_cached_msi_msg(data->msi_desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 12d0f29..2bd0fbe 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -279,7 +279,7 @@ void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	}
 }
 
-void get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	/* Assert that the cache is valid, assuming that
 	 * valid messages are not all-zeroes. */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 0bb302f..d0e0cfe 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -16,7 +16,7 @@ struct msi_desc;
 void mask_msi_irq(struct irq_data *data);
 void unmask_msi_irq(struct irq_data *data);
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 

