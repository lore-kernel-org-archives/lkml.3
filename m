Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3CNKgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:36:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3CNKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joerg Roedel <joro@8bytes.org>, Shuah Khan <shuah.khan@hp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 03/88] iommu/amd: Initialize device table after dma_ops
Date: Thu, 14 Mar 2013 10:34:56 +0000
Message-Id: <1363257381-15900-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/amd_iommu_init.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index eadc6b5..9e5096a 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1572,9 +1572,6 @@ int __init amd_iommu_init_hardware(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1655,6 +1652,7 @@ out:
  */
 static int __init amd_iommu_init(void)
 {
+	struct amd_iommu *iommu;
 	int ret = 0;
 
 	ret = amd_iommu_init_hardware();
@@ -1673,6 +1671,12 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	/* init the device table */
+	init_device_table();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	amd_iommu_init_api();
 
 	x86_platform.iommu_shutdown = disable_iommus;
-- 
1.8.1.2

