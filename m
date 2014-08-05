Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaHEPdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:33:42 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:52708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756037AbaHEPdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:33:40 -0400
X-WSS-ID: 0N9UB7K-08-R67-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 23/23] amdkfd: Implement the Get Process Aperture IOCTL
Date: Tue, 5 Aug 2014 18:30:51 +0300
Message-ID: <1407252651-3539-24-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(95666004)(81342001)(46102001)(76176999)(20776003)(47776003)(575784001)(86362001)(31966008)(74662001)(74502001)(102836001)(106466001)(50226001)(4396001)(80022001)(64706001)(50986999)(92726001)(105586002)(99396002)(81542001)(85306004)(92566001)(77096002)(50466002)(21056001)(36756003)(68736004)(62966002)(85852003)(79102001)(84676001)(89996001)(76482001)(88136002)(77982001)(83072002)(87936001)(33646002)(101416001)(104166001)(87286001)(48376002)(107046002)(229853001)(44976005)(19580405001)(97736001)(83322001)(19580395003)(77156001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

v3: fix debug msg

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 47 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  5 +++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index eba5b5d..5ee0cda 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -397,7 +397,52 @@ static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process
 
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

