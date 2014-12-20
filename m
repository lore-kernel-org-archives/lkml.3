Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaLTUMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:12:51 -0500
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:52832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbaLTUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:12:48 -0500
X-WSS-ID: 0NGWDH6-07-6OY-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Joerg Roedel <joro@8bytes.org>, <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, John Bridgman <John.Bridgman@amd.com>
Subject: [PATCH] iommu/amd: Track when amd_iommu_v2 init is complete
Date: Sat, 20 Dec 2014 22:12:32 +0200
Message-ID: <1419106352-6486-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(77156002)(107046002)(62966003)(89996001)(99396003)(50986999)(33646002)(87936001)(68736005)(105586002)(106466001)(31966008)(46102003)(86362001)(77096005)(101416001)(21056001)(229853001)(92566001)(53416004)(47776003)(20776003)(64706001)(4396001)(50226001)(97736003)(84676001)(19580405001)(50466002)(48376002)(36756003)(19580395003)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB0995;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB0995;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0201MB0995;
X-Forefront-PRVS: 0431F981D8
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB0995;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2014 20:12:45.1012
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0201MB0995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new exported function to amd_iommu_v2, which returns 1 if the
amd_iommu_v2 initialization function has completed, and 0 otherwise.

This is necessary for the case when amd_iommu_v2 is compiled inside the kernel
image (not as module) and another module (e.g. amdkfd), which is also compiled
inside the kernel image, is dependent on amd_iommu_v2 functionality.

In that case, there is no mechanism in the kernel that enforces the order of
loading between the two modules. Therefore, If the amd_iommu_v2 is loaded
_after_ the other module, and the other module calls one of
amd_iommu_v2 exported functions _before_ amd_iommu_v2 is loaded, than that
function will fail, and as a result, the calling module may fail as well.

Note that when the two modules are compiled as modules, this situation can't
occur as the kernel enforces the order of loading.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 11 +++++++++++
 include/linux/amd-iommu.h    |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 1e6360e..2456f18 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -895,6 +895,14 @@ out_unlock:
 }
 EXPORT_SYMBOL(amd_iommu_set_invalidate_ctx_cb);
 
+static int iommu_v2_init_completed;
+
+int amd_iommu_v2_is_init_completed(void)
+{
+	return iommu_v2_init_completed;
+}
+EXPORT_SYMBOL(amd_iommu_v2_is_init_completed);
+
 static int __init amd_iommu_v2_init(void)
 {
 	int ret;
@@ -903,6 +911,7 @@ static int __init amd_iommu_v2_init(void)
 
 	if (!amd_iommu_v2_supported()) {
 		pr_info("AMD IOMMUv2 functionality not available on this system\n");
+		iommu_v2_init_completed = 1;
 		/*
 		 * Load anyway to provide the symbols to other modules
 		 * which may use AMD IOMMUv2 optionally.
@@ -919,6 +928,8 @@ static int __init amd_iommu_v2_init(void)
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 
+	iommu_v2_init_completed = 1;
+
 	return 0;
 
 out:
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 2b08e79..115c03a 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -169,6 +169,8 @@ typedef void (*amd_iommu_invalidate_ctx)(struct pci_dev *pdev, int pasid);
 extern int amd_iommu_set_invalidate_ctx_cb(struct pci_dev *pdev,
 					   amd_iommu_invalidate_ctx cb);
 
+extern int amd_iommu_v2_is_init_completed(void);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
2.1.0

