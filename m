Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaGWQNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:13:31 -0400
Received: from legacy.ddn.com ([64.47.133.206]:40498 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaGWQNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:13:30 -0400
Date: Wed, 23 Jul 2014 10:13:26 -0600
From: Greg Edwards <gedwards@ddn.com>
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] iommu/vt-d: race setting IRQ CPU affinity while freeing
 IRQ
Message-ID: <20140723161326.GB32422@psuche.datadirectnet.com>
References: <20140722142719.GA28143@psuche.datadirectnet.com>
 <20140723144024.GA14017@8bytes.org>
 <20140723144917.GA26986@psuche.datadirectnet.com>
 <20140723151040.GB14017@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140723151040.GB14017@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.32.22.129]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A user process setting the CPU affinity of an IRQ for a KVM
direct-assigned device via /proc/irq/<IRQ#>/smp_affinity can race with
the IRQ being released by QEMU, resulting in a NULL iommu pointer
dereference in get_irte().

Signed-off-by: Greg Edwards <gedwards@ddn.com>
---

Dropped the Cc: for stable since this likely wouldn't ever be seen in
the real world.  We saw it on an automated CI stress test.

 drivers/iommu/intel_irq_remapping.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9b17489..d926676 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -70,6 +70,11 @@ static int get_irte(int irq, struct irte *entry)
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
+	if (unlikely(!irq_iommu->iommu)) {
+		raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+		return -1;
+	}
+
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
-- 
1.9.3

