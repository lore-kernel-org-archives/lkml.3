Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab3B1Vj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:39:57 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39031 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab3B1Vjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:39:55 -0500
Message-ID: <1362087590.2822.44.camel@lorien2>
Subject: [PATCH 3.2] iommu/amd: Initialize device table after dma_ops
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        ben@decadent.org.uk, shuahkhan@gmail.com
Date: Thu, 28 Feb 2013 14:39:50 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dma_ops are initialized the unity mappings are created. The
init_device_table_dma() function makes sure DMA from all devices is
blocked by default. This opens a short window in time where DMA to
unity mapped regions is blocked by the IOMMU. Make sure this does not
happen by initializing the device table after dma_ops.

Back-port upstream commit: f528d980c17b8714aedc918ba86e058af914d66b
Tested on 3.2.38

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: stable@vger.kernel.org 3.2
---
 drivers/iommu/amd_iommu_init.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 62a4d5c..b7d1cdd 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1396,6 +1396,7 @@ static struct syscore_ops amd_iommu_syscore_ops = {
  */
 static int __init amd_iommu_init(void)
 {
+	struct amd_iommu *iommu;
 	int i, ret = 0;
 
 	/*
@@ -1444,9 +1445,6 @@ static int __init amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1496,6 +1494,12 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free_disable;
 
+	/* init the device table */
+	init_device_table();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	amd_iommu_init_api();
 
 	amd_iommu_init_notifier();
-- 
1.7.10.4



