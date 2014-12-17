Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaLQEeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:34:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:37015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaLQEeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:34:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429971513"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [Patch v1 15/17] iommu/irq_remapping: Refine function irq_remapping_prepare() for maintenance
Date: Wed, 17 Dec 2014 12:35:46 +0800
Message-Id: <1418790948-22804-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
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
index eb944ed3a463..a0b26ca853ae 100644
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

