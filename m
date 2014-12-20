Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaLTVBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 16:01:53 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:62537
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752011AbaLTVBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 16:01:51 -0500
X-WSS-ID: 0NGWF1K-07-758-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, <linux-kernel@vger.kernel.org>,
        "John Bridgman" <John.Bridgman@amd.com>, <Alexander.Deucher@amd.com>
Subject: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
Date: Sat, 20 Dec 2014 22:46:12 +0200
Message-ID: <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(21056001)(46102003)(97736003)(76176999)(50986999)(99396003)(89996001)(48376002)(77156002)(62966003)(50466002)(87936001)(101416001)(20776003)(64706001)(120916001)(2950100001)(4396001)(50226001)(53416004)(68736005)(77096005)(84676001)(31966008)(19580405001)(47776003)(106466001)(92566001)(110136001)(105586002)(107046002)(229853001)(19580395003)(36756003)(86362001)(33646002)(2351001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0431F981D8
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2014 20:46:35.1091
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When amdkfd and radeon are compiled inside the kernel image (not as modules),
radeon will load before amdkfd and will set *kfd2kgd to its interface
structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd is loaded
because it will override radeon's initialization and cause kernel BUG.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
index 95d5af1..236562f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -34,7 +34,7 @@
 #define KFD_DRIVER_MINOR	7
 #define KFD_DRIVER_PATCHLEVEL	0
 
-const struct kfd2kgd_calls *kfd2kgd;
+const struct kfd2kgd_calls *kfd2kgd = NULL;
 static const struct kgd2kfd_calls kgd2kfd = {
 	.exit		= kgd2kfd_exit,
 	.probe		= kgd2kfd_probe,
@@ -84,14 +84,13 @@ EXPORT_SYMBOL(kgd2kfd_init);
 
 void kgd2kfd_exit(void)
 {
+	kfd2kgd = NULL;
 }
 
 static int __init kfd_module_init(void)
 {
 	int err;
 
-	kfd2kgd = NULL;
-
 	/* Verify module parameters */
 	if ((sched_policy < KFD_SCHED_POLICY_HWS) ||
 		(sched_policy > KFD_SCHED_POLICY_NO_HWS)) {
-- 
2.1.0

