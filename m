Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3CREit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:38:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33647 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab3CREbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:06 -0400
Message-Id: <20130318042147.707124294@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Shuah Khan <shuah.khan@hp.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 36/82] iommu/amd: Initialize device table after dma_ops
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

commit f528d980c17b8714aedc918ba86e058af914d66b upstream.

When dma_ops are initialized the unity mappings are created. The
init_device_table_dma() function makes sure DMA from all devices is
blocked by default. This opens a short window in time where DMA to
unity mapped regions is blocked by the IOMMU. Make sure this does not
happen by initializing the device table after dma_ops.

Tested on 3.2.38

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu_init.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1396,6 +1396,7 @@ static struct syscore_ops amd_iommu_sysc
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


