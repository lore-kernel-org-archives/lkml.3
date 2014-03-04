Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbaCDU5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:57:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaCDUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.13 140/172] iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts
Date: Tue,  4 Mar 2014 12:03:44 -0800
Message-Id: <20140304200304.185240260@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 57ca90f6800987ac274d7ba065ae6692cdf9bcd7 upstream.

Whilst trying to bring-up an SMMUv2 implementation with the table
walker plumbed into a coherent interconnect, I noticed that the memory
transactions targetting the CPU caches from the SMMU were marked as
outer-shareable instead of inner-shareable.

After a bunch of digging, it seems that we actually need to program
CBARn.BPSHCFG for s1-s2-bypass contexts to act as non-shareable in order
for the shareability configured in the corresponding TTBCR not to be
overridden with an outer-shareable attribute.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -189,6 +189,9 @@
 #define ARM_SMMU_GR1_CBAR(n)		(0x0 + ((n) << 2))
 #define CBAR_VMID_SHIFT			0
 #define CBAR_VMID_MASK			0xff
+#define CBAR_S1_BPSHCFG_SHIFT		8
+#define CBAR_S1_BPSHCFG_MASK		3
+#define CBAR_S1_BPSHCFG_NSH		3
 #define CBAR_S1_MEMATTR_SHIFT		12
 #define CBAR_S1_MEMATTR_MASK		0xf
 #define CBAR_S1_MEMATTR_WB		0xf
@@ -670,11 +673,16 @@ static void arm_smmu_init_context_bank(s
 	if (smmu->version == 1)
 	      reg |= root_cfg->irptndx << CBAR_IRPTNDX_SHIFT;
 
-	/* Use the weakest memory type, so it is overridden by the pte */
-	if (stage1)
-		reg |= (CBAR_S1_MEMATTR_WB << CBAR_S1_MEMATTR_SHIFT);
-	else
+	/*
+	 * Use the weakest shareability/memory types, so they are
+	 * overridden by the ttbcr/pte.
+	 */
+	if (stage1) {
+		reg |= (CBAR_S1_BPSHCFG_NSH << CBAR_S1_BPSHCFG_SHIFT) |
+			(CBAR_S1_MEMATTR_WB << CBAR_S1_MEMATTR_SHIFT);
+	} else {
 		reg |= ARM_SMMU_CB_VMID(root_cfg) << CBAR_VMID_SHIFT;
+	}
 	writel_relaxed(reg, gr1_base + ARM_SMMU_GR1_CBAR(root_cfg->cbndx));
 
 	if (smmu->version > 1) {


