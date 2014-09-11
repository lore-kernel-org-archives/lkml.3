Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIKIX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:23:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:19478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaIKIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:23:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629398"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part1 v1 18/18] iommu/amd: Use helpers to access irq_cfg data structure associated with IRQ
Date: Thu, 11 Sep 2014 16:25:05 +0800
Message-Id: <1410423905-26239-19-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helpers to access irq_cfg data structure associated with IRQ,
instead of accessing irq_data->chip_data directly. Later we could
rewrite those helpers to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/amd_iommu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index ecb0109a5360..e0def6249284 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4049,7 +4049,7 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	int devid;
 	int ret;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4112,7 +4112,7 @@ static int set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (!config_enabled(CONFIG_SMP))
 		return -1;
 
-	cfg       = data->chip_data;
+	cfg       = irqd_cfg(data);
 	irq       = data->irq;
 	irte_info = &cfg->irq_2_irte;
 
@@ -4150,7 +4150,7 @@ static int free_irq(int irq)
 	struct irq_2_irte *irte_info;
 	struct irq_cfg *cfg;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4169,7 +4169,7 @@ static void compose_msi_msg(struct pci_dev *pdev,
 	struct irq_cfg *cfg;
 	union irte irte;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return;
 
@@ -4198,7 +4198,7 @@ static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4218,7 +4218,7 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4241,7 +4241,7 @@ static int setup_hpet_msi(unsigned int irq, unsigned int id)
 	struct irq_cfg *cfg;
 	int index, devid;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
-- 
1.7.10.4

