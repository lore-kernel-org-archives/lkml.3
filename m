Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3CATqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3CATqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Shuah Khan <shuah.khan@hp.com>
Subject: [ 03/46] iommu/amd: Initialize device table after dma_ops
Date: Fri,  1 Mar 2013 11:44:51 -0800
Message-Id: <20130301194432.634764528@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1572,8 +1572,6 @@ int __init amd_iommu_init_hardware(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
-	/* init the device table */
-	init_device_table();
 
 	/*
 	 * let all alias entries point to itself
@@ -1655,6 +1653,7 @@ out:
  */
 static int __init amd_iommu_init(void)
 {
+	struct amd_iommu *iommu;
 	int ret = 0;
 
 	ret = amd_iommu_init_hardware();
@@ -1673,6 +1672,12 @@ static int __init amd_iommu_init(void)
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


