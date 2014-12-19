Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaLSOLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:11:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaLSOLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:11:40 -0500
Date: Fri, 19 Dec 2014 06:10:49 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-b71a3b2944223de30a9744d35f93625d1298d692@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, konrad.wilk@oracle.com, hpa@zytor.com,
        tony.luck@intel.com, yinghai@kernel.org, rdunlap@infradead.org,
        jiang.liu@linux.intel.com, bp@alien8.de, bhelgaas@google.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de, rjw@rjwysocki.net
Reply-To: joro@8bytes.org, konrad.wilk@oracle.com, benh@kernel.crashing.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        bp@alien8.de, gregkh@linuxfoundation.org, bhelgaas@google.com,
        tglx@linutronix.de, rjw@rjwysocki.net, tony.luck@intel.com,
        yinghai@kernel.org, jiang.liu@linux.intel.com, rdunlap@infradead.org
In-Reply-To: <1414397531-28254-18-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: b71a3b2944223de30a9744d35f93625d1298d692
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

Commit-ID:  b71a3b2944223de30a9744d35f93625d1298d692
Gitweb:     http://git.kernel.org/tip/b71a3b2944223de30a9744d35f93625d1298d692
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:08 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:17 +0100

x86: irq_remapping: Use helpers to access irq_cfg data structure associated with IRQ

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
Link: http://lkml.kernel.org/r/1414397531-28254-18-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/iommu/irq_remapping.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 2c3f5ad..89c4846 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -298,7 +298,7 @@ static int set_remapped_irq_affinity(struct irq_data *data,
 
 void free_remapped_irq(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
@@ -311,7 +311,7 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!irq_remapped(cfg))
 		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
@@ -364,7 +364,7 @@ static void ir_ack_apic_edge(struct irq_data *data)
 static void ir_ack_apic_level(struct irq_data *data)
 {
 	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, data->chip_data);
+	eoi_ioapic_irq(data->irq, irqd_cfg(data));
 }
 
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
