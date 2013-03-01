Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3CATqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3CATqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Shuah Khan <shuah.khan@hp.com>
Subject: [ 02/30] iommu/amd: Initialize device table after dma_ops
Date: Fri,  1 Mar 2013 11:45:23 -0800
Message-Id: <20130301194528.275438849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/amd_iommu_init.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1363,6 +1363,7 @@ static struct syscore_ops amd_iommu_sysc
  */
 static int __init amd_iommu_init(void)
 {
+	struct amd_iommu *iommu;
 	int i, ret = 0;
 
 	/*
@@ -1411,9 +1412,6 @@ static int __init amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1463,6 +1461,12 @@ static int __init amd_iommu_init(void)
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


