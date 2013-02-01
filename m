Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3BANIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:08:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:44555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab3BANIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:08:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <joro@8bytes.org>
Subject: [ 20/89] IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround
Date: Fri,  1 Feb 2013 14:07:35 +0100
Message-Id: <20130201130208.927241627@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -975,6 +975,38 @@ static void __init free_iommu_all(void)
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
@@ -1172,6 +1204,8 @@ static int iommu_init_pci(struct amd_iom
 			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
 	}
 
+	amd_iommu_erratum_746_workaround(iommu);
+
 	return pci_enable_device(iommu->dev);
 }
 


