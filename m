Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaLSOL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:11:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaLSOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:11:55 -0500
Date: Fri, 19 Dec 2014 06:11:06 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-91411da1f99f4b626ec63b5faa30e75c468045a3@git.kernel.org>
Cc: joro@8bytes.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tglx@linutronix.de, yinghai@kernel.org, jiang.liu@linux.intel.com,
        mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, rjw@rjwysocki.net, tony.luck@intel.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com, bp@alien8.de
Reply-To: mingo@kernel.org, jiang.liu@linux.intel.com, bp@alien8.de,
        bhelgaas@google.com, gregkh@linuxfoundation.org, tony.luck@intel.com,
        rjw@rjwysocki.net, benh@kernel.crashing.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rdunlap@infradead.org, konrad.wilk@oracle.com, joro@8bytes.org,
        yinghai@kernel.org
In-Reply-To: <1414397531-28254-19-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-19-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: 91411da1f99f4b626ec63b5faa30e75c468045a3
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

Commit-ID:  91411da1f99f4b626ec63b5faa30e75c468045a3
Gitweb:     http://git.kernel.org/tip/91411da1f99f4b626ec63b5faa30e75c468045a3
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:09 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:17 +0100

iommu/vt-d: Use helpers to access irq_cfg data structure associated with IRQ

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
Link: http://lkml.kernel.org/r/1414397531-28254-19-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/iommu/intel_irq_remapping.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 27541d4..a55b207 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -54,7 +54,7 @@ static int __init parse_ioapics_under_ir(void);
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	return cfg ? &cfg->irq_2_iommu : NULL;
 }
 
@@ -85,7 +85,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
 	int index;
@@ -153,7 +153,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -1050,7 +1050,7 @@ static int
 intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			  bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
 	int err;
@@ -1105,7 +1105,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	u16 sub_handle = 0;
 	int ir_index;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 
 	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
 	BUG_ON(ir_index == -1);
