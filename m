Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaLTUq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:46:59 -0500
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:55360
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752643AbaLTUqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:46:53 -0500
X-WSS-ID: 0NGWF20-07-75D-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, <linux-kernel@vger.kernel.org>,
        "John Bridgman" <John.Bridgman@amd.com>, <Alexander.Deucher@amd.com>
Subject: [PATCH 3/3] amdkfd: Use workqueue for GPU init
Date: Sat, 20 Dec 2014 22:46:14 +0200
Message-ID: <1419108374-7020-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(36756003)(87936001)(92566001)(68736005)(50986999)(62966003)(77156002)(2950100001)(77096005)(50226001)(120916001)(89996001)(53416004)(110136001)(4396001)(99396003)(101416001)(21056001)(31966008)(97736003)(105586002)(229853001)(107046002)(2351001)(106466001)(46102003)(84676001)(48376002)(50466002)(19580395003)(19580405001)(86362001)(33646002)(76176999)(64706001)(20776003)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0431F981D8
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2014 20:46:50.5582
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When amd_iommu_v2, amdkfd and radeon are all compiled inside the kernel image
(not as modules), radeon probes the existing GPU before amdkfd and amd_iommu_v2
are even loaded. When radeon encounters an AMD GPU, it will pass that
information to amdkfd. However, that call will fail and will cause a kernel BUG.

We could poll in radeon on when amdkfd and amd_iommu_v2 have been loaded, but
that would stall radeon.

Therefore, this patch moves the amdkfd part of GPU initialization to a
workqueue. When radeon calls amdkfd to perform GPU related initialization, it
will check if both amdkfd and amd_iommu_v2 have been loaded. If so, which is
the situation when the three drivers are compiled as modules, it will call the
relevant amdkfd function directly. If not, it will queue the initialization
work on the workqueue. The work function will schedule itself until both amdkfd
and amd_iommu_v2 have been loaded. Then, it will call the relevant amdkfd
function.

The workqueue is defined per kfd_dev structure (per GPU).

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 72 +++++++++++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h   |  2 +
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 43884eb..cec5b4b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -24,6 +24,7 @@
 #include <linux/bsearch.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include "kfd_priv.h"
 #include "kfd_device_queue_manager.h"
 
@@ -40,6 +41,11 @@ struct kfd_deviceid {
 	const struct kfd_device_info *device_info;
 };
 
+struct kfd_device_init_work {
+	struct work_struct kfd_work;
+	struct kfd_dev *dev;
+};
+
 /* Please keep this sorted by increasing device id. */
 static const struct kfd_deviceid supported_devices[] = {
 	{ 0x1304, &kaveri_device_info },	/* Kaveri */
@@ -99,6 +105,8 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
 	kfd->pdev = pdev;
 	kfd->init_complete = false;
 
+	kfd->kfd_dev_wq = create_workqueue("kfd_dev_wq");
+
 	return kfd;
 }
 
@@ -161,13 +169,10 @@ static void iommu_pasid_shutdown_callback(struct pci_dev *pdev, int pasid)
 		kfd_unbind_process_from_device(dev, pasid);
 }
 
-bool kgd2kfd_device_init(struct kfd_dev *kfd,
-			 const struct kgd2kfd_shared_resources *gpu_resources)
+static bool kfd_kgd_device_init(struct kfd_dev *kfd)
 {
 	unsigned int size;
 
-	kfd->shared_resources = *gpu_resources;
-
 	/* calculate max size of mqds needed for queues */
 	size = max_num_of_processes *
 		max_num_of_queues_per_process *
@@ -249,6 +254,63 @@ out:
 	return kfd->init_complete;
 }
 
+static void kfd_device_wq_init_device(struct work_struct *work)
+{
+	struct kfd_device_init_work *my_work;
+	struct kfd_dev *kfd;
+
+	my_work = (struct kfd_device_init_work *) work;
+
+	kfd = my_work->dev;
+
+	/*
+	 * As long as amdkfd or amd_iommu_v2 are not initialized, we
+	 * yield the processor
+	 */
+	while ((!amdkfd_is_init_completed()) ||
+		(!amd_iommu_v2_is_init_completed()))
+		schedule();
+
+	kfd_kgd_device_init(kfd);
+}
+
+bool kgd2kfd_device_init(struct kfd_dev *kfd,
+			 const struct kgd2kfd_shared_resources *gpu_resources)
+{
+	struct kfd_device_init_work *work;
+
+	kfd->shared_resources = *gpu_resources;
+
+	/*
+	 * When amd_iommu_v2, amdkfd and radeon are compiled inside the kernel,
+	 * there is no mechanism to enforce order of loading between the
+	 * drivers. Therefore, we need to use an explicit form of
+	 * synchronization to know when amdkfd and amd_iommu_v2 have finished
+	 * there initialization routines
+	 */
+	if ((!amdkfd_is_init_completed()) ||
+		(!amd_iommu_v2_is_init_completed())) {
+		BUG_ON(!kfd->kfd_dev_wq);
+
+		work = (struct kfd_device_init_work *)
+			kmalloc(sizeof(struct kfd_device_init_work),
+				GFP_ATOMIC);
+
+		if (!work) {
+			pr_err("kfd: no memory for device work queue\n");
+			return false;
+		}
+
+		INIT_WORK((struct work_struct *) work,
+				kfd_device_wq_init_device);
+		work->dev = kfd;
+		queue_work(kfd->kfd_dev_wq, (struct work_struct *) work);
+		return true;
+	}
+
+	return kfd_kgd_device_init(kfd);
+}
+
 void kgd2kfd_device_exit(struct kfd_dev *kfd)
 {
 	if (kfd->init_complete) {
@@ -258,6 +320,8 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 		kfd_topology_remove_device(kfd);
 	}
 
+	flush_workqueue(kfd->kfd_dev_wq);
+	destroy_workqueue(kfd->kfd_dev_wq);
 	kfree(kfd);
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 01df7e6..fc000a2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -151,6 +151,8 @@ struct kfd_dev {
 	 * from the HW ring into a SW ring.
 	 */
 	bool interrupts_active;
+
+	struct workqueue_struct *kfd_dev_wq;
 };
 
 int amdkfd_is_init_completed(void);
-- 
2.1.0

