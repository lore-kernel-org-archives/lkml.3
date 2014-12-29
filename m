Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaL2JAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:00:24 -0500
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:54979
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbaL2JAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:00:22 -0500
X-WSS-ID: 0NHC6CD-08-KLJ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>
CC: <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        LKP ML <lkp@01.org>, <ak@linux.intel.com>, <rusty@rustcorp.com.au>,
        <deathsimple@vodafone.de>, <airlied@linux.ie>
Subject: [PATCH v2] drm/radeon: Init amdkfd only if it was compiled
Date: Mon, 29 Dec 2014 10:59:46 +0200
Message-ID: <1419843586-29864-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50466002)(20776003)(64706001)(19580395003)(106466001)(19580405001)(101416001)(31966008)(92566001)(99396003)(86362001)(48376002)(120916001)(47776003)(50986999)(46102003)(68736005)(87936001)(84676001)(97736003)(50226001)(21056001)(229853001)(36756003)(107046002)(4396001)(89996001)(33646002)(77096005)(77156002)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 09:00:17.6056
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the radeon_kfd_init(), which is used to initialize the
interface between radeon and amdkfd, so the interface will be initialized only
if amdkfd was build, either as module or inside the kernel image.

In the modules case, the symbol_request() will be used (same as old code). In
the in-image compilation case, a direct call to kgd2kfd_init() will be done.
For other cases, radeon_kfd_init() will just return false.

This patch is necessary because in case of the following specific
configuration: kernel 32-bit, no modules support, random kernel base and no
hibernation, the symbol_request() doesn't work as expected - it doesn't return
NULL if the symbol doesn't exists - which makes the kernel panic.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 242fd8b..d3e78b4 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -101,6 +101,7 @@ static const struct kgd2kfd_calls *kgd2kfd;
 
 bool radeon_kfd_init(void)
 {
+#if defined(CONFIG_HSA_AMD_MODULE)
 	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
 				const struct kgd2kfd_calls**);
 
@@ -117,6 +118,17 @@ bool radeon_kfd_init(void)
 	}
 
 	return true;
+#elif defined(CONFIG_HSA_AMD)
+	if (!kgd2kfd_init(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
+		kgd2kfd = NULL;
+
+		return false;
+	}
+
+	return true;
+#else
+	return false;
+#endif
 }
 
 void radeon_kfd_fini(void)
-- 
1.9.1

