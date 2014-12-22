Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaLVLHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:07:42 -0500
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:30016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbaLVLHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:07:41 -0500
X-WSS-ID: 0NGZDKN-07-84H-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, Joerg Roedel <joro@8bytes.org>,
        "Jerome Glisse" <j.glisse@gmail.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
Date: Mon, 22 Dec 2014 13:07:13 +0200
Message-ID: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(229853001)(101416001)(50986999)(84676001)(120916001)(77156002)(62966003)(99396003)(89996001)(87936001)(50466002)(4396001)(19580395003)(48376002)(68736005)(36756003)(50226001)(31966008)(86362001)(106466001)(92566001)(105586002)(46102003)(33646002)(97736003)(107046002)(21056001)(64706001)(47776003)(20776003)(15975445007)(77096005)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;SPF:None;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB193;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 11:07:37.0101
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch-set, was created to solve the bug described at 
https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when 
trying use amdkfd driver on Kaveri). It replaces the previous patch-set called 
[PATCH 0/3] Use workqueue for device init in amdkfd
(http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.html)

That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled 
inside the kernel (not as modules). In that case, the correct loading 
order, as determined by the exported symbol used by each driver, is 
not enforced anymore and the kernel loads them based on who was linked 
first. That makes radeon load first, amdkfd second and amd_iommu_v2 
third.

Because the initialization of a device in amdkfd is initiated by radeon, 
and can only be completed if amdkfd and amd_iommu_v2 were loaded and 
initialized, then in the case mentioned above, this initalization fails 
and there is a kernel panic as some pointers are not initialized but 
used nontheless.

To solve this bug, this patch-set moves iommu/ before gpu/ in drivers/Makefile 
and also moves amdkfd/ before radeon/ in drivers/gpu/drm/Makefile.

The rationale is that in general, AMD GPU devices are dependent on AMD IOMMU 
controller functionality to allow the GPU to access a process's virtual memory 
address space, without the need for pinning the memory. That's why it makes 
sense to initialize the iommu/ subsystem ahead of the gpu/ subsystem.

	Oded

Oded Gabbay (2):
  drivers: Move iommu/ before gpu/ in Makefile
  drm: Put amdkfd before radeon in drm Makefile

 drivers/Makefile         | 6 ++++--
 drivers/gpu/drm/Makefile | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
1.9.1

