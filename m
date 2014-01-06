Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaAFGU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:20:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:37985 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaAFGSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364942"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 17/20] iommu/vt-d: fix wrong return value of dmar_table_init()
Date: Mon,  6 Jan 2014 14:18:24 +0800
Message-Id: <1388989107-4795-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dmar_table_init() fails to detect DMAR table on the first call,
it will return wrong result on following calls because it always
sets dmar_table_initialized no matter if succeeds or fails to
detect DMAR table.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index bb635fb..c4b271d 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -472,24 +472,23 @@ int __init dmar_table_init(void)
 	static int dmar_table_initialized;
 	int ret;
 
-	if (dmar_table_initialized)
-		return 0;
-
-	dmar_table_initialized = 1;
-
-	ret = parse_dmar_table();
-	if (ret) {
-		if (ret != -ENODEV)
-			pr_info("parse DMAR table failure.\n");
-		return ret;
-	}
+	if (dmar_table_initialized == 0) {
+		ret = parse_dmar_table();
+		if (ret < 0) {
+			if (ret != -ENODEV)
+				pr_info("parse DMAR table failure.\n");
+		} else  if (list_empty(&dmar_drhd_units)) {
+			pr_info("No DMAR devices found\n");
+			ret = -ENODEV;
+		}
 
-	if (list_empty(&dmar_drhd_units)) {
-		pr_info("No DMAR devices found\n");
-		return -ENODEV;
+		if (ret < 0)
+			dmar_table_initialized = ret;
+		else
+			dmar_table_initialized = 1;
 	}
 
-	return 0;
+	return dmar_table_initialized < 0 ? dmar_table_initialized : 0;
 }
 
 static void warn_invalid_dmar(u64 addr, const char *message)
-- 
1.7.10.4

