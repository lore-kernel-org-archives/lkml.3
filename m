Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaEEMxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41013 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jay Cornwall <jay.cornwall@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 06/50] iommu/amd: Fix PASID format in INVALIDATE_IOTLB_PAGES command
Date: Mon,  5 May 2014 14:42:48 +0200
Message-Id: <8152809394aea1d96e0ebf77700c9e4f2237d04e.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cornwall <jay.cornwall@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e8d2d82d4a73f37b3270e4fd19ba83e48b589656 upstream.

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
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iommu/amd_iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 72531f008a5e..5d2edb4b60aa 100644
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
1.9.2

