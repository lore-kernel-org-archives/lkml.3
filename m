Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaGVOck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:32:40 -0400
Received: from legacy.ddn.com ([64.47.133.206]:48347 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaGVOcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:32:39 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 10:32:39 EDT
Date: Tue, 22 Jul 2014 08:27:19 -0600
From: Greg Edwards <gedwards@ddn.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] iommu/vt-d: fix race between free_irte() and get_irte()
Message-ID: <20140722142719.GA28143@psuche.datadirectnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.32.22.129]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_irte() can race with free_irte() and dereference a NULL iommu
pointer.

Signed-off-by: Greg Edwards <gedwards@ddn.com>
Cc: stable@vger.kernel.org
---
 drivers/iommu/intel_irq_remapping.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9b17489..2d67e6d 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -70,6 +70,12 @@ static int get_irte(int irq, struct irte *entry)
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
+	/* ensure we're not racing with free_irte() */
+	if (unlikely(!irq_iommu->iommu)) {
+		raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+		return -1;
+	}
+
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
-- 
1.9.3

