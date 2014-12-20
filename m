Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaLTUqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:46:31 -0500
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:29894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751248AbaLTUqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:46:30 -0500
X-WSS-ID: 0NGWF1C-08-D73-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, <linux-kernel@vger.kernel.org>,
        "John Bridgman" <John.Bridgman@amd.com>, <Alexander.Deucher@amd.com>
Subject: [PATCH 0/3] Use workqueue for device init in amdkfd
Date: Sat, 20 Dec 2014 22:46:11 +0200
Message-ID: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50986999)(62966003)(15188555004)(77156002)(15975445007)(68736005)(106466001)(107046002)(2351001)(97736003)(229853001)(105586002)(110136001)(120916001)(92566001)(53416004)(86362001)(99396003)(33646002)(36756003)(89996001)(87936001)(50226001)(20776003)(4396001)(64706001)(19580395003)(21056001)(84676001)(31966008)(50466002)(46102003)(47776003)(77096005)(48376002)(101416001)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0431F981D8
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2014 20:46:26.8618
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch-set, together with amd_iommu_v2 patch at 
http://lists.linuxfoundation.org/pipermail/iommu/2014-December/011435.html 
was created to solve the bug described at 
https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when 
trying use amdkfd driver on Kaveri).

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

To solve this problem, amdkfd now checks if both it and amd_iommu_v2 
were loaded before trying to initalize the device. If not, it enqueue 
the work using a workqueue, which allows radeon to continue its device 
initialization (because radeon calls amdkfd to initalize the device).
The work function schedules itself as long as amdkfd and amd_iommu_v2 
were not initialized.

Detection of when the modules finished their initialization is done by 
a simple variable that is initialized to 1 when the module_init function 
is completed successfully. Other methods for detection were checked, 
e.g. module_is_live() and MODULE_SOFTDEP(), but they were proved not 
to work when all modules are compiled in the kernel image (which is 
the problematic scenario to begin with).

	Oded

Oded Gabbay (3):
  amdkfd: Don't clear *kfd2kgd on kfd_module_init
  amdkfd: Track when amdkfd init is complete
  amdkfd: Use workqueue for GPU init

 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 72 +++++++++++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdkfd/kfd_module.c | 14 +++++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h   |  4 ++
 3 files changed, 83 insertions(+), 7 deletions(-)

-- 
2.1.0

