Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaLVLLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:11:39 -0500
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:2656
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753978AbaLVLLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:11:37 -0500
X-WSS-ID: 0NGZDR8-07-89W-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Alexander Deucher <Alexander.Deucher@amd.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>, "Huang Ying" <ying.huang@intel.com>,
        LKP ML <lkp@01.org>
Subject: [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
Date: Mon, 22 Dec 2014 13:11:13 +0200
Message-ID: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(31966008)(36756003)(68736005)(50226001)(106466001)(86362001)(4396001)(19580395003)(19580405001)(50466002)(48376002)(64706001)(21056001)(47776003)(97736003)(107046002)(77096005)(20776003)(92566001)(33646002)(105586002)(46102003)(101416001)(110136001)(50986999)(229853001)(89996001)(87936001)(120916001)(84676001)(99396003)(62966003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB193;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 11:11:33.9442
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amdkfd driver can be compiled only in 64-bit kernel. Therefore, there is no
point in trying to initialize amdkfd in 32-bit kernel.

In addition, in case of specific configuration of 32-bit kernel, no modules and
random kernel base, the symbol_request function doesn't work as expected - It
doesn't return NULL if the symbol doesn't exists. That makes the kernel panic.
Therefore, the as amdkfd doesn't compile in 32-bit kernel, the best way is just
to return false immediately.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 242fd8b..cb77e5c 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -101,6 +101,7 @@ static const struct kgd2kfd_calls *kgd2kfd;
 
 bool radeon_kfd_init(void)
 {
+#ifdef CONFIG_X86_64
 	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
 				const struct kgd2kfd_calls**);
 
@@ -117,6 +118,9 @@ bool radeon_kfd_init(void)
 	}
 
 	return true;
+#else
+	return false;
+#endif
 }
 
 void radeon_kfd_fini(void)
-- 
1.9.1

