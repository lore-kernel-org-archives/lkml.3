Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AWSOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:14:03 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:28924
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab3AWSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:14:01 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MH3BZ0-01-OB9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <bp@alien8.de>, <linux-kernel@vger.kernel.org>, <udovdh@xs4all.nl>,
        <ssg.sos.patches@mpdtxmail.amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/1 V2] AMD Family15h Model10-1Fh erratum 746 Workaround
Date: Wed, 23 Jan 2013 12:13:28 -0600
Message-ID: <1358964808-2124-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Changes from V1:
* Fix logic that check the processor model.
* Clear writing enable bit after apply the workaround
* Change function name

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 81837b0..a04b20a 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -975,6 +975,37 @@ static void __init free_iommu_all(void)
 }
 
 /*
+ * AMD family15h Model 10h-1fh erratum 746 (IOMMU Logging May Stall Translations)
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
+	if (!(value & 0x4)) {
+		/* Select Northbridge indirect register 0x90 and enable writing */
+		pci_write_config_dword(iommu->dev, 0xf0, 0x90 | (1 << 8));
+
+		pci_write_config_dword(iommu->dev, 0xf4, value | 0x4);
+		pr_info("AMD-Vi: Applying erratum 746 workaround for IOMMU at %s\n",
+		 dev_name(&iommu->dev->dev));
+
+		/* Clear the enable writing bit */
+		pci_write_config_dword(iommu->dev, 0xf0, 0x90);
+	}
+}
+
+/*
  * This function clues the initialization function for one IOMMU
  * together and also allocates the command buffer and programs the
  * hardware. It does NOT enable the IOMMU. This is done afterwards.
@@ -1171,6 +1202,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 		for (i = 0; i < 0x83; i++)
 			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
 	}
+	
+	amd_iommu_erratum_746_workaround(iommu);
 
 	return pci_enable_device(iommu->dev);
 }
-- 
1.7.10.4


