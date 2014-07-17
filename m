Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbaGQNeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:34:12 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:58786
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932720AbaGQNeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:34:03 -0400
X-WSS-ID: 0N8UZ0M-08-71Z-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 24/25] amdkfd: Implement the Get Process Aperture IOCTL
Date: Thu, 17 Jul 2014 16:29:31 +0300
Message-ID: <1405603773-32688-25-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(428002)(189002)(199002)(83322001)(93916002)(92726001)(19580405001)(77982001)(87936001)(104166001)(68736004)(89996001)(33646002)(31966008)(575784001)(105586002)(92566001)(97736001)(106466001)(50466002)(46102001)(74502001)(48376002)(102836001)(101416001)(87286001)(44976005)(88136002)(19580395003)(36756003)(64706001)(21056001)(81542001)(77156001)(76176999)(80022001)(95666004)(99396002)(81342001)(62966002)(84676001)(76482001)(107046002)(50986999)(86362001)(85306003)(20776003)(74662001)(4396001)(79102001)(83072002)(77096002)(47776003)(229853001)(50226001)(85852003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 40 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  5 ++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index 72d8e79..1e19504 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -348,7 +348,45 @@ static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process
 
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
+			dev_dbg(kfd_device, "node id %u, gpu id %u, lds_base %llX lds_limit %llX gpuvm_base %llX gpuvm_limit %llX scratch_base %llX scratch_limit %llX",
+					args.num_of_nodes, pdd->dev->id, pdd->lds_base, pdd->lds_limit, pdd->gpuvm_base, pdd->gpuvm_limit, pdd->scratch_base, pdd->scratch_limit);
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
 
 static long kfd_ioctl_pmc_acquire_access(struct file *filp, struct kfd_process *p, void __user *arg)
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 7ea0e81..1db1ede 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -346,6 +346,11 @@ void kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid);
 struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p);
 
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

