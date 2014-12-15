Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaLOPNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:13:37 -0500
Received: from 8bytes.org ([81.169.241.247]:48620 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaLOPN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:13:29 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/5] iommu/vt-d: Allocate IRQ remapping data structures only for all IOMMUs
Date: Mon, 15 Dec 2014 16:13:20 +0100
Message-Id: <1418656404-28575-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418656404-28575-1-git-send-email-joro@8bytes.org>
References: <1418656404-28575-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

IRQ remapping is only supported when all IOMMUs in the
system support it. So check if all IOMMUs in the system
support IRQ remapping before doing the allocations.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index ff35b03..3ef63b8 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -568,14 +568,16 @@ static int __init intel_prepare_irq_remapping(void)
 		goto error;
 	}
 
-	for_each_iommu(iommu, drhd) {
+	/* First make sure all IOMMUs support IRQ remapping */
+	for_each_iommu(iommu, drhd)
 		if (!ecap_ir_support(iommu->ecap))
-			continue;
+			goto error;
 
-		/* Do the allocations early */
+	/* Do the allocations early */
+	for_each_iommu(iommu, drhd)
 		if (intel_setup_irq_remapping(iommu))
 			goto error;
-	}
+
 	return 0;
 error:
 	intel_cleanup_irq_remapping();
-- 
1.9.1

