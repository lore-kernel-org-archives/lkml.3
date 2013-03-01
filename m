Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3CAUWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:22:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3CATpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 19/77] iommu/amd: Initialize device table after dma_ops
Date: Fri,  1 Mar 2013 11:44:04 -0800
Message-Id: <20130301194354.017027335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit f528d980c17b8714aedc918ba86e058af914d66b upstream.

When dma_ops are initialized the unity mappings are
created. The init_device_table_dma() function makes sure DMA
from all devices is blocked by default. This opens a short
window in time where DMA to unity mapped regions is blocked
by the IOMMU. Make sure this does not happen by initializing
the device table after dma_ops.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1876,11 +1876,6 @@ static int amd_iommu_init_dma(void)
 	struct amd_iommu *iommu;
 	int ret;
 
-	init_device_table_dma();
-
-	for_each_iommu(iommu)
-		iommu_flush_all_caches(iommu);
-
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1889,6 +1884,11 @@ static int amd_iommu_init_dma(void)
 	if (ret)
 		return ret;
 
+	init_device_table_dma();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	amd_iommu_init_api();
 
 	amd_iommu_init_notifier();


