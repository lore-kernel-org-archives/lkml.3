Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbbAGHaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:30:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:2508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbbAGHaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:30:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665634192"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [Patch v2 14/16] iommu/irq_remapping: Refine function irq_remapping_prepare() for maintenance
Date: Wed,  7 Jan 2015 15:31:41 +0800
Message-Id: <1420615903-28253-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign intel_irq_remap_ops to remap_ops only if
intel_irq_remap_ops.prepare() succeeds.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/irq_remapping.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index e7449b42504d..7d85d2ba0e8b 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -204,15 +204,15 @@ int __init irq_remapping_prepare(void)
 	if (disable_irq_remap)
 		return -ENOSYS;
 
-	remap_ops = &intel_irq_remap_ops;
-
-#ifdef CONFIG_AMD_IOMMU
-	if (amd_iommu_irq_ops.prepare() == 0) {
+	if (intel_irq_remap_ops.prepare() == 0)
+		remap_ops = &intel_irq_remap_ops;
+	else if (IS_ENABLED(CONFIG_AMD_IOMMU) &&
+		 amd_iommu_irq_ops.prepare() == 0)
 		remap_ops = &amd_iommu_irq_ops;
-		return 0;
-	}
-#endif
-	return remap_ops->prepare();
+	else
+		return -ENOSYS;
+
+	return 0;
 }
 
 int __init irq_remapping_enable(void)
-- 
1.7.10.4

