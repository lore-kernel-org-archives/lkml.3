Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbbAONEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:04:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbbAONEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:04:10 -0500
Date: Thu, 15 Jan 2015 05:03:44 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e901176046e6729e002839d7296f27f17599ccb8@git.kernel.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        mingo@kernel.org, joro@8bytes.org, bp@alien8.de,
        jiang.liu@linux.intel.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org
Reply-To: tglx@linutronix.de, benh@kernel.crashing.org, bp@alien8.de,
        joro@8bytes.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        yinghai@kernel.org, mingo@kernel.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1420615903-28253-17-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/irq_remapping:
  Normailize the way to detect whether IR is enabled
Git-Commit-ID: e901176046e6729e002839d7296f27f17599ccb8
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

Commit-ID:  e901176046e6729e002839d7296f27f17599ccb8
Gitweb:     http://git.kernel.org/tip/e901176046e6729e002839d7296f27f17599ccb8
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:43 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:24 +0100

iommu/irq_remapping: Normailize the way to detect whether IR is enabled

Refine code by normailizing the way to detect whether IR is enabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/irq_remapping.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5585c4e..390079e 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -218,7 +218,7 @@ int __init irq_remapping_enable(void)
 {
 	int ret;
 
-	if (!remap_ops || !remap_ops->enable)
+	if (!remap_ops->enable)
 		return -ENODEV;
 
 	ret = remap_ops->enable();
@@ -231,22 +231,16 @@ int __init irq_remapping_enable(void)
 
 void irq_remapping_disable(void)
 {
-	if (!irq_remapping_enabled ||
-	    !remap_ops ||
-	    !remap_ops->disable)
-		return;
-
-	remap_ops->disable();
+	if (irq_remapping_enabled && remap_ops->disable)
+		remap_ops->disable();
 }
 
 int irq_remapping_reenable(int mode)
 {
-	if (!irq_remapping_enabled ||
-	    !remap_ops ||
-	    !remap_ops->reenable)
-		return 0;
+	if (irq_remapping_enabled && remap_ops->reenable)
+		return remap_ops->reenable(mode);
 
-	return remap_ops->reenable(mode);
+	return 0;
 }
 
 int __init irq_remap_enable_fault_handling(void)
@@ -254,7 +248,7 @@ int __init irq_remap_enable_fault_handling(void)
 	if (!irq_remapping_enabled)
 		return 0;
 
-	if (!remap_ops || !remap_ops->enable_faulting)
+	if (!remap_ops->enable_faulting)
 		return -ENODEV;
 
 	return remap_ops->enable_faulting();
@@ -265,7 +259,7 @@ int setup_ioapic_remapped_entry(int irq,
 				unsigned int destination, int vector,
 				struct io_apic_irq_attr *attr)
 {
-	if (!remap_ops || !remap_ops->setup_ioapic_entry)
+	if (!remap_ops->setup_ioapic_entry)
 		return -ENODEV;
 
 	return remap_ops->setup_ioapic_entry(irq, entry, destination,
@@ -275,8 +269,7 @@ int setup_ioapic_remapped_entry(int irq,
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask, bool force)
 {
-	if (!config_enabled(CONFIG_SMP) || !remap_ops ||
-	    !remap_ops->set_affinity)
+	if (!config_enabled(CONFIG_SMP) || !remap_ops->set_affinity)
 		return 0;
 
 	return remap_ops->set_affinity(data, mask, force);
@@ -286,10 +279,7 @@ void free_remapped_irq(int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
 
-	if (!remap_ops || !remap_ops->free_irq)
-		return;
-
-	if (irq_remapped(cfg))
+	if (irq_remapped(cfg) && remap_ops->free_irq)
 		remap_ops->free_irq(irq);
 }
 
@@ -301,13 +291,13 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 
 	if (!irq_remapped(cfg))
 		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-	else if (remap_ops && remap_ops->compose_msi_msg)
+	else if (remap_ops->compose_msi_msg)
 		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
 }
 
 static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
-	if (!remap_ops || !remap_ops->msi_alloc_irq)
+	if (!remap_ops->msi_alloc_irq)
 		return -ENODEV;
 
 	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
@@ -316,7 +306,7 @@ static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
 				  int index, int sub_handle)
 {
-	if (!remap_ops || !remap_ops->msi_setup_irq)
+	if (!remap_ops->msi_setup_irq)
 		return -ENODEV;
 
 	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
@@ -326,7 +316,7 @@ int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	int ret;
 
-	if (!remap_ops || !remap_ops->alloc_hpet_msi)
+	if (!remap_ops->alloc_hpet_msi)
 		return -ENODEV;
 
 	ret = remap_ops->alloc_hpet_msi(irq, id);
