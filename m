Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaKERSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:18:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaKERSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:18:36 -0500
Date: Wed, 5 Nov 2014 09:17:28 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-dd379395f9951e8e152593007d66ede649a31fa5@git.kernel.org>
Cc: mingo@kernel.org, bhelgaas@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        benh@kernel.crashing.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, rjw@rjwysocki.net, rdunlap@infradead.org,
        konrad.wilk@oracle.com, bp@alien8.de, hpa@zytor.com
Reply-To: rdunlap@infradead.org, konrad.wilk@oracle.com, bp@alien8.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, tony.luck@intel.com,
        rjw@rjwysocki.net, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, mingo@kernel.org, bhelgaas@google.com,
        joro@8bytes.org
In-Reply-To: <1414397531-28254-18-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: dd379395f9951e8e152593007d66ede649a31fa5
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

Commit-ID:  dd379395f9951e8e152593007d66ede649a31fa5
Gitweb:     http://git.kernel.org/tip/dd379395f9951e8e152593007d66ede649a31fa5
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:08 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:48 +0100

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
index 74a1767..e9fbd68 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -306,7 +306,7 @@ static int set_remapped_irq_affinity(struct irq_data *data,
 
 void free_remapped_irq(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
@@ -319,7 +319,7 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!irq_remapped(cfg))
 		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
@@ -372,7 +372,7 @@ static void ir_ack_apic_edge(struct irq_data *data)
 static void ir_ack_apic_level(struct irq_data *data)
 {
 	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, data->chip_data);
+	eoi_ioapic_irq(data->irq, irqd_cfg(data));
 }
 
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
