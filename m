Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbbAONG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:06:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbAONGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:06:54 -0500
Date: Thu, 15 Jan 2015 05:01:27 -0800
From: tip-bot for Joerg Roedel <tipbot@zytor.com>
Message-ID: <tip-69cf1d8a1286a7bfbeec497b69c43cc7ebb2a787@git.kernel.org>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com, bp@alien8.de,
        mingo@kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        hpa@zytor.com, joro@8bytes.org
Reply-To: tony.luck@intel.com, hpa@zytor.com, joro@8bytes.org,
        mingo@kernel.org, tglx@linutronix.de, bp@alien8.de,
        benh@kernel.crashing.org, yinghai@kernel.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com
In-Reply-To: <1420615903-28253-10-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Allocate IRQ remapping data structures only for all IOMMUs
Git-Commit-ID: 69cf1d8a1286a7bfbeec497b69c43cc7ebb2a787
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

Commit-ID:  69cf1d8a1286a7bfbeec497b69c43cc7ebb2a787
Gitweb:     http://git.kernel.org/tip/69cf1d8a1286a7bfbeec497b69c43cc7ebb2a787
Author:     Joerg Roedel <jroedel@suse.de>
AuthorDate: Wed, 7 Jan 2015 15:31:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

iommu/vt-d: Allocate IRQ remapping data structures only for all IOMMUs

IRQ remapping is only supported when all IOMMUs in the
system support it. So check if all IOMMUs in the system
support IRQ remapping before doing the allocations.

[Jiang]
1) Rebased to v3.19.
2) Remove redundant check of ecap_ir_support(iommu->ecap) in function
   intel_enable_irq_remapping().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 8ccc7aa..137663b 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -619,10 +619,16 @@ static int __init intel_prepare_irq_remapping(void)
 		goto error;
 	}
 
+	/* First make sure all IOMMUs support IRQ remapping */
 	for_each_iommu(iommu, drhd)
-		if (!ecap_ir_support(iommu->ecap) ||
-		    intel_setup_irq_remapping(iommu))
+		if (!ecap_ir_support(iommu->ecap))
+			goto error;
+
+	/* Do the allocations early */
+	for_each_iommu(iommu, drhd)
+		if (intel_setup_irq_remapping(iommu))
 			goto error;
+
 	return 0;
 
 error:
@@ -673,16 +679,12 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * check for the Interrupt-remapping support
 	 */
-	for_each_iommu(iommu, drhd) {
-		if (!ecap_ir_support(iommu->ecap))
-			continue;
-
+	for_each_iommu(iommu, drhd)
 		if (eim && !ecap_eim_support(iommu->ecap)) {
 			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
 			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
 			goto error;
 		}
-	}
 
 	/*
 	 * Enable queued invalidation for all the DRHD's.
@@ -702,9 +704,6 @@ static int __init intel_enable_irq_remapping(void)
 	 * Setup Interrupt-remapping for all the DRHD's now.
 	 */
 	for_each_iommu(iommu, drhd) {
-		if (!ecap_ir_support(iommu->ecap))
-			continue;
-
 		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
