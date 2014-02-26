Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaBZVtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:49:51 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:15506
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbaBZVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:49:49 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zze0eahzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
X-WSS-ID: 0N1MHYS-08-2TA-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, Jay Cornwall <jay.cornwall@amd.com>
Subject: [PATCH 1/1] iommu/amd: Fix PASID format in INVALIDATE_IOTLB_PAGES command
Date: Wed, 26 Feb 2014 15:49:31 -0600
Message-ID: <1393451371-17894-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cornwall <jay.cornwall@amd.com>

This patch corrects the PASID format in the INVALIDATE_IOTLB_PAGES
command, which was caused by incorrect information in
the AMD IOMMU Architectural Specification v2.01 document.

    Incorrect format:
         cmd->data[0][16:23] = PASID[7:0]
         cmd->data[1][16:27] = PASID[19:8]

     Correct format:
         cmd->data[0][16:23] = PASID[15:8]
         cmd->data[1][16:23] = PASID[7:0]

However, this does not affect the IOMMUv2 hardware implementation,
and has been corrected since version 2.02 of the specification
(available through AMD NDA).

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index faf0da4..1dd9f81 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -982,10 +982,10 @@ static void build_inv_iotlb_pasid(struct iommu_cmd *cmd, u16 devid, int pasid,
 	address &= ~(0xfffULL);
 
 	cmd->data[0]  = devid;
-	cmd->data[0] |= (pasid & 0xff) << 16;
+	cmd->data[0] |= ((pasid >> 8) & 0xff) << 16;
 	cmd->data[0] |= (qdep  & 0xff) << 24;
 	cmd->data[1]  = devid;
-	cmd->data[1] |= ((pasid >> 8) & 0xfff) << 16;
+	cmd->data[1] |= (pasid & 0xff) << 16;
 	cmd->data[2]  = lower_32_bits(address);
 	cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
 	cmd->data[3]  = upper_32_bits(address);
-- 
1.8.1.2


