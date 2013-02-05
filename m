Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3BEWLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3BEWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 64/93] IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround
Date: Tue,  5 Feb 2013 20:06:53 -0200
Message-Id: <1360102042-10732-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 318fe782539c4150d1b8e4e6c9dc3a896512cb8a upstream.

The IOMMU may stop processing page translations due to a perceived lack
of credits for writing upstream peripheral page service request (PPR)
or event logs. If the L2B miscellaneous clock gating feature is enabled
the IOMMU does not properly register credits after the log request has
completed, leading to a potential system hang.

BIOSes are supposed to disable L2B micellaneous clock gating by setting
L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b. This
patch corrects that for those which do not enable this workaround.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/iommu/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index a33612f..eadc6b5 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1002,6 +1002,38 @@ static void __init free_iommu_all(void)
 }
 
 /*
+ * Family15h Model 10h-1fh erratum 746 (IOMMU Logging May Stall Translations)
+ * Workaround:
+ *     BIOS should disable L2B micellaneous clock gating by setting
+ *     L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b
+ */
+static void __init amd_iommu_erratum_746_workaround(struct amd_iommu *iommu)
+{
+	u32 value;
+
+	if ((boot_cpu_data.x86 != 0x15) ||
+	    (boot_cpu_data.x86_model < 0x10) ||
+	    (boot_cpu_data.x86_model > 0x1f))
+		return;
+
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
+	pci_read_config_dword(iommu->dev, 0xf4, &value);
+
+	if (value & BIT(2))
+		return;
+
+	/* Select NB indirect register 0x90 and enable writing */
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90 | (1 << 8));
+
+	pci_write_config_dword(iommu->dev, 0xf4, value | 0x4);
+	pr_info("AMD-Vi: Applying erratum 746 workaround for IOMMU at %s\n",
+		dev_name(&iommu->dev->dev));
+
+	/* Clear the enable writing bit */
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
+}
+
+/*
  * This function clues the initialization function for one IOMMU
  * together and also allocates the command buffer and programs the
  * hardware. It does NOT enable the IOMMU. This is done afterwards.
@@ -1062,6 +1094,8 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
+	amd_iommu_erratum_746_workaround(iommu);
+
 	return pci_enable_device(iommu->dev);
 }
 
-- 
1.7.9.5

