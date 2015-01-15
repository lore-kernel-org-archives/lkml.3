Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbbAOND2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:03:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbAONDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:03:24 -0500
Date: Thu, 15 Jan 2015 05:03:00 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-30969e34ae6edf10a003f6c0be1fecf6dadcd421@git.kernel.org>
Cc: benh@kernel.crashing.org, tony.luck@intel.com, joro@8bytes.org,
        yinghai@kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, bp@alien8.de, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com
Reply-To: tglx@linutronix.de, bp@alien8.de, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        tony.luck@intel.com, joro@8bytes.org, yinghai@kernel.org,
        mingo@kernel.org, hpa@zytor.com
In-Reply-To: <1420615903-28253-15-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/irq_remapping:
  Refine function irq_remapping_prepare() for maintenance
Git-Commit-ID: 30969e34ae6edf10a003f6c0be1fecf6dadcd421
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

Commit-ID:  30969e34ae6edf10a003f6c0be1fecf6dadcd421
Gitweb:     http://git.kernel.org/tip/30969e34ae6edf10a003f6c0be1fecf6dadcd421
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:41 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:24 +0100

iommu/irq_remapping: Refine function irq_remapping_prepare() for maintenance

Assign intel_irq_remap_ops to remap_ops only if
intel_irq_remap_ops.prepare() succeeds.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/irq_remapping.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index e7449b4..7d85d2b 100644
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
