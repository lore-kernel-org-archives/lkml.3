Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaLSOMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:12:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaLSOMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:12:13 -0500
Date: Fri, 19 Dec 2014 06:11:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-719b530cdc70b45f22fed2185db8b34568b4c3f8@git.kernel.org>
Cc: bp@alien8.de, rdunlap@infradead.org, rjw@rjwysocki.net, yinghai@kernel.org,
        tglx@linutronix.de, jiang.liu@linux.intel.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, joro@8bytes.org,
        mingo@kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, benh@kernel.crashing.org, tony.luck@intel.com
Reply-To: gregkh@linuxfoundation.org, hpa@zytor.com, joro@8bytes.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        bhelgaas@google.com, benh@kernel.crashing.org, tony.luck@intel.com,
        bp@alien8.de, rdunlap@infradead.org, rjw@rjwysocki.net,
        yinghai@kernel.org, jiang.liu@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1414397531-28254-20-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-20-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: 719b530cdc70b45f22fed2185db8b34568b4c3f8
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

Commit-ID:  719b530cdc70b45f22fed2185db8b34568b4c3f8
Gitweb:     http://git.kernel.org/tip/719b530cdc70b45f22fed2185db8b34568b4c3f8
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:10 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:17 +0100

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
index 2d84c9e..d65f766 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4069,7 +4069,7 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	int devid;
 	int ret;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4132,7 +4132,7 @@ static int set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (!config_enabled(CONFIG_SMP))
 		return -1;
 
-	cfg       = data->chip_data;
+	cfg       = irqd_cfg(data);
 	irq       = data->irq;
 	irte_info = &cfg->irq_2_irte;
 
@@ -4170,7 +4170,7 @@ static int free_irq(int irq)
 	struct irq_2_irte *irte_info;
 	struct irq_cfg *cfg;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4189,7 +4189,7 @@ static void compose_msi_msg(struct pci_dev *pdev,
 	struct irq_cfg *cfg;
 	union irte irte;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return;
 
@@ -4218,7 +4218,7 @@ static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4238,7 +4238,7 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	if (!pdev)
 		return -EINVAL;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
@@ -4261,7 +4261,7 @@ static int alloc_hpet_msi(unsigned int irq, unsigned int id)
 	struct irq_cfg *cfg;
 	int index, devid;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 	if (!cfg)
 		return -EINVAL;
 
