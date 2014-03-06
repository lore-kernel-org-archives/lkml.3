Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbaCFAzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:55:48 -0500
Received: from [213.199.154.204] ([213.199.154.204]:19411 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754511AbaCFAzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:55:46 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zze0eahzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZP6U-08-FVR-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, <kim.naru@amd.com>, <jay.cornwall@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH V2] iommu/amd: Fix logic to determine and checking max PASID
Date: Wed, 5 Mar 2014 18:54:18 -0600
Message-ID: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

In reality, the spec can only support 16-bit PASID since
INVALIDATE_IOTLB_PAGES and COMPLETE_PPR_REQUEST commands only allow 16-bit
PASID. So, we updated the PASID_MASK accordingly and invoke BUG_ON
if the hardware is reporting PASmax more than 16-bit.

Besides, max PASID is defined as ((2^(PASmax+1)) - 1). The current does not
determine this correctly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
---
 drivers/iommu/amd_iommu.c       |    4 ++--
 drivers/iommu/amd_iommu_init.c  |   16 +++++++++-------
 drivers/iommu/amd_iommu_types.h |   11 ++++++++---
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index faf0da4..66ef2cb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -963,7 +963,7 @@ static void build_inv_iommu_pasid(struct iommu_cmd *cmd, u16 domid, int pasid,
 
 	address &= ~(0xfffULL);
 
-	cmd->data[0]  = pasid & PASID_MASK;
+	cmd->data[0]  = pasid;
 	cmd->data[1]  = domid;
 	cmd->data[2]  = lower_32_bits(address);
 	cmd->data[3]  = upper_32_bits(address);
@@ -1001,7 +1001,7 @@ static void build_complete_ppr(struct iommu_cmd *cmd, u16 devid, int pasid,
 
 	cmd->data[0]  = devid;
 	if (gn) {
-		cmd->data[1]  = pasid & PASID_MASK;
+		cmd->data[1]  = pasid;
 		cmd->data[2]  = CMD_INV_IOMMU_PAGES_GN_MASK;
 	}
 	cmd->data[3]  = tag & 0x1ff;
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 28b4bea..b76c58d 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -150,7 +150,7 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 bool amd_iommu_iotlb_sup __read_mostly = true;
 
-u32 amd_iommu_max_pasids __read_mostly = ~0;
+u32 amd_iommu_max_pasid __read_mostly = ~0;
 
 bool amd_iommu_v2_present __read_mostly;
 bool amd_iommu_pc_present __read_mostly;
@@ -1231,14 +1231,16 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 
 	if (iommu_feature(iommu, FEATURE_GT)) {
 		int glxval;
-		u32 pasids;
-		u64 shift;
+		u32 max_pasid;
+		u64 pasmax;
 
-		shift   = iommu->features & FEATURE_PASID_MASK;
-		shift >>= FEATURE_PASID_SHIFT;
-		pasids  = (1 << shift);
+		pasmax = iommu->features & FEATURE_PASID_MASK;
+		pasmax >>= FEATURE_PASID_SHIFT;
+		max_pasid  = (1 << (pasmax + 1)) - 1;
 
-		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
+		amd_iommu_max_pasid = min(amd_iommu_max_pasid, max_pasid);
+
+		BUG_ON(amd_iommu_max_pasid & ~PASID_MASK);
 
 		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
 		glxval >>= FEATURE_GLXVAL_SHIFT;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e400fbe..55ba46b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -98,7 +98,12 @@
 #define FEATURE_GLXVAL_SHIFT	14
 #define FEATURE_GLXVAL_MASK	(0x03ULL << FEATURE_GLXVAL_SHIFT)
 
-#define PASID_MASK		0x000fffff
+/* Note:
+ * The current driver only support 16-bit PASID.
+ * Currently, hardware only implement upto 16-bit PASID
+ * even though the spec says it could have upto 20 bits.
+ */
+#define PASID_MASK		0x0000ffff
 
 /* MMIO status bits */
 #define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
@@ -696,8 +701,8 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
  */
 extern u32 amd_iommu_unmap_flush;
 
-/* Smallest number of PASIDs supported by any IOMMU in the system */
-extern u32 amd_iommu_max_pasids;
+/* Smallest max PASID supported by any IOMMU in the system */
+extern u32 amd_iommu_max_pasid;
 
 extern bool amd_iommu_v2_present;
 
-- 
1.7.10.4


