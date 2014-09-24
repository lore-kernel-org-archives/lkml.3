Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaIXVFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:05:21 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:19452
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753864AbaIXVFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:15 -0400
X-WSS-ID: 0NCFB7H-07-TBH-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 23/23] amdkfd: Implement the Get Process Aperture IOCTL
Date: Wed, 24 Sep 2014 23:45:37 +0300
Message-ID: <1411591537-31636-24-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(74502003)(50226001)(77982003)(229853001)(102836001)(81342003)(104166001)(20776003)(79102003)(46102003)(4396001)(81542003)(74662003)(47776003)(64706001)(48376002)(83322001)(44976005)(19580395003)(19580405001)(68736004)(107046002)(50466002)(80022003)(101416001)(84676001)(87286001)(89996001)(85852003)(87936001)(85306004)(83072002)(62966002)(88136002)(21056001)(105586002)(33646002)(95666004)(106466001)(120916001)(77096002)(93916002)(76482002)(86362001)(76176999)(90102001)(31966008)(97736003)(92566001)(92726001)(99396003)(36756003)(10300001)(50986999)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

v3: Fixed debug messages

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 47 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  5 +++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index 1e4b731..bf9ea51 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -406,7 +406,52 @@ static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process
 
 static int kfd_ioctl_get_process_apertures(struct file *filp, struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_get_process_apertures_args args;
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
+
+			args.process_apertures[args.num_of_nodes].gpu_id = pdd->dev->id;
+			args.process_apertures[args.num_of_nodes].lds_base = pdd->lds_base;
+			args.process_apertures[args.num_of_nodes].lds_limit = pdd->lds_limit;
+			args.process_apertures[args.num_of_nodes].gpuvm_base = pdd->gpuvm_base;
+			args.process_apertures[args.num_of_nodes].gpuvm_limit = pdd->gpuvm_limit;
+			args.process_apertures[args.num_of_nodes].scratch_base = pdd->scratch_base;
+			args.process_apertures[args.num_of_nodes].scratch_limit = pdd->scratch_limit;
+
+			dev_dbg(kfd_device, "node id %u\n", args.num_of_nodes);
+			dev_dbg(kfd_device, "gpu id %u\n", pdd->dev->id);
+			dev_dbg(kfd_device, "lds_base %llX\n", pdd->lds_base);
+			dev_dbg(kfd_device, "lds_limit %llX\n", pdd->lds_limit);
+			dev_dbg(kfd_device, "gpuvm_base %llX\n", pdd->gpuvm_base);
+			dev_dbg(kfd_device, "gpuvm_limit %llX\n", pdd->gpuvm_limit);
+			dev_dbg(kfd_device, "scratch_base %llX\n", pdd->scratch_base);
+			dev_dbg(kfd_device, "scratch_limit %llX\n", pdd->scratch_limit);
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
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 0e3e18f..9f49f11 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -445,6 +445,11 @@ struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p,
 							int create_pdd);
 
+/* Process device data iterator */
+struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p);
+struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p, struct kfd_process_device *pdd);
+bool kfd_has_process_device_data(struct kfd_process *p);
+
 /* PASIDs */
 int kfd_pasid_init(void);
 void kfd_pasid_exit(void);
-- 
1.9.1

