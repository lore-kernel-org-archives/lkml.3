Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaGQNeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:34:09 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:28291
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933555AbaGQNeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:34:05 -0400
X-WSS-ID: 0N8UZ0O-08-725-02
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
        "Evgeny Pinchuk" <evgeny.pinchuk@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 25/25] amdkfd: Implement the PMC Acquire/Release IOCTLs
Date: Thu, 17 Jul 2014 16:29:32 +0300
Message-ID: <1405603773-32688-26-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(85306003)(81342001)(93916002)(83322001)(62966002)(19580405001)(74662001)(107046002)(50986999)(77156001)(76176999)(84676001)(87936001)(88136002)(31966008)(104166001)(87286001)(74502001)(83072002)(85852003)(77096002)(102836001)(81542001)(92566001)(97736001)(36756003)(92726001)(95666004)(21056001)(77982001)(79102001)(80022001)(47776003)(20776003)(68736004)(44976005)(101416001)(86362001)(89996001)(46102001)(64706001)(99396002)(33646002)(4396001)(48376002)(106466001)(50466002)(76482001)(229853001)(19580395003)(105586002)(50226001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB043;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 46 +++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c  |  2 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  5 ++++
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c |  6 ++++
 4 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index 1e19504..be90ab9 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -391,12 +391,54 @@ static int kfd_ioctl_get_process_apertures(struct file *filp, struct kfd_process
 
 static long kfd_ioctl_pmc_acquire_access(struct file *filp, struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_pmc_acquire_access_args args;
+	struct kfd_dev *dev;
+	int err = -EBUSY;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	spin_lock(&dev->pmc_access_lock);
+	if (dev->pmc_locking_process == NULL) {
+		dev->pmc_locking_process = p;
+		dev->pmc_locking_trace = args.trace_id;
+		err = 0;
+	} else if (dev->pmc_locking_process == p && dev->pmc_locking_trace == args.trace_id) {
+		/* Same trace already has an access. Returning success */
+		err = 0;
+	}
+
+	spin_unlock(&dev->pmc_access_lock);
+
+	return err;
 }
 
 static long kfd_ioctl_pmc_release_access(struct file *filp, struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_pmc_release_access_args args;
+	struct kfd_dev *dev;
+	int err = -EINVAL;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	spin_lock(&dev->pmc_access_lock);
+	if (dev->pmc_locking_process == p && dev->pmc_locking_trace == args.trace_id) {
+		dev->pmc_locking_process = NULL;
+		dev->pmc_locking_trace = 0;
+		err = 0;
+	}
+	spin_unlock(&dev->pmc_access_lock);
+
+	return err;
 }
 
 static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index 6a7a8b2..f1cbc46 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -184,6 +184,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 		return false;
 	}
 
+	spin_lock_init(&kfd->pmc_access_lock);
+
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 1db1ede..a5356d1 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -131,6 +131,11 @@ struct kfd_dev {
 
 	/* QCM Device instance */
 	struct device_queue_manager *dqm;
+
+	/* Performance counters exclusivity lock */
+	spinlock_t pmc_access_lock;
+	struct kfd_process *pmc_locking_process;
+	uint64_t pmc_locking_trace;
 };
 
 /* KGD2KFD callbacks */
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
index bcc004f..a67c239 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
@@ -98,6 +98,12 @@ static void free_process(struct kfd_process *p)
 	BUG_ON(p == NULL);
 
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		spin_lock(&pdd->dev->pmc_access_lock);
+		if (pdd->dev->pmc_locking_process == p) {
+			pdd->dev->pmc_locking_process = NULL;
+			pdd->dev->pmc_locking_trace = 0;
+		}
+		spin_unlock(&pdd->dev->pmc_access_lock);
 		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
 		kfree(pdd);
-- 
1.9.1

