Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaKHSzP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:55:15 -0500
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:2508
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbaKHSzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:55:13 -0500
X-WSS-ID: 0NEQHVS-08-GIS-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>, Ben Goz <ben.goz@amd.com>,
        "Jay Cornwall" <jay.cornwall@amd.com>
Subject: [PATCH v5 23/24] amdkfd: Implement the Get Process Aperture IOCTL
Date: Sat, 8 Nov 2014 20:54:50 +0200
Message-ID: <1415472896-4272-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(36756003)(102836001)(46102003)(48376002)(4396001)(107046002)(62966003)(92566001)(88136002)(53416004)(89996001)(120916001)(19580405001)(68736004)(93916002)(19580395003)(101416001)(77096003)(77156002)(50466002)(64706001)(50226001)(20776003)(33646002)(84676001)(105586002)(50986999)(86362001)(44976005)(104166001)(92726001)(21056001)(47776003)(31966008)(87936001)(229853001)(99396003)(97736003)(76176999)(87286001)(106466001)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

v3: Fixed debug messages

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 56 +++++++++++++++++++++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  6 ++++
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 473f8e1..3130265 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -435,7 +435,61 @@ static long kfd_ioctl_get_clock_counters(struct file *filep,
 static int kfd_ioctl_get_process_apertures(struct file *filp,
 				struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_get_process_apertures_args args;
+	struct kfd_process_device_apertures *pAperture;
+	struct kfd_process_device *pdd;
+
+	dev_dbg(kfd_device, "get apertures for PASID %d", p->pasid);
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	args.num_of_nodes = 0;
+
+	mutex_lock(&p->mutex);
+
+	/*if the process-device list isn't empty*/
+	if (kfd_has_process_device_data(p)) {
+		/* Run over all pdd of the process */
+		pdd = kfd_get_first_process_device_data(p);
+		do {
+			pAperture = &args.process_apertures[args.num_of_nodes];
+			pAperture->gpu_id = pdd->dev->id;
+			pAperture->lds_base = pdd->lds_base;
+			pAperture->lds_limit = pdd->lds_limit;
+			pAperture->gpuvm_base = pdd->gpuvm_base;
+			pAperture->gpuvm_limit = pdd->gpuvm_limit;
+			pAperture->scratch_base = pdd->scratch_base;
+			pAperture->scratch_limit = pdd->scratch_limit;
+
+			dev_dbg(kfd_device,
+				"node id %u\n", args.num_of_nodes);
+			dev_dbg(kfd_device,
+				"gpu id %u\n", pdd->dev->id);
+			dev_dbg(kfd_device,
+				"lds_base %llX\n", pdd->lds_base);
+			dev_dbg(kfd_device,
+				"lds_limit %llX\n", pdd->lds_limit);
+			dev_dbg(kfd_device,
+				"gpuvm_base %llX\n", pdd->gpuvm_base);
+			dev_dbg(kfd_device,
+				"gpuvm_limit %llX\n", pdd->gpuvm_limit);
+			dev_dbg(kfd_device,
+				"scratch_base %llX\n", pdd->scratch_base);
+			dev_dbg(kfd_device,
+				"scratch_limit %llX\n", pdd->scratch_limit);
+
+			args.num_of_nodes++;
+		} while ((pdd = kfd_get_next_process_device_data(p, pdd)) != NULL &&
+				(args.num_of_nodes < NUM_OF_SUPPORTED_GPUS));
+	}
+
+	mutex_unlock(&p->mutex);
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 2bc34aa1..41e608d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -473,6 +473,12 @@ struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p,
 							int create_pdd);
 
+/* Process device data iterator */
+struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p);
+struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p,
+						struct kfd_process_device *pdd);
+bool kfd_has_process_device_data(struct kfd_process *p);
+
 /* PASIDs */
 int kfd_pasid_init(void);
 void kfd_pasid_exit(void);
-- 
2.1.0

