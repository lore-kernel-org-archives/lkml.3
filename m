Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaKERTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:19:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaKERTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:19:04 -0500
Date: Wed, 5 Nov 2014 09:17:59 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e1d8f79a27a41493c8f1ad0bde440048e17f9494@git.kernel.org>
Cc: tony.luck@intel.com, joro@8bytes.org, tglx@linutronix.de,
        bhelgaas@google.com, rjw@rjwysocki.net, konrad.wilk@oracle.com,
        mingo@kernel.org, bp@alien8.de, yinghai@kernel.org,
        benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Reply-To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rdunlap@infradead.org, jiang.liu@linux.intel.com,
        benh@kernel.crashing.org, yinghai@kernel.org, mingo@kernel.org,
        bp@alien8.de, konrad.wilk@oracle.com, rjw@rjwysocki.net,
        tglx@linutronix.de, bhelgaas@google.com, tony.luck@intel.com,
        joro@8bytes.org
In-Reply-To: <1414397531-28254-20-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-20-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: e1d8f79a27a41493c8f1ad0bde440048e17f9494
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

Commit-ID:  e1d8f79a27a41493c8f1ad0bde440048e17f9494
Gitweb:     http://git.kernel.org/tip/e1d8f79a27a41493c8f1ad0bde440048e17f9494
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:10 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:48 +0100

iommu/amd: Use helpers to access irq_cfg data structure associated with IRQ

Use helpers to access irq_cfg data structure associated with IRQ,
instead of accessing irq_data->chip_data directly. Later we can
rewrite those helpers to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1414397531-28254-20-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/amd_iommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 505a9ad..6fda7cc 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4068,7 +4068,7 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	int devid;
 	int ret;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4131,7 +4131,7 @@ static int set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (!config_enabled(CONFIG_SMP))
 		return -1;
 
-	cfg       = data->chip_data;
+	cfg       = irqd_cfg(data);
 	irq       = data->irq;
 	irte_info = &cfg->irq_2_irte;
 
@@ -4169,7 +4169,7 @@ static int free_irq(int irq)
 	struct irq_2_irte *irte_info;
 	struct irq_cfg *cfg;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4188,7 +4188,7 @@ static void compose_msi_msg(struct pci_dev *pdev,
 	struct irq_cfg *cfg;
 	union irte irte;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return;
 
@@ -4217,7 +4217,7 @@ static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4237,7 +4237,7 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4260,7 +4260,7 @@ static int alloc_hpet_msi(unsigned int irq, unsigned int id)
 	struct irq_cfg *cfg;
 	int index, devid;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
